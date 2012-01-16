/*
	SDZDBG.h
	The implementation of properties and methods for the SDZDBG object.
	Generated by SudzC.com
*/
#import "SDZDBG.h"

#import "SDZDebugOptions.h"
@implementation SDZDBG
	@synthesize options = _options;
	@synthesize current = _current;

	- (id) init
	{
		if(self = [super init])
		{
			self.options = [[NSMutableArray alloc] init];
			self.current = nil;

		}
		return self;
	}

	+ (SDZDBG*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (SDZDBG*)[[SDZDBG alloc] initWithNode: node];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.options = [[SDZDebugOptions newWithNode: [Soap getNode: node withName: @"options"]] object];
			self.current = [Soap getNodeValue: node withName: @"current"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"DBG"];
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
		if (self.options != nil && self.options.count > 0) {
			[s appendFormat: @"<options>%@</options>", [SDZDebugOptions serialize: self.options]];
		} else {
			[s appendString: @"<options/>"];
		}
		if (self.current != nil) [s appendFormat: @"<current>%@</current>", [[self.current stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[SDZDBG class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}

@end