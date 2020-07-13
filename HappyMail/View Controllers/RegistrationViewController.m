//
//  RegistrationViewController.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "RegistrationViewController.h"
#import "User.h"
#import "Utils.h"

@interface RegistrationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;

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
    
    // Set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    newUser.address = self.addressField.text;
    
    // Call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            
            // Display issue to user if anything is wrong with sign up
            [Utils showAlertWithMessage:error.localizedDescription title:@"Error signing up" controller:self];
        } else {
            NSLog(@"User registered successfully");
            [self performSegueWithIdentifier:@"registrationSegue" sender:nil];
        }
    }];
}

@end
