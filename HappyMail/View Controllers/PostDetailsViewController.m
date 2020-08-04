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
#import "Utils.h"
#import "User.h"
#import "FeedViewController.h"

@interface PostDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *postTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *usernameButton;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *respondButton;
@property (weak, nonatomic) IBOutlet UILabel *responseLimitLabel;
@property (strong, nonatomic) IBOutlet UIScreenEdgePanGestureRecognizer *swipeGestureRecognizer;

@end

@implementation PostDetailsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshPost];
    
    // Disable responding for anyone who has already responded
    for (User *user in self.post.respondees) {
        if ([user.username isEqualToString:[User currentUser].username]) {
            self.respondButton.enabled = NO;
            break;
        }
    }
    
    // Hide respond button if response limit is reached
    // and the user has not already responded
    if (self.post.respondees.count >= self.post.responseLimit && self.respondButton.enabled != NO) {
        self.respondButton.hidden = YES;
    }
}

#pragma mark - Init

- (void)refreshPost {
    self.postTypeLabel.text = [Post formatTypeToString:self.post.type];
    [self.usernameButton setTitle:self.post.author.username forState:UIControlStateNormal];
    
    if (self.post.type == Offer) {
    self.responseLimitLabel.text = [NSString stringWithFormat:@"%lu/%lu responses", self.post.respondees.count, self.post.responseLimit];
    } else {
        self.responseLimitLabel.hidden = YES;
    }
    
    self.titleLabel.text = self.post.title;
    self.bodyTextLabel.text = self.post.bodyText;
    NSDate *timeCreated = self.post.createdAt;
    self.timestampLabel.text = [NSString stringWithFormat:@"%@ ago", timeCreated.shortTimeAgoSinceNow];
    [Utils roundCorners:self.respondButton];
    [Utils roundCorners:self.usernameButton];
}

#pragma mark - Actions

- (IBAction)didPressRespond:(id)sender {
    switch (self.post.type) {
        case Offer:
            [Utils showAlertWithMessage:@"Are you sure you want to request a card from this user?" title:@"Confirm response" controller:self okAction:@selector(handleOkResponse) shouldAddCancelButton:YES cancelSelector:@selector(handleCancelResponse)];
            break;
        case Request:
            [Utils showAlertWithMessage:@"Are you sure you want to send a card to this user?" title:@"Confirm response" controller:self okAction:@selector(handleOkResponse) shouldAddCancelButton:YES cancelSelector:@selector(handleCancelResponse)];
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected PostType"];
            break;
    }
}

- (IBAction)didSwipeFromRightEdge:(id)sender {
    if (self.swipeGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Swiping!");
        
        NSInteger currentIndex = [self.posts indexOfObject:self.post];
        // Only swipe if there are more posts to show
        if (currentIndex < self.posts.count - 1) {
            // Pass in the next post
            PostDetailsViewController *postDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"PostDetailsViewController"];
            postDetailsView.post = self.posts[currentIndex+1];
            postDetailsView.posts = self.posts;
            [self.navigationController pushViewController:postDetailsView animated:YES];
        }
    }
}

#pragma mark - Response handler

- (void)handleOkResponse {
    // Must query in order to include address key with user
    [Utils queryUser:[User currentUser] withCompletion:^(User *user, NSError *error) {
        if (user) {
            User *currentUser = user;
            switch (self.post.type) {
                case Offer:
                    self.responseLimitLabel.text = [NSString stringWithFormat:@"%lu/%lu responses", self.post.respondees.count+1, self.post.responseLimit];
                    [self.delegate didRespond];
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
            self.respondButton.enabled = NO;
            [self.post addRespondee:currentUser];
        } else {
            NSLog(@"Error querying current user: %@", error.localizedDescription);
        }
    }];
}

- (void)handleCancelResponse {
    self.respondButton.enabled = YES;
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
