//
//  ISYControllerAppDelegate.h
//  ISYController
//
//  Created by Nandor Szots on 12/23/11.
//  Copyright (c) 2011 Umbra LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISYBrain.h"

@interface ISYControllerAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ISYBrain *brain;
@property (weak, nonatomic) IBOutlet UITabBarController *tabBar;

- (NSMutableArray*)getDevices;
- (NSMutableArray*)getScenes;
- (void)refreshBrain;

@end
