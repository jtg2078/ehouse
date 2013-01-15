//
//  MessageInfo.h
//  e-Management
//
//  Created by 【羊】 on 2010/10/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MessageInfo : NSObject {

	BOOL		IsPublicMessage;
	NSString	*ID;
	NSString	*ApplicationId;
	int			Priority;
	NSString	*Category;
	NSString	*Title;
	NSString	*Content;
	NSString	*Status;
	NSString	*MsgTo;
	BOOL		IsCertification;
	BOOL		IsFavorite;
	BOOL		IsImportant;
	NSDate		*StartTime;
	NSDate		*EndTime;
	NSURL		*Url;
	NSString	*ApplicationName;
	NSString	*AppGroupId;
	NSString	*AppGroupName;
	NSArray		*MessageTags;	
}


@property (nonatomic)			BOOL		IsPublicMessage;
@property (nonatomic, retain)	NSString	*ID;
@property (nonatomic, retain)	NSString	*ApplicationId;
@property (nonatomic)			int			Priority;
@property (nonatomic, retain)	NSString	*Category;
@property (nonatomic, retain)	NSString	*Title;
@property (nonatomic, retain)	NSString	*Content;
@property (nonatomic, retain)	NSString	*Status;
@property (nonatomic, retain)	NSString	*MsgTo;
@property (nonatomic)			BOOL		IsCertification;
@property (nonatomic)			BOOL		IsFavorite;
@property (nonatomic)			BOOL		IsImportant;
@property (nonatomic, retain)	NSDate		*StartTime;
@property (nonatomic, retain)	NSDate		*EndTime;
@property (nonatomic, retain)	NSURL		*Url;
@property (nonatomic, retain)	NSString	*ApplicationName;
@property (nonatomic, retain)	NSString	*AppGroupId;
@property (nonatomic, retain)	NSString	*AppGroupName;
@property (nonatomic, retain)	NSArray		*MessageTags;	

@end
