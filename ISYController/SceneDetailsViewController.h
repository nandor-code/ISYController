//
//  SceneDetailsViewController.h
//  ISYController2
//
//  Created by Nandor Szots on 12/23/11.
//  Copyright (c) 2011 Umbra LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SceneDetailsViewController;

@protocol SceneDetailsViewControllerDelegate <NSObject>
- (void)sceneDetailsViewControllerClose:(SceneDetailsViewController*)controller;
- (void)toggleDevice:(NSString*)sID setOn:(BOOL)bOn;
- (void)dimDevice:(NSString*)sID setDim:(int)iValue;
@end

@interface SceneDetailsViewController : UIViewController <UISplitViewControllerDelegate>

@property (nonatomic, weak) id <SceneDetailsViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString* sCurDeviceName;
@property (nonatomic, strong) NSString* sCurDeviceID;

@property (weak, nonatomic) IBOutlet UINavigationItem *sceneNavBar;
@property (weak, nonatomic) IBOutlet UISwitch *switchToggle;
@property (weak, nonatomic) IBOutlet UISlider *sliderBar;
@property (weak, nonatomic) IBOutlet UIImageView *lightbulbImage;
@property (weak, nonatomic) IBOutlet UIView *configInstructions;

- (IBAction)toggled:(id)sender;
- (IBAction)dim:(id)sender;

- (void)refreshView;
- (void)showConfigPage;

@end
