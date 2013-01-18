//
//  CalendarTableViewCellController.m
//  e-Management
//
//  Created by 【羊】 on 2010/10/22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CalendarTableViewCellController.h"


@implementation CalendarTableViewCellController
@synthesize textLabel, circleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
