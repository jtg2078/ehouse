//
//  SecondViewController.h
//  eManagement
//
//  Created by (dbx) Amigo on 13/1/4.
//  Copyright (c) 2013年 (dbx) Amigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SecondViewController : BaseViewController<UIWebViewDelegate>
{
    
}

@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *navTopText2;

@property (strong, nonatomic) NSString *myUrl;

- (id)initWithUrl:(NSString *)url;

- (IBAction)homeBack2:(id)sender;
- (IBAction)UrlItem:(id)sender;

- (void)loadURL:(NSString *)url;

@end
