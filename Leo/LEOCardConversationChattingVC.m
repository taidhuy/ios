//
//  LEOCardConversationChattingVC.m
//  Leo
//
//  Created by Zachary Drossman on 7/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOCardConversationChattingVC.h"

#import "UIColor+LeoColors.h"
#import "LEOMessagesViewController.h"

NSString *const kMessagesViewControllerSegue = @"MessagesViewControllerSegue";

@interface LEOCardConversationChattingVC ()

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@end

@implementation LEOCardConversationChattingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)iconImage {
    return [UIImage imageNamed:@"Icon-Chat"];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kMessagesViewControllerSegue]) {
        LEOMessagesViewController *messagesVC = segue.destinationViewController;
        messagesVC.card = (LEOCardConversation *)self.card;
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
