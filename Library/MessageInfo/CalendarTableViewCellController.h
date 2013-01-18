//
//  CalendarTableViewCellController.h
//  e-Management
//
//  Created by 【羊】 on 2010/10/22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CalendarTableViewCellController : UITableViewCell {

	
	IBOutlet UILabel *textLabel;
	IBOutlet UILabel *circleLabel;
}

@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) UILabel *circleLabel;
@end
