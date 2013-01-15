//
//  MessageParser.h
//  e-Management
//
//  Created by 呂 泓儒 on 11/7/27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageInfo.h"

@interface MessageParser : NSObject <NSXMLParserDelegate> {
    
    NSString *strMessage;
    
	NSArray *messages;
    
	NSMutableArray	*currentMessages;
	MessageInfo		*currentMessage;
	NSMutableString *currentElementValue;
}

- (NSArray *)parse:(NSData *)data;

@end
