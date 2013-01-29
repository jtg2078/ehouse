//
//  ScheduleViewController.m
//  eManagement
//
//  Created by (dbx) Amigo on 13/1/9.
//  Copyright (c) 2013年 (dbx) Amigo. All rights reserved.
//

#import "ScheduleViewController.h"
#import "IIViewDeckController.h"
#import "SecondViewController.h"
#import "RootViewController.h"
#import "AppDelegate.h"

@interface ScheduleViewController ()
@property (nonatomic, strong) NSArray *messages;
@end

@implementation ScheduleViewController

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    
}

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [SVProgressHUD dismiss];
    [super viewDidLoad];
    
    // -------------------- view --------------------
    
    self.scrillView.contentSize = CGSizeMake(320, 461);
    [self.scrillView addSubview:self.myContentView];
    
    if([self is4inchScreen])
    {
        int adjust = 416 + 88 - 461;
        self.myContentView.frame = CGRectMake(0, 0, 320, 461 + adjust);
        self.scrillView.contentSize = CGSizeMake(320, 461 + adjust);
        
        UIImage *bgImage = [[UIImage imageNamed:@"schedule-Bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(460, 0, 0, 0)];
        self.bgImageView.image = bgImage;
    }
    
    self.allMsgBtn.selected = [self loadSelectStateForTag:self.allMsgBtn.tag];
    self.partialMsgBtn.selected = [self loadSelectStateForTag:self.partialMsgBtn.tag];
    self.paymentMsgBtn.selected = [self loadSelectStateForTag:self.paymentMsgBtn.tag];
    self.importantMsgBtn.selected = [self loadSelectStateForTag:self.importantMsgBtn.tag];
    self.holidayBtn.selected = [self loadSelectStateForTag:self.holidayBtn.tag];
    self.favoriteBtn.selected = [self loadSelectStateForTag:self.favoriteBtn.tag];
    self.customBtn.selected = [self loadSelectStateForTag:self.customBtn.tag];
    self.autoImportBtn.selected = [self loadSelectStateForTag:self.autoImportBtn.tag];
    
    // -------------------- other --------------------
    
    self.ccvc = [[CalendarChooserViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.ccvc.delegate = self;
    self.nav_ccvc = [[UINavigationController alloc] initWithRootViewController:self.ccvc];
    self.nav_ccvc.navigationBar.barStyle = UIBarStyleBlackOpaque;
}

- (void)viewDidUnload
{
    [self setAllMsgBtn:nil];
    [self setPartialMsgBtn:nil];
    [self setPaymentMsgBtn:nil];
    [self setImportantMsgBtn:nil];
    [self setHolidayBtn:nil];
    [self setFavoriteBtn:nil];
    [self setCustomBtn:nil];
    [self setAutoImportBtn:nil];
    [self setImportButton:nil];
    [self setBgImageView:nil];
    [self setMyContentView:nil];
    [super viewDidUnload];
}

#pragma mark - user interaction

- (IBAction)optionButtonPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    
    [self saveSelectStateForTag:btn.tag selected:btn.selected];
}

- (IBAction)importButtonPressed:(id)sender
{
    // save the auto import setting
    [self.userDefaults setBool:self.autoImportBtn.selected forKey:KEY_AUTO_IMPORT];
    [self.userDefaults synchronize];
    
    if (!self.allMsgBtn.selected &&
        !self.paymentMsgBtn.selected &&
        !self.importantMsgBtn.selected &&
        !self.holidayBtn.selected &&
        !self.favoriteBtn.selected &&
        !self.customBtn.selected)
        return;
    
    [self lockScreen];
    
    [self.appManager downloadMessagesForTypePersonal:self.allMsgBtn.selected
                                             payment:self.paymentMsgBtn.selected
                                           important:self.importantMsgBtn.selected
                                            vacation:self.holidayBtn.selected
                                            favorite:self.favoriteBtn.selected
                                           customize:self.customBtn.selected
                                               token:self.appManager.userInfo.token
                                             success:^(NSArray *messageInfo, int availableToImportCount) {
                                                 
                                                 [self releaseScreen];
                                                 
                                                 if (messageInfo == nil || [messageInfo count] == 0)
                                                 {
                                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"無新訊息"
                                                                                                     message:@"目前沒有新訊息。"
                                                                                                    delegate:self
                                                                                           cancelButtonTitle:@"好"
                                                                                           otherButtonTitles:nil];
                                                     bIsMessageImportCompletedAlert = YES;
                                                     [alert show];
                                                 }
                                                 else
                                                 {
                                                     if (availableToImportCount > 0)
                                                     {
                                                         self.messages = messageInfo;
                                                         
                                                         NSString *strMessage = [NSString stringWithFormat:@"共有 %d 筆新訊息", availableToImportCount];
                                                         
                                                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strMessage
                                                                                                         message:@"若要將訊息匯入行事曆，請按[確認]"
                                                                                                        delegate:self
                                                                                               cancelButtonTitle:@"取消"
                                                                                               otherButtonTitles:@"確認", nil];
                                                         bIsMessageCountAlert = YES;
                                                         [alert show];
                                                     }
                                                     else
                                                     {
                                                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"無新訊息"
                                                                                                         message:@"目前沒有新訊息。"
                                                                                                        delegate:self
                                                                                               cancelButtonTitle:@"好"
                                                                                               otherButtonTitles:nil];
                                                         bIsMessageImportCompletedAlert = YES;
                                                         [alert show];
                                                     }
                                                 }
                                             }
                                             failure:^(NSString *errorMsg, NSError *error) {
                                                 
                                                 [self releaseScreen];
                                                 
                                                 
                                                 NSLog(@"%@", [error description]);
                                                 
                                                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                                                     message:@"無法取得訊息，請稍候再試。"
                                                                                                    delegate:self 
                                                                                           cancelButtonTitle:@"確定" 
                                                                                           otherButtonTitles:nil];
                                                 [alertView show];
                                             }];
}

#pragma mark - helper

- (void)saveSelectStateForTag:(int)tag selected:(BOOL)selected
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"scheduleOption-%d", tag];
    [df setObject:@(selected) forKey:key];
    [df synchronize];
}

- (BOOL)loadSelectStateForTag:(int)tag
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"scheduleOption-%d", tag];
    NSNumber *selected = [df objectForKey:key];
    if(selected)
        return [selected boolValue];
    
    return NO;
}

#pragma mark - tool bar interaction

- (IBAction)itemMenu:(id)sender
{
    if([self.viewDeckController isSideClosed:IIViewDeckLeftSide] == YES)
    {
        [self.viewDeckController openLeftViewAnimated:YES];
    }
    else
    {
        [self.viewDeckController closeLeftViewAnimated:YES];
    }
}

- (IBAction)backHome:(id)sender
{
    SecondViewController *sec = [[SecondViewController alloc] initWithUrl:@"http://emsgmobile2013.test.demo2.miniasp.com.tw/User"];
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [vcs insertObject:sec atIndex:[vcs count]-1];    
    [self.navigationController setViewControllers:vcs animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
     
}


#pragma mark - Screen Lock

- (void)lockScreen
{
	[SVProgressHUD showWithStatus:@"取得訊息"];
    self.importButton.enabled = NO;
}

- (void)releaseScreen
{
	[SVProgressHUD dismiss];
    self.importButton.enabled = YES;
}

- (void)lockProgressedScreen:(float)progress
{
    [SVProgressHUD showProgress:progress
                         status:@"正在寫入行事曆"
                       maskType:SVProgressHUDMaskTypeGradient];
}

- (void)releaseProgressedScreen
{
    [SVProgressHUD dismiss];
}

#pragma mark - UIAlertView Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (bIsMessageCountAlert)
    {
		bIsMessageCountAlert = NO;
		
		if (buttonIndex == 1)
        {
            [self presentModalViewController:self.nav_ccvc animated:YES];
		}
	}
	else if (bIsMessageImportCompletedAlert)
    {
		bIsMessageImportCompletedAlert = NO;
	}
}

#pragma mark - CalendarChooserViewController Delegates

- (void)calendarChooserDidCancel
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)calendarChooserDidFinishChooseWithCalendar:(EKCalendar *)calendar
{
	if (calendar == nil || self.messages == nil)
    {
		[self dismissModalViewControllerAnimated:YES];
	}
    else
    {
        [self.userDefaults setBool:self.allMsgBtn.selected forKey:KEY_IMPORT_all];
        [self.userDefaults setBool:self.paymentMsgBtn.selected forKey:KEY_IMPORT_payment];
        [self.userDefaults setBool:self.importantMsgBtn.selected forKey:KEY_IMPORT_important];
        [self.userDefaults setBool:self.holidayBtn.selected forKey:KEY_IMPORT_holiday];
        [self.userDefaults setBool:self.favoriteBtn.selected forKey:KEY_IMPORT_favorite];
        [self.userDefaults setBool:self.customBtn.selected forKey:KEY_IMPORT_custom];
        [self.userDefaults setObject:calendar.calendarIdentifier forKey:KEY_IMPORT_CAL];
        [self.userDefaults synchronize];
        
        [self dismissModalViewControllerAnimated:YES];
        [self lockProgressedScreen:0.0];
        
        [self.appManager importMessages:self.messages
                             toCalendar:calendar
                               progress:^(int current, int total) {
                                   float percentage = (float)current/(float)total;
                                   if(current != total)
                                       [self lockProgressedScreen:percentage];
                               }
                                success:^(int messageCount) {
                                    [self releaseProgressedScreen];
                                    
                                    NSString *strMessage = [NSString stringWithFormat:@"%d 筆新訊息已匯入行事曆，詳細內容可至手機行事曆查看。", messageCount];
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"訊息已匯入"
                                                                                    message:strMessage
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"好"
                                                                          otherButtonTitles:nil];
                                    bIsMessageImportCompletedAlert = YES;
                                    [alert show];
                                }
                                failure:^(NSString *errorMsg, NSError *error) {
                                    [self releaseProgressedScreen];
                                    
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                                        message:@"發生了未知的問題，請稍候再試。"
                                                                                       delegate:self
                                                                              cancelButtonTitle:@"確定"
                                                                              otherButtonTitles:nil];
                                    [alertView show];
                                }];
    }
}

@end
