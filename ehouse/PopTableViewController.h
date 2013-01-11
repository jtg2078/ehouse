//
//  PopTableViewController.h
//  eManagement
//
//  Created by (dbx) Amigo on 13/1/8.
//  Copyright (c) 2013年 (dbx) Amigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
{
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSArray *items;
@property (strong, nonatomic)  NSArray *titleItems;
@property (strong, nonatomic)  NSArray *img;

@end
