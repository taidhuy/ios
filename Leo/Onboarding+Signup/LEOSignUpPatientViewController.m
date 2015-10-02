//
//  LEOSignUpPatientViewController.m
//  Leo
//
//  Created by Zachary Drossman on 9/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOSignUpPatientViewController.h"

#import "LEOValidatedFloatLabeledTextField.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "UIImage+Extensions.h"

#import "LEOApiReachability.h"

#import "LEOValidationsHelper.h"
#import "LEOSignUpPatientView.h"
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>
#import <NSDate+DateTools.h>
#import "NSDate+Extensions.h"
#import "LEOValidationsHelper.h"
#import "LEOMessagesAvatarImageFactory.h"

#import "Family.h"
#import "Patient.h"

@interface LEOSignUpPatientViewController ()

@property (strong, nonatomic) LEOSignUpPatientView *signUpPatientView;
@property (weak, nonatomic) IBOutlet StickyView *stickyView;
@property (nonatomic) BOOL isNewFamily;
@end

@implementation LEOSignUpPatientViewController


#pragma mark - View Controller Lifecycle & Helpers

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupStickyView];
    [self setupFirstNameField];
    [self setupLastNameField];
    [self setupBirthDateField];
    [self setupAvatarButton];
    [self setupAvatarValidationLabel];
    [self setupGenderField];
}

- (void)setupStickyView {
    
    self.stickyView.delegate = self;
    self.stickyView.tintColor = [UIColor leoOrangeRed];
    [self.stickyView reloadViews];
}

- (void)setupFirstNameField {
    
    [self firstNameTextField].delegate = self;
    [self firstNameTextField].standardPlaceholder = @"first name";
    [self firstNameTextField].validationPlaceholder = @"please enter a valid first name";
    [[self firstNameTextField] sizeToFit];

    [self firstNameTextField].text = self.patient.firstName;
}

- (void)setupLastNameField {
    
    [self lastNameTextField].delegate = self;
    [self lastNameTextField].standardPlaceholder = @"last name";
    [self lastNameTextField].validationPlaceholder = @"please enter a valid last name";
    [[self lastNameTextField] sizeToFit];

    [self lastNameTextField].text = self.patient.lastName;
}

- (void)setupBirthDateField {
    
    [self birthDateTextField].delegate = self;
    [self birthDateTextField].standardPlaceholder = @"birth date";
    [self birthDateTextField].validationPlaceholder = @"please add your child's birth date";
    [[self birthDateTextField] sizeToFit];

    [self birthDateTextField].enabled = NO;
    self.signUpPatientView.birthDatePromptView.accessoryImageViewVisible = YES;
    self.signUpPatientView.birthDatePromptView.delegate = self;

    [self birthDateTextField].text = [NSDate stringifiedShortDate:self.patient.dob];
}

- (void)setupGenderField {
    
    [self genderTextField].delegate = self;
    [self genderTextField].standardPlaceholder = @"gender";
    [self genderTextField].validationPlaceholder = @"please provide us with your child's gender";
    [[self genderTextField] sizeToFit];

    [self genderTextField].enabled = NO;
    self.signUpPatientView.genderPromptView.accessoryImageViewVisible = YES;
    self.signUpPatientView.genderPromptView.accessoryImage = [UIImage imageNamed:@"Icon-Forms"];
    self.signUpPatientView.genderPromptView.delegate = self;

    [self genderTextField].text = self.patient.gender;
}

- (void)setupAvatarValidationLabel {
    self.signUpPatientView.avatarValidationLabel.font = [UIFont leoMenuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    self.signUpPatientView.avatarValidationLabel.textColor = [UIColor leoOrangeRed];
    self.signUpPatientView.avatarValidationLabel.text = @"";
}
- (void)setupAvatarButton {

    [[self avatarButton] addTarget:self action:@selector(presentPhotoPicker:) forControlEvents:UIControlEventTouchUpInside];

    if (self.patient.avatar) {

        [self updateButtonWithImage:self.patient.avatar];
    }
}


#pragma mark - <UIImagePickerViewControllerDelegate>

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:originalImage cropMode:RSKImageCropModeCircle];
    imageCropVC.delegate = self;

    [self.navigationController pushViewController:imageCropVC animated:NO];

    [self dismissViewControllerAnimated:NO completion:^{

        self.signUpPatientView.avatarValidationLabel.text = @"";
    }];
}


#pragma mark - <RSKImageCropViewControllerDelegate>

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
{
    [self updateButtonWithImage:croppedImage];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateButtonWithImage:(UIImage *)avatarImage {
    
    UIImage *circularAvatarImage = [LEOMessagesAvatarImageFactory circularAvatarImage:avatarImage withDiameter:67 borderColor:[UIColor leoOrangeRed] borderWidth:1.0];
    [[self avatarButton] setImage:circularAvatarImage forState:UIControlStateNormal];
    self.patient.avatar = avatarImage;
}

#pragma mark - <StickyViewDelegate>

- (BOOL)scrollable {
    return YES;
}

- (BOOL)initialStateExpanded {
    return YES;
}

- (NSString *)expandedTitleViewContent {
    return @"Now, tell us about your child";
}


- (NSString *)collapsedTitleViewContent {
    return @" ";
}

- (UIView *)stickyViewBody{
    return self.signUpPatientView;
}

- (UIImage *)expandedGradientImage {
    
    return [UIImage imageWithColor:[UIColor leoWhite]];
}

- (UIImage *)collapsedGradientImage {
    return [UIImage imageWithColor:[UIColor leoWhite]];
}

-(UIViewController *)associatedViewController {
    return self;
}

- (LEOSignUpPatientView *)signUpPatientView {
    
    if (!_signUpPatientView) {
        
        _signUpPatientView = [[LEOSignUpPatientView alloc] init];
        _signUpPatientView.tintColor = [UIColor leoOrangeRed];
    }
    
    return _signUpPatientView;
}


#pragma mark - <LEOPromptViewDelegate>

-(void)respondToPrompt:(id)sender {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (sender == self.signUpPatientView.birthDatePromptView) {
        
        [self selectADate:sender];
    }
    
    if (sender == self.signUpPatientView.genderPromptView) {
        
        [self selectAGender:sender];
    }
}


#pragma mark - <ActionSheetPicker-3.0>

- (void)selectADate:(UIControl *)sender {
    
    NSDate *minDate = [[NSDate date] dateBySubtractingYears:26];
    NSDate *maxDate = [NSDate date];
    
    NSDate *selectedDate = [NSDate dateFromShortDate:[self birthDateTextField].text] ?: [NSDate date];
    
    AbstractActionSheetPicker *actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:selectedDate
                                                                                    minimumDate:minDate
                                                                                    maximumDate:maxDate
                                                                                         target:self action:@selector(dateWasSelected:element:) origin:sender];
    
    actionSheetPicker.hideCancel = YES;
    [actionSheetPicker showActionSheetPicker];
}

- (void)selectAGender:(UIControl *)sender {
    
    NSInteger selectedIndex = 0;
    
    if ([[self genderTextField].text isEqualToString:@"Male"]) {
        
        selectedIndex = 1;
    }
    
    AbstractActionSheetPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:nil rows:@[@"Female",@"Male"] initialSelection:selectedIndex target:self successAction:@selector(genderWasSelected:element:) cancelAction:nil origin:sender];
    picker.hideCancel = YES;
    picker.pickerBackgroundColor = [UIColor blackColor];
    picker.pickerTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                    NSFontAttributeName:[UIFont leoStandardFont],};
    [picker showActionSheetPicker];
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    
    [self birthDateTextField].text = [NSDate stringifiedShortDate:selectedDate];
}

- (void)genderWasSelected:(NSNumber *)selectedGender element:(id)element {

   [self genderTextField].text = ([selectedGender isEqualToNumber:@0]) ? @"Female" : @"Male";
}

#pragma mark - Navigation

- (void)continueTapped:(UIButton *)sender {
    
    if ([self validatePage]) {
        
        [self addOnboardingData];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)addOnboardingData {

    self.patient.firstName = [self firstNameTextField].text;
    self.patient.lastName = [self lastNameTextField].text;
    self.patient.gender = [self genderTextField].text;
    self.patient.dob = [NSDate dateFromShortDate:[self birthDateTextField].text];
    
    if (self.managementMode == ManagementModeCreate) {
        
        [self.family addPatient:self.patient];
    }
}

-(Patient *)patient {
    
    if (!_patient) {
        
        _patient = [[Patient alloc] init];
    }
    
    return _patient;
}


- (void)presentPhotoPicker:(id)sender {
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.delegate = self;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Validation

- (BOOL)validatePage {
    
    BOOL validFirstName = [LEOValidationsHelper isValidFirstName:[self firstNameTextField].text];
    BOOL validLastName = [LEOValidationsHelper isValidLastName:[self lastNameTextField].text];
    BOOL validBirthDate = [LEOValidationsHelper isValidBirthDate:[self birthDateTextField].text];
    BOOL validGender = [LEOValidationsHelper isValidGender:[self genderTextField].text];
    BOOL validAvatar = self.signUpPatientView.avatarButton.imageView.image ? YES : NO;
    
    [self firstNameTextField].valid = validFirstName;
    [self lastNameTextField].valid = validLastName;
    [self birthDateTextField].valid = validBirthDate;
    [self genderTextField].valid = validGender;
    
    if (!validAvatar) {
        
        self.signUpPatientView.avatarValidationLabel.text = @"please tap the camera to add a photo of your child";
    }
    
    return validAvatar && validFirstName && validLastName && validBirthDate && validGender;
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    
    [mutableText replaceCharactersInRange:range withString:string];
    
    if (textField == [self firstNameTextField] && ![self firstNameTextField].valid) {
        
        self.firstNameTextField.valid = [LEOValidationsHelper isValidFirstName:mutableText.string];
    }
    
    if (textField == self.lastNameTextField && ![self lastNameTextField].valid) {
     
        self.lastNameTextField.valid = [LEOValidationsHelper isValidLastName:mutableText.string];
    }
        
    return YES;
}


#pragma mark - Shorthand Helpers

- (LEOValidatedFloatLabeledTextField *)firstNameTextField {
    return self.signUpPatientView.firstNamePromptView.textField;
}

- (LEOValidatedFloatLabeledTextField *)lastNameTextField {
    return self.signUpPatientView.lastNamePromptView.textField;
}

- (LEOValidatedFloatLabeledTextField *)birthDateTextField {
    return self.signUpPatientView.birthDatePromptView.textField;
}

- (LEOValidatedFloatLabeledTextField *)genderTextField {
    return self.signUpPatientView.genderPromptView.textField;
}

- (UIButton *)avatarButton {
    return self.signUpPatientView.avatarButton;
}



@end
