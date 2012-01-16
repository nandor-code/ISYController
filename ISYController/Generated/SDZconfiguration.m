/*
	SDZconfiguration.h
	The implementation of properties and methods for the SDZconfiguration object.
	Generated by SudzC.com
*/
#import "SDZconfiguration.h"

#import "SDZDeviceSpecifications.h"
#import "SDZUPnPSpecifications.h"
#import "SDZControls.h"
#import "SDZDeviceRoot.h"
#import "SDZProduct.h"
#import "SDZFeatures.h"
@implementation SDZconfiguration
	@synthesize deviceSpecs = _deviceSpecs;
	@synthesize upnpSpecs = _upnpSpecs;
	@synthesize controls = _controls;
	@synthesize app = _app;
	@synthesize app_version = _app_version;
	@synthesize platform = _platform;
	@synthesize build_timestamp = _build_timestamp;
	@synthesize root = _root;
	@synthesize product = _product;
	@synthesize features = _features;
	@synthesize triggers = _triggers;
	@synthesize security = _security;
	@synthesize isDefaultCert = _isDefaultCert;
	@synthesize internetAccessURL = _internetAccessURL;

	- (id) init
	{
		if(self = [super init])
		{
			self.deviceSpecs = nil; // [[SDZDeviceSpecifications alloc] init];
			self.upnpSpecs = nil; // [[SDZUPnPSpecifications alloc] init];
			self.controls = [[NSMutableArray alloc] init];
			self.app = nil;
			self.app_version = nil;
			self.platform = nil;
			self.build_timestamp = nil;
			self.root = nil; // [[SDZDeviceRoot alloc] init];
			self.product = nil; // [[SDZProduct alloc] init];
			self.features = [[NSMutableArray alloc] init];
			self.internetAccessURL = nil;

		}
		return self;
	}

	+ (SDZconfiguration*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (SDZconfiguration*)[[SDZconfiguration alloc] initWithNode: node];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.deviceSpecs = [[SDZDeviceSpecifications newWithNode: [Soap getNode: node withName: @"deviceSpecs"]] object];
			self.upnpSpecs = [[SDZUPnPSpecifications newWithNode: [Soap getNode: node withName: @"upnpSpecs"]] object];
			self.controls = [[SDZControls newWithNode: [Soap getNode: node withName: @"controls"]] object];
			self.app = [Soap getNodeValue: node withName: @"app"];
			self.app_version = [Soap getNodeValue: node withName: @"app_version"];
			self.platform = [Soap getNodeValue: node withName: @"platform"];
			self.build_timestamp = [Soap getNodeValue: node withName: @"build_timestamp"];
			self.root = [[SDZDeviceRoot newWithNode: [Soap getNode: node withName: @"root"]] object];
			self.product = [[SDZProduct newWithNode: [Soap getNode: node withName: @"product"]] object];
			self.features = [[SDZFeatures newWithNode: [Soap getNode: node withName: @"features"]] object];
			self.triggers = [[Soap getNodeValue: node withName: @"triggers"] boolValue];
			self.security = [Soap deserialize: [Soap getNode: node withName: @"security"]];
			self.isDefaultCert = [[Soap getNodeValue: node withName: @"isDefaultCert"] boolValue];
			self.internetAccessURL = [Soap getNodeValue: node withName: @"internetAccessURL"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"configuration"];
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
		if (self.deviceSpecs != nil) [s appendString: [self.deviceSpecs serialize: @"deviceSpecs"]];
		if (self.upnpSpecs != nil) [s appendString: [self.upnpSpecs serialize: @"upnpSpecs"]];
		if (self.controls != nil && self.controls.count > 0) {
			[s appendFormat: @"<controls>%@</controls>", [SDZControls serialize: self.controls]];
		} else {
			[s appendString: @"<controls/>"];
		}
		if (self.app != nil) [s appendFormat: @"<app>%@</app>", [[self.app stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.app_version != nil) [s appendFormat: @"<app_version>%@</app_version>", [[self.app_version stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.platform != nil) [s appendFormat: @"<platform>%@</platform>", [[self.platform stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.build_timestamp != nil) [s appendFormat: @"<build_timestamp>%@</build_timestamp>", [[self.build_timestamp stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.root != nil) [s appendString: [self.root serialize: @"root"]];
		if (self.product != nil) [s appendString: [self.product serialize: @"product"]];
		if (self.features != nil && self.features.count > 0) {
			[s appendFormat: @"<features>%@</features>", [SDZFeatures serialize: self.features]];
		} else {
			[s appendString: @"<features/>"];
		}
		[s appendFormat: @"<triggers>%@</triggers>", (self.triggers)?@"true":@"false"];
		[s appendString: [Soap serialize: self.security]];
		[s appendFormat: @"<isDefaultCert>%@</isDefaultCert>", (self.isDefaultCert)?@"true":@"false"];
		if (self.internetAccessURL != nil) [s appendFormat: @"<internetAccessURL>%@</internetAccessURL>", [[self.internetAccessURL stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[SDZconfiguration class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}

@end