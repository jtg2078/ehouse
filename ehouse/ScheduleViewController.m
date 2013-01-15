//
//  ScheduleViewController.m
//  eManagement
//
//  Created by (dbx) Amigo on 13/1/9.
//  Copyright (c) 2013年 (dbx) Amigo. All rights reserved.
//

#import "ScheduleViewController.h"
#import "IIViewDeckController.h"

@interface ScheduleViewController ()

@end

@implementation ScheduleViewController

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

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
    
    // -------------------- view --------------------
    
    self.scrillView.contentSize = CGSizeMake(320, 461);
    
    // -------------------- other --------------------
    
    self.reader = [[MessageReader alloc] init];
    self.reader.delegate = self;
    
    self.importer = [[MessageImporter alloc] init];
    self.importer.delegate = self;
    
    self.strToken = self.appManager.userInfo.token;
    
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
    [super viewDidUnload];
}

#pragma mark - user interaction

- (IBAction)optionButtonPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
}

- (IBAction)importButtonPressed:(id)sender
{
    self.reader.bImportPersonalMessage = self.allMsgBtn.selected;
    self.reader.bImportPaymentMessage = self.paymentMsgBtn.selected;
    self.reader.bImportImportantMessage = self.importantMsgBtn.selected;
    self.reader.bImportVacationMessage = self.holidayBtn.selected;
    self.reader.bImportFavoriteMessage = self.favoriteBtn.selected;
    self.reader.bImportCustomizeMessage = self.customBtn.selected;
    
    if (!self.reader.bImportPersonalMessage &&
        !self.reader.bImportPaymentMessage &&
        !self.reader.bImportImportantMessage &&
        !self.reader.bImportVacationMessage &&
        !self.reader.bImportFavoriteMessage &&
        !self.reader.bImportCustomizeMessage)
        return;
    
    [self lockScreen];
    
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self releaseProgressedScreen];
        bIsReadyToInsert = NO;
        self.calendarToInsert = nil;
    }];
    
	[self.reader getMessagesAsynchronous:self.strToken];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
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

#pragma mark - MessageReader Delegates

- (void)messageReader:(MessageReader *)sender didFinishReading:(NSArray *)messageInfo
{
	[self releaseScreen];
	bMessageReaderIsReading = NO;
	
	if (nil == messageInfo || [messageInfo count] == 0)
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"無新訊息"
														 message:@"目前沒有新訊息。"
														delegate:self
											   cancelButtonTitle:@"好"
											   otherButtonTitles:nil];
		bIsMessageImportCompletedAlert = YES;
		[alert show];
		return;
	}
	
	self.messages = messageInfo;
	
	int messageCount = [self.importer messagesAvailableImportCount:messageInfo];
	NSString *strMessage = [NSString stringWithFormat:@"共有 %d 筆新訊息", messageCount];
	if (messageCount > 0)
    {
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

- (void)messageReaderDidFailedReading:(MessageReader *)sender {
	
	[self releaseScreen];
	bMessageReaderIsReading = NO;
	
	NSLog(@"%@", [sender.error description]);
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"無法取得訊息，請稍候再試。"
                                                        delegate:self 
                                               cancelButtonTitle:@"確定" 
                                               otherButtonTitles:nil];
	[alertView show];
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
	if (nil == calendar)
    {
		[self dismissModalViewControllerAnimated:YES];
        
		bIsReadyToInsert = NO;
		return;
	}
	
	bIsReadyToInsert = YES;
	self.calendarToInsert = calendar;
	[self dismissModalViewControllerAnimated:YES];
    
    if (bIsReadyToInsert)
    {
		bIsReadyToInsert = NO;
		[self lockProgressedScreen:0.0];
		[self.importer beginImportAsynchronous:self.messages
                                  intoCalendar:self.calendarToInsert];
		return;
	}
}

#pragma mark - MessageImporter Delegates

- (void)messageImporter:(MessageImporter *)importer
	  didReportProgress:(int)current
				  outOf:(int)all
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        float percentage = (float)current/(float)all;
        [self lockProgressedScreen:percentage];
    });
}

- (void)messageImporterDidFinishImport:(MessageImporter *)importer
                         messagesCount:(NSInteger)count
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self releaseProgressedScreen];
        bIsReadyToInsert = NO;
        self.calendarToInsert = nil;
        
        NSString *strMessage = [NSString stringWithFormat:@"%d 筆新訊息已匯入行事曆，詳細內容可至手機行事曆查看。", count];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"訊息已匯入"
                                                        message:strMessage
                                                       delegate:self
                                              cancelButtonTitle:@"好"
                                              otherButtonTitles:nil];
        bIsMessageImportCompletedAlert = YES;
        [alert show];
        
    });
}

- (void)messageImporterDidFailedImport:(MessageImporter *)importer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self releaseProgressedScreen];
        bIsReadyToInsert = NO;
        self.calendarToInsert = nil;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"發生了未知的問題，請稍候再試。"
                                                           delegate:self
                                                  cancelButtonTitle:@"確定"
                                                  otherButtonTitles:nil];
        [alertView show];
    });
}

@end
