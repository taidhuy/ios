//
//  DateTimeSelectionProtocol.h
//  Leo
//
//  Created by Zachary Drossman on 6/22/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DateTimeSelectionProtocol <NSObject>

- (void)didUpdateAppointmentDateTime:(NSDate *)dateTime;

@end
