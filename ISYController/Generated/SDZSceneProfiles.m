/*
	SDZSceneProfiles.h
	The implementation of properties and methods for the SDZSceneProfiles array.
	Generated by SudzC.com
*/
#import "SDZSceneProfiles.h"

#import "SDZSceneProfile.h"
@implementation SDZSceneProfiles

	+ (id) newWithNode: (CXMLNode*) node
	{
		return [[SDZSceneProfiles alloc] initWithNode: node];
	}

	- (id) initWithNode: (CXMLNode*) node
	{
		if(self = [self init]) {
			for(CXMLElement* child in [node children])
			{
				SDZSceneProfile* value = [[SDZSceneProfile newWithNode: child] object];
				if(value != nil) {
					[self addObject: value];
				}
			}
		}
		return self;
	}
	
	+ (NSMutableString*) serialize: (NSArray*) array
	{
		NSMutableString* s = [NSMutableString string];
		for(id item in array) {
			[s appendString: [item serialize: @"SceneProfile"]];
		}
		return s;
	}
@end