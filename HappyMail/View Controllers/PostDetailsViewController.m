//
//  PostDetailsViewController.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "PostDetailsViewController.h"
#import "DateTools.h"

@interface PostDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *postTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyTextLabel;

@end

@implementation PostDetailsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshPost];
}

#pragma mark - Init

- (void)refreshPost {
    self.postTypeLabel.text = _PostTypes()[self.post.type];
    self.usernameLabel.text = self.post.author.username;
    self.titleLabel.text = self.post.title;
    self.bodyTextLabel.text = self.post.bodyText;
    NSDate *timeCreated = self.post.createdAt;
    self.timestampLabel.text = [NSString stringWithFormat:@"%@ ago", timeCreated.shortTimeAgoSinceNow];
}

#pragma mark - Actions

- (IBAction)didPressRespond:(id)sender {
    // Responding to an offer post
    if (self.post.type == 0) {
        User *currentUser = [User currentUser];
        // TODO: Ask TAs about line below. Can't save new object to an array any other way
        [self.post addObject:currentUser forKey:@"respondees"];
        [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"%@ added to respondees for this post", currentUser.username);
            } else {
                NSLog(@"Error adding user to respondees: %@", error.localizedDescription);
            }
        }];
    } else if (self.post.type == 1) {  // Responding to request
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
