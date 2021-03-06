//
//  LEODevice.h
//  Leo
//
//  Created by Zachary Drossman on 11/20/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEODevice : NSObject

+ (NSString *)deviceType;
+ (DeviceModel)deviceModel;
+ (NSString *)osVersionString;

+ (NSDictionary *)serializeToJSON;

@end
