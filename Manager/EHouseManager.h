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

typedef enum{
    LinkIDUnknown = 0,
    LinkIDHome,
    LinkIDMemberArea,
    LinkIDLogin,
    LinkIDMyMsg,
    LinkIDSubscribeMsg,
    LinkIDMyBookmark,
    LinkIDManageLabel,
    LinkIDSetting,
    LinkIDExpense,
    LinkIDMemeberPublicMsg,
    LinkIDImportSchedule,
    LinkIDFacebook,
    LinkIDPublicMsg,
    LinkIDRanking,
    LinkIDConstellation,
    LinkIDWeather,
    LinkIDHelp,
    LinkIDRegister,
    LinkIDForgetPwd,
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

- (NSString *)valueForKey:(NSString *)key;

@end

@interface EHouseManager : NSObject
{
    
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

- (NSString *)getFullURLforLinkType:(NSNumber *)linkType;

- (BOOL)processRequest:(NSURLRequest *)request
              callback:(BOOL(^)(LinkID linkID, NSString *url))callback;

- (void)loginWithAccountName:(NSString *)name
                         pwd:(NSString *)pwd
                     success:(void (^)(NSString *token))success
                     failure:(void (^)(NSString *errorMsg, NSError *error))failure;


- (void)registerForPushAccount:(NSString *)account
                        device:(NSString *)device
                         token:(NSString *)token
                       success:(void (^)())success
                       failure:(void (^)(NSString *errorMsg, NSError *error))failure;

- (NSString *)createURLWithToken:(NSString *)token;

@end
