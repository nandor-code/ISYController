//
//  ISYGeneralParser.m
//  ISYController
//
//  Created by Nandor Szots on 1/1/12.
//  Copyright (c) 2012 Umbra LLC. All rights reserved.
//

#import "ISYGeneralParser.h"
#import "ISYDevice.h"

@interface ISYGeneralParser()
@property (nonatomic, strong) NSMutableString* sCurrentText;
@property (nonatomic) BOOL bError;
@end

@implementation ISYGeneralParser

@synthesize delegate     = _delegate;
@synthesize curState     = _curState;
@synthesize bError       = _bError;
@synthesize sCurrentText = _sCurrentText;
@synthesize pCurDevice   = _pCurDevice;

- (id)initWithDelegate:(id)newDelegate
{
    self = [self init];
    
    self.curState = IB_NONE;
    self.bError   = NO;
    self.delegate = newDelegate;
    
    return self;
}

- (NSMutableString *)sCurrentText
{
    if( _sCurrentText == nil )
        _sCurrentText = [[NSMutableString alloc] init];
    
    return _sCurrentText;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if( [elementName isEqualToString:@"node"] )
    {
        // new node.
        self.pCurDevice = [[ISYDevice alloc] initWithType:ID_DEVICE];   
        self.curState = IB_DEV;
    }
    else if( [elementName isEqualToString:@"group"] )
    {
        // new node.
        self.pCurDevice = [[ISYDevice alloc] initWithType:ID_SCENE];        
        self.curState = IB_SCENE;
    } 
    else if( [elementName isEqualToString:@"name"] )
    {
        switch( self.pCurDevice.deviceType )
        {
            case ID_DEVICE:
                self.curState = IB_DEV_NAME;
                break;
            case ID_SCENE:
                self.curState = IB_SCENE_NAME;
                break;
            default:
                break;
        }
    }
    else if( [elementName isEqualToString:@"address"] )
    {
        switch( self.pCurDevice.deviceType )
        {
            case ID_DEVICE:
                self.curState = IB_DEV_ADDRESS;
                break;
            case ID_SCENE:
                self.curState = IB_SCENE_ADDRESS;
                break;
            default:
                break;
        }
    }
    else if( [elementName isEqualToString:@"type"] )
    {
        switch( self.pCurDevice.deviceType )
        {
            case ID_DEVICE:
                self.curState = IB_DEV_TYPE;
                break;
            default:
                break;
        }
    }
    else if( [elementName isEqualToString:@"property"] )
    {
        switch( self.pCurDevice.deviceType )
        {
            case ID_DEVICE:
                // set state.
                self.pCurDevice.fValue = [NSNumber numberWithFloat:[[attributeDict objectForKey:@"value"] floatValue]];
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
        enum eState eNextState = IB_NONE; 
        
        switch( self.curState )
        {
            case IB_SCENE_ADDRESS:
            case IB_SCENE_NAME:
                eNextState = IB_SCENE;
                break;
            case IB_DEV_TYPE:
            case IB_DEV_ADDRESS:
            case IB_DEV_NAME:
                eNextState = IB_DEV;
                break;
            default:
                break;
        }
        
        if( self.pCurDevice == nil )
        {
            [self.sCurrentText setString:@""];
            return;
        }
                
        switch( self.curState )
        {
            case IB_SCENE_ADDRESS:
            case IB_DEV_ADDRESS:
                [self.pCurDevice setDeviceID:self.sCurrentText];
                break;
            case IB_SCENE_NAME:
            case IB_DEV_NAME:
                [self.pCurDevice setDeviceName:self.sCurrentText];
                break;
            case IB_DEV_TYPE:
                [self.pCurDevice setDeviceTypeName:[ISYDevice getDeviceTypeByID:self.sCurrentText]];
                break;
            default:
                break;
        }
        
        self.curState = eNextState;
        [self.sCurrentText setString:@""];
    }
    
    if( [elementName isEqualToString:@"node"] )
    {
        // new node.
        //NSLog( @"Created NODE %@ with name(%@) addr(%@) type(%@)", self.pCurDevice, self.pCurDevice.sName, self.pCurDevice.sID, self.pCurDevice.sType );
        
        [self.delegate createISYDevice:self.pCurDevice];
    }
    else if( [elementName isEqualToString:@"group"] )
    {
        // new scene.
        [self.delegate createISYScene:self.pCurDevice];
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
