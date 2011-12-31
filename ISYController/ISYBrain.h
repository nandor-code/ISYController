//
//  ISYBrain.h
//  ISYController
//
//  Created by Nandor Szots on 12/22/11.
//  Copyright (c) 2011 Umbra LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/tree.h>
#import "ISYDevice.h"

@interface ISYBrain : NSObject<NSXMLParserDelegate, NSURLConnectionDataDelegate>

enum eState
{
    IB_NONE,
    IB_DEV,
    IB_DEV_NAME,
    IB_DEV_ADDRESS,
    IB_DEV_TYPE,
    IB_SCENE,
    IB_SCENE_NAME,
    IB_SCENE_ADDRESS

};

@property (nonatomic, strong) NSMutableDictionary* isyDevicesByType;
@property (nonatomic, strong) NSMutableArray* isyDeviceStack;
@property (nonatomic, strong) NSMutableArray* isySceneStack;
@property (nonatomic, strong) NSString* sServerAddress;

@property enum eState curState;

- (NSString*)getData:(NSURL*)url;
- (NSString*)execCmd:(NSURL*)url;

- (NSMutableArray*)getArrayForType:(enum eISYDeviceType)type;
- (NSArray*)getDeviceArrayForType:(NSString*)sType;
- (NSArray*)getAllDeviceTypes;

- (void)setBaseURL:(NSString*)hostName userName:(NSString*)userName passWord:(NSString*)passWord useSSL:(BOOL)bUseSSL;

@end