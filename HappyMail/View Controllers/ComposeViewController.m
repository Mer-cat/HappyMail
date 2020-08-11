//
//  ComposeViewController.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "ComposeViewController.h"
#import "Utils.h"
#import "HKWTextView.h"
#import "HKWMentionsPlugin.h"
#import "HKWMentionsPluginV1.h"
#import "MentionsManager.h"
#import "HKWMentionsAttribute.h"
#import "IQKeyboardManager.h"
#import "UserExternalData.h"

@interface ComposeViewController () <HKWTextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *postTypeControl;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (weak, nonatomic) IBOutlet UIStepper *responseLimitStepper;
@property (weak, nonatomic) IBOutlet UILabel *responseLimitLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitQuestionLabel;
@property (weak, nonatomic) IBOutlet HKWTextView *userTagTextView;
@property (nonatomic, strong) id<HKWMentionsPlugin> plugin;
@property (weak, nonatomic) IBOutlet UILabel *tagInstructionsLabel;

@end

@implementation ComposeViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMentionsPlugin];
    [self hideThankYouFields];
    
    // Round corners
    [Utils roundCorners:self.responseLimitLabel];
    [Utils roundCorners:self.bodyTextView];
    [Utils roundCorners: self.userTagTextView];
    
    // Add custom action for keyboard when on user tagging text view
    [self.userTagTextView.keyboardToolbar.doneBarButton setTarget:self action:@selector(doneAction:)];
}

#pragma mark - Init

/**
 * Set up the mentions plugin which will allow users to add mentions to post
 */
- (void)initMentionsPlugin {
    self.userTagTextView.externalDelegate = self;
    
    NSCharacterSet *controlCharacters = [NSCharacterSet characterSetWithCharactersInString:@"@"];
    id<HKWMentionsPlugin> mentionsPlugin = [HKWMentionsPluginV1 mentionsPluginWithChooserMode:HKWMentionsChooserPositionModeEnclosedTop controlCharacters:controlCharacters searchLength:2];
    self.plugin = mentionsPlugin;
    
    mentionsPlugin.defaultChooserViewDelegate = [MentionsManager sharedInstance];
    mentionsPlugin.stateChangeDelegate = [MentionsManager sharedInstance];
    
    self.userTagTextView.controlFlowPlugin = mentionsPlugin;
}

#pragma mark - Actions

/**
 * Make a new post
 */
- (IBAction)didPressPost:(id)sender {
    self.postButton.enabled = NO;
    
    NSString *title = self.titleField.text;
    NSString *bodyText = self.bodyTextView.text;
    NSInteger postType = self.postTypeControl.selectedSegmentIndex;
    NSInteger responseLimit = (int) self.responseLimitStepper.value;
    NSMutableArray *taggedUsers = [[NSMutableArray alloc] init];
    
    // Grab tagged users only for Thank You post
    if (postType == ThankYou) {
        NSArray *taggedUsersAttributes = self.plugin.mentions;
        for (HKWMentionsAttribute *mention in taggedUsersAttributes) {
            NSString *username = mention.mentionText;
            [taggedUsers addObject:username];
        }
    }
    
    [Post createNewPostWithTitle:title withBody:bodyText withType:postType withLimit:responseLimit withTaggedUsers:taggedUsers withCompletion:^(Post *post, NSError *error) {
        if (post) {
            NSLog(@"Successfully made new post");
            [self.delegate didPost:post];
            
            // Add thank you post to each user's array of thank-yous via their external data object
            if (postType == ThankYou) {
                PFQuery *taggedUserQuery = [PFQuery queryWithClassName:@"UserExternalData"];
                [taggedUserQuery whereKey:@"username" containedIn:taggedUsers];
                [taggedUserQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable externalDataArray, NSError * _Nullable error) {
                    if (externalDataArray) {
                        for (UserExternalData *externalData in externalDataArray) {
                            [externalData addThankYou:post];
                        }
                    } else {
                        NSLog(@"Error finding external data for users: %@", error.localizedDescription);
                    }
                }];
            }
            
            // Return to the home screen
            [self dismissViewControllerAnimated:true completion:nil];
        } else {
            NSLog(@"Error posting: %@", error.localizedDescription);
        }
        self.postButton.enabled = YES;
    }];
}

/**
 * Selectively hide and show fields depending on the type of post the user is making
 */
- (IBAction)postTypeChanged:(id)sender {
    switch (self.postTypeControl.selectedSegmentIndex) {
        case Offer:
            [self showOfferFields];
            [self hideThankYouFields];
            break;
        case Request:
            [self hideOfferFields];
            [self hideThankYouFields];
            break;
        case ThankYou:
            [self hideOfferFields];
            [self showThankYouFields];
            break;
        default:
            break;
    }
}

- (IBAction)stepperValueChanged:(id)sender {
    self.responseLimitLabel.text = [NSString stringWithFormat:@"%d", (int) self.responseLimitStepper.value];
}

/**
 * Cancel creation of post and return to feed
 */
- (IBAction)didPressCancel:(id)sender {
    // Return to the home screen
    [self dismissViewControllerAnimated:true completion:nil];
}

/**
 * Fixes slight compability issue between Hakawai and IQKeyboardManager
 */
- (void)doneAction:(UIBarButtonItem*)barButton {
    [self.userTagTextView endEditing:YES];
}

#pragma mark - Helpers

- (void)showOfferFields {
    self.responseLimitStepper.hidden = NO;
    self.limitQuestionLabel.hidden = NO;
    self.responseLimitLabel.hidden = NO;
}

- (void)hideOfferFields {
    self.responseLimitStepper.hidden = YES;
    self.limitQuestionLabel.hidden = YES;
    self.responseLimitLabel.hidden = YES;
}

- (void)showThankYouFields {
    self.tagInstructionsLabel.hidden = NO;
    self.userTagTextView.hidden = NO;
}

- (void)hideThankYouFields {
    self.tagInstructionsLabel.hidden = YES;
    self.userTagTextView.hidden = YES;
}

@end
