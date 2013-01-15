//
//  MessageParser.m
//  e-Management
//
//  Created by 呂 泓儒 on 11/7/27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MessageParser.h"

@implementation MessageParser

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
	
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	
}

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {
    
}

@end
