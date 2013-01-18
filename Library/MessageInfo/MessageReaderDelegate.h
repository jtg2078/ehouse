//
//  MessageReaderDelegate.h
//  e-Management
//
//  Created by 【羊】 on 2010/10/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageReader;

@protocol MessageReaderDelegate

- (void)messageReader:(MessageReader *)reader didFinishReading:(NSArray *)messageInfo;
- (void)messageReaderDidFailedReading:(MessageReader *)reader;
   
@end
