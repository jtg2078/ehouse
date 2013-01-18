//
//  LogInViewController.m
//  eManagement
//
//  Created by (dbx) Amigo on 13/1/9.
//  Copyright (c) 2013年 (dbx) Amigo. All rights reserved.
//

#import "LogInViewController.h"
#import "IIViewDeckController.h"
#import "RootViewController.h"
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
    
    // make the bg stretchable
    UIImage *bgImage = [[UIImage imageNamed:@"back-image.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(416, 0, 0, 0)];
    self.bgImageView.image = bgImage;
    
    self.myScrollView.contentSize = self.myContentView.bounds.size;
    [self.myScrollView addSubview:self.myContentView];
    
    self.nameTextField.text = self.appManager.accoutName;
    self.pwdTextField.text = self.appManager.accoutPwd;
    self.rememberNameButton.selected = self.nameTextField.text.length > 0;
    self.rememberPwdButton.selected = self.pwdTextField.text.length > 0;
    self.autoLogInButton.selected = [self.appManager.autoLogin boolValue];
    
    
    if(DEVELOPMENT_MODE)
    {
        self.nameTextField.text = @"a25339306";
        self.pwdTextField.text = @"a19841019";
    }
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
    [self setMyScrollView:nil];
    [self setMyContentView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self subscribeForKeyboardEvents];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self unsubscribeFromKeyboardEvents];
    [self.view endEditing:YES];
    
    [super viewWillDisappear:animated];
}

#pragma mark - keyboard

- (void)subscribeForKeyboardEvents
{
    /* Listen for keyboard */
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unsubscribeFromKeyboardEvents
{
    /* No longer listen for keyboard */
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    UIViewAnimationCurve curve = [[info  objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGRect endFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    endFrame = [self.view convertRect:endFrame fromView:nil]; //rects are in screen coordinates
    
    CGSize contentSize = self.myContentView.frame.size;
    contentSize.height += endFrame.size.height;
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:curve
                     animations:^{self.myScrollView.contentSize = contentSize;}
                     completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    UIViewAnimationCurve curve = [[info  objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:curve
                     animations:^{self.myScrollView.contentSize = self.myContentView.frame.size;}
                     completion:nil];
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
    self.logInButton.enabled = NO;
    
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
    
    if(self.nameTextField.text.length == 0 || self.pwdTextField.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"帳號/密碼不正確"];
        self.logInButton.enabled = YES;
        return;
    }
    
    [SVProgressHUD showWithStatus:@"登入中"];
    
    [self.appManager loginWithAccountName:self.nameTextField.text
                                      pwd:self.pwdTextField.text
                                  success:^(NSString *token){
                                      [SVProgressHUD showSuccessWithStatus:@"登入成功"];
                                      self.logInButton.enabled = YES;
                                      
                                      IIViewDeckController *viewDeck = (IIViewDeckController *)self.appDelegate.window.rootViewController;
                                      UINavigationController *nav = (UINavigationController *)viewDeck.centerController;
                                      if([nav.topViewController isKindOfClass:[SecondViewController class]]) {
                                          SecondViewController *svc = (SecondViewController *)nav.topViewController;
                                          [svc loadURL:[self.appManager createURLWithToken:token]];
                                      }
                                      else if ([nav.topViewController isKindOfClass:[RootViewController class]])
                                      {
                                          RootViewController *rvc = (RootViewController *)nav.topViewController;
                                          SecondViewController *svc = [[SecondViewController alloc] initWithUrl:[self.appManager createURLWithToken:token]];
                                          [rvc.navigationController pushViewController:svc animated:NO];
                                      }
                                       
                                      [self dismissModalViewControllerAnimated:YES];
                                  }
                                  failure:^(NSString *errorMsg, NSError *error) {
                                      [SVProgressHUD showErrorWithStatus:errorMsg];
                                      self.logInButton.enabled = YES;
                                  }];
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)loginId:(id)sender {
    
    
    
    IIViewDeckController *viewDeck = (IIViewDeckController *)self.appDelegate.window.rootViewController;
    UINavigationController *nav = (UINavigationController *)viewDeck.centerController;
    if([nav.topViewController isKindOfClass:[SecondViewController class]]) {
        SecondViewController *svc = (SecondViewController *)nav.topViewController;
        [svc loadURL:@"https://www.cp.gov.tw/portal/person/initial/Registry.aspx?returnUrl=http://msg.nat.gov.tw"];
    }
    else if ([nav.topViewController isKindOfClass:[RootViewController class]])
    {
        RootViewController *rvc = (RootViewController *)nav.topViewController;
        SecondViewController *svc = [[SecondViewController alloc] initWithUrl:@"https://www.cp.gov.tw/portal/person/initial/Registry.aspx?returnUrl=http://msg.nat.gov.tw"];
        [rvc.navigationController pushViewController:svc animated:NO];
    }
    
    [self dismissModalViewControllerAnimated:YES];
    
    
}

- (IBAction)forgetPassword:(id)sender {
    IIViewDeckController *viewDeck = (IIViewDeckController *)self.appDelegate.window.rootViewController;
    UINavigationController *nav = (UINavigationController *)viewDeck.centerController;
    if([nav.topViewController isKindOfClass:[SecondViewController class]]) {
        SecondViewController *svc = (SecondViewController *)nav.topViewController;
        [svc loadURL:@"https://www.cp.gov.tw/portal/Person/Initial/SendPasswordMail.aspx?returnUrl=http://msg.nat.gov.tw"];
    }
    else if ([nav.topViewController isKindOfClass:[RootViewController class]])
    {
        RootViewController *rvc = (RootViewController *)nav.topViewController;
        SecondViewController *svc = [[SecondViewController alloc] initWithUrl:@"https://www.cp.gov.tw/portal/Person/Initial/SendPasswordMail.aspx?returnUrl=http://msg.nat.gov.tw"];
        [rvc.navigationController pushViewController:svc animated:NO];
    }
    
    [self dismissModalViewControllerAnimated:YES];

    }

@end
