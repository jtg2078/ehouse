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
    LinkTypeUnknown = 0,
    LinkTypeMyMsg,
    LinkTypeSubscribeMsg,
    LinkTypeMyBookmark,
    LinkTypeManageLabel,
    LinkTypeSetting,
    LinkTypeExpense,
    LinkTypeMemeberPublicMsg,
    LinkTypeImportSchedule,
    LinkTypeFacebook,
    LinkTypePublicMsg,
    LinkTypeRanking,
    LinkTypeConstellation,
    LinkTypeWeather,
    LinkTypeHelp,
    LinkTypeRegister,
    LinkTypeForgetPwd,
}LinkType;

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

@property (nonatomic, strong) NSString *accoutName;
@property (nonatomic, strong) NSString *accoutPwd;
@property (nonatomic, strong) NSNumber *autoLogin;

@property (nonatomic, strong) AFHTTPClient *myClient;

@property (nonatomic, strong) UserInfo *userInfo;

+ (EHouseManager *)sharedInstance;

- (NSString *)getFullURLforLinkType:(NSNumber *)linkType;

- (BOOL)processRequest:(NSURLRequest *)request
         forController:(id)controller
             needLogIn:(void (^)())login
              callback:(void (^)(BOOL canLoad, BOOL callSecondVC, NSString *title))callback
                 error:(void (^)(NSString *errorMsg, NSError *error))error;

- (void)loginWithAccountName:(NSString *)name
                         pwd:(NSString *)pwd
                     success:(void (^)(NSString *token))success
                     failure:(void (^)(NSString *errorMsg, NSError *error))failure;

- (NSString *)createURLWithToken:(NSString *)token;

@end
