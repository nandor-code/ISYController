/*
	SDZNotificationsOptions.h
	The implementation of properties and methods for the SDZNotificationsOptions object.
	Generated by SudzC.com
*/
#import "SDZNotificationsOptions.h"

@implementation SDZNotificationsOptions
	@synthesize MailTo = _MailTo;
	@synthesize CompactEmail = _CompactEmail;

	- (id) init
	{
		if(self = [super init])
		{
			self.MailTo = nil;

		}
		return self;
	}

	+ (SDZNotificationsOptions*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (SDZNotificationsOptions*)[[SDZNotificationsOptions alloc] initWithNode: node];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.MailTo = [Soap getNodeValue: node withName: @"MailTo"];
			self.CompactEmail = [[Soap getNodeValue: node withName: @"CompactEmail"] boolValue];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"NotificationsOptions"];
	}
  
	- (NSMutableString*) serialize: (NSString*) nodeName
	{
		NSMutableString* s = [NSMutableString string];
		[s appendFormat: @"<%@", nodeName];
		[s appendString: [self serializeAttributes]];
		[s appendString: @">"];
		[s appendString: [self serializeElements]];
		[s appendFormat: @"</%@>", nodeName];
		return s;
	}
	
	- (NSMutableString*) serializeElements
	{
		NSMutableString* s = [super serializeElements];
		if (self.MailTo != nil) [s appendFormat: @"<MailTo>%@</MailTo>", [[self.MailTo stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<CompactEmail>%@</CompactEmail>", (self.CompactEmail)?@"true":@"false"];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[SDZNotificationsOptions class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}

@end