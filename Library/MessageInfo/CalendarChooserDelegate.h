//
//  CalendarChooserDelegate.h
//  e-Management
//
//  Created by 【羊】 on 2010/10/19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@protocol CalendarChooserDelegate

- (void)calendarChooserDidCancel;
- (void)calendarChooserDidFinishChooseWithCalendar:(EKCalendar *)calendar;

@end
