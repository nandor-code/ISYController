/*
	SDZSetSceneProfileParam.h
	The implementation of properties and methods for the SDZSetSceneProfileParam object.
	Generated by SudzC.com
*/
#import "SDZSetSceneProfileParam.h"

@implementation SDZSetSceneProfileParam
	@synthesize control = _control;
	@synthesize action = _action;

	- (id) init
	{
		if(self = [super init])
		{
			self.control = nil;
			self.action = nil;

		}
		return self;
	}

	+ (SDZSetSceneProfileParam*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (SDZSetSceneProfileParam*)[[SDZSetSceneProfileParam alloc] initWithNode: node];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.control = [Soap getNodeValue: node withName: @"control"];
			self.action = [Soap getNodeValue: node withName: @"action"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"SetSceneProfileParam"];
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
		if (self.control != nil) [s appendFormat: @"<control>%@</control>", [[self.control stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.action != nil) [s appendFormat: @"<action>%@</action>", [[self.action stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[SDZSetSceneProfileParam class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}

@end