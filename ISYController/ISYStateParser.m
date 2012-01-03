//
//  ISYStateParser.m
//  ISYController
//
//  Created by Nandor Szots on 1/2/12.
//  Copyright (c) 2012 Umbra LLC. All rights reserved.
//

#import "ISYStateParser.h"

@implementation ISYStateParser

@synthesize delegate  = _delegate;
@synthesize sDeviceID = _sDeviceID;

- (id)initWithDelegate:(id)newDelegate andDeviceID:(NSString*)deviceID;
{
    self = [self init];
    
    self.delegate  = newDelegate;
    self.sDeviceID = deviceID;
    
    return self;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if( [elementName isEqualToString:@"property"] )
    {
        NSString* name = [attributeDict objectForKey:@"id"];
        
        if( [name isEqualToString:@"ST" ] )
            [self.delegate setValueForDevice:self.sDeviceID withValue:[NSNumber numberWithFloat:[[attributeDict objectForKey:@"value"] floatValue] ] ];
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{    
}

// This method can get called multiple times for the
// text in a single element
- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string
{
}

- (void)parser:(NSXMLParser *)parser
parseErrorOccurred:(NSError *)parseError
{
    NSLog( @"Error: %@", parseError );
}

@end
