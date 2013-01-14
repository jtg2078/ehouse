//
//  PopTableViewController.m
//  eManagement
//
//  Created by (dbx) Amigo on 13/1/8.
//  Copyright (c) 2013年 (dbx) Amigo. All rights reserved.
//

#import "PopTableViewController.h"
#import "SecondViewController.h"
#import "IIViewDeckController.h"

@interface PopTableViewController ()

@end

@implementation PopTableViewController



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"我的專區";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
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
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.items objectAtIndex:section] count];
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PopTableViewCell";
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
        SecondViewController *sec = [[SecondViewController alloc] initWithUrl:@"http://emsgmobile.test.demo2.miniasp.com.tw/MyMSG/MyMSGSet"];
        
        [self.viewDeckController rightViewPushViewControllerOverCenterController:sec];
    }
    if (indexPath.row==1) {
        
        [self.viewDeckController closeLeftViewAnimated:YES];
        SecondViewController *sec = [[SecondViewController alloc] initWithUrl:@"http://emsgmobile.test.demo2.miniasp.com.tw/Subscribe/SubscribeSet"];
        
        [self.viewDeckController rightViewPushViewControllerOverCenterController:sec];
    }

    if (indexPath.row==2) {
        
        [self.viewDeckController closeLeftViewAnimated:YES];
        SecondViewController *sec = [[SecondViewController alloc] initWithUrl:@"http://emsgmobile.test.demo2.miniasp.com.tw/favorite"];
        
        [self.viewDeckController rightViewPushViewControllerOverCenterController:sec];
    }

    if (indexPath.row==3) {
        
        [self.viewDeckController closeLeftViewAnimated:YES];
        SecondViewController *sec = [[SecondViewController alloc] initWithUrl:@"http://emsgmobile.test.demo2.miniasp.com.tw/Label"];
        
        [self.viewDeckController rightViewPushViewControllerOverCenterController:sec];
    }

    if (indexPath.row==4) {
        
        [self.viewDeckController closeLeftViewAnimated:YES];
        SecondViewController *sec = [[SecondViewController alloc] initWithUrl:@"http://emsgmobile.test.demo2.miniasp.com.tw/Set"];
        
        [self.viewDeckController rightViewPushViewControllerOverCenterController:sec];
    }

    if (indexPath.row==5) {
        
        [self.viewDeckController closeLeftViewAnimated:YES];
        SecondViewController *sec = [[SecondViewController alloc] initWithUrl:@"http://emsgmobile.test.demo2.miniasp.com.tw/Expense"];
        
        [self.viewDeckController rightViewPushViewControllerOverCenterController:sec];
    }

    if (indexPath.row==6) {
        
        [self.viewDeckController closeLeftViewAnimated:YES];
        SecondViewController *sec = [[SecondViewController alloc] initWithUrl:@"http://emsgmobile.test.demo2.miniasp.com.tw/PubMSG"];
        
        [self.viewDeckController rightViewPushViewControllerOverCenterController:sec];
    }

    if (indexPath.row==7) {
        
        [self.viewDeckController closeLeftViewAnimated:YES];
        SecondViewController *sec = [[SecondViewController alloc] initWithUrl:@"http://emsgmobile.test.demo2.miniasp.com.tw/Schedule"];
        
        [self.viewDeckController rightViewPushViewControllerOverCenterController:sec];
    }

    if (indexPath.row==8) {
        
        [self.viewDeckController closeLeftViewAnimated:YES];
        SecondViewController *sec = [[SecondViewController alloc] initWithUrl:@"http://emsgmobile.test.demo2.miniasp.com.tw/Schedule"];
        
        [self.viewDeckController rightViewPushViewControllerOverCenterController:sec];
    }

    if (indexPath.row==9) {
        
        [self.viewDeckController closeLeftViewAnimated:YES];
        SecondViewController *sec = [[SecondViewController alloc] initWithUrl:@"http://emsgmobile.test.demo2.miniasp.com.tw/PubMSG"];
        
        [self.viewDeckController rightViewPushViewControllerOverCenterController:sec];
    }

    if (indexPath.row==10) {
        
        [self.viewDeckController closeLeftViewAnimated:YES];
        SecondViewController *sec = [[SecondViewController alloc] initWithUrl:@"http://emsgmobile.test.demo2.miniasp.com.tw/RankStat/Collection"];
        
        [self.viewDeckController rightViewPushViewControllerOverCenterController:sec];
    }

    if (indexPath.row==11) {
        
        [self.viewDeckController closeLeftViewAnimated:YES];
        SecondViewController *sec = [[SecondViewController alloc] initWithUrl:@"http://emsgmobile.test.demo2.miniasp.com.tw/Constellation"];
        
        [self.viewDeckController rightViewPushViewControllerOverCenterController:sec];
    }

    if (indexPath.row==12) {
        
        [self.viewDeckController closeLeftViewAnimated:YES];
        SecondViewController *sec = [[SecondViewController alloc] initWithUrl:@"http://emsgmobile.test.demo2.miniasp.com.tw/Weather"];
        
        [self.viewDeckController rightViewPushViewControllerOverCenterController:sec];
    }

    if (indexPath.row==13) {
        
        [self.viewDeckController closeLeftViewAnimated:YES];
        SecondViewController *sec = [[SecondViewController alloc] initWithUrl:@"http://emsgmobile.test.demo2.miniasp.com.tw/Help"];
        
        [self.viewDeckController rightViewPushViewControllerOverCenterController:sec];
    }

    if (indexPath.row==14) {
        
        [self.viewDeckController closeLeftViewAnimated:YES];
        SecondViewController *sec = [[SecondViewController alloc] initWithUrl:@"https://www.cp.gov.tw/portal/person/initial/Registry.aspx?returnUrl=http://msg.nat.gov.tw"];
        
        [self.viewDeckController rightViewPushViewControllerOverCenterController:sec];
    }

    if (indexPath.row==15) {
        
        [self.viewDeckController closeLeftViewAnimated:YES];
        SecondViewController *sec = [[SecondViewController alloc] initWithUrl:@"https://www.cp.gov.tw/portal/Person/Initial/SendPasswordMail.aspx?returnUrl=http://msg.nat.gov.tw"];
        
        [self.viewDeckController rightViewPushViewControllerOverCenterController:sec];
    }

}

@end
