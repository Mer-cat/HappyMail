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
#import <ChameleonFramework/Chameleon.h>
#import "PaddedLabel.h"
@import Parse;

@interface PostDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *postTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *usernameButton;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyTextLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *respondButton;
@property (weak, nonatomic) IBOutlet PaddedLabel *responseLimitLabel;
@property (strong, nonatomic) IBOutlet UIScreenEdgePanGestureRecognizer *swipeGestureRecognizer;
@property (weak, nonatomic) IBOutlet UILabel *taggedUsersLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowView;
@property (nonatomic, strong) NSArray *taggedUserObjects;

@end

@implementation PostDetailsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self queryTaggedUsers];
    [self refreshPost];
    [self setRespondPermissions];
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
    
    if (self.post.type == ThankYou) {
    
        if (self.taggedUserObjects) {
            NSMutableAttributedString *taggedUserStringList = [[NSMutableAttributedString alloc] init];
            for (User *user in self.taggedUserObjects) {
                // Create a label whose text is the user's username
                // Add tap gesture recognizer to the label
                NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:user.username attributes:@{@"taggedUser" : @(YES) }];
                [taggedUserStringList appendAttributedString:attributedString];
            }
            self.taggedUsersLabel.attributedText = taggedUserStringList;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapUser:)];
            [self.taggedUsersLabel addGestureRecognizer:tapGesture];
        } else {
            NSString *userList = [self.post.taggedUsers componentsJoinedByString:@", "];
            self.taggedUsersLabel.text = [NSString stringWithFormat:@"Tagged users: %@",userList];
            self.taggedUsersLabel.hidden = NO;
        }
    }
    
    self.titleLabel.text = self.post.title;
    self.bodyTextLabel.text = self.post.bodyText;
    NSDate *timeCreated = self.post.createdAt;
    self.timestampLabel.text = [NSString stringWithFormat:@"%@ ago", timeCreated.shortTimeAgoSinceNow];
    
    self.profileImageView.file = self.post.author.profileImage;
    [self.profileImageView loadInBackground];
    
    // Make profile picture circular
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    [Utils createBorder:self.profileImageView color:FlatBlack];
    
    [Utils createBorder:self.responseLimitLabel color:FlatBlack];
    [Utils roundCorners:self.responseLimitLabel];
    [self.responseLimitLabel setTextInsets];
    if (self.post.respondees.count == self.post.responseLimit) {
        self.responseLimitLabel.backgroundColor = [UIColor systemGray5Color];
    }
    
    [Utils roundCorners:self.respondButton];
    
    [Utils roundCorners:self.usernameButton];
    
    // Hide arrow if there are no more posts to swipe to
    NSInteger currentIndex = [self.posts indexOfObject:self.post];
    if (currentIndex >= self.posts.count - 1) {
        self.arrowView.hidden = YES;
    }
}

- (void)didTapUser:(UITapGestureRecognizer *)recognizer {
    UILabel *label = (UILabel *)recognizer.view;
    CGPoint tapLocation = [recognizer locationInView:label];
    
    // Init text storage
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:label.attributedText];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];

    // Init text container
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(label.frame.size.width, label.frame.size.height+100) ];
    textContainer.lineFragmentPadding  = 0;
    textContainer.maximumNumberOfLines = label.numberOfLines;
    textContainer.lineBreakMode        = label.lineBreakMode;

    [layoutManager addTextContainer:textContainer];

    NSUInteger characterIndex = [layoutManager characterIndexForPoint:tapLocation
                                    inTextContainer:textContainer
                                    fractionOfDistanceBetweenInsertionPoints:NULL];
    
    if (characterIndex < textStorage.length) {
        NSRange range;
        id value = [label.attributedText attribute:@"taggedUser" atIndex:characterIndex effectiveRange:&range];
        NSLog(@"%@", value);
        // Handle as required
    }
    
}

- (void)queryTaggedUsers {
    PFQuery *userQuery = [User query];
    [userQuery whereKey:@"username" containedIn:self.post.taggedUsers];
    [userQuery includeKey:@"address"];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable userObjects, NSError * _Nullable error) {
        if (userObjects) {
            self.taggedUserObjects = userObjects;
            // Reload tagged user list
        } else {
            NSLog(@"Error grabbing tagged user objects: %@", error.localizedDescription);
        }
    }];
}

#pragma mark - User permissions

- (void)setRespondPermissions {
    // Disable responding for anyone who has already responded
    for (User *user in self.post.respondees) {
        if ([user.username isEqualToString:[User currentUser].username]) {
            self.respondButton.enabled = NO;
            break;
        }
    }
    
    // Disable responding to thank yous and one's own post
    if (self.post.type == ThankYou || [self.post.author.username isEqualToString:[User currentUser].username]) {
        self.respondButton.hidden = YES;
    }
    
    // Hide respond button if response limit is reached
    // and the user has not already responded
    if (self.post.type == Offer) {
        if (self.post.respondees.count >= self.post.responseLimit && self.respondButton.enabled != NO) {
            self.respondButton.hidden = YES;
        }
    }
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

/**
 * Allows user to swipe to see the next post in the feed
 */
- (IBAction)didSwipeFromRightEdge:(id)sender {
    if (self.swipeGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Swiping!");
        [self segueToNextPost];
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
                    // Update response limit label on details screen
                    self.responseLimitLabel.text = [NSString stringWithFormat:@"%lu/%lu responses", self.post.respondees.count+1, self.post.responseLimit];
                    if (self.post.respondees.count+1 >= self.post.responseLimit) {
                        self.responseLimitLabel.backgroundColor = [UIColor systemGray5Color];
                    }
                    
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

#pragma mark - Navigation helpers

/**
 * Pulls up the details view of the next post in the feed
 * Stops once user has reached last post
 */
- (void)segueToNextPost {
    NSInteger currentIndex = [self.posts indexOfObject:self.post];
    
    // Only transition if there are more posts to show
    NSLog(@"%lu", currentIndex);
    NSLog(@"%lu", self.posts.count);
    if (currentIndex < self.posts.count - 1) {
        
        // Pass in the next post
        PostDetailsViewController *postDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"PostDetailsViewController"];
        postDetailsView.post = self.posts[currentIndex+1];
        postDetailsView.posts = self.posts;
        [self.navigationController pushViewController:postDetailsView animated:YES];
    }
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
