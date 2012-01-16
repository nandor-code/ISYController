/*
	SDZUnsubscriptionParam.h
	The implementation of properties and methods for the SDZUnsubscriptionParam object.
	Generated by SudzC.com
*/
#import "SDZUnsubscriptionParam.h"

@implementation SDZUnsubscriptionParam
	@synthesize SID = _SID;

	- (id) init
	{
		if(self = [super init])
		{
			self.SID = nil;

		}
		return self;
	}

	+ (SDZUnsubscriptionParam*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (SDZUnsubscriptionParam*)[[SDZUnsubscriptionParam alloc] initWithNode: node];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.SID = [Soap getNodeValue: node withName: @"SID"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"UnsubscriptionParam"];
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
		if (self.SID != nil) [s appendFormat: @"<SID>%@</SID>", [[self.SID stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[SDZUnsubscriptionParam class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}

@end