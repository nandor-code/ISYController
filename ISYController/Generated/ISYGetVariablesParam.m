/*
	ISYGetVariablesParam.h
	The implementation of properties and methods for the ISYGetVariablesParam object.
	Generated by SudzC.com
*/
#import "ISYGetVariablesParam.h"

@implementation ISYGetVariablesParam
	@synthesize type = _type;

	- (id) init
	{
		if(self = [super init])
		{

		}
		return self;
	}

	+ (ISYGetVariablesParam*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (ISYGetVariablesParam*)[[ISYGetVariablesParam alloc] initWithNode: node];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.type = [[Soap getNodeValue: node withName: @"type"] intValue];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"GetVariablesParam"];
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
		[s appendFormat: @"<type>%@</type>", [NSString stringWithFormat: @"%i", self.type]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[ISYGetVariablesParam class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}

@end