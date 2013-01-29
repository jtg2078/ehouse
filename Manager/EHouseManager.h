//
//  EHouseManager.h
//  ehouse
//
//  Created by jason on 1/11/13.
//  Copyright (c) 2013 jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
#import "AFNetworking.h"

#import "DDXMLDocument.h"
#import "DDXMLElement.h"
#import "DDXMLElementAdditions.h"

#import "MessageReader.h"
#import "MessageReaderDelegate.h"
#import "MessageImporter.h"
#import "MessageImporterDelegate.h"

#import "CalendarChooserViewController.h"
#import "CalendarChooserDelegate.h"

typedef enum{
    LinkIDUnknown = 0,
    LinkIDHome,
    LinkIDLogin,
    LinkIDMyMsg,
    LinkIDSubscribeMsg,
    LinkIDMyBookmark,
    LinkIDManageLabel,
    LinkIDSetting,
    LinkIDExpense,
    LinkIDMemeberPublicMsg,
    LinkIDMemeberSinglePublicMsg,
    LinkIDImportSchedule,
    LinkIDFacebookFans,
    LinkIDFacebook,
    LinkIdIntegration,
    LinkIDPublicMsg,
    LinkIDRanking,
    LinkIDConstellation,
    LinkIDWeather,
    LinkIDHelp,
    LinkIDRegister,
    LinkIDForgetPwd,
    LinkIdUser
}LinkID;

typedef enum{
    URLTypeRelative = 0,
    URLTypeFull,
}URLType;

@interface UserInfo : DDXMLDocument
{
    
}

@property (readonly, nonatomic, strong) NSString *token;
@property (readonly, nonatomic, strong) NSNumber *displayNickname;
@property (readonly, nonatomic, strong) NSString *nickname;
@property (readonly, nonatomic, strong) NSString *userName;

- (NSString *)valueForKey:(NSString *)key;

@end

@interface EHouseManager : NSObject <MessageReaderDelegate, MessageImporterDelegate, CalendarChooserDelegate, UIAlertViewDelegate>
{
    BOOL bIsReadyToDownload;
	BOOL bIsReadyToInsert;
}

@property (nonatomic, strong) NSArray *linkInfo;
@property (nonatomic, strong) NSArray *sideMenuLinks;

@property (nonatomic, strong) NSString *accoutName;
@property (nonatomic, strong) NSString *accoutPwd;
@property (nonatomic, strong) NSNumber *autoLogin;

@property (nonatomic, strong) AFHTTPClient *myClient;
@property (nonatomic, strong) AFHTTPClient *myClient2;

@property (nonatomic, strong) UserInfo *userInfo;

+ (EHouseManager *)sharedInstance;

- (NSDictionary *)getLinkInfoLinkID:(LinkID)linkID;
- (NSString *)getFullURLforLinkID:(NSNumber *)linkType;

- (BOOL)processRequest:(NSURLRequest *)request
              callback:(BOOL(^)(LinkID linkID, NSString *url))callback;

- (void)loginWithAccountName:(NSString *)name
                         pwd:(NSString *)pwd
                     success:(void (^)(NSString *token))success
                     failure:(void (^)(NSString *errorMsg, NSError *error))failure;

- (void)logout:(void (^)(NSString *msg, NSError *error))callback;

- (void)registerForPushAccount:(NSString *)account
                        device:(NSString *)device
                         token:(NSString *)token
                       success:(void (^)())success
                       failure:(void (^)(NSString *errorMsg, NSError *error))failure;

- (void)downloadMessagesForTypePersonal:(BOOL)personal
                                payment:(BOOL)payment
                              important:(BOOL)important
                               vacation:(BOOL)vacation
                               favorite:(BOOL)favorite
                              customize:(BOOL)customize
                                  token:(NSString *)token
                                success:(void (^)(NSArray * messageInfo, int availableToImportCount))success
                                failure:(void (^)(NSString *errorMsg, NSError *error))failure;

- (void)importMessages:(NSArray *)messages
            toCalendar:(EKCalendar *)calendar
              progress:(void (^)(int current, int total))progress
               success:(void (^)(int messageCount))success
               failure:(void (^)(NSString *errorMsg, NSError *error))failure;

- (void)peformAutoImport;

- (NSString *)createURLWithToken:(NSString *)token;

@end
