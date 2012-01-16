/*
	ISYDDNSHostParam.h
	The interface definition of properties and methods for the ISYDDNSHostParam object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface ISYDDNSHostParam : SoapObject
{
	NSString* _host;
	
}
		
	@property (retain, nonatomic) NSString* host;

	+ (ISYDDNSHostParam*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end