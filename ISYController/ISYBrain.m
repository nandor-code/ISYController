//
//  ISYBrain.m
//  ISYController
//
//  Created by Nandor Szots on 12/22/11.
//  Copyright (c) 2011 Umbra LLC. All rights reserved.
//

#import "ISYBrain.h"
#import "ISYGeneralParser.h"
#import "ISYStateParser.h"

@interface NSURLRequest (DummyInterface)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end

@interface ISYBrain() <NSURLConnectionDataDelegate, ISYGeneralParserBrainDelgate, ISYStateParserBrainDelgate>
@property (nonatomic) BOOL bError;
- (void)setValueForDevice:(NSString*)sDeviceID withValue:(NSNumber*)value;
@end

@implementation ISYBrain

@synthesize isyDevicesByType = _isyDevicesByType;
@synthesize isySceneStack    = _isySceneStack;
@synthesize isyDeviceStack   = _isyDeviceStack;
@synthesize sServerAddress   = _sServerAddress;
@synthesize bError           = _bError;

- (NSMutableArray *)isySceneStack
{
    if( _isySceneStack == nil )
        _isySceneStack = [[NSMutableArray alloc] init];
    
    return _isySceneStack;
}

- (NSMutableDictionary *)isyDevicesByType
{
    if( _isyDevicesByType == nil )
        _isyDevicesByType = [[NSMutableDictionary alloc] init];
    
    return _isyDevicesByType;
}

- (NSMutableArray *)isyDeviceStack
{
    if( _isyDeviceStack == nil )
        _isyDeviceStack = [[NSMutableArray alloc] init];
    
    return _isyDeviceStack;
}

- (NSString *)sServerAddress
{
    if( _sServerAddress == nil )
        _sServerAddress = [[NSString alloc] init ];
    
    return _sServerAddress;
}

- (NSMutableArray*)getArrayForType:(enum eISYDeviceType)type
{
    switch( type )
    {
        case ID_SCENE:
            return self.isySceneStack;
        case ID_DEVICE:
            return self.isyDeviceStack;
        default:
            return nil;
    }
}

- (NSArray*)getDeviceArrayForType:(NSString*)sType
{
    return [self.isyDevicesByType objectForKey:sType];
}

- (NSArray*)getAllDeviceTypes
{
    return [self.isyDevicesByType allKeys];
}

- (void)setBaseURL:(NSString*)hostName userName:(NSString*)userName passWord:(NSString*)passWord useSSL:(BOOL)bUseSSL
{
    self.sServerAddress = nil;
    
    if( bUseSSL )
    {
        self.sServerAddress = [[NSString alloc] initWithFormat:@"https://%@:%@@%@/rest/nodes", userName, passWord, hostName ];
    }
    else
    {
        self.sServerAddress = [[NSString alloc] initWithFormat:@"http://%@:%@@%@/rest/nodes", userName, passWord, hostName ];        
    }
}

- (NSString*)execCmd:(NSURL*)url forDevice:(NSString*)deviceID
{
    self.bError = NO;
    
    // lock the device from updates until we are done.
    
    ISYDevice* isyDevice = [self getDevice:deviceID];
    
    isyDevice.bLocked = YES;
    
    NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    ISYGeneralParser* isyParser = [[ISYGeneralParser alloc] initWithDelegate:self];
        
    [xmlParser setDelegate:isyParser];    
    
    [xmlParser parse];
    
    xmlParser = nil;
    isyParser = nil;
    
    isyDevice.bLocked = NO;

    if( self.bError )
        return @"ERROR";
    
    return @"OK";
}

- (void)getLightState:(NSString*)deviceID
{
    ISYDevice* updateDev = [self getDevice:deviceID];

    if( updateDev.bLocked )
        return;
    
    NSURL* url;
    
    url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/%@", 
                                         self.sServerAddress, 
                                         [deviceID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                         ] ];
    
    NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    ISYStateParser* isyParser = [[ISYStateParser alloc] initWithDelegate:self andDeviceID:deviceID];
    
    [xmlParser setDelegate:isyParser];
    
    [xmlParser parse];
    
    xmlParser = nil;
    
    isyParser = nil;
}

- (void)setValueForDevice:(NSString*)sDeviceID withValue:(NSNumber*)value
{
    ISYDevice* updateDev = [self getDevice:sDeviceID];
    
    NSLog( @"Setting Value %g for %@ Locked = %d", [value floatValue], updateDev, updateDev.bLocked );
    [updateDev setDeviceValue:value];
}

- (ISYDevice*)getDevice:(NSString*)deviceID
{
    for ( id obj in self.isyDeviceStack ) 
    {
        if( [obj isKindOfClass:[ISYDevice class]] )
        {
            ISYDevice* curDev = (ISYDevice*)obj;
            if( [curDev.sID isEqualToString:deviceID] )
                return curDev;
        }
    }
    
    return nil;
}

- (NSString*)getData:(NSURL*)url
{            
    [self.isyDeviceStack removeAllObjects];
    [self.isySceneStack removeAllObjects];
    [self.isyDevicesByType removeAllObjects];
        
    self.bError = NO;
    
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES
                                       forHost:[url host]];
    
    NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    ISYGeneralParser* isyParser = [[ISYGeneralParser alloc] initWithDelegate:self];
    
    [xmlParser setDelegate:isyParser];
    
    [xmlParser parse];
        
    xmlParser = nil;    
    
    // sort it
    [self.isySceneStack sortUsingSelector:@selector(compareDevices:)];
    
    if( self.bError )
        return @"ERROR";
    
    return @"OK";
}

#pragma mark Delegate calls

- (void)createISYDevice:(ISYDevice*)device
{
    [self.isyDeviceStack addObject:device];  
    
    NSArray* arrayForType = [self.isyDevicesByType objectForKey:device.sType];
    
    NSMutableArray* mutableArrayForType = nil;
    
    if( arrayForType == nil )
    {
        mutableArrayForType = [[NSMutableArray alloc] init];
    }
    else
    {
        mutableArrayForType = [arrayForType mutableCopy];
    }
    
    [mutableArrayForType addObject:device];
    
    [mutableArrayForType sortUsingSelector:@selector(compareDevices:)];
    
    [self.isyDevicesByType setObject:[mutableArrayForType copy] forKey:device.sType];
}

- (ISYDevice*)getCurrentDevice
{
    return [self.isyDeviceStack lastObject];
}

- (void)createISYScene:(ISYDevice*)device
{
    [self.isySceneStack addObject:device];
}

- (ISYDevice*)getCurrentScene
{
    return [self.isySceneStack lastObject];
}

- (void)parseError
{
    self.bError = YES;
}
@end
