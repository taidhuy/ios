//
//  LEOTwoButtonSecondaryOnlyCell+ConfigureForCell.m
//  Leo
//
//  Created by Zachary Drossman on 6/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOTwoButtonSecondaryOnlyCell+ConfigureForCell.h"
#import "LEOCard.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "LEOSecondaryUserView.h"

@implementation LEOTwoButtonSecondaryOnlyCell (ConfigureForCell)

- (void)configureForCard:(LEOCard *)card
{
    
    self.iconImageView.image = [card icon];
    self.titleLabel.text = [card title];
    
    self.secondaryUserView.user = card.secondaryUser;
    self.secondaryUserView.timeStamp = card.timestamp;
    self.secondaryUserView.cardLayout = CardLayoutTwoButtonSecondaryOnly;
    
    self.bodyLabel.text = [card body];
    [self.buttonOne setTitle:[card stringRepresentationOfActionsAvailableForState][0] forState:UIControlStateNormal];
    [self.buttonOne addTarget:card action:NSSelectorFromString([card actionsAvailableForState][0]) forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttonTwo setTitle:[card stringRepresentationOfActionsAvailableForState][1] forState:UIControlStateNormal];
    
    [self.buttonTwo addTarget:card action:NSSelectorFromString([card actionsAvailableForState][1]) forControlEvents:UIControlEventTouchUpInside];
    
    [self formatSubviews];
}

- (void)formatSubviews {
    
    self.titleLabel.font = [UIFont leoTitleBoldFont];
    self.titleLabel.textColor = [UIColor leoWarmHeavyGray];
    
    
    self.bodyLabel.font = [UIFont leoBodyBasicFont];
    self.bodyLabel.textColor = [UIColor leoWarmHeavyGray];
    
    self.buttonOne.titleLabel.font = [UIFont leoBodyBolderFont];
    [self.buttonOne setTitleColor:[UIColor leoWarmHeavyGray] forState:UIControlStateNormal];
    
    self.buttonTwo.titleLabel.font = [UIFont leoBodyBolderFont];
    [self.buttonTwo setTitleColor:[UIColor leoWarmHeavyGray] forState:UIControlStateNormal];
}


@end