//
//  ScheduleViewController.m
//  eManagement
//
//  Created by (dbx) Amigo on 13/1/9.
//  Copyright (c) 2013年 (dbx) Amigo. All rights reserved.
//

#import "ScheduleViewController.h"
#import "IIViewDeckController.h"

@interface ScheduleViewController ()

@end

@implementation ScheduleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _scrillView.contentSize = CGSizeMake(320, 461);
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}

- (IBAction)itemMenu:(id)sender {
    if([self.viewDeckController isSideClosed:IIViewDeckLeftSide] == YES)
    {
        [self.viewDeckController openLeftViewAnimated:YES];
    }
    else
    {
        [self.viewDeckController closeLeftViewAnimated:YES];
    }

}

- (IBAction)backHome:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (IBAction)check1:(id)sender {
    [(UIButton*) sender setSelected:![sender isSelected]];
}

- (IBAction)check2:(id)sender {
    [(UIButton*) sender setSelected:![sender isSelected]];
}

- (IBAction)check3:(id)sender {
   [(UIButton*) sender setSelected:![sender isSelected]];}

- (IBAction)check4:(id)sender {
   [(UIButton*) sender setSelected:![sender isSelected]];
}

- (IBAction)check5:(id)sender {
    [(UIButton*) sender setSelected:![sender isSelected]];
}

- (IBAction)check6:(id)sender {
    [(UIButton*) sender setSelected:![sender isSelected]];}

- (IBAction)check7:(id)sender {
    [(UIButton*) sender setSelected:![sender isSelected]];
}

- (IBAction)check8:(id)sender {
    [(UIButton*) sender setSelected:![sender isSelected]];
}

- (IBAction)enter:(id)sender {
}
@end
