//
//  LEOReviewOnboardingView.m
//  Leo
//
//  Created by Zachary Drossman on 1/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOButtonCell.h"
#import "Family.h"
#import "LEOIntrinsicSizeTableView.h"
#import "LEOReviewOnboardingView.h"
#import "LEOReviewPatientCell+ConfigureForCell.h"
#import "LEOReviewUserCell+ConfigureForCell.h"

#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "UIView+Extensions.h"


@implementation LEOReviewOnboardingView

-(instancetype)initWithFamily:(Family *)family {

    self = [super init];

    if (self) {

        _family = family;

        [self commonInit];
    }

    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];

    if (self) {

        [self commonInit];
    }

    return self;
}

- (void)commonInit {

    [self setupTouchEventForDismissingKeyboard];
}


-(void)setTableView:(LEOIntrinsicSizeTableView *)tableView {

    _tableView = tableView;

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _tableView.estimatedRowHeight = 100.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;

    _tableView.alwaysBounceVertical = NO;

    [_tableView registerNib:[LEOReviewPatientCell nib]
         forCellReuseIdentifier:kReviewPatientCellReuseIdentifer];
    [_tableView registerNib:[LEOReviewUserCell nib]
         forCellReuseIdentifier:kReviewUserCellReuseIdentifer];
    [_tableView registerNib:[LEOButtonCell nib] forCellReuseIdentifier:kButtonCellReuseIdentifier];

    _tableView.tableFooterView = [self buildAgreeViewFromString:@"By clicking subscribe you agree to our #<ts>terms of service# and #<pp>privacy policies#."];
    _tableView.tableFooterView.bounds = CGRectInset(self.tableView.tableFooterView.bounds, 0.0, -10.0);

    _tableView.dataSource = self;
}


#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger rows = 0;

    switch (section) {
            
        case TableViewSectionGuardians:
            rows = 1;
            break;

        case TableViewSectionPatients:
            rows = [self.family.patients count];
            break;

        case TableViewSectionButton:
            rows = 1;
            break;
    }

    return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return TableViewNumberOfSections;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {

        case TableViewSectionGuardians: {

            LEOReviewUserCell *reviewUserCell = [tableView dequeueReusableCellWithIdentifier:kReviewUserCellReuseIdentifer];

            Guardian *guardian = self.family.guardians[indexPath.row];

            [reviewUserCell configureForGuardian:guardian];

            return reviewUserCell;
        }

        case TableViewSectionPatients: {

            LEOReviewPatientCell *reviewPatientCell = [tableView dequeueReusableCellWithIdentifier:kReviewPatientCellReuseIdentifer];

            Patient *patient = self.family.patients[indexPath.row];

            [reviewPatientCell configureForPatient:patient patientNumber:indexPath.row];

            return reviewPatientCell;
        }

        case TableViewSectionButton: {

            LEOButtonCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:kButtonCellReuseIdentifier];

            //Using responder chain to get to continueTapped: in view controller
            [buttonCell.button addTarget:nil action:@selector(continueTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            return buttonCell;
        }
    }
    
    return nil;
}

//Adapted from http://stackoverflow.com/questions/20541676/ios-uitextview-or-uilabel-with-clickable-links-to-actions
- (UIView *)buildAgreeViewFromString:(NSString *)localizedString {

    UIView *agreeView = [UIView new];
    CGRect agreeFrame = CGRectMake(30,0,[UIScreen mainScreen].bounds.size.width - 60,74);
    agreeView.frame = agreeFrame;

    // 1. Split the localized string on the # sign:
    NSArray *localizedStringPieces = [localizedString componentsSeparatedByString:@"#"];

    // 2. Loop through all the pieces:
    NSUInteger msgChunkCount = localizedStringPieces ? localizedStringPieces.count : 0;
    CGPoint wordLocation = CGPointMake(0.0, 0.0);
    for (NSUInteger i = 0; i < msgChunkCount; i++)
    {
        NSString *chunk = [localizedStringPieces objectAtIndex:i];
        if ([chunk isEqualToString:@""])
        {
            continue;     // skip this loop if the chunk is empty
        }

        // 3. Determine what type of word this is:
        BOOL isTermsOfServiceLink = [chunk hasPrefix:@"<ts>"];
        BOOL isPrivacyPolicyLink  = [chunk hasPrefix:@"<pp>"];
        BOOL isLink = (BOOL)(isTermsOfServiceLink || isPrivacyPolicyLink);

        // 4. Create label, styling dependent on whether it's a link:
        UILabel *label = [UILabel new];
        label.font = [UIFont leo_standardFont];
        label.text = chunk;
        label.userInteractionEnabled = isLink;

        if (isLink)
        {
            label.textColor = [UIColor leo_blue];

            // 5. Set tap gesture for this clickable text:
            SEL selectorAction = isTermsOfServiceLink ? @selector(tapOnTermsOfServiceLink:) : @selector(tapOnPrivacyPolicyLink:);
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:selectorAction];
            [label addGestureRecognizer:tapGesture];

            // Trim the markup characters from the label:
            if (isTermsOfServiceLink)
                label.text = [label.text stringByReplacingOccurrencesOfString:@"<ts>" withString:@""];
            if (isPrivacyPolicyLink)
                label.text = [label.text stringByReplacingOccurrencesOfString:@"<pp>" withString:@""];
        }
        else
        {
            label.textColor = [UIColor leo_grayStandard];
        }

        // 6. Lay out the labels so it forms a complete sentence again:

        // If this word doesn't fit at end of this line, then move it to the next
        // line and make sure any leading spaces are stripped off so it aligns nicely:

        [label sizeToFit];

        if (agreeView.frame.size.width < wordLocation.x + label.bounds.size.width)
        {
            wordLocation.x = 0.0;                       // move this word all the way to the left...
            wordLocation.y += label.frame.size.height;  // ...on the next line

            // And trim of any leading white space:
            NSRange startingWhiteSpaceRange = [label.text rangeOfString:@"^\\s*"
                                                                options:NSRegularExpressionSearch];
            if (startingWhiteSpaceRange.location == 0)
            {
                label.text = [label.text stringByReplacingCharactersInRange:startingWhiteSpaceRange
                                                                 withString:@""];
                [label sizeToFit];
            }
        }

        // Set the location for this label:
        label.frame = CGRectMake(wordLocation.x,
                                 wordLocation.y,
                                 label.frame.size.width,
                                 label.frame.size.height);


        [agreeView addSubview:label];

        // Update the horizontal position for the next word:
        wordLocation.x += label.frame.size.width;
    }
    
    return agreeView;
}


@end
