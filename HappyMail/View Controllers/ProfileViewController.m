//
//  ProfileViewController.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "ProfileViewController.h"
#import "SceneDelegate.h"
#import "Utils.h"
#import "User.h"
#import "PostCell.h"
@import Parse;

/**
 * View controller for users' profiles
 */
@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *aboutMeTextView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UILabel *usersPostsLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *userPosts;

@end

@implementation ProfileViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.aboutMeTextView.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // If no user has been passed in,
    // we are looking at user's own profile
    if (!self.user) {
        self.user = [User currentUser];
    } else {  // If looking at another user's profile
        self.logoutButton.enabled = NO;
        self.logoutButton.tintColor = UIColor.clearColor;
        self.aboutMeTextView.editable = NO;
        self.mapButton.hidden = YES;
    }
    self.userPosts = self.user.myPosts;
    
    [self refreshProfile];
}

#pragma mark - Init

- (void)refreshProfile {
    // Set labels
    self.usernameLabel.text = self.user.username;
    self.usersPostsLabel.text = [NSString stringWithFormat:@"Posts by %@",self.user.username];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM-dd-yyyy"];
    NSString *joinDateString = [dateFormatter stringFromDate:self.user.createdAt];
    
    self.joinDateLabel.text = [NSString stringWithFormat:@"Joined %@", joinDateString];
    self.aboutMeTextView.text = self.user.aboutMeText;
    
    UIImage *placeholderImage = [UIImage imageNamed:@"blank-profile-picture"];
    [self.profileImageView setImage: placeholderImage];
    
    self.profileImageView.file = self.user.profileImage;
    [self.profileImageView loadInBackground];
    
    // Add below line to make profile pictures circular (thank you Ria)
    // self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
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
    self.profileImageView.image = resizedImage;
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

- (IBAction)didPressImage:(id)sender {
    // Only user who owns account may change profile image
    if (self.user == [User currentUser]) {
        [self initUIImagePickerController];
    }
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

- (IBAction)didPressSaveAboutMe:(id)sender {
    // Save the entered text to Parse and dismiss keyboard
    self.user.aboutMeText = self.aboutMeTextView.text;
    [self.user saveInBackground];
    [self.aboutMeTextView resignFirstResponder];
}

- (IBAction)didPressCancelAboutMe:(id)sender {
    // Dismiss the keyboard and revert to previous text
    [self.aboutMeTextView resignFirstResponder];
    self.aboutMeTextView.text = self.user.aboutMeText;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    // TODO: Animate appearance of the buttons
    self.saveButton.hidden = NO;
    self.cancelButton.hidden = NO;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    // TODO: Make save and cancel buttons disappear with animation
    self.saveButton.hidden = YES;
    self.cancelButton.hidden = YES;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.userPosts[indexPath.row];
    
    // Load the cell with current post
    [cell refreshPost:post];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userPosts.count;
}

@end
