//
//  ScheduleViewController.h
//  eManagement
//
//  Created by (dbx) Amigo on 13/1/9.
//  Copyright (c) 2013年 (dbx) Amigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ScheduleViewController : BaseViewController
{
    
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrillView;

- (IBAction)itemMenu:(id)sender;
- (IBAction)backHome:(id)sender;
- (IBAction)check1:(id)sender;
- (IBAction)check2:(id)sender;
- (IBAction)check3:(id)sender;
- (IBAction)check4:(id)sender;
- (IBAction)check5:(id)sender;
- (IBAction)check6:(id)sender;
- (IBAction)check7:(id)sender;
- (IBAction)check8:(id)sender;
- (IBAction)enter:(id)sender;

@end
