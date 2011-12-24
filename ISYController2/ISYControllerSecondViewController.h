//
//  ISYControllerSecondViewController.h
//  ISYController2
//
//  Created by Nandor Szots on 12/23/11.
//  Copyright (c) 2011 Umbra LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISYBrain.h"
#import "ISYDevice.h"
#import "ISYControllerAppDelegate.h"
#import "SceneDetailsViewController.h"

@interface ISYControllerSecondViewController : UIViewController <SceneDetailsViewControllerDelegate>

@property (nonatomic, assign) ISYControllerAppDelegate* delegate;
@property (nonatomic, weak) ISYBrain* brain;
@property enum eISYDeviceType eCurType;
@property (weak, nonatomic) IBOutlet UITableView *sceneTableView;

- (void)sceneDetailsViewControllerClose:(SceneDetailsViewController *)controller;
- (void)toggleDevice:(NSString*)sID setOn:(BOOL)bOn;

@end
