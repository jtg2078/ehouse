//
//  MessageReader.m
//  e-Management
//
//  Created by 【羊】 on 2010/10/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MessageReader.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "PersonalMessageParser.h"
#import "FavoriteMessageParser.h"
#import "CustomizeMessageParser.h"

#define URL_PERSONAL_MESSAGE @"https://msg.nat.gov.tw/WSProxy/Emsg4Services.asmx/GetAllPrivateMessageInfo"
#define URL_FAVORITE_MESSAGE @"https://msg.nat.gov.tw/WSProxy/Emsg4Services.asmx/GetUserPublicMessages"
#define URL_CUSTOMIZE_MESSAGE @"https://msg.nat.gov.tw/WSProxy/Emsg4Services.asmx/GetUserCalendarEvent"

#define FAVORITE_MESSAGE_VALUE_FOR_KEY_TOP @"all"
#define CUSTOMIZE_MESSAGE_VALUE_FOR_KEY_DT @"2011-01-01"

@implementation MessageReader
@synthesize delegate, error;
@synthesize bImportPersonalMessage, bImportPaymentMessage, bImportImportantMessage, bImportVacationMessage, bImportFavoriteMessage, bImportCustomizeMessage;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        allMessages = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark - MessageInfo Getter

- (void)getMessagesAsynchronous:(NSString *)strToken {
    
    [allMessages removeAllObjects];
    
    strToken = [[strToken stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\b\t\n"]];
    
    if (bImportPersonalMessage || bImportPaymentMessage || bImportImportantMessage || bImportVacationMessage) {
        
        bPersonalMessageRequestDone = NO;
        
        personalMessageRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_PERSONAL_MESSAGE]];
        [personalMessageRequest setValidatesSecureCertificate:NO];
        [personalMessageRequest setDelegate:self];
        
        [personalMessageRequest setPostValue:strToken forKey:@"token"];
        [personalMessageRequest setPostValue:@"m" forKey:@"client"];
        [personalMessageRequest startAsynchronous];
    }
    
    if (bImportFavoriteMessage) {
        
        bFavoriteMessageRequestDone = NO;
        
        favoriteMessageRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_FAVORITE_MESSAGE]];
        [favoriteMessageRequest setValidatesSecureCertificate:NO];
        [favoriteMessageRequest setDelegate:self];

        [favoriteMessageRequest setPostValue:strToken forKey:@"token"];
        [favoriteMessageRequest setPostValue:@"m" forKey:@"client"];
        [favoriteMessageRequest setPostValue:FAVORITE_MESSAGE_VALUE_FOR_KEY_TOP forKey:@"top"];
        [favoriteMessageRequest startAsynchronous];  
    }
    
    if (bImportCustomizeMessage) {
        
        bCustomizeMessageRequestDone = NO;
        
        customizeMessageRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_CUSTOMIZE_MESSAGE]];
        [customizeMessageRequest setValidatesSecureCertificate:NO];
        [customizeMessageRequest setDelegate:self];
        
        [customizeMessageRequest setPostValue:strToken forKey:@"token"];
        [customizeMessageRequest setPostValue:@"m" forKey:@"client"];
        [customizeMessageRequest setPostValue:CUSTOMIZE_MESSAGE_VALUE_FOR_KEY_DT forKey:@"dt"];
        [customizeMessageRequest startAsynchronous];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{    
    if ((bImportPersonalMessage || bImportPaymentMessage || bImportImportantMessage || bImportVacationMessage)  &&
        (request == personalMessageRequest)) {
        
        bPersonalMessageRequestDone = YES;
        
        PersonalMessageParser *parser = [[PersonalMessageParser alloc] init];
        NSArray *arrMessage = [parser parse:[request responseData]];
        
        for (MessageInfo* messageInfo in arrMessage) {
            
            BOOL bImport = NO;
            
            if (bImportPaymentMessage && [messageInfo.Category isEqualToString:@"bi"])
                bImport = YES;
            
            if (bImportImportantMessage && [messageInfo IsImportant])
                bImport = YES;
            
            if (bImportVacationMessage && [messageInfo.Category isEqualToString:@"holiday"])
                bImport = YES;
        
            if (bImportPersonalMessage && ![messageInfo.Category isEqualToString:@"holiday"])
                bImport = YES;
            
            if (bImport)
                [allMessages addObject:messageInfo];
        }
    }
    
    if (bImportFavoriteMessage &&
        (request == favoriteMessageRequest)) {
        
        bFavoriteMessageRequestDone = YES;
        
        FavoriteMessageParser *parser = [[FavoriteMessageParser alloc] init];
        NSArray *arrMessage = [parser parse:[request responseData]];
        [allMessages addObjectsFromArray:arrMessage];
    }
    
    if (bImportCustomizeMessage &&
        (request == customizeMessageRequest)) {
        
        bCustomizeMessageRequestDone = YES;
        
        CustomizeMessageParser *parser = [[CustomizeMessageParser alloc] init];
        NSArray *arrMessage = [parser parse:[request responseData]];
        [allMessages addObjectsFromArray:arrMessage];
    }
    
    if ([self checkAllRequestDone]) {
        
        [delegate messageReader:self didFinishReading:allMessages];
    }
}

- (BOOL)checkAllRequestDone {
    
    BOOL bAllDone = YES;
    
    if ((bImportPersonalMessage || bImportPaymentMessage || bImportImportantMessage || bImportVacationMessage) && !bPersonalMessageRequestDone)
        bAllDone = NO;
    
    if (bImportFavoriteMessage && !bFavoriteMessageRequestDone)
        bAllDone = NO;
    
    if (bImportCustomizeMessage && !bCustomizeMessageRequestDone)
        bAllDone = NO;
    
    return  bAllDone;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	error = [request error];
	[delegate messageReaderDidFailedReading:self];
}

@end
