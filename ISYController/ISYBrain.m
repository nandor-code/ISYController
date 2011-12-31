//
//  ISYBrain.m
//  ISYController
//
//  Created by Nandor Szots on 12/22/11.
//  Copyright (c) 2011 Umbra LLC. All rights reserved.
//

#import "ISYBrain.h"


@interface ISYBrain()
@property (nonatomic, strong) NSMutableString* sCurrentText;
@property (nonatomic) BOOL bError;
@end

@interface NSURLRequest (DummyInterface)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end

@implementation ISYBrain

@synthesize isyDevicesByType = _isyDevicesByType;
@synthesize isySceneStack    = _isySceneStack;
@synthesize isyDeviceStack   = _isyDeviceStack;
@synthesize sCurrentText     = _sCurrentText;
@synthesize curState         = _curState;
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

- (NSMutableString *)sCurrentText
{
    if( _sCurrentText == nil )
        _sCurrentText = [[NSMutableString alloc] init];
    
    return _sCurrentText;
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
    
    [xmlParser setDelegate:self];
    
    [xmlParser parse];
    
    xmlParser = nil;
    
    if( self.bError )
        return @"ERROR";
    
    return @"OK";
}

- (NSString*)getData:(NSURL*)url
{
    [self.sCurrentText setString:@""];
            
    [self.isyDeviceStack removeAllObjects];
    [self.isySceneStack removeAllObjects];
    [self.isyDevicesByType removeAllObjects];
    
    self.curState = IB_NONE;
    
    self.bError = NO;
    
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES
                                       forHost:[url host]];
    
    NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [xmlParser setDelegate:self];
    
    [xmlParser parse];
        
    xmlParser = nil;    
    
    // sort it
    [self.isySceneStack sortUsingSelector:@selector(compareDevices:)];
    
    if( self.bError )
        return @"ERROR";
    
    return @"OK";
}

#pragma mark Delegate calls

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if( [elementName isEqualToString:@"node"] )
    {
        // new node.
        ISYDevice* newDevice = [[ISYDevice alloc] initWithType:ID_DEVICE];
        
        [self.isyDeviceStack addObject:newDevice];
        self.curState = IB_DEV;
    }
    else if( [elementName isEqualToString:@"group"] )
    {
        // new node.
        ISYDevice* newDevice = [[ISYDevice alloc] initWithType:ID_SCENE];
        
        [self.isySceneStack addObject:newDevice];
        self.curState = IB_SCENE;
    } 
    else if( [elementName isEqualToString:@"name"] )
    {
        switch( self.curState )
        {
            case IB_DEV:
                self.curState = IB_DEV_NAME;
                break;
            case IB_SCENE:
                self.curState = IB_SCENE_NAME;
                break;
            default:
                break;
        }
    }
    else if( [elementName isEqualToString:@"address"] )
    {
        switch( self.curState )
        {
            case IB_DEV:
                self.curState = IB_DEV_ADDRESS;
                break;
            case IB_SCENE:
                self.curState = IB_SCENE_ADDRESS;
                break;
            default:
                break;
        }
    }
    else if( [elementName isEqualToString:@"type"] )
    {
        switch( self.curState )
        {
            case IB_DEV:
                self.curState = IB_DEV_TYPE;
                break;
            default:
                break;
        }
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{    
    if (self.sCurrentText.length > 0)
    {
        ISYDevice* curDevice = nil;
        enum eState eNextState = IB_NONE; 
        
        switch( self.curState )
        {
            case IB_SCENE_ADDRESS:
            case IB_SCENE_NAME:
                curDevice = [self.isySceneStack lastObject];
                eNextState = IB_SCENE;
                break;
            case IB_DEV_TYPE:
            case IB_DEV_ADDRESS:
            case IB_DEV_NAME:
                curDevice = [self.isyDeviceStack lastObject];
                eNextState = IB_DEV;
                break;
            default:
                break;
        }
        
        if( curDevice == nil )
        {
            [self.sCurrentText setString:@""];
            return;
        }

        switch( self.curState )
        {
            case IB_SCENE_ADDRESS:
            case IB_DEV_ADDRESS:
                [curDevice setDeviceID:self.sCurrentText];
                break;
            case IB_SCENE_NAME:
            case IB_DEV_NAME:
                [curDevice setDeviceName:self.sCurrentText];
                break;
            case IB_DEV_TYPE:
                {
                    NSString* curType = [ISYDevice getDeviceTypeByID:self.sCurrentText];
                    NSArray* arrayForType = [self.isyDevicesByType objectForKey:curType];
                    
                    NSMutableArray* mutableArrayForType = nil;
                    
                    if( arrayForType == nil )
                    {
                        mutableArrayForType = [[NSMutableArray alloc] init];
                    }
                    else
                    {
                        mutableArrayForType = [arrayForType mutableCopy];
                    }
                                        
                    [mutableArrayForType addObject:curDevice];
                    
                    [mutableArrayForType sortUsingSelector:@selector(compareDevices:)];
                    
                    [self.isyDevicesByType setObject:[mutableArrayForType copy] forKey:curType];
                        
                }
                break;
            default:
                break;
        }
        
        self.curState = eNextState;
        [self.sCurrentText setString:@""];
    }
}

// This method can get called multiple times for the
// text in a single element
- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string
{
    [self.sCurrentText appendString:string];
}

- (void)parser:(NSXMLParser *)parser
parseErrorOccurred:(NSError *)parseError
{
    NSLog( @"Error: %@", parseError );
    self.bError = YES;
}

@end
