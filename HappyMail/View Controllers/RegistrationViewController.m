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
#import "Address.h"

@interface RegistrationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *streetAddressField;
@property (weak, nonatomic) IBOutlet UITextField *addresseeField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeField;

@end

@implementation RegistrationViewController

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
    
    [Address createNewAddress:self.streetAddressField.text city:self.cityField.text state:self.stateField.text zipcode:self.zipcodeField.text addressee:self.addresseeField.text withCompletion:^(Address *address, NSError *error) {
        if (address) {
            NSLog(@"Successfully added address to user");
            newUser.address = address;
        } else {
            NSLog(@"Error adding address for user");
        }
    }];
    
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
