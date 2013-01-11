//
//  SideMenuViewController.m
//  ehouse
//
//  Created by jason on 1/11/13.
//  Copyright (c) 2013 jason. All rights reserved.
//

#import "SideMenuViewController.h"
#import "SecondViewController.h"
#import "IIViewDeckController.h"

@interface SideMenuViewController ()

@end

@implementation SideMenuViewController

#pragma mark - memory management

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
    
    self.title = @"我的專區";
    
    NSString *item1 =@"我的訊息";
    NSString *item2 =@"訊息訂閱";
    NSString *item3 =@"我的收藏";
    NSString *item4 =@"標簽管理";
    NSString *item5 =@"設定";
    NSString *item6 =@"費用統計";
    NSString *item7 =@"公眾訊息";
    NSString *item8 =@"匯入行事曆";
    NSString *item9 =@"粉絲團";
    NSString *item10 =@"公眾訊息";
    NSString *item11 =@"排行榜";
    NSString *item12 =@"星座服務";
    NSString *item13 =@"天氣服務";
    NSString *item14 =@"新手上路";
    NSString *item15 =@"註冊會員";
    NSString *item16 =@"忘記密碼";
    
    NSMutableArray *section1 = [[NSMutableArray alloc] initWithObjects:item1,item2,item3,item4,item5,item6,item7,item8,item9,item10,item11,item12,item13,item14,item15,item16, nil];
    self.items = [[NSMutableArray alloc] initWithObjects:section1, nil];
    
    NSString *title = @"我的專區";
    self.titleItems = [[NSMutableArray alloc] initWithObjects:title, nil];
    
    NSString *img1 = @"my_msg_icon.png";
    NSString *img2 = @"order_msg_icon.png";
    NSString *img3 = @"my_favorite_icon.png";
    NSString *img4 = @"tag_setting_icon.png";
    NSString *img5 = @"setting_icon.png";
    NSString *img6 = @"cost_statistics_icon.png";
    NSString *img7 = @"public_msg_icon.png";
    NSString *img8 = @"import_schedule_icon.png";
    NSString *img9 = @"fb_fans_icon.png";
    NSString *img10 = @"public_msg_icon.png";
    NSString *img11 = @"ranking_icon.png";
    NSString *img12 = @"constellation_service_icon.png";
    NSString *img13 = @"weather_service_icon.png";
    NSString *img14 = @"helper_icon.png";
    NSString *img15 = @"register_icon.png";
    NSString *img16 = @"forget_password_icon.png";
    NSMutableArray *imgA = [[NSMutableArray alloc] initWithObjects:img1,img2,img3,img4,img5,img6,img7,img8,img9,img10,img11,img12,img13,img14,img15,img16, nil];
    self.img = [[NSMutableArray alloc] initWithObjects:imgA, nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.items objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SideMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    // Configure the cell...
    cell.textLabel.text = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[[self.img objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        
        [self.viewDeckController closeLeftViewAnimated:YES];
        SecondViewController *sec = [[SecondViewController alloc] initWithUrl:@"http://emsgmobile.test.demo2.miniasp.com.tw"];
        
        [self.viewDeckController rightViewPushViewControllerOverCenterController:sec];
    }
}



- (void)viewDidUnload {
    [self setMyTableView:nil];
    [super viewDidUnload];
}
@end
