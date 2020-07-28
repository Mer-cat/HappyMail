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

@interface PostDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *postTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *usernameButton;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *respondButton;
@property (weak, nonatomic) IBOutlet UILabel *responseLimitLabel;

@end

@implementation PostDetailsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshPost];
    
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
}

#pragma mark - Actions

- (IBAction)didPressRespond:(id)sender {
    switch (self.post.type) {
        case Offer:
            [self showAlertWithMessage:@"Are you sure you want to request a card from this user?" title:@"Confirm response"];
            break;
        case Request:
            // Send an info request to the receiving user to ask for their information
            [self showAlertWithMessage:@"Are you sure you want to send a card to this user?" title:@"Confirm response"];
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected PostType"];
            break;
    }
}

#pragma mark - UIAlertController

- (void)showAlertWithMessage:(NSString *)message title:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    // Create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        [self handleOkResponse];
    }];
    
    // Add the OK action to the alert controller
    [alert addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        self.respondButton.enabled = YES;
    }];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - Response handler

- (void)handleOkResponse {
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
