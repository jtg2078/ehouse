//
//  RootViewController.h
//  eManagement
//
//  Created by (dbx) Amigo on 12/12/28.
//  Copyright (c) 2012年 (dbx) Amigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface RootViewController : BaseViewController<UIWebViewDelegate>
{
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *navTopText;

- (IBAction)homeBack:(id)sender;
- (IBAction)UrlItem:(id)sender;

- (void)reload;

@end
