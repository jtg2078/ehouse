//
//  EHouseManager.m
//  ehouse
//
//  Created by jason on 1/11/13.
//  Copyright (c) 2013 jason. All rights reserved.
//

#import "EHouseManager.h"
#import "RootViewController.h"
#import "SecondViewController.h"
#import <EventKit/EventKit.h>


// -------------------- UserInfo implementation --------------------

@implementation UserInfo

- (id)initWithData:(NSData *)data options:(NSUInteger)mask error:(NSError **)error
{
    self = [super initWithData:data options:mask error:error];
    if (self) {
        
    }
    return self;
}

@synthesize token = _token;
@synthesize displayNickname = _displayNickname;
@synthesize nickname = _nickname;
@synthesize userName = _userName;

- (NSString *)token
{
    if(_token == nil)
    {
        _token = [[[self rootElement] elementForName:KEY_Token] stringValue];
    }
    
    return _token;
}

- (NSNumber *)displayNickname
{
    if (_displayNickname == nil) {
        NSString *value = [[[self rootElement] elementForName:KEY_IsDisplayNickname] stringValue];
        if(value)
            _displayNickname = @([value isEqualToString:@"true"]);
    }
    return _displayNickname;
}

- (NSString *)userName
{
    if (_userName == nil) {
        NSString *value = [[[self rootElement] elementForName:KEY_UserName] stringValue];
        if(value)
            _userName = value;
    }
    return _userName;
    
}

- (NSString *)nickname
{
    if (_nickname == nil) {
        NSString *value = [[[self rootElement] elementForName:KEY_NickName] stringValue];
        if(value)
            _nickname = value;
    }
    return _nickname;
}

- (NSString *)valueForKey:(NSString *)key
{
    NSString *value = [[[self rootElement] elementForName:key] stringValue];
    return value;
}

@end

// -------------------- EHouseManager implementation --------------------

typedef void (^DownloadMessagesSuccessBlock)(NSArray * messageInfo, int availableToImportCount);
typedef void (^DownloadMessagesFailureBlock)(NSString *errorMsg, NSError *error);
typedef void (^ImportMessagesProgressBlock)(int current, int total);
typedef void (^ImportMessagesSuccessBlock)(int messageCount);
typedef void (^ImportMessagesFailureBlock)(NSString *errorMsg, NSError *error);

@interface EHouseManager()

@property (nonatomic, weak) NSUserDefaults *userDefault;
@property (nonatomic, strong) NSDictionary *linkInfoLookupType;

@property (nonatomic, strong) MessageReader *reader;
@property (nonatomic, strong) MessageImporter *importer;

@property (readwrite, nonatomic, copy) DownloadMessagesSuccessBlock downloadMessagesSuccess;
@property (readwrite, nonatomic, copy) DownloadMessagesFailureBlock downloadMessagesFailure;

@property (readwrite, nonatomic, copy) ImportMessagesProgressBlock importMessagesProgress;
@property (readwrite, nonatomic, copy) ImportMessagesSuccessBlock importMessagesSuccess;
@property (readwrite, nonatomic, copy) ImportMessagesFailureBlock importMessagesFailure;

@end

@implementation EHouseManager

#pragma mark - init and setup

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.userDefault = [NSUserDefaults standardUserDefaults];
    
    self.accoutName = [self.userDefault stringForKey:KEY_accountname];
    self.accoutPwd = [self.userDefault stringForKey:KEY_accountpwd];
    self.autoLogin = [self.userDefault objectForKey:KEY_autoLogin];
    
    NSString *api = DEVELOPMENT_MODE ? API_DEVELOPMENT_URL : API_PRODUCTION_URL;
    self.myClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api]];
    api = DEVELOPMENT_MODE ? DEVELOPMENT_URL : PRODUCTION_URL;
    self.myClient2 = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api]];
    
    bIsReadyToDownload = YES;
	bIsReadyToInsert = YES;
    
    self.reader = [[MessageReader alloc] init];
    self.reader.delegate = self;
    
    self.importer = [[MessageImporter alloc] init];
    self.importer.delegate = self;
    
    self.linkInfo = @[
        @{
            KEY_id: @(LinkIDHome),
            KEY_name:@"首頁",
            KEY_image:@"home_icon.png",
            KEY_url: DEVELOPMENT_MODE ? DEVELOPMENT_URL : PRODUCTION_URL,
            KEY_urlType: @(URLTypeFull),
            KEY_inSideMenu: @(YES),
        },
        @{
            KEY_id: @(LinkIDLogin),
            KEY_name:@"登入",
            KEY_url:@"/Account/Login",
            KEY_urlType: @(URLTypeRelative),
            KEY_inSideMenu: @(NO),
        },
        @{
            KEY_id: @(LinkIdUser),
            KEY_name:@"我的專區",
            KEY_url:@"/User",
            KEY_urlType: @(URLTypeRelative),
            KEY_inSideMenu: @(NO),
        },        
        @{
            KEY_id: @(LinkIDMyMsg),
            KEY_name:@"我的訊息",
            KEY_image:@"my_msg_icon.png",
            KEY_url:@"/MyMSG/MyMSGSet",
            KEY_urlType: @(URLTypeRelative),
            KEY_inSideMenu: @(YES),
        },
        @{
            KEY_id: @(LinkIDSubscribeMsg),
            KEY_name:@"訊息訂閱",
            KEY_image:@"order_msg_icon.png",
            KEY_url:@"/Subscribe/SubscribeSet",
            KEY_urlType: @(URLTypeRelative),
            KEY_inSideMenu: @(YES),
        },
        @{
            KEY_id: @(LinkIDMyBookmark),
            KEY_name:@"我的收藏",
            KEY_image:@"my_favorite_icon.png",
            KEY_url:@"/favorite",
            KEY_urlType: @(URLTypeRelative),
            KEY_inSideMenu: @(YES),
        },
        @{
            KEY_id: @(LinkIDManageLabel),
            KEY_name:@"標籤管理",
            KEY_image:@"tag_setting_icon.png",
            KEY_url:@"/Label",
            KEY_urlType: @(URLTypeRelative),
            KEY_inSideMenu: @(YES),
        },
        @{
            KEY_id: @(LinkIDSetting),
            KEY_name:@"設定",
            KEY_image:@"setting_icon.png",
            KEY_url:@"/Set",
            KEY_urlType: @(URLTypeRelative),
            KEY_inSideMenu: @(YES),
        },
        @{
            KEY_id: @(LinkIDExpense),
            KEY_name:@"費用統計",
            KEY_image:@"cost_statistics_icon.png",
            KEY_url:@"/Expense",
            KEY_urlType: @(URLTypeRelative),
            KEY_inSideMenu: @(YES),
        },
        @{
            KEY_id: @(LinkIDMemeberPublicMsg),
            KEY_name:@"公眾訊息",
            KEY_image:@"public_msg_icon.png",
            KEY_url:@"/PubMSG",
            KEY_urlType: @(URLTypeRelative),
            KEY_inSideMenu: @(YES),
        },
        @{
            KEY_id: @(LinkIDMemeberSinglePublicMsg),
            KEY_name:@"公眾訊息",
            KEY_image:@"public_msg_icon.png",
            KEY_url:@"/PubMSG/SinglePubMSG",
            KEY_urlType: @(URLTypeRelative),
            KEY_inSideMenu: @(NO),
        },
        @{
            KEY_id: @(LinkIDImportSchedule),
            KEY_name:@"匯入行事曆",
            KEY_image:@"import_schedule_icon.png",
            KEY_url:@"/Schedule",
            KEY_urlType: @(URLTypeRelative),
            KEY_inSideMenu: @(YES),
        },
        @{
            KEY_id: @(LinkIDFacebookFans),
            KEY_name:@"粉絲團",
            KEY_image:@"fb_fans_icon.png",
            KEY_url:@"http://www.facebook.com/ehousekeeper",
            KEY_urlFull:@"http://www.facebook.com/ehousekeeper",
            KEY_urlType: @(URLTypeFull),
            KEY_inSideMenu: @(YES),
        },
        @{
            KEY_id: @(LinkIDFacebook),
            KEY_name:@"Facebook",
            KEY_image:@"fb_fans_icon.png",
            KEY_url:@"/sharer/sharer.php",
            //KEY_urlFull:@"http://www.facebook.com/",
            KEY_urlType: @(URLTypeRelative),
            KEY_inSideMenu: @(NO),
        },
        @{
            KEY_id: @(LinkIdIntegration),
            KEY_name:@"我的積分",
            KEY_image:@"my_score_ios.png",
            KEY_url:@"/MyScore/myScore",
            KEY_urlType: @(URLTypeRelative),
            KEY_inSideMenu: @(YES),
        },
        @{
            KEY_id: @(LinkIdPublic),
            KEY_name:@"e公務訊息",
            KEY_image:@"e_public_icon.png",
            KEY_url:@"/G2E",
            KEY_urlType: @(URLTypeRelative),
            KEY_inSideMenu: @(YES),
        },
        @{
            KEY_id: @(LinkIDRanking),
            KEY_name:@"排行榜",
            KEY_image:@"ranking_icon.png",
            KEY_url:@"/RankStat/Collection",
            KEY_urlType: @(URLTypeRelative),
            KEY_inSideMenu: @(YES),
        },
        @{
            KEY_id: @(LinkIDConstellation),
            KEY_name:@"星座服務",
            KEY_image:@"constellation_service_icon.png",
            KEY_url:@"/Constellation",
            KEY_urlType: @(URLTypeRelative),
            KEY_inSideMenu: @(YES),
        },
        @{
            KEY_id: @(LinkIDWeather),
            KEY_name:@"天氣服務",
            KEY_image:@"weather_service_icon.png",
            KEY_url:@"/Weather",
            KEY_urlType: @(URLTypeRelative),
            KEY_inSideMenu: @(YES),
        },
        @{
            KEY_id: @(LinkIDHelp),
            KEY_name:@"新手上路",
            KEY_image:@"helper_icon.png",
            KEY_url:@"/Help",
            KEY_urlType: @(URLTypeRelative),
            KEY_inSideMenu: @(YES),
        },
        @{
            KEY_id: @(LinkIDRegister),
            KEY_name:@"註冊會員",
            KEY_image:@"register_icon.png",
            KEY_url:@"http://www.cp.gov.tw/portal/person/initial/Registry.aspx",
            KEY_urlFull:@"http://www.cp.gov.tw/portal/person/initial/Registry.aspx",
            KEY_urlSpecial: @(YES),
            KEY_urlType: @(URLTypeFull),
            KEY_inSideMenu: @(YES),
        },
        @{
            KEY_id: @(LinkIDForgetPwd),
            KEY_name:@"忘記密碼",
            KEY_image:@"forget_password_icon.png",
            KEY_url:@"https://www.cp.gov.tw/portal/CPinit/SendPassword.aspx",
            KEY_urlFull:@"https://www.cp.gov.tw/portal/CPinit/SendPassword.aspx",
            KEY_urlSpecial: @(YES),
            KEY_urlType: @(URLTypeFull),
            KEY_inSideMenu: @(YES),
        },
    ];
    
    // construct the lookup table for link id
    NSMutableDictionary *typeInfo = [NSMutableDictionary dictionary];
    for(NSDictionary *info in self.linkInfo)
    {
        [typeInfo setObject:info forKey:info[KEY_id]];
    }
    self.linkInfoLookupType = typeInfo;
    
    // construct the side menu links array
    NSMutableArray *links = [NSMutableArray array];
    for(NSDictionary *info in self.linkInfo)
    {
        if([info[KEY_inSideMenu] boolValue])
           [links addObject:info];
    }
    self.sideMenuLinks = links;
    
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
}

#pragma mark - location related

- (void)startLocationTracking
{
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)stopLocationTracking
{
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

#pragma mark - member related

- (void)setAccoutName:(NSString *)accoutName
{
    _accoutName = accoutName;
    
    if(_accoutName == nil)
    {
        [self.userDefault removeObjectForKey:KEY_accountname];
    }
    else
    {
        [self.userDefault setObject:_accoutName forKey:KEY_accountname];
    }
    
    [self.userDefault synchronize];
}

- (void)setAccoutPwd:(NSString *)accoutPwd
{
    _accoutPwd = accoutPwd;
    
    if(_accoutPwd == nil)
    {
        [self.userDefault removeObjectForKey:KEY_accountpwd];
    }
    else
    {
        [self.userDefault setObject:_accoutPwd forKey:KEY_accountpwd];
    }
    
    [self.userDefault synchronize];
}

- (void)setAutoLogin:(NSNumber *)autoLogin
{
    _autoLogin = autoLogin;
    
    if(_autoLogin == nil)
    {
        [self.userDefault removeObjectForKey:KEY_autoLogin];
    }
    else
    {
      [self.userDefault setObject:_autoLogin forKey:KEY_autoLogin];
    }
    
    [self.userDefault synchronize];
}

#pragma mark - info related

- (NSDictionary *)getLinkInfoWithURL:(NSURL *)url
{
    NSLog(@"absoluteString: %@", url.absoluteString);
    NSLog(@"baseURL: %@", url.baseURL.absoluteString);
    NSLog(@"fragment: %@", url.fragment);
    NSLog(@"host: %@", url.host);
    NSLog(@"lastPathComponent: %@", url.lastPathComponent);
    NSLog(@"parameterString: %@", url.parameterString);
    NSLog(@"path: %@", url.path);
    NSLog(@"pathComponents: %@", [url.pathComponents description]);
    NSLog(@"pathExtension: %@", url.pathExtension);
    NSLog(@"query: %@", url.query);
    NSLog(@"relativePath: %@", url.relativePath);
    NSLog(@"relativeString: %@", url.relativeString);
    NSLog(@"resourceSpecifier: %@", url.baseURL.resourceSpecifier);
    
    
    for(NSDictionary *info in self.linkInfo)
    {
        BOOL test1 = [url.absoluteString localizedCaseInsensitiveCompare:info[KEY_url]] == NSOrderedSame;
        BOOL test2 = [url.relativePath localizedCaseInsensitiveCompare:info[KEY_url]] == NSOrderedSame;
        
        if(test1 || test2)
            return info;
    }
    
    return nil;
}

- (NSDictionary *)getLinkInfoWithLastComponent:(NSString *)component
{
    for(NSDictionary *info in self.linkInfo)
    {
        NSString *last = [[info[KEY_url] componentsSeparatedByString:@"/"] lastObject];
        if(last && [last localizedCaseInsensitiveCompare:component] == NSOrderedSame)
            return info;
    }
    
    return nil;
}

- (NSDictionary *)getLinkInfoLinkID:(LinkID)linkID
{
    NSDictionary *info = self.linkInfoLookupType[@(linkID)];
    return info;
}

- (NSString *)getFullURLforLinkID:(NSNumber *)linkType
{
    NSString *urlString = nil;
    
    NSDictionary *info = self.linkInfoLookupType[linkType];
    
    if(info)
    {
        if(info[KEY_urlSpecial] && [info[KEY_urlSpecial] boolValue] == YES)
        {
            urlString = info[KEY_urlFull];
        }
        else
        {
            NSURL *baseURL = [NSURL URLWithString:info[KEY_url]
                                    relativeToURL:[NSURL URLWithString: DEVELOPMENT_MODE ? DEVELOPMENT_URL : PRODUCTION_URL]];
            
            urlString = baseURL.absoluteString;
        }
    }
    
    return urlString;
}

#pragma mark - task

- (void)peformAutoImport
{
    [self downloadMessagesForTypePersonal:[self.userDefault boolForKey:KEY_IMPORT_all]
                                  payment:[self.userDefault boolForKey:KEY_IMPORT_payment]
                                important:[self.userDefault boolForKey:KEY_IMPORT_important]
                                 vacation:[self.userDefault boolForKey:KEY_IMPORT_holiday]
                                 favorite:[self.userDefault boolForKey:KEY_IMPORT_favorite]
                                customize:[self.userDefault boolForKey:KEY_IMPORT_custom]
                                    token:self.userInfo.token
                                  success:^(NSArray *messageInfo, int availableToImportCount) {
                                      
                                      if(messageInfo.count && availableToImportCount && [self.userDefault stringForKey:KEY_IMPORT_CAL])
                                      {
                                          EKEventStore *eventStore = [[EKEventStore alloc] init];
                                          
                                          if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
                                          {
                                              [eventStore requestAccessToEntityType:EKEntityTypeEvent
                                                                         completion:^(BOOL granted, NSError *error) {
                                                                             EKCalendar *calendar = [eventStore calendarWithIdentifier:[self.userDefault stringForKey:KEY_IMPORT_CAL]];
                                                                             if(calendar)
                                                                             {
                                                                                 [self importMessages:messageInfo
                                                                                           toCalendar:calendar
                                                                                             progress:nil
                                                                                              success:^(int messageCount) {
                                                                                                  NSLog(@"auto import event successful: %d", messageCount);
                                                                                              }
                                                                                              failure:^(NSString *errorMsg, NSError *error) {
                                                                                                  NSLog(@"auto import event failed: %@", errorMsg);
                                                                                              }];
                                                                             }
                                                                         }];
                                          }
                                          else
                                          {
                                              EKCalendar *calendar = [eventStore calendarWithIdentifier:[self.userDefault stringForKey:KEY_IMPORT_CAL]];
                                              if(calendar)
                                              {
                                                  [self importMessages:messageInfo
                                                            toCalendar:calendar
                                                              progress:nil
                                                               success:^(int messageCount) {
                                                                   NSLog(@"auto import event successful: %d", messageCount);
                                                               }
                                                               failure:^(NSString *errorMsg, NSError *error) {
                                                                   NSLog(@"auto import event failed: %@", errorMsg);
                                                               }];
                                              }
                                              
                                          }

                                      }
                                  }
                                  failure:^(NSString *errorMsg, NSError *error) {
                                      NSLog(@"auto import download msg failed: %@", errorMsg);
                                  }];
}

#pragma mark - main methods

- (BOOL)processRequest:(NSURLRequest *)request
              callback:(BOOL(^)(LinkID linkID, NSString *url))callback
{
    NSString *last = nil;
    
    // deal with hash (why is it even in the URL?)
    if([request.URL.absoluteString componentsSeparatedByString:@"#"].count > 1)
    {
        last = [[request.URL.absoluteString componentsSeparatedByString:@"/"] lastObject];
    }
    else
    {
        last = request.URL.lastPathComponent;
    }
    
    LinkID linkID = LinkIDUnknown;
    NSString *url = request.URL.absoluteString;
    BOOL shouldLoad = YES;
    
    NSDictionary *link = [self getLinkInfoWithURL:request.URL];
    if(link)
    {
        linkID = [link[KEY_id] intValue];
        //url = [self getFullURLforLinkID:link[KEY_id]];
    }
    
    if(callback)
        shouldLoad = callback(linkID, url);
    
    return shouldLoad;
}

#pragma mark - backend api related

- (void)logout:(void (^)(NSString *msg, NSError *error))callback
{
    self.userInfo = nil;
    
    [self.myClient2 getPath:@"logout"
                 parameters:nil
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self setAccoutName:nil];
                        [self setAccoutPwd:nil];
                        [self setAutoLogin:@(NO)];
                        
                        if(callback)
                            callback(@"已登出", nil);
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        if(callback)
                            callback(@"登出連線失敗", error);
                    } ];
}

- (void)loginWithAccountName:(NSString *)name
                         pwd:(NSString *)pwd
                     success:(void (^)(NSString *token))success
                     failure:(void (^)(NSString *errorMsg, NSError *error))failure
   {
    NSDictionary *param = @{
        @"account": name,
        @"password": pwd,
        @"client": @"wa",
    };
    
    self.myClient.parameterEncoding = AFFormURLParameterEncoding;
    
    [self.myClient getPath:@"UserLoginMobile"
                parameters:param
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       
                       NSError *error = nil;
                       
                       self.userInfo = [[UserInfo alloc] initWithData:responseObject
                                                              options:0
                                                                error:&error];
                       if(error)
                       {
                           if(failure)
                               failure(@"XML 解析失敗", error);
                           
                           return;
                       }
                       
                       if(self.userInfo.token.length == 0)
                       {
                           if(failure)
                               failure([self.userInfo valueForKey:KEY_ErrorMessage], nil);
                           
                           return;
                       }
                       
                       [self notifyWebLoginToken:self.userInfo.token success:success failure:failure];
                       
                   }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       
                       if(failure)
                           failure(@"連線失敗", error);
                       
                   }];
}

- (void)notifyWebLoginToken:(NSString *)token
                    success:(void (^)(NSString *token))success
                    failure:(void (^)(NSString *errorMsg, NSError *error))failure
{
    NSDictionary *param = @{
        @"token": token,
    };
    
    [self.myClient2 getPath:@"Account/loginByToken"
                 parameters:param
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"告訴web使用者已登入成功!");
                        if(success){
                            success(token);
                            
                            NSString *pushToken = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_pushToken];
                            if(pushToken)
                            {
                                [self registerForPushAccount:self.userInfo.token
                                                      device:@"iphone"
                                                       token:pushToken
                                                     success:^{
                                                         NSLog(@"推播的api 註冊成功");
                                                     }
                                                     failure:^(NSString *errorMsg, NSError *error) {
                                                         NSLog(@"推播的api 註冊失敗: %@", errorMsg);
                                                     }];
                            }
                        }
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"告訴web使用者已登入失敗: %@", error.description);
                        if(failure)
                            failure(@"連線失敗", error);
                    }];
}

- (void)registerForPushAccount:(NSString *)account
                        device:(NSString *)device
                         token:(NSString *)token
                       success:(void (^)())success
                       failure:(void (^)(NSString *errorMsg, NSError *error))failure
{
    NSDictionary *param = @{
        @"account": account,
        @"device": device,
        @"token": token,
    };
    
    self.myClient2.parameterEncoding = AFJSONParameterEncoding;
    [self.myClient2 putPath:@"api/tokenBooking"
                 parameters:param
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"register for push successful!");
                        
                        NSError *error = nil;
                        NSString *abc = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                        DDXMLDocument *ret = [[DDXMLDocument alloc] initWithXMLString:abc
                                                                              options:0
                                                                                error:&error];
                        NSString *value = [[[ret rootElement] elementForName:@"isSuccess"] stringValue];
                        if(value && [value isEqualToString:@"True"])
                        {
                            
                        }
                        
                
                         
                        
                        if(success)
                            success();
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"register for push failure: %@", error.description);
                        if(failure)
                            failure(@"register for push failed", error);
                    }];
}

- (void)downloadMessagesForTypePersonal:(BOOL)personal
                                payment:(BOOL)payment
                              important:(BOOL)important
                               vacation:(BOOL)vacation
                               favorite:(BOOL)favorite
                              customize:(BOOL)customize
                                  token:(NSString *)token
                                success:(void (^)(NSArray * messageInfo, int availableToImportCount))success
                                failure:(void (^)(NSString *errorMsg, NSError *error))failure
{
    if(self.reader == nil)
    {
        self.reader = [[MessageReader alloc] init];
        self.reader.delegate = self;
    }
    
    if(bIsReadyToDownload)
    {
        bIsReadyToDownload = NO;
        
        self.reader.bImportPersonalMessage = personal;
        self.reader.bImportPaymentMessage = payment;
        self.reader.bImportImportantMessage = important;
        self.reader.bImportVacationMessage = vacation;
        self.reader.bImportFavoriteMessage = favorite;
        self.reader.bImportCustomizeMessage = customize;
        
        self.downloadMessagesSuccess = success;
        self.downloadMessagesFailure = failure;
        
        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            if(self.downloadMessagesFailure)
                self.downloadMessagesFailure(@"下載訊息遇時", nil);
        }];
        
        [self.reader getMessagesAsynchronous:token];
    }
    else
    {
        if(self.downloadMessagesFailure)
            self.downloadMessagesFailure(@"正在下載訊息", nil);
    }
}

- (void)importMessages:(NSArray *)messages
            toCalendar:(EKCalendar *)calendar
              progress:(void (^)(int current, int total))progress
               success:(void (^)(int messageCount))success
               failure:(void (^)(NSString *errorMsg, NSError *error))failure
{
    if(self.importer == nil)
    {
        self.importer = [[MessageImporter alloc] init];
        self.importer.delegate = self;
    }
    
    if(bIsReadyToInsert)
    {
        bIsReadyToInsert = NO;
        
        self.importMessagesProgress = progress;
        self.importMessagesSuccess = success;
        self.importMessagesFailure = failure;
        
        [self.importer beginImportAsynchronous:messages
                                  intoCalendar:calendar];
    }
    else
    {
        if(failure)
            failure(@"匯入訊息正在進行中", nil);
    }
}

#pragma mark - MessageReader Delegates

- (void)messageReader:(MessageReader *)sender didFinishReading:(NSArray *)messageInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        bIsReadyToDownload = YES;
        int availableToImportCount = [self.importer messagesAvailableImportCount:messageInfo];
        
        if(self.downloadMessagesSuccess)
            self.downloadMessagesSuccess(messageInfo, availableToImportCount);
    });
}

- (void)messageReaderDidFailedReading:(MessageReader *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        bIsReadyToDownload = YES;
        
        if(self.downloadMessagesFailure)
            self.downloadMessagesFailure(@"無法取得訊息，請稍候再試。", sender.error);
    });
}

#pragma mark - MessageImporter Delegates

- (void)messageImporter:(MessageImporter *)importer
	  didReportProgress:(int)current
				  outOf:(int)all
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(self.importMessagesProgress)
            self.importMessagesProgress(current, all);
    });
}

- (void)messageImporterDidFinishImport:(MessageImporter *)importer
                         messagesCount:(NSInteger)count
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        bIsReadyToInsert = YES;
        
        if(self.importMessagesSuccess)
            self.importMessagesSuccess(count);
    });
}

- (void)messageImporterDidFailedImport:(MessageImporter *)importer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        bIsReadyToInsert = YES;
        
        if(self.importMessagesFailure)
            self.importMessagesFailure(@"發生了未知的問題，請稍候再試。", importer.error);
    });
}

#pragma mark - helper

- (NSString *)createURLWithToken:(NSString *)token
{
    NSString *url = [NSString stringWithFormat:@"%@/Account/loginByToken?token=%@",
                     DEVELOPMENT_MODE ? DEVELOPMENT_URL : PRODUCTION_URL,
                     token];
    
    return url;
}

//以郵遞區號查詢地區代碼
- (NSString *)areaCode:(NSString *)postCode
{
    if(!postCode || postCode.length == 0) {
        return nil;
    }
    
    //台北市
    NSArray *a01 = [NSArray arrayWithObjects:
                    @"100",@"103",@"104",@"105",@"106",@"108",@"110",@"111",@"112",@"114"
                    ,@"115",@"116", nil];
    //高雄市
    NSArray *a02 = [NSArray arrayWithObjects:
                    @"800",@"801",@"802",@"803",@"804",@"805",@"806",@"807",@"811",@"812"
                    ,@"813", nil];
    //基隆市
    NSArray *a03 = [NSArray arrayWithObjects:
                    @"200",@"201",@"202",@"203",@"204",@"205",@"206", nil];
    //新北市
    NSArray *a04 = [NSArray arrayWithObjects:
                    @"207",@"208",@"220",@"221",@"222",@"223",@"224",@"226",@"227",@"228"
                    ,@"231",@"232",@"233",@"234",@"235",@"236",@"237",@"238",@"239",@"241"
                    ,@"242",@"243",@"244",@"247",@"248",@"249",@"251",@"252",@"253", nil];
    //桃園縣
    NSArray *a05 = [NSArray arrayWithObjects:
                    @"320",@"324",@"325",@"326",@"327",@"328",@"330",@"333",@"334",@"335"
                    ,@"336",@"337",@"338", nil];
    //新竹縣
    NSArray *a06 = [NSArray arrayWithObjects:
                    @"302",@"303",@"304",@"305",@"306",@"307",@"308",@"310",@"311",@"312"
                    ,@"313",@"314",@"315", nil];
    //苗栗縣
    NSArray *a07 = [NSArray arrayWithObjects:
                    @"350",@"351",@"352",@"353",@"354",@"356",@"357",@"358",@"360",@"361"
                    ,@"362",@"363",@"364",@"365",@"366",@"367",@"368",@"369", nil];
    //台中市
    NSArray *a08 = [NSArray arrayWithObjects:
                    @"400",@"401",@"402",@"403",@"404",@"406",@"407",@"408",@"411",@"412"
                    ,@"413",@"414",@"420",@"421",@"422",@"423",@"424",@"426",@"427",@"428"
                    ,@"429",@"432",@"433",@"434",@"435",@"436",@"437",@"438",@"439", nil];
    //彰化縣
    NSArray *a09 = [NSArray arrayWithObjects:
                    @"500",@"502",@"503",@"504",@"505",@"506",@"057",@"508",@"509",@"510"
                    ,@"511",@"512",@"513",@"514",@"515",@"516",@"520",@"521",@"522",@"523"
                    ,@"524",@"525",@"526",@"527",@"528",@"530", nil];
    //南投縣
    NSArray *a10 = [NSArray arrayWithObjects:
                    @"540",@"541",@"542",@"544",@"545",@"546",@"551",@"552",@"553",@"555"
                    ,@"556",@"557",@"558", nil];
    //雲林縣
    NSArray *a11 = [NSArray arrayWithObjects:
                    @"630",@"631",@"632",@"633",@"634",@"635",@"636",@"637",@"638",@"640"
                    ,@"643",@"646",@"647",@"648",@"649",@"651",@"652",@"653",@"654",@"655", nil];
    //嘉義縣
    NSArray *a12 = [NSArray arrayWithObjects:
                    @"602",@"603",@"604",@"605",@"606",@"607",@"608",@"611",@"612",@"613"
                    ,@"614",@"615",@"616",@"621",@"622",@"623",@"624",@"625", nil];
    //台南市
    NSArray *a13 = [NSArray arrayWithObjects:
                    @"710",@"711",@"712",@"713",@"714",@"715",@"716",@"717",@"718",@"719"
                    ,@"720",@"721",@"722",@"723",@"724",@"725",@"726",@"727",@"730",@"731"
                    ,@"732",@"733",@"734",@"735",@"737",@"741",@"742",@"742",@"744",@"745", nil];
    //屏東縣
    NSArray *a15 = [NSArray arrayWithObjects:
                    @"900",@"901",@"902",@"903",@"904",@"905",@"906",@"907",@"908",@"909"
                    ,@"911",@"912",@"913",@"920",@"921",@"922",@"923",@"924",@"925",@"926"
                    ,@"927",@"928",@"929",@"931",@"932",@"940",@"941",@"942",@"943",@"944"
                    ,@"945",@"946",@"947", nil];
    //新竹市
    NSArray *a16 = [NSArray arrayWithObjects:@"300", nil];
    //宜蘭縣
    NSArray *a17 = [NSArray arrayWithObjects:
                    @"260",@"261",@"262",@"263",@"264",@"265",@"266",@"267",@"268",@"269",@"270",@"272", nil];
    //花蓮縣
    NSArray *a18 = [NSArray arrayWithObjects:
                    @"970",@"971",@"972",@"973",@"974",@"975",@"976",@"977",@"978",@"979",@"981",@"982",@"983", nil];
    //台東縣
    NSArray *a19 = [NSArray arrayWithObjects:@"950",@"955",@"961",@"966", nil];
    //澎湖縣
    NSArray *a20 = [NSArray arrayWithObjects:@"880",@"881",@"882",@"883",@"884",@"885",nil];
    //金門線
    NSArray *a21 = [NSArray arrayWithObjects:@"890",@"891",@"892",@"893",@"894",@"896",nil];
    //連江縣
    NSArray *a22 = [NSArray arrayWithObjects:@"209",@"210",@"211",@"212",nil];
    //嘉義市
    NSArray *a23 = [NSArray arrayWithObjects:@"600",nil];
    
    NSArray *countys = [NSArray arrayWithObjects:a01,a02,a03,a04,a05,a06,a07,a08,a09,a10,a11,a12,a13,a15,a16,a17,a18,a19,a20,a21,a22,a23,nil];
    NSArray *codes = [NSArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23", nil];
    NSDictionary *codeDic = [[NSDictionary alloc] initWithObjects:countys forKeys:codes];
    
    BOOL stop = false;
    NSString *result = nil;
    for (id key in codeDic) {
        NSArray *ar = [codeDic objectForKey:key];
        for (int j=0; j<[ar count]; j++) {
            NSString *code = [ar objectAtIndex:j];
            if ([postCode isEqualToString:code]) {
                result = key;
                stop = true;
                break;
            }
        }
        if (stop) {
            break;
        }
    }
    
	return result;
}

- (void)processLocation:(CLLocation *)location
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true&region=zh&language=zh", location.coordinate.latitude, location.coordinate.longitude]]];
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary *reDict = (NSDictionary *)JSON;
        NSArray *results = [reDict objectForKey:@"results"];
        
        if(results.count)
        {
            NSDictionary *partialDict = [results objectAtIndex:0];
            NSString *addr = [partialDict objectForKey:@"formatted_address"];
            
            if (addr && addr.length > 3)
            {
                //取出郵遞區號
                NSString *postCode = [addr substringWithRange:NSMakeRange(0,3)];
                
                NSString *areaCode = [self areaCode:postCode];
                if(areaCode && areaCode.length > 0)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"regionCodeUpdated"
                                                                        object:self
                                                                      userInfo:@{@"code": areaCode}];
                    
                }
                else
                {
                    NSString *errorMsg = [NSString stringWithFormat:@"取得地區代碼失敗！ %@", postCode];
                    NSLog(@"%@", errorMsg);
                }
                
            }
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"%@", error.description);
    }];
    
    [op start];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if(newLocation)
        [self locationManager:manager didUpdateLocations:@[newLocation]];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self processLocation:[locations lastObject]];
}

#pragma mark - singleton implementation code

static EHouseManager *singletonManager = nil;

+ (EHouseManager *)sharedInstance {
    
    static dispatch_once_t pred;
    static EHouseManager *manager;
    
    dispatch_once(&pred, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (singletonManager == nil) {
            singletonManager = [super allocWithZone:zone];
            return singletonManager;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
@end
