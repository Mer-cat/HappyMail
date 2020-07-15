//
//  ProfileViewController.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *aboutMeTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;

@end

@implementation ProfileViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // If no user has been passed in,
    // we are looking at user's own profile
    if (!self.user) {
        self.user = [User currentUser];
    } else { // If looking at another user's profile
        self.logoutButton.enabled = NO;
        self.logoutButton.tintColor = UIColor.clearColor;
    }
    
    [self refreshProfile];
}

#pragma mark - Init

- (void)refreshProfile {
    // Set labels
    self.usernameLabel.text = self.user.username;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM-dd-yyyy"];
    NSString *joinDateString = [dateFormatter stringFromDate:self.user.createdAt];
    
    self.joinDateLabel.text = [NSString stringWithFormat:@"Joined %@", joinDateString];
    self.aboutMeTextView.text = self.user.aboutMeText;
    
    // TODO: Set profile image
}

#pragma mark - Actions

- (IBAction)didPressLogout:(id)sender {
    // Go back to the login screen
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
    
    // Clear out the current user
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"User logged out successfully");
        }
    }];
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
