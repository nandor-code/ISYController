//
//  ISYControllerDeviceViewController.h
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

@interface ISYControllerDeviceViewController : UIViewController <SceneDetailsViewControllerDelegate>

@property (nonatomic, assign) ISYControllerAppDelegate* delegate;
@property (nonatomic, weak) ISYBrain* brain;
@property enum eISYDeviceType eCurType;
@property (weak, nonatomic) IBOutlet UITableView *deviceTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIView *refreshView;
@property (nonatomic, strong) NSString* sCurType;

- (void)sceneDetailsViewControllerClose:(SceneDetailsViewController *)controller;
- (void)toggleDevice:(NSString*)sID setOn:(BOOL)bOn;
- (void)dimDevice:(NSString*)sID setDim:(int)iValue;

- (void)setCurType:(NSString*)type;

- (void)tableReset;
- (void)setSelectedDevice:(NSIndexPath *)indexPath;

- (IBAction)refreshDevices:(id)sender;

@end
