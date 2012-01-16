//
//  SceneDetailsViewController.m
//  ISYController
//
//  Created by Nandor Szots on 12/23/11.
//  Copyright (c) 2011 Umbra LLC. All rights reserved.
//

#import "LightDetailsViewController.h"
#import "ISYControllerDeviceViewController.h"
#import "ISYControllerSceneViewController.h"
#import "dispatch/dispatch.h"

@interface LightDetailsViewController()

@property (nonatomic) BOOL bStopUpdates;

- (void)updateDevice;

@end

@implementation LightDetailsViewController

@synthesize delegate            = _delegate;
@synthesize brain               = _brain;
@synthesize sceneNavBar         = _sceneNavBar;
@synthesize sliderBar           = _sliderBar;
@synthesize lightbulbImage      = _lightbulbImage;
@synthesize configInstructions  = _configInstructions;
@synthesize sCurDeviceName      = _sCurDeviceName;
@synthesize sCurDeviceID        = _sCurDeviceID;
@synthesize bStopUpdates        = _bStopUpdates;
@synthesize bCurrentlyOn        = _bCurrentlyOn;
@synthesize pUpdateTimer        = _pUpdateTimer;

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
    
    self.bStopUpdates = NO;
    
    [self refreshView];
    
    [self.splitViewController setDelegate:self];
    
    [self updateDevice];
    
    self.pUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateDevice) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.pUpdateTimer invalidate];
    self.pUpdateTimer = nil;
    
    [super viewWillDisappear:animated];
}

- (void)updateDevice
{
    dispatch_queue_t updateQueue = dispatch_queue_create("UpdateQueue", NULL);
    
    dispatch_async(updateQueue, ^{
        if( !self.bStopUpdates )
        {
            [self.brain getLightState:self.sCurDeviceID];
            [self performSelectorOnMainThread:@selector(refreshView) withObject:self waitUntilDone:YES];
        }
    });
    
    dispatch_release(updateQueue);
}
     
- (void)refreshView
{
    if( self.bStopUpdates )
        return;
    
    ISYDevice* myDevice = [self.brain getDevice:self.sCurDeviceID];
    
    if( myDevice )
    {
        if( [myDevice.fValue floatValue] == 0.0f )
        {
            self.bCurrentlyOn = NO;
            
            self.lightbulbImage.image = [UIImage imageNamed:@"Light_Off.png"];    
            
            if( self.sliderBar.value != 0.0f )
                [self.sliderBar setValue:0.0f];
        }
        else
        {
            self.bCurrentlyOn = YES;

            self.lightbulbImage.image = [UIImage imageNamed:@"Light_On.png"];  
            
            if( self.sliderBar.value != [myDevice.fValue floatValue] )
                [self.sliderBar setValue:[myDevice.fValue floatValue]];
        }
    }
        
    [self.sceneNavBar setTitle:self.sCurDeviceName];
    
    [self.configInstructions setHidden:YES];

    [self.lightbulbImage setNeedsDisplay];
    [self.view setNeedsDisplay];
}

- (void)showConfigPage
{
    [self.configInstructions setHidden:NO];  
}

- (void)viewDidUnload
{
    [self setSceneNavBar:nil];
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

- (IBAction)handleTap:(id)sender
{
    self.bStopUpdates = YES;
        
    self.bCurrentlyOn = !self.bCurrentlyOn;
    
	[self.delegate toggleDevice:self.sCurDeviceID setOn:self.bCurrentlyOn];
    
    [self.brain getLightState:self.sCurDeviceID];
    
    if( self.bCurrentlyOn )
    {
        self.lightbulbImage.image = [UIImage imageNamed:@"Light_On.png"];
    }
    else
    {
        self.lightbulbImage.image = [UIImage imageNamed:@"Light_Off.png"];
    }
    
    self.bStopUpdates = NO;
}

- (IBAction)dim:(id)sender
{
    self.bStopUpdates = YES;

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

    self.bStopUpdates = NO;
}

// split view controls
- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

@end
