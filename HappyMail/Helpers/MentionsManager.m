//
//  HKWMentionsDelegateHelper.m
//  HappyMail
//
//  Created by Mercy Bickell on 8/4/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "User.h"
#import "MentionsManager.h"
#import <Parse/Parse.h>
#import <ChameleonFramework/Chameleon.h>

@implementation MentionsManager

+ (instancetype)sharedInstance {
    static MentionsManager *staticInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[self class] new];
    });
    return staticInstance;
}

- (UITableViewCell * _Null_unspecified)cellForMentionsEntity:(id<HKWMentionsEntityProtocol> _Null_unspecified)entity withMatchString:(NSString * _Null_unspecified)matchString tableView:(UITableView * _Null_unspecified)tableView atIndexPath:(NSIndexPath * _Null_unspecified)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mentionsCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"mentionsCell"];
    }
    cell.textLabel.text = [entity entityName];
    cell.backgroundColor = FlatYellow;
    return cell;
}

/**
 * Fetch users from parse whose usernames contain the search text
 */
- (void)asyncRetrieveEntitiesForKeyString:(nonnull NSString *)keyString searchType:(HKWMentionsSearchType)type controlCharacter:(unichar)character completion:(void (^ _Null_unspecified)(NSArray * _Null_unspecified, BOOL, BOOL))completionBlock {
    // Do not show table view initially until user types
    if (!completionBlock || type == HKWMentionsSearchTypeInitial) {
           return;
    }
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" matchesRegex:keyString modifiers:@"i"];
    [query orderByAscending:@"createdAt"];
    [query setLimit:10];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
        if (!error) {
            completionBlock(users, NO, YES);
        } else {
            NSLog(@"Error fetching users: %@", error.localizedDescription);
            completionBlock(nil, NO, YES);
        }
    }];
}

- (CGFloat)heightForCellForMentionsEntity:(id<HKWMentionsEntityProtocol> _Null_unspecified)entity tableView:(UITableView * _Null_unspecified)tableView {
    return 44;
}

@end
