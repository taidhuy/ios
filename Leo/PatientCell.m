//
//  PatientCell.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/5/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "PatientCell.h"

@implementation PatientCell

- (void)awakeFromNib {
    // Initialization code
}

+(UINib *)nib {
    
    return [UINib nibWithNibName:@"PatientCell" bundle:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
