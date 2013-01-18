//
//  MessageImporter.h
//  e-Management
//
//  Created by 【羊】 on 2010/10/18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import "MessageImporterDelegate.h"

@class MessageImporterDelegate;

@protocol MessageImporterDelegate;

@interface MessageImporter : NSObject {

	id <MessageImporterDelegate> delegate;
	
	NSMutableArray *eventIDRecord;
	
	NSError *error;
}

- (int)messagesAvailableImportCount:(NSArray *)messageInfo;

- (void)beginImportAsynchronous:(NSArray *)messageInfo intoCalendar:(EKCalendar *)calendar;
- (void)beginImportSynchronous:(NSArray *)params;

- (void)reportProgress:(NSArray *)params;

@property (nonatomic, assign) id <MessageImporterDelegate> delegate;
@property (nonatomic, retain) NSError *error;

@end
