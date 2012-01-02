//
//  ISYBrain.m
//  ISYController
//
//  Created by Nandor Szots on 12/22/11.
//  Copyright (c) 2011 Umbra LLC. All rights reserved.
//

#import "ISYBrain.h"

@interface NSURLRequest (DummyInterface)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end

@interface ISYBrain() <ISYParserBrainDelgate>
@property (nonatomic) BOOL bError;
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

- (NSString*)execCmd:(NSURL*)url
{
    self.bError = NO;
    
    NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    ISYGeneralParser* isyParser = [[ISYGeneralParser alloc] initWithDelegate:self];
        
    [xmlParser setDelegate:isyParser];    
    
    [xmlParser parse];
    
    xmlParser = nil;
    isyParser = nil;
    
    if( self.bError )
        return @"ERROR";
    
    return @"OK";
}

- (NSNumber*)getLightState:(NSURL*)url
{
    self.bError = NO;
    
    NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    ISYGeneralParser* isyParser = [[ISYGeneralParser alloc] initWithDelegate:self];
    
    [xmlParser setDelegate:isyParser];
    
    [xmlParser parse];
    
    xmlParser = nil;
    
    isyParser = nil;
    
    if( self.bError )
        return [NSNumber numberWithInt:0];

    
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
