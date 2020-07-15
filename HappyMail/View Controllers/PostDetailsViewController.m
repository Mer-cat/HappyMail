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
@property (weak, nonatomic) IBOutlet UIButton *respondButton;

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
    // Currently, completely disable ability or respond twice
    self.respondButton.enabled = NO;
    User *currentUser = [User currentUser];
    // User is responding to an offer post
    if (self.post.type == 0) {
        [self.post addRespondee:currentUser];
    } else if (self.post.type == 1) {  // User is responding to request
        // TODO: Set up info request creation and flow
        [currentUser addFollowUp:self.post];
        NSLog(@"User successfully responded to request");
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
