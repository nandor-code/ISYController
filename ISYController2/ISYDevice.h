//
//  ISYDevice.h
//  ISYController
//
//  Created by Nandor Szots on 12/23/11.
//  Copyright (c) 2011 Umbra LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISYDevice : NSObject

enum eISYDeviceType
{
    ID_NONE,
    ID_DEVICE,
    ID_SCENE
};

+ (NSString*)getDeviceTypeByID:(NSString*)typeID;

@property enum eISYDeviceType deviceType;
@property (nonatomic, copy) NSString* sName;
@property (nonatomic, copy) NSString* sID;

- (id)initWithType:(enum eISYDeviceType)type;
- (id)initWithType:(enum eISYDeviceType)type withName:(NSString*)name;

- (void)setDeviceName:(NSString *)deviceName;
- (void)setDeviceID:(NSString *)deviceID;
- (NSComparisonResult)compareDevices:(ISYDevice *)p;

@end
