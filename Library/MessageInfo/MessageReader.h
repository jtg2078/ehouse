//
//  MessageReader.h
//  e-Management
//
//  Created by 【羊】 on 2010/10/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "MessageReaderDelegate.h"
#import "MessageInfo.h"

@protocol MessageReaderDelegate;

@interface MessageReader : NSObject {

	id <MessageReaderDelegate> delegate;
	
    BOOL bImportPersonalMessage;
    BOOL bImportPaymentMessage;
    BOOL bImportImportantMessage;
    BOOL bImportVacationMessage;
    BOOL bImportFavoriteMessage;
    BOOL bImportCustomizeMessage;
    
	NSError *error;
    
    ASIFormDataRequest *personalMessageRequest;
    ASIFormDataRequest *favoriteMessageRequest;
    ASIFormDataRequest *customizeMessageRequest;
    
    BOOL bPersonalMessageRequestDone;
    BOOL bFavoriteMessageRequestDone;
    BOOL bCustomizeMessageRequestDone;
    
    NSMutableArray *allMessages;
}

- (void)getMessagesAsynchronous:(NSString *)strToken;

- (BOOL)checkAllRequestDone;

@property (nonatomic, assign) id <MessageReaderDelegate> delegate;
@property (nonatomic, assign) BOOL bImportPersonalMessage;
@property (nonatomic, assign) BOOL bImportPaymentMessage;
@property (nonatomic, assign) BOOL bImportImportantMessage;
@property (nonatomic, assign) BOOL bImportVacationMessage;
@property (nonatomic, assign) BOOL bImportFavoriteMessage;
@property (nonatomic, assign) BOOL bImportCustomizeMessage;
@property (nonatomic, retain) NSError *error;
@end
