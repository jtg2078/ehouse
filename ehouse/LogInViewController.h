//
//  LogInViewController.h
//  eManagement
//
//  Created by (dbx) Amigo on 13/1/9.
//  Copyright (c) 2013年 (dbx) Amigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LogInViewController : BaseViewController <UITextFieldDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *returnBarButton;

- (IBAction)returnButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@property (weak, nonatomic) IBOutlet UIButton *rememberNameButton;
@property (weak, nonatomic) IBOutlet UIButton *rememberPwdButton;
@property (weak, nonatomic) IBOutlet UIButton *autoLogInButton;

- (IBAction)optionButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)logInButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end
