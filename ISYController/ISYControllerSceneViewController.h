//
//  ISYControllerSceneViewController.h
//  ISYController
//
//  Created by Nandor Szots on 12/23/11.
//  Copyright (c) 2011 Umbra LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISYBrain.h"
#import "ISYDevice.h"
#import "ISYControllerAppDelegate.h"
#import "SceneDetailsViewController.h"

@interface ISYControllerSceneViewController : UIViewController <SceneDetailsViewControllerDelegate>

@property (nonatomic, assign) ISYControllerAppDelegate* delegate;
@property (nonatomic, weak) ISYBrain* brain;
@property enum eISYDeviceType eCurType;
@property (weak, nonatomic) IBOutlet UITableView *sceneTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIView *refreshView;

- (void)sceneDetailsViewControllerClose:(SceneDetailsViewController *)controller;
- (void)toggleDevice:(NSString*)sID setOn:(BOOL)bOn;
- (void)dimDevice:(NSString*)sID setDim:(int)iValue;

- (IBAction)refreshDevices:(id)sender;

@end
