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
@synthesize sType      = _sType;
@synthesize fValue     = _fValue;

+ (NSString*)getDeviceTypeByID:(NSString*)typeID
{
    if( [typeID isEqualToString:@"1.32.56.0"] )
        return @"Lights";
    if( [typeID isEqualToString:@"2.28.58.0"] )
        return @"Lights";
    if( [typeID isEqualToString:@"1.25.56.0"] )
        return @"Lights";
    if( [typeID isEqualToString:@"7.0.54.0"] )
        return @"Link Controls";
    if( [typeID isEqualToString:@"7.7.146.0"] )
        return @"Sensors";
    
    return @"Generic";
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

- (void)setDeviceTypeName:(NSString *)deviceType
{
    self.sType = deviceType;
}

- (NSComparisonResult)compareDevices:(ISYDevice *)p
{
    return [ self.sName
            compare: 
            p.sName ];
}

@end
