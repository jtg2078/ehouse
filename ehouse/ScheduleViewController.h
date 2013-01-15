//
//  ScheduleViewController.h
//  eManagement
//
//  Created by (dbx) Amigo on 13/1/9.
//  Copyright (c) 2013年 (dbx) Amigo. All rights reserved.
//

/*
 #import <UIKit/UIKit.h>
 #import <EventKit/EventKit.h>
 #import "e_ManagementAppDelegate.h"
 #import "MessageReader.h"
 #import "MessageReaderDelegate.h"
 #import "MessageImporter.h"
 #import "MessageImporterDelegate.h"
 #import "LockViewController.h"
 #import "ProgressedLockViewController.h"
 #import "MessageInfo.h"
 #import "CalendarChooserViewController.h"
 #import "CalendarChooserDelegate.h"
 #import "CheckBox.h"
 */

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "BaseViewController.h"

#import "MessageReader.h"
#import "MessageReaderDelegate.h"
#import "MessageImporter.h"
#import "MessageImporterDelegate.h"

#import "CalendarChooserViewController.h"
#import "CalendarChooserDelegate.h"

#import "MessageInfo.h"

@interface ScheduleViewController : BaseViewController <MessageReaderDelegate, MessageImporterDelegate, CalendarChooserDelegate, UIAlertViewDelegate>
{
    BOOL bMessageReaderIsReading;
	BOOL bIsReadyToInsert;
    BOOL bIsMessageCountAlert;
	BOOL bIsMessageImportCompletedAlert;
}

@property (nonatomic, strong) EKCalendar *calendarToInsert;
@property (nonatomic, strong) NSString *strToken;
@property (nonatomic, strong) NSString *strUserName;
@property (nonatomic, strong) NSString *strIDNumber;
@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) MessageReader *reader;
@property (nonatomic, strong) MessageImporter *importer;
@property (nonatomic, strong) CalendarChooserViewController *ccvc;
@property (nonatomic, strong) UINavigationController *nav_ccvc;

@property (strong, nonatomic) IBOutlet UIScrollView *scrillView;
@property (weak, nonatomic) IBOutlet UIView *myContentView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *allMsgBtn;
@property (weak, nonatomic) IBOutlet UIButton *partialMsgBtn;
@property (weak, nonatomic) IBOutlet UIButton *paymentMsgBtn;
@property (weak, nonatomic) IBOutlet UIButton *importantMsgBtn;
@property (weak, nonatomic) IBOutlet UIButton *holidayBtn;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;
@property (weak, nonatomic) IBOutlet UIButton *customBtn;
@property (weak, nonatomic) IBOutlet UIButton *autoImportBtn;
@property (weak, nonatomic) IBOutlet UIButton *importButton;

- (IBAction)optionButtonPressed:(id)sender;
- (IBAction)importButtonPressed:(id)sender;

- (IBAction)itemMenu:(id)sender;
- (IBAction)backHome:(id)sender;

@end
