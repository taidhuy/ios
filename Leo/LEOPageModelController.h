//
//  LEOPageModelController.h
//  Leo
//
//  Created by Zachary Drossman on 5/26/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOPageModelController : NSObject <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

- (instancetype)initWithPageData:(NSArray *)pageData;
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (void)pageViewController:(UIPageViewController *)pageViewController flipToViewController:(UIViewController *)viewController;

@end