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
#import "PostDetailsViewController.h"
#import "Post.h"
#import "ProfileHeaderCell.h"
#import "UIScrollView+EmptyDataSet.h"
#import <Parse/Parse.h>

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, PostDetailsViewControllerDelegate, ProfileHeaderCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *userPosts;

@end

@implementation ProfileViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // Do not display insets when table view is empty
    self.tableView.tableFooterView = [UIView new];
    
    // If no user has been passed in,
    // we are looking at user's own profile
    if (!self.user) {
        self.user = [User currentUser];
    } else {  // If looking at another user's profile
        // Hide self-only information
        self.logoutButton.enabled = NO;
        self.logoutButton.tintColor = UIColor.clearColor;
    }

    [self fetchMyPosts];
}

#pragma mark - ProfileHeaderCellDelegate

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

- (void)relayout {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
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
    
    PFFileObject *imageFile = [Utils getPFFileFromImage:resizedImage];
    self.user.profileImage = imageFile;
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"The profile image was saved!");
            [self.tableView reloadData];  // In order to load the new image into the image view
        } else {
            NSLog(@"Problem saving profile image: %@",error.localizedDescription);
        }
    }];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Parse query

- (void)fetchMyPosts {
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Post"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery whereKey:@"author" equalTo:self.user];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"respondees"];
    
    // Fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> *posts, NSError *error) {
        if (posts != nil) {
            self.userPosts = posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"Error getting posts: %@", error.localizedDescription);
        }
    }];
}

#pragma mark - Actions

- (IBAction)didPressLogout:(id)sender {
    // Go back to the login screen
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
    sceneDelegate.window.rootViewController = loginViewController;
    
    // Clear out the current user
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"User logged out successfully");
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ProfileHeaderCell *profileHeaderCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileHeaderCell"];
        // Load data into cell
        profileHeaderCell.delegate = self;
        [profileHeaderCell loadCell:self.user];
        return profileHeaderCell;
    } else {
        PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
        Post *post = self.userPosts[indexPath.row];
        
        // Load the cell with current post
        [cell refreshPost:post];
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.userPosts.count;
    }
}

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"lines"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = [NSString stringWithFormat:@"%@ hasn't made any posts yet", self.user];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - PostDetailsViewControllerDelegate

- (void)didRespond {
    [self.tableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PostDetailsViewSegue"]) {
        PostDetailsViewController *detailsViewController = [segue destinationViewController];
        PostCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *specificPost = self.userPosts[indexPath.row];
        detailsViewController.post = specificPost;
        detailsViewController.delegate = self;
    }
}

@end
