/*
	ISYUPnPSpecifications.h
	The implementation of properties and methods for the ISYUPnPSpecifications object.
	Generated by SudzC.com
*/
#import "ISYUPnPSpecifications.h"

#import "ISYUPnPInfo.h"
#import "ISYUPnPInfo.h"
@implementation ISYUPnPSpecifications
	@synthesize upnpDevice = _upnpDevice;
	@synthesize upnpService = _upnpService;

	- (id) init
	{
		if(self = [super init])
		{
			self.upnpDevice = nil; // [[ISYUPnPInfo alloc] init];
			self.upnpService = nil; // [[ISYUPnPInfo alloc] init];

		}
		return self;
	}

	+ (ISYUPnPSpecifications*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (ISYUPnPSpecifications*)[[ISYUPnPSpecifications alloc] initWithNode: node];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.upnpDevice = [[ISYUPnPInfo newWithNode: [Soap getNode: node withName: @"upnpDevice"]] object];
			self.upnpService = [[ISYUPnPInfo newWithNode: [Soap getNode: node withName: @"upnpService"]] object];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"UPnPSpecifications"];
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
		if (self.upnpDevice != nil) [s appendString: [self.upnpDevice serialize: @"upnpDevice"]];
		if (self.upnpService != nil) [s appendString: [self.upnpService serialize: @"upnpService"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[ISYUPnPSpecifications class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}

@end