/*
	ISYDDNSHost.h
	The interface definition of properties and methods for the ISYDDNSHost object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface ISYDDNSHost : SoapObject
{
	NSString* _name;
	NSString* _ip;
	
}
		
	@property (retain, nonatomic) NSString* name;
	@property (retain, nonatomic) NSString* ip;

	+ (ISYDDNSHost*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end