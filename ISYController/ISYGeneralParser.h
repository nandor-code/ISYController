//
//  ISYGeneralParser.h
//  ISYController
//
//  Created by Nandor Szots on 1/1/12.
//  Copyright (c) 2012 Umbra LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/tree.h>
#import "ISYDevice.h"

@protocol ISYParserBrainDelgate <NSObject>
- (void)createISYDevice:(ISYDevice*)device;
- (ISYDevice*)getCurrentDevice;
- (void)createISYScene:(ISYDevice*)device;
- (ISYDevice*)getCurrentScene;
- (void)parseError;
@end

@interface ISYGeneralParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, weak) id <ISYParserBrainDelgate> delegate;

enum eState
{
    IB_NONE,
    IB_DEV,
    IB_DEV_NAME,
    IB_DEV_ADDRESS,
    IB_DEV_TYPE,
    IB_SCENE,
    IB_SCENE_NAME,
    IB_SCENE_ADDRESS
    
};

@property (nonatomic, strong) ISYDevice* pCurDevice;

@property enum eState curState;

- (id)initWithDelegate:(id)newDelegate;

@end
