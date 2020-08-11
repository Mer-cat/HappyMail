//
//  ProfileHeaderCell.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/28/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "ProfileHeaderCell.h"
#import "Utils.h"
#import <ChameleonFramework/Chameleon.h>
@import Parse;

@interface ProfileHeaderCell() <UITextViewDelegate, ProfileViewControllerDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *aboutMeTextView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UILabel *usersPostsLabel;
@property (nonatomic, strong) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *mailLocationImage;
@property (nonatomic, strong) UITapGestureRecognizer *imageTapGesture;
@property (weak, nonatomic) IBOutlet UILabel *thankYouCountLabel;

@end

@implementation ProfileHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Add tap gesture recognizer to profile image
    self.imageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPressImage)];
    [self.profileImageView addGestureRecognizer:self.imageTapGesture];
}

#pragma mark - Init

- (void)loadCell:(User *)user externalData:(UserExternalData *)externalData {
    self.aboutMeTextView.delegate = self;
    
    self.user = user;
    [self setAccessPermissions];

    // Round corners of various fields
    [Utils roundCorners:self.aboutMeTextView];
    [Utils roundCorners:self.mapButton];
    [Utils roundCorners:self.saveButton];
    [Utils roundCorners:self.cancelButton];
    
    // Make profile picture circular
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    [Utils createBorder:self.profileImageView color:FlatBlack];
    
    // Set labels
    self.usernameLabel.text = user.username;
    self.usersPostsLabel.text = [NSString stringWithFormat:@"Posts by %@",user.username];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM-dd-yyyy"];
    NSString *joinDateString = [dateFormatter stringFromDate:user.createdAt];
    
    self.joinDateLabel.text = [NSString stringWithFormat:@"Joined %@", joinDateString];
    self.aboutMeTextView.text = user.aboutMeText;
    
    UIImage *placeholderImage = [UIImage imageNamed:@"blank-profile-picture"];
    [self.profileImageView setImage: placeholderImage];
    
    self.profileImageView.file = user.profileImage;
    [self.profileImageView loadInBackground];
    
    if (externalData) {
        self.thankYouCountLabel.text = [NSString stringWithFormat:@"Thank Yous: %lu", externalData.thankYous.count];
    }
}

- (void)makeDelegateOfViewController:(ProfileViewController *)controller {
    controller.delegate = self;
}

#pragma mark - ProfileViewControllerDelegate

- (void)didChangeProfileImage:(UIImage *)image {
    self.profileImageView.image = image;
}

#pragma mark - Helpers

- (void)setAccessPermissions {
    if(self.user != [User currentUser]) {
        self.aboutMeTextView.editable = NO;
        self.mapButton.hidden = YES;
        self.mailLocationImage.hidden = YES;
        self.saveButton.hidden = YES;
        self.cancelButton.hidden = YES;
    }
}

#pragma mark - Actions

- (void)didPressImage {
    // Only user who owns account may change profile image
    if (self.user == [User currentUser]) {
        [self.delegate initUIImagePickerController];
    }
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
    [self.delegate relayout];
}

#pragma mark - UITextViewDelegate

/**
 * Fade in save and cancel buttons
 */
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [UIButton animateWithDuration:0.5 animations:^{
        self.saveButton.alpha = 1;
        self.cancelButton.alpha = 1;
    }];
}

/**
 * Fade out save and cancel buttons
 */
- (void)textViewDidEndEditing:(UITextView *)textView {
    [UIButton animateWithDuration:0.5 animations:^{
        self.saveButton.alpha = 0;
        self.cancelButton.alpha = 0;
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.delegate relayout];
}

@end
