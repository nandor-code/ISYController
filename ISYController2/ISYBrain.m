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
@end

@implementation ISYBrain

@synthesize isySceneStack  = _isySceneStack;
@synthesize isyDeviceStack = _isyDeviceStack;
@synthesize sCurrentText   = _sCurrentText;
@synthesize curState       = _curState;
@synthesize sServerAddress = _sServerAddress;

- (NSMutableArray *)isySceneStack
{
    if( _isySceneStack == nil )
        _isySceneStack = [[NSMutableArray alloc] init];
    
    return _isySceneStack;
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
        _sServerAddress = [[NSString alloc] initWithFormat:@"http://nandor:xaqw2ggg@10.13.69.200/rest/nodes" ];
    
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

- (NSString*)execCmd:(NSURL*)url
{
    NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [xmlParser setDelegate:self];
    
    [xmlParser parse];
    
    xmlParser = nil;
    
    return @"OK";
}

- (void)getData:(NSURL*)url
{
    [self.sCurrentText setString:@""];
            
    [self.isyDeviceStack removeAllObjects];
    [self.isySceneStack removeAllObjects];
    
    self.curState = IB_NONE;
    
    NSError *error;
    
    NSString* sData = [NSString stringWithContentsOfURL:url 
                                               encoding:NSASCIIStringEncoding
                                                  error:&error];
    
    NSLog( @"DATA : %@ / ERR: %@", sData, error );
    
    NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [xmlParser setDelegate:self];
    
    [xmlParser parse];
        
    xmlParser = nil;    
    
    // sort it
    [self.isySceneStack sortUsingSelector:@selector(compareDevices:)];
}

#pragma mark Delegate calls

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{

    NSLog( @"%@", elementName );
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
}

@end
