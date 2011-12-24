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

@synthesize isyTypesStack  = _isyTypesStack;
@synthesize isySceneStack  = _isySceneStack;
@synthesize isyDeviceStack = _isyDeviceStack;
@synthesize sCurrentText   = _sCurrentText;
@synthesize curState       = _curState;

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

- (NSMutableArray *)isyTypesStack
{
    if( _isyTypesStack == nil )
        _isyTypesStack = [[NSMutableArray alloc] init];
    
    return _isyTypesStack;
}

- (NSMutableString *)sCurrentText
{
    if( _sCurrentText == nil )
        _sCurrentText = [[NSMutableString alloc] init];
    
    return _sCurrentText;
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
            return self.isyTypesStack;
    }
}

- (void)getData:(NSURL*)url
{
    [self.sCurrentText setString:@""];
            
    [self.isyTypesStack removeAllObjects];
    [self.isyDeviceStack removeAllObjects];
    [self.isySceneStack removeAllObjects];
    
    [self.isyTypesStack addObject:[[ISYDevice alloc] initWithType:ID_DEVICE withName:@"Devices"]];
    [self.isyTypesStack addObject:[[ISYDevice alloc] initWithType:ID_SCENE withName:@"Scenes"]];
    
    self.curState = IB_NONE;
    
    NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [xmlParser setDelegate:self];
    
    [xmlParser parse];
        
    xmlParser = nil;       
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
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{    
    if (self.sCurrentText.length > 0)
    {
        ISYDevice* curDevice = nil;
        
        switch( self.curState )
        {
            case IB_SCENE_ADDRESS:
            case IB_SCENE_NAME:
                curDevice = [self.isySceneStack lastObject];
                break;
            case IB_DEV_ADDRESS:
            case IB_DEV_NAME:
                curDevice = [self.isyDeviceStack lastObject];
                break;
            default:
                break;
        }
        
        if( curDevice == nil )
        {
            NSLog( @"Got a name but not in a valid state!" );
            return;
        }

        switch( self.curState )
        {
            case IB_SCENE_ADDRESS:
            case IB_DEV_ADDRESS:
                [curDevice setID:elementName];
                break;
            case IB_SCENE_NAME:
            case IB_DEV_NAME:
                [curDevice setName:elementName];
                break;
            default:
                break;
        }
        
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
