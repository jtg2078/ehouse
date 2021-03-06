//
//  BaseViewController.h
//  ehouse
//
//  Created by jason on 1/11/13.
//  Copyright (c) 2013 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "EHouseManager.h"

@interface BaseViewController : UIViewController
{
    
}

@property (nonatomic, weak) EHouseManager *appManager;
@property (nonatomic, weak) NSNotificationCenter *notifCenter;
@property (nonatomic, weak) NSUserDefaults *userDefaults;

- (BOOL)is4inchScreen;

@end
