//
//  BaseViewController.h
//  ehouse
//
//  Created by jason on 1/11/13.
//  Copyright (c) 2013 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "EHouseManager.h"

@interface BaseViewController : UIViewController
{
    
}

@property (nonatomic, weak) EHouseManager *appManager;
@property (nonatomic, weak) AppDelegate *appDelegate;

@end
