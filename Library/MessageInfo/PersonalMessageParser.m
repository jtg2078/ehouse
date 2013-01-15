//
//  PersonalMessageParser.m
//  e-Management
//
//  Created by 呂 泓儒 on 11/7/27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PersonalMessageParser.h"

@implementation PersonalMessageParser

- (NSArray *)parse:(NSData *)data {
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    
	[xmlParser setDelegate:self];
	[xmlParser parse];
	[xmlParser release];
    
    return messages;
}

#pragma mark - XML Parse Delegates

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName	
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"ArrayOfMessageInfo"]) {
		
		currentMessages = [[NSMutableArray alloc] init];
	}
	else if([elementName isEqualToString:@"MessageInfo"]) {
        
		currentMessage = [[MessageInfo alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {
	
	if ([elementName isEqualToString:@"ArrayOfMessageInfo"]) {
		
		messages = [[NSArray alloc] initWithArray:currentMessages];
		[currentMessages release];
		return;
	}
	
    
	if ([elementName isEqualToString:@"MessageInfo"]) {
		
		/* Append Title prefix */
		NSRange rangeBi = [currentMessage.Category rangeOfString:@"bi"];
		NSRange rangeCo = [currentMessage.Category rangeOfString:@"co"];
		NSRange rangePn = [currentMessage.Category rangeOfString:@"pn"];
		
		if (rangeBi.location != NSNotFound) {
			currentMessage.Title = [NSString stringWithFormat:@"【繳費通知】%@", currentMessage.Title];
		}
		else if (rangeCo.location != NSNotFound) {
			currentMessage.Title = [NSString stringWithFormat:@"【通知】%@", currentMessage.Title];
		}
		else if (rangePn.location != NSNotFound) {
			currentMessage.Title = [NSString stringWithFormat:@"【已繳費通知】%@", currentMessage.Title];
		}		
		
		[currentMessages addObject: currentMessage];
		
		[currentMessage release];
		currentMessage = nil;
	}
	else {
		
		NSString *trimmedString = [currentElementValue stringByTrimmingCharactersInSet:
								   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if ([elementName isEqualToString:@"Title"]) {
			currentMessage.Title = trimmedString;
		}
		else if ([elementName isEqualToString:@"Content"]) {
			currentMessage.Content = trimmedString;
		}
		else if ([elementName isEqualToString:@"ID"]) {
			currentMessage.ID = trimmedString;
		}
		else if ([elementName isEqualToString:@"Category"]) {
			currentMessage.Category = trimmedString;
		}
		else if ([elementName isEqualToString:@"IsImportant"]) {
            
            if ([trimmedString isEqualToString:@"true"])
                currentMessage.IsImportant = YES;
            else
                currentMessage.IsImportant = NO;
		}
		else if ([elementName isEqualToString:@"StartTime"]) {
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
			currentMessage.StartTime = [dateFormatter dateFromString:[NSString stringWithString:trimmedString]];
			
			if (nil == currentMessage.StartTime) {	
				NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];	
				[dateFormatter2 setDateStyle:NSDateFormatterMediumStyle];
				[dateFormatter2 setTimeStyle:NSDateFormatterShortStyle];	
				[dateFormatter2 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
				currentMessage.StartTime = [dateFormatter2 dateFromString:[NSString stringWithString:trimmedString]];
			}
			
			[dateFormatter release];
		}
		else if ([elementName isEqualToString:@"EndTime"]) {
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
			currentMessage.EndTime = [dateFormatter dateFromString:[NSString stringWithString:trimmedString]];
			
			if (nil == currentMessage.EndTime) {	
				NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];	
				[dateFormatter2 setDateStyle:NSDateFormatterMediumStyle];
				[dateFormatter2 setTimeStyle:NSDateFormatterShortStyle];	
				[dateFormatter2 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
				currentMessage.EndTime = [dateFormatter2 dateFromString:[NSString stringWithString:trimmedString]];
			}
			
			[dateFormatter release];
		}
        
		[currentElementValue release];
		currentElementValue = nil;
	}
}

@end
