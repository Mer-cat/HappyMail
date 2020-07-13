//
//  RegistrationViewController.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "RegistrationViewController.h"
#import "User.h"

@interface RegistrationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Actions

- (IBAction)didPressRegister:(id)sender {
    [self registerUser];
}

#pragma mark - Parse network calls

- (void)registerUser {
    // Initialize a user object
    User *newUser = [User user];
    
//    // Check for empty username or password
//    if ([self.usernameField.text isEqual:@""]) {
//        [self createAlertWithMessage:@"Please enter your username" withTitle:@"Username required"];
//    }
//    if([self.passwordField.text isEqual:@""]) {
//        [self createAlertWithMessage:@"Please enter your password" withTitle:@"Password required"];
//    }
    
    // Set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    // Call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            //[self createAlertWithMessage:error.localizedDescription withTitle:@"Error signing up"];
        } else {
            NSLog(@"User registered successfully");
            [self performSegueWithIdentifier:@"registrationSegue" sender:nil];
        }
    }];
}

@end
