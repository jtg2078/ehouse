//
//  MessageImporter.m
//  e-Management
//
//  Created by 【羊】 on 2010/10/18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MessageImporter.h"
#import "MessageInfo.h"

#define EVENT_NOTE_ID_PREFIX			@"[ID: "
#define EVENT_NOTE_ID_SUFFIX			@"]\n\n"
#define EVENT_NOTE_ID_PREFIX_LENGTH		4

@interface MessageImporter (PrivateMethod)
	
- (BOOL)insertEvent:(MessageInfo *)messageInfo intoCalendar:(EKCalendar *)calendar;
- (void)recordEventID:(NSString *)ID;
//- (BOOL)isEventAlreadyInserted:(MessageInfo *)info;
- (BOOL)isEventAlreadyInserted:(NSString *)ID;

- (NSString *)getInsertedEventIDsFilePath;

@end

@implementation MessageImporter
@synthesize delegate, error;

- (id)init {
	
	if ((self = [super init])) {
		
		// Read Event IDs file in document directory if exists
		NSString *path = [self getInsertedEventIDsFilePath];
		if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
			eventIDRecord = [[NSMutableArray arrayWithContentsOfFile:path] retain];
		}
		else {
			eventIDRecord = [[NSMutableArray alloc] init];
		}
    }
    return self;
}

- (int)messagesAvailableImportCount:(NSArray *)messageInfo {
	
	NSInteger count = 0;
	
	for (MessageInfo *info in messageInfo) {
		if (![self isEventAlreadyInserted:info.ID]) {
			count ++;
		}
	}
	
	return count;
}

- (void)beginImportAsynchronous:(NSArray *)messageInfo intoCalendar:(EKCalendar *)calendar {
	
	[NSThread detachNewThreadSelector:@selector(beginImportSynchronous:) toTarget:self  withObject:[NSArray arrayWithObjects:messageInfo, calendar, nil]];
}

- (void)beginImportSynchronous:(NSArray *)params {
	
	NSAutoreleasePool	 *autoreleasepool = [[NSAutoreleasePool alloc] init];
	
	NSArray *messageInfo = (NSArray *)[params objectAtIndex:0];
	EKCalendar *calendar = (EKCalendar *)[params objectAtIndex:1];
	
	BOOL bSuccess = YES;
	int iMessageImportedCount = 0;	
	
	for (int i = 0 ; i < [messageInfo count] ; i++) {
		
		if (!messageInfo || !calendar) {
			bSuccess = NO;
			break;
		}
		
		MessageInfo *info = (MessageInfo *)[messageInfo objectAtIndex:i];
		
		if ([self isEventAlreadyInserted:info.ID]) {
			continue;
		}
		
		if (![self insertEvent:info intoCalendar:calendar]) {
			bSuccess = NO;
			break;
		}
		
		iMessageImportedCount++;
		
		//[delegate messageImporter:self didReportProgress:(i+1) outOf:messageInfo.count];
		[NSThread detachNewThreadSelector:@selector(reportProgress:) toTarget:self
							   withObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:(i+1)], [NSNumber numberWithInt:messageInfo.count], nil]];
		
	}
	
	if (bSuccess) {
		[delegate messageImporterDidFinishImport:self messagesCount:iMessageImportedCount];
	}
	else {
		[delegate messageImporterDidFailedImport:self];
	}
	
	[autoreleasepool release];
}

- (void)reportProgress:(NSArray *)params {
	
	NSAutoreleasePool	 *autoreleasepool = [[NSAutoreleasePool alloc] init];
	
	NSNumber *progress	= (NSNumber *)[params objectAtIndex:0];
	NSNumber *outof		= (NSNumber *)[params objectAtIndex:1];
	
	[delegate messageImporter:self 
			didReportProgress:progress.intValue
						outOf:outof.intValue];
	
	[autoreleasepool release];
}

- (BOOL)insertEvent:(MessageInfo *)messageInfo intoCalendar:(EKCalendar *)calendar {
	
	EKEventStore *eventStore = [[EKEventStore alloc] init];
	
    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
	
    /* Set event details */
	
	event.title		= messageInfo.Title;
	event.allDay	= YES;
	event.notes		= [NSString stringWithFormat:@"%@%@%@%@",
								EVENT_NOTE_ID_PREFIX, 
								messageInfo.ID, 
								EVENT_NOTE_ID_SUFFIX,  
								messageInfo.Content];
	
	// 訊息寫入到期日就好
	event.startDate = messageInfo.EndTime;
	event.endDate	= [[NSDate alloc] initWithTimeInterval:3600 sinceDate:messageInfo.EndTime];
	
	EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:-172800]; // 預設兩天前提醒
	[event addAlarm:alarm];
	
	
	/* End of event details */
	
	if (nil == calendar) {
		[event setCalendar:[eventStore defaultCalendarForNewEvents]];
	}
	else {
		[event setCalendar:calendar];
	}

    NSError *err = error;
    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
	
	BOOL bSuccess;
	
	if (nil != err) {
		NSLog(@"%@", [error localizedDescription]);
		bSuccess = NO;
	}
	else {
		[self recordEventID:messageInfo.ID];
		bSuccess = YES;
	}
	
	[eventStore release];
	return bSuccess;
}

- (void)recordEventID:(NSString *)ID {
	
	[eventIDRecord addObject:ID];
	[eventIDRecord writeToFile:[self getInsertedEventIDsFilePath] atomically:YES];
}


- (BOOL)isEventAlreadyInserted:(NSString *)ID {
	
	for (NSString *str in eventIDRecord) {
		if ([str isEqualToString:ID]) {
			return YES;
		}
	}
	return NO;
}

//- (BOOL)isEventAlreadyInserted:(MessageInfo *)info {
//	
//	EKEventStore *eventStore = [[EKEventStore alloc] init];
//	
//	NSPredicate *predicate = nil;
//	
//	@try {
//		predicate = [eventStore predicateForEventsWithStartDate:info.StartTime
//																	 endDate:[info.EndTime dateByAddingTimeInterval:3600]
//																   calendars:nil];
//	}
//	@catch (NSException * e) {
//		return NO;
//	}
//	
//	NSArray *events = [eventStore eventsMatchingPredicate:predicate];
//	
//	BOOL bSuccess = NO;
//	
//	for (EKEvent *event in events) {
//		
//		NSRange rangeLeft = [event.notes rangeOfString:EVENT_NOTE_ID_PREFIX options: NSCaseInsensitiveSearch];
//		NSRange rangeRight = [event.notes rangeOfString:EVENT_NOTE_ID_SUFFIX options: NSCaseInsensitiveSearch];
//		
//		NSString *strTrimmedString = nil;
//		
//		if (rangeLeft.location < [event.notes length] && 
//			rangeRight.location < [event.notes length] &&
//			rangeRight.location > rangeLeft.location) {
//			
//			strTrimmedString = [event.notes substringWithRange:
//								NSMakeRange(rangeLeft.location + EVENT_NOTE_ID_PREFIX_LENGTH, 
//											rangeRight.location - (rangeLeft.location + EVENT_NOTE_ID_PREFIX_LENGTH))];
//		}
//		
//		strTrimmedString = [strTrimmedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//		
//		if (nil != strTrimmedString && 
//			[strTrimmedString isEqualToString:
//			 [info.ID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
//				
//			bSuccess = YES;
//			break;
//		}
//	}
//	
//	[eventStore release];
//	return bSuccess;
//}

- (NSString *)getInsertedEventIDsFilePath {
	
	NSString *bundleDocumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return [bundleDocumentPath stringByAppendingPathComponent:@"InsertedEventIDs.plist"];
}

@end
