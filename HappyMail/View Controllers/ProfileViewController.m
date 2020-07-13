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

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
