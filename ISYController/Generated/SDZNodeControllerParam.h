/*
	SDZNodeControllerParam.h
	The interface definition of properties and methods for the SDZNodeControllerParam object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface SDZNodeControllerParam : SoapObject
{
	NSString* _node;
	NSString* _controller;
	
}
		
	@property (retain, nonatomic) NSString* node;
	@property (retain, nonatomic) NSString* controller;

	+ (SDZNodeControllerParam*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end