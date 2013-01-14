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

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *bgImage = [[UIImage imageNamed:@"back-image.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(416, 0, 0, 0)];
    self.bgImageView.image = bgImage;
}

- (void)viewDidUnload
{
    [self setBgImageView:nil];
    [self setReturnBarButton:nil];
    [self setNameTextField:nil];
    [self setPwdTextField:nil];
    [self setRememberNameButton:nil];
    [self setRememberPwdButton:nil];
    [self setAutoLogInButton:nil];
    [self setLogInButton:nil];
    [self setCancelButton:nil];
    [super viewDidUnload];
}

#pragma mark - user interaction

- (IBAction)returnButtonPressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)optionButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}

- (IBAction)logInButtonPressed:(id)sender
{
    if(self.rememberNameButton.selected && self.nameTextField.text.length)
        self.appManager.accoutName = self.nameTextField.text;
    else
        self.appManager.accoutName = nil;
    
    if(self.rememberPwdButton.selected && self.pwdTextField.text.length)
        self.appManager.accoutPwd = self.pwdTextField.text;
    else
        self.appManager.accoutPwd = nil;
    
    if(self.autoLogInButton.selected && self.appManager.accoutName && self.appManager.accoutPwd)
        self.appManager.autoLogin = @(YES);
    else
        self.appManager.autoLogin = @(NO);
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
