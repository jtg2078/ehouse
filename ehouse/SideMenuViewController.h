//
//  SideMenuViewController.h
//  ehouse
//
//  Created by jason on 1/11/13.
//  Copyright (c) 2013 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SideMenuViewController : BaseViewController
{
    
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSArray *titleItems;
@property (strong, nonatomic) NSArray *img;

@end
