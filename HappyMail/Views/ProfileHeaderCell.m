//
//  ProfileHeaderCell.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/28/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "ProfileHeaderCell.h"
#import "Utils.h"
#import "ProfileViewController.h"
@import Parse;

@interface ProfileHeaderCell() <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
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

@end

@implementation ProfileHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Add tap gesture recognizer to profile image
    UITapGestureRecognizer *imageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPressImage)];
    [self.profileImageView addGestureRecognizer:imageTapGesture];
}

#pragma mark - Init

- (void)loadCell:(User *)user {
    self.aboutMeTextView.delegate = self;
    
    self.user = user;
    if(user != [User currentUser]) {
        self.aboutMeTextView.editable = NO;
        self.mapButton.hidden = YES;
        self.mailLocationImage.hidden = YES;
    }
    // Round corners
    [Utils roundCorners:self.aboutMeTextView];
    
    // Make profile picture circular
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    
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
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.saveButton.hidden = NO;
    self.cancelButton.hidden = NO;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.saveButton.hidden = YES;
    self.cancelButton.hidden = YES;
}

@end