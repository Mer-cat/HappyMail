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

@end

@implementation ComposeViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMentionsPlugin];
    
    // Round corners
    [Utils roundCorners:self.responseLimitLabel];
    [Utils roundCorners:self.bodyTextView];
}

#pragma mark - Init

- (void)initMentionsPlugin {
    self.userTagTextView.externalDelegate = self;
    
    NSCharacterSet *controlCharacters = [NSCharacterSet characterSetWithCharactersInString:@"@+"];
    id<HKWMentionsPlugin> mentionsPlugin = [HKWMentionsPluginV1 mentionsPluginWithChooserMode:HKWMentionsChooserPositionModeEnclosedTop controlCharacters:controlCharacters searchLength:0];
    self.plugin = mentionsPlugin;
    
    mentionsPlugin.defaultChooserViewDelegate = [MentionsManager sharedInstance];
    mentionsPlugin.stateChangeDelegate = [MentionsManager sharedInstance];
    mentionsPlugin.resumeMentionsCreationEnabled = YES;
    
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
    
    // Should only apply for Thank You posts
    NSArray *taggedUsers = [[NSArray alloc] init];
    
    [Post createNewPostWithTitle:title withBody:bodyText withType:postType withLimit:responseLimit withTaggedUsers:taggedUsers withCompletion:^(Post *post, NSError *error) {
        if (post) {
            NSLog(@"Successfully made new post");
            [self.delegate didPost:post];
            
            // Return to the home screen
            [self dismissViewControllerAnimated:true completion:nil];
        } else {
            NSLog(@"Error posting: %@", error.localizedDescription);
        }
        self.postButton.enabled = YES;
    }];
}

- (IBAction)postTypeChanged:(id)sender {
    if (self.postTypeControl.selectedSegmentIndex != Offer) {
        self.responseLimitStepper.hidden = YES;
        self.limitQuestionLabel.hidden = YES;
        self.responseLimitLabel.hidden = YES;
    } else {
        self.responseLimitStepper.hidden = NO;
        self.limitQuestionLabel.hidden = NO;
        self.responseLimitLabel.hidden = NO;
    }
    if (self.postTypeControl.selectedSegmentIndex == ThankYou) {
        // Enable user tagging
    }
}

- (IBAction)stepperValueChanged:(id)sender {
    self.responseLimitLabel.text = [NSString stringWithFormat:@"%d", (int) self.responseLimitStepper.value];
}

/**
 * Cancel creation of post, return to feed
 */
- (IBAction)didPressCancel:(id)sender {
    // Return to the home screen
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
