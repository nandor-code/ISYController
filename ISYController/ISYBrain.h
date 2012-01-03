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

@interface ISYBrain : NSObject

@property (nonatomic, strong) NSMutableDictionary* isyDevicesByType;
@property (nonatomic, strong) NSMutableArray* isyDeviceStack;
@property (nonatomic, strong) NSMutableArray* isySceneStack;
@property (nonatomic, strong) NSString* sServerAddress;

- (NSString*)getData:(NSURL*)url;
- (NSString*)execCmd:(NSURL*)url;

- (NSMutableArray*)getArrayForType:(enum eISYDeviceType)type;
- (NSArray*)getDeviceArrayForType:(NSString*)sType;
- (NSArray*)getAllDeviceTypes;

- (void)getLightState:(NSString*)deviceID;

- (ISYDevice*)getDevice:(NSString*)deviceID;

- (void)setBaseURL:(NSString*)hostName userName:(NSString*)userName passWord:(NSString*)passWord useSSL:(BOOL)bUseSSL;

@end
