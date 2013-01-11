//
//  LogInViewController.h
//  eManagement
//
//  Created by (dbx) Amigo on 13/1/9.
//  Copyright (c) 2013年 (dbx) Amigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LogInViewController : BaseViewController
{
    
}

@property (strong, nonatomic) IBOutlet UIButton *b1;
@property (strong, nonatomic) IBOutlet UIButton *b2;
@property (strong, nonatomic) IBOutlet UIButton *b3;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

- (IBAction)backHome:(id)sender;
- (IBAction)itemMenu:(id)sender;
- (IBAction)btn1:(id)sender;
- (IBAction)btn2:(id)sender;
- (IBAction)btn3:(id)sender;
- (IBAction)logIN:(id)sender;
- (IBAction)cancel:(id)sender;

@end
