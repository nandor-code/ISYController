//
//  ISYDevice.m
//  ISYController
//
//  Created by Nandor Szots on 12/23/11.
//  Copyright (c) 2011 Umbra LLC. All rights reserved.
//

#import "ISYDevice.h"

@implementation ISYDevice

@synthesize deviceType = _deviceType;
@synthesize sName      = _sName;
@synthesize sID        = _sID;

- (NSString*)sName
{
    if( _sName == nil )
        _sName = [[NSString alloc] init];
    
    return _sName;
}

- (NSString*)sID
{
    if( _sID == nil )
        _sID = [[NSString alloc] init];
    
    return _sID;
}

- initWithType:(enum eISYDeviceType)type
{
    self.deviceType = type;
    
    return self;
}

- initWithType:(enum eISYDeviceType)type withName:(NSString*)name
{
    self.deviceType = type;
    self.sName      = name;
    
    return self;
}

- (void)setName:(NSString *)deviceName
{
    self.sName = deviceName;
}

- (void)setID:(NSString *)deviceID
{
    self.sID   = deviceID;
}

@end
