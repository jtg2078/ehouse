//
//  LogInViewController.m
//  eManagement
//
//  Created by (dbx) Amigo on 13/1/9.
//  Copyright (c) 2013年 (dbx) Amigo. All rights reserved.
//

#import "LogInViewController.h"
#import "IIViewDeckController.h"
#import "SecondViewController.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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

- (IBAction)btn1:(id)sender {
    //UIButton *btn = (UIButton *) sender ;
    [(UIButton*) sender setSelected:![sender isSelected]];
}

- (IBAction)btn2:(id)sender {
    [(UIButton*) sender setSelected:![sender isSelected]];}

- (IBAction)btn3:(id)sender {
    [(UIButton*) sender setSelected:![sender isSelected]];        
    //btn.selected=YES;
    //uibutton 開關 select後改變image
}

- (IBAction)logIN:(id)sender {
    
}

- (IBAction)cancel:(id)sender {
}
@end
