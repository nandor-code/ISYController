/*
	ISYLinkingModeParam.h
	The implementation of properties and methods for the ISYLinkingModeParam object.
	Generated by SudzC.com
*/
#import "ISYLinkingModeParam.h"

@implementation ISYLinkingModeParam
	@synthesize flag = _flag;

	- (id) init
	{
		if(self = [super init])
		{

		}
		return self;
	}

	+ (ISYLinkingModeParam*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (ISYLinkingModeParam*)[[ISYLinkingModeParam alloc] initWithNode: node];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.flag = [[NSNumber numberWithInt: [[Soap getNodeValue: node withName: @"flag"] intValue]] charValue];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"LinkingModeParam"];
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
		[s appendFormat: @"<flag>%@</flag>", [NSString stringWithFormat: @"%c", self.flag]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[ISYLinkingModeParam class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}

@end