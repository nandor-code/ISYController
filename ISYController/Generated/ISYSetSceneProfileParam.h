/*
	ISYSetSceneProfileParam.h
	The interface definition of properties and methods for the ISYSetSceneProfileParam object.
	Generated by SudzC.com
*/

#import "Soap.h"
	
#import "ISYNodeControllerParam.h"
@class ISYNodeControllerParam;


@interface ISYSetSceneProfileParam : ISYNodeControllerParam
{
	NSString* _control;
	NSString* _action;
	
}
		
	@property (retain, nonatomic) NSString* control;
	@property (retain, nonatomic) NSString* action;

	+ (ISYSetSceneProfileParam*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end