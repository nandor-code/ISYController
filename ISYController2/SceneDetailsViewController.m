//
//  SceneDetailsViewController.m
//  ISYController2
//
//  Created by Nandor Szots on 12/23/11.
//  Copyright (c) 2011 Umbra LLC. All rights reserved.
//

#import "SceneDetailsViewController.h"
#import "ISYControllerDeviceViewController.h"
#import "ISYControllerSceneViewController.h"

@implementation SceneDetailsViewController

@synthesize delegate            = _delegate;
@synthesize sceneNavBar         = _sceneNavBar;
@synthesize switchToggle        = _switchToggle;
@synthesize sliderBar           = _sliderBar;
@synthesize lightbulbImage      = _lightbulbImage;
@synthesize configInstructions  = _configInstructions;
@synthesize sCurDeviceName      = _sCurDeviceName;
@synthesize sCurDeviceID        = _sCurDeviceID;

- (NSString*)sCurDeviceName
{
    if( _sCurDeviceName == nil )
        _sCurDeviceName = [[NSString alloc] initWithString:@"Scene"];
    
    return _sCurDeviceName;
}

- (NSString*)sCurDeviceID
{
    if( _sCurDeviceID == nil )
        _sCurDeviceID = [[NSString alloc] initWithString:@"0"];
    
    return _sCurDeviceID;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshView];
    
    [self.splitViewController setDelegate:self];
}

- (void)refreshView
{
    [self.sceneNavBar setTitle:self.sCurDeviceName];
    self.lightbulbImage.image = [UIImage imageNamed:@"Light_Off.png"];    
    
    [self.configInstructions setHidden:YES];
}

- (void)showConfigPage
{
    [self.configInstructions setHidden:NO];  
}

- (void)viewDidUnload
{
    [self setSceneNavBar:nil];
    [self setSwitchToggle:nil];
    [self setSliderBar:nil];
    [self setLightbulbImage:nil];
    [self setConfigInstructions:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (IBAction)toggled:(id)sender
{
    BOOL bOn = !self.switchToggle.on;
    
	[self.delegate toggleDevice:self.sCurDeviceID setOn:bOn];
    
    if( bOn )
    {
        self.lightbulbImage.image = [UIImage imageNamed:@"Light_On.png"];
    }
    else
    {
        self.lightbulbImage.image = [UIImage imageNamed:@"Light_Off.png"];
    }
}

- (IBAction)dim:(id)sender
{
    int iValue = (int)self.sliderBar.value;
    
    if( iValue > 1 )
    {
        [self.delegate dimDevice:self.sCurDeviceID setDim:iValue];   
        self.lightbulbImage.image = [UIImage imageNamed:@"Light_On.png"];
    }
    else
    {
        [self.delegate toggleDevice:self.sCurDeviceID setOn:NO];
        self.lightbulbImage.image = [UIImage imageNamed:@"Light_Off.png"];

    }
}

// split view controls
- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

@end
