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
#import "Utils.h"
#import "User.h"

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
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
    
    // Temporary until PFImageView is set up
    UIImage *placeholderImage = [UIImage imageNamed:@"image_placeholder"];
    [self.profileImage setImage: placeholderImage];
    [self.user.profileImage getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error getting image: %@", error.localizedDescription);
        } else {
            [self.profileImage setImage: [UIImage imageWithData:data]];
        }
    }];
}

/**
 * Create new image picker to allow user to select profile image from their camera or photo library
 */
- (void)initUIImagePickerController {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        NSLog(@"Camera not available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

/**
 * Delegate method for UIImagePickerController
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    // Assign image chosen to appear in the image view
    UIImage *resizedImage = [Utils resizeImage:originalImage withSize:CGSizeMake(400, 400)];
    self.profileImage.image = resizedImage;
    PFFileObject *imageFile = [Utils getPFFileFromImage:resizedImage];
    self.user.profileImage = imageFile;
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"The profile image was saved!");
        } else {
            NSLog(@"Problem saving profile image: %@",error.localizedDescription);
        }
    }];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions

// TODO: Set user permissions
- (IBAction)didPressImage:(id)sender {
    [self initUIImagePickerController];
}

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
