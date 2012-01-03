//
//  ISYControllerSceneViewController.m
//  ISYController
//
//  Created by Nandor Szots on 12/23/11.
//  Copyright (c) 2011 Umbra LLC. All rights reserved.
//

#import "ISYControllerSceneViewController.h"
#import "dispatch/dispatch.h"
#import "QuartzCore/QuartzCore.h"

@interface ISYControllerSceneViewController() <LightDetailsViewControllerDelegate>
- (void)lightDetailsViewControllerClose:(LightDetailsViewController *)controller;
- (void)toggleDevice:(NSString*)sID setOn:(BOOL)bOn;
- (void)dimDevice:(NSString*)sID setDim:(int)iValue;
@end

@implementation ISYControllerSceneViewController

@synthesize delegate        = _delegate;
@synthesize brain           = _brain;
@synthesize eCurType        = _eCurType;
@synthesize sceneTableView  = _sceneTableView;
@synthesize refreshButton   = _refreshButton;
@synthesize refreshView     = _refreshView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.eCurType = ID_SCENE;
    
    self.delegate = (ISYControllerAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.brain = self.delegate.brain;
    
    self.refreshView.layer.cornerRadius = 20.0f;
}

- (void)viewDidUnload
{
    [self setSceneTableView:nil];
    [self setRefreshView:nil];
    [self setRefreshButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section 
{    
    return [[self.brain getArrayForType:self.eCurType] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ISYDeviceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    ISYDevice* curDevice = (ISYDevice*)[[self.brain getArrayForType:self.eCurType] objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = curDevice.sName;
    return cell;
}

- (void)tableView:(UITableView *)aTableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LightDetailsViewController *lightDetailsViewController = [[self.splitViewController viewControllers] lastObject];
    
    if( lightDetailsViewController != nil )
    {
        lightDetailsViewController.delegate = self;
        
        ISYDevice* curDevice = (ISYDevice*)[[self.brain getArrayForType:self.eCurType] objectAtIndex:[indexPath row]];
        
        lightDetailsViewController.sCurDeviceName = curDevice.sName;
        lightDetailsViewController.sCurDeviceID   = curDevice.sID;
        lightDetailsViewController.brain          = self.brain;

        
        [lightDetailsViewController refreshView];

        NSLog( @"Selection of %@", curDevice.sName );     
    }
}

- (void)lightDetailsViewControllerClose:(LightDetailsViewController *)controller
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleDevice:(NSString*)sID setOn:(BOOL)bOn
{
    NSURL* url;
    
    if( bOn )
    {
        NSLog(@"Setting Device %@ ON", sID );
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/%@/cmd/DFON", self.brain.sServerAddress, [sID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
    }
    else
    {
        NSLog(@"Setting Device %@ OFF", sID );
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/%@/cmd/DFOF", self.brain.sServerAddress, [sID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
    }
    
    [self.brain execCmd:url];
}

- (void)dimDevice:(NSString*)sID setDim:(int)iValue
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"SceneDetails"])
	{
		LightDetailsViewController *lightDetailsViewController = segue.destinationViewController;
		lightDetailsViewController.delegate = self;
        
        NSIndexPath *indexPath = [self.sceneTableView indexPathForSelectedRow];

        ISYDevice* curDevice = (ISYDevice*)[[self.brain getArrayForType:self.eCurType] objectAtIndex:[indexPath row]];
        
        lightDetailsViewController.sCurDeviceName = curDevice.sName;
        lightDetailsViewController.sCurDeviceID   = curDevice.sID;
        lightDetailsViewController.brain          = self.brain;
        
        // clear selection
        [self.sceneTableView deselectRowAtIndexPath:[self.sceneTableView indexPathForSelectedRow] animated:NO];

        NSLog( @"Seg from %@", curDevice.sName );
	}
}

- (IBAction)refreshDevices:(id)sender
{
    [self.refreshView setHidden:NO];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    dispatch_async(queue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.delegate refreshBrain];
            [self.view setNeedsLayout];
            [self.sceneTableView reloadData];
            [self.refreshView setHidden:YES];
        });
    });
}


@end
