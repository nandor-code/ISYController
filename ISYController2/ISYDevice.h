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

@property enum eISYDeviceType deviceType;
@property (nonatomic, strong) NSString* sName;
@property (nonatomic, strong) NSString* sID;

- initWithType:(enum eISYDeviceType)type;
- initWithType:(enum eISYDeviceType)type withName:(NSString*)name;

- (void)setName:(NSString *)deviceName;
- (void)setID:(NSString *)deviceID;

@end
