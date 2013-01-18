//
//  MessageImporterDelegate.h
//  e-Management
//
//  Created by 【羊】 on 2010/10/19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageImporter;

@protocol MessageImporterDelegate

- (void)messageImporterDidFinishImport:(MessageImporter *)importer messagesCount:(NSInteger)count;
- (void)messageImporterDidFailedImport:(MessageImporter *)importer;

- (void)messageImporter:(MessageImporter *)importer 
	  didReportProgress:(int)current
				  outOf:(int)all;

@end
