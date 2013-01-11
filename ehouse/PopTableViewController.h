//
//  PopTableViewController.h
//  eManagement
//
//  Created by (dbx) Amigo on 13/1/8.
//  Copyright (c) 2013年 (dbx) Amigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray *items;
    NSArray *titleItems;
    NSArray *img;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSArray *items;
@property (strong, nonatomic) IBOutlet NSArray *titleItems;
@property (strong, nonatomic) IBOutlet NSArray *img;

@end
