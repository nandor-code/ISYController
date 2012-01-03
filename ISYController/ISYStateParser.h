//
//  ISYStateParser.h
//  ISYController
//
//  Created by Nandor Szots on 1/2/12.
//  Copyright (c) 2012 Umbra LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISYDevice.h"

@protocol ISYStateParserBrainDelgate <NSObject>
- (void)setValueForDevice:(NSString*)sDeviceID withValue:(NSNumber*)value;
@end

@interface ISYStateParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, weak) id <ISYStateParserBrainDelgate> delegate;

@property (nonatomic, strong) NSString* sDeviceID;

- (id)initWithDelegate:(id)newDelegate andDeviceID:(NSString*)deviceID;
@end
