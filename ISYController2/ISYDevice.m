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

- (id)initWithType:(enum eISYDeviceType)type
{
    self = [self init];
    
    self.deviceType = type;
    
    return self;
}

- (id)initWithType:(enum eISYDeviceType)type withName:(NSString*)name
{
    self = [self init];
    
    self.deviceType = type;
    self.sName      = name;
    
    return self;
}

- (void)setDeviceName:(NSString *)deviceName
{
    self.sName = deviceName;
}

- (void)setDeviceID:(NSString *)deviceID
{
    self.sID = deviceID;
}

- (NSComparisonResult)compareDevices:(ISYDevice *)p
{
    return [ self.sName
            compare: 
            p.sName ];
}

@end
