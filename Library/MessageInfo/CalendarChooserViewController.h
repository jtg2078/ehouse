//
//  CalendarChooserViewController.h
//  e-Management
//
//  Created by 【羊】 on 2010/10/19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CalendarChooserDelegate.h"

@protocol CalendarChooserDelegate;

@interface CalendarChooserViewController : UITableViewController {

	id<CalendarChooserDelegate> delegate;
	
	NSMutableArray *calendars;
	EKCalendar *currentSelection;
	NSInteger currentSelectionIndex;
	EKEventStore *eventStore;
}

@property (nonatomic, assign) id<CalendarChooserDelegate> delegate;
@property (nonatomic, readonly) EKCalendar *currentSelection;
@end
