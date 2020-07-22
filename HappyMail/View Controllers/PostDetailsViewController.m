//
//  PostDetailsViewController.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "PostDetailsViewController.h"
#import "DateTools.h"
#import "ProfileViewController.h"
#import "InfoRequest.h"
#import "FollowUp.h"

/**
 * View controller for viewing a single post in more detail
 */
@interface PostDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *postTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *usernameButton;
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
    self.postTypeLabel.text = [Post formatTypeToString:self.post.type];
    [self.post.author fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object) {
             [self.usernameButton setTitle:self.post.author.username forState:UIControlStateNormal];
        } else {
            NSLog(@"Error fetching post author: %@", error.localizedDescription);
        }
    }];
    
    self.titleLabel.text = self.post.title;
    self.bodyTextLabel.text = self.post.bodyText;
    NSDate *timeCreated = self.post.createdAt;
    self.timestampLabel.text = [NSString stringWithFormat:@"%@ ago", timeCreated.shortTimeAgoSinceNow];
}

#pragma mark - Actions

- (IBAction)didPressRespond:(id)sender {
    // Currently, users can go back to the page to respond again
    self.respondButton.enabled = NO;
    User *currentUser = [User currentUser];
    
    // Can use switch case here wtih error handling
    // User is responding to an offer post
    switch (self.post.type) {
        case Offer:
            [FollowUp createNewFollowUpForUser:self.post.author fromPost:self.post aboutUser:currentUser];
            break;
        case Request:
            // Send an info request to the receiving user to ask for their information
            [InfoRequest createNewInfoRequestToUser:self.post.author fromUser:currentUser fromPost:self.post];
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected PostType"];
            break;
    }
    [self.post addRespondee:currentUser];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ProfileViewSegue"]) {
        ProfileViewController *profileViewController = [segue destinationViewController];
        // If viewing another user's profile
        if (![self.post.author.username isEqualToString:[User currentUser].username]) {
            profileViewController.user = self.post.author;
        }
    }
}

@end
