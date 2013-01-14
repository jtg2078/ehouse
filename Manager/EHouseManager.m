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
        NSString *value = [[[self rootElement] elementForName:KEY_Token] stringValue];
        if(value)
            _displayNickname = @([value boolValue]);
    }
    return _displayNickname;
}

- (NSString *)valueForKey:(NSString *)key
{
    return [[[self rootElement] elementForName:KEY_Token] stringValue];
}

@end

@interface EHouseManager()
@property (nonatomic, weak) NSUserDefaults *userDefault;
@property (nonatomic, strong) NSDictionary *linkInfoLookupType;
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
    
    NSString *api = DEVELOPMENT_MODE ? API_DEVLOPMENT_URL : API_PRODUCTION_URL;
    self.myClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api]];
    
    self.linkInfo = @[
        @{
            KEY_id: @(LinkTypeMyMsg),
            KEY_name:@"我的訊息",
            KEY_image:@"my_msg_icon.png",
            KEY_url:@"MyMSG/MyMSGSet",
        },
        @{
            KEY_id: @(LinkTypeSubscribeMsg),
            KEY_name:@"訊息訂閱",
            KEY_image:@"order_msg_icon.png",
            KEY_url:@"Subscribe/SubscribeSet",
        },
        @{
            KEY_id: @(LinkTypeMyBookmark),
            KEY_name:@"我的收藏",
            KEY_image:@"my_favorite_icon.png",
            KEY_url:@"favorite",
        },
        @{
            KEY_id: @(LinkTypeManageLabel),
            KEY_name:@"標簽管理",
            KEY_image:@"tag_setting_icon.png",
            KEY_url:@"Label",
        },
        @{
            KEY_id: @(LinkTypeSetting),
            KEY_name:@"設定",
            KEY_image:@"setting_icon.png",
            KEY_url:@"Set",
        },
        @{
            KEY_id: @(LinkTypeExpense),
            KEY_name:@"費用統計",
            KEY_image:@"cost_statistics_icon.png",
            KEY_url:@"Expense",
        },
        @{
            KEY_id: @(LinkTypeMemeberPublicMsg),
            KEY_name:@"公眾訊息",
            KEY_image:@"public_msg_icon.png",
            KEY_url:@"PubMSG",
        },
        @{
            KEY_id: @(LinkTypeImportSchedule),
            KEY_name:@"匯入行事曆",
            KEY_image:@"import_schedule_icon.png",
            KEY_url:@"Schedule",
        },
        @{
            KEY_id: @(LinkTypeFacebook),
            KEY_name:@"粉絲團",
            KEY_image:@"fb_fans_icon.png",
            KEY_url:@"Schedule",
        },
        @{
            KEY_id: @(LinkTypePublicMsg),
            KEY_name:@"公眾訊息",
            KEY_image:@"public_msg_icon.png",
            KEY_url:@"PubMSG",
        },
        @{
            KEY_id: @(LinkTypeRanking),
            KEY_name:@"排行榜",
            KEY_image:@"ranking_icon.png",
            KEY_url:@"RankStat/Collection",
        },
        @{
            KEY_id: @(LinkTypeConstellation),
            KEY_name:@"星座服務",
            KEY_image:@"constellation_service_icon.png",
            KEY_url:@"Constellation",
        },
        @{
            KEY_id: @(LinkTypeWeather),
            KEY_name:@"天氣服務",
            KEY_image:@"weather_service_icon.png",
            KEY_url:@"Weather",
        },
        @{
            KEY_id: @(LinkTypeHelp),
            KEY_name:@"新手上路",
            KEY_image:@"helper_icon.png",
            KEY_url:@"Help",
        },
        @{
            KEY_id: @(LinkTypeRegister),
            KEY_name:@"註冊會員",
            KEY_image:@"register_icon.png",
            KEY_url:@"https://www.cp.gov.tw/portal/person/initial/Registry.aspx?returnUrl=http://msg.nat.gov.tw",
            KEY_urlFixed: @(YES),
        },
        @{
            KEY_id: @(LinkTypeForgetPwd),
            KEY_name:@"忘記密碼",
            KEY_image:@"forget_password_icon.png",
            KEY_url:@"https://www.cp.gov.tw/portal/Person/Initial/SendPasswordMail.aspx?returnUrl=http://msg.nat.gov.tw",
            KEY_urlFixed: @(YES),
        },
    ];
    
    NSMutableDictionary *typeInfo = [NSMutableDictionary dictionary];
    for(NSDictionary *info in self.linkInfo)
    {
        [typeInfo setObject:info forKey:info[KEY_id]];
    }
    self.linkInfoLookupType = typeInfo;
    
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

- (NSDictionary *)getLinkInfoWithLastComponent:(NSString *)component
{
    for(NSDictionary *info in self.linkInfo)
    {
        NSString *last = [[info[KEY_url] componentsSeparatedByString:@"/"] lastObject];
        if([last isEqualToString:component] == YES)
            return info;
    }
    
    return nil;
}

- (NSString *)getFullURLforLinkType:(NSNumber *)linkType
{
    NSString *url = nil;
    
    NSDictionary *info = self.linkInfoLookupType[linkType];
    
    if(info)
    {
        if(info[KEY_urlFixed] && [info[KEY_urlFixed] boolValue] == YES)
        {
            url = info[KEY_url];
        }
        else
        {
            if(DEVELOPMENT_MODE == YES)
            {
                url = [NSString stringWithFormat:@"%@/%@", DEVLOPMENT_URL, info[KEY_url]];
            }
            else
            {
                url = [NSString stringWithFormat:@"%@/%@", PRODUCTION_URL, info[KEY_url]];
            }
        }
    }
    
    return url;
}

#pragma mark - main methods

- (BOOL)processRequest:(NSURLRequest *)request
         forController:(id)controller
             needLogIn:(void (^)())login
              callback:(void (^)(BOOL canLoad, BOOL callSecondVC, NSString *title))callback
                 error:(void (^)(NSString *errorMsg, NSError *error))error
{
    if([controller isKindOfClass:[SecondViewController class]])
    {
        NSString *last = [[request URL] lastPathComponent];
        
        if([[last lowercaseString] isEqualToString:@"login"] == YES)
        {
            if(login)
                login();
            
            return NO;
        }
        else
        {
            NSDictionary *link = [self getLinkInfoWithLastComponent:last];
            
            if(link)
            {
                if(callback)
                    callback(YES, NO, link[KEY_name]);
            }
            else
            {
                if(error)
                   error(@"找不到此URL", nil);
            }
            
            return YES;
        }
    }
    else if([controller isKindOfClass:[RootViewController class]])
    {
        
    }
    
    return YES;
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
                       
                       if(success)
                           success(self.userInfo.token);
                       
                   }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       
                       if(failure)
                           failure(@"連線失敗", error);
        
                   }];
}

- (NSString *)createURLWithToken:(NSString *)token
{
    NSString *url = [NSString stringWithFormat:@"%@/Account/loginByToken?token=%@",
                     DEVELOPMENT_MODE ? DEVLOPMENT_URL : PRODUCTION_URL,
                     token];
    
    return url;
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
