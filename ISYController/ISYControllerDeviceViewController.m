//
//  ISYControllerDeviceViewController.m
//  ISYController
//
//  Created by Nandor Szots on 12/23/11.
//  Copyright (c) 2011 Umbra LLC. All rights reserved.
//

#import "ISYControllerDeviceViewController.h"
#import "dispatch/dispatch.h"
#import "QuartzCore/QuartzCore.h"

@interface ISYControllerDeviceViewController() <LightDetailsViewControllerDelegate>
@property (nonatomic) BOOL bHaveValidData;
- (void)lightDetailsViewControllerClose:(LightDetailsViewController *)controller;
- (void)toggleDevice:(NSString*)sID setOn:(BOOL)bOn;
- (void)dimDevice:(NSString*)sID setDim:(int)iValue;
@end

@implementation ISYControllerDeviceViewController

@synthesize delegate        = _delegate;
@synthesize brain           = _brain;
@synthesize eCurType        = _eCurType;
@synthesize deviceTableView = _deviceTableView;
@synthesize refreshButton   = _refreshButton;
@synthesize refreshView     = _refreshView;
@synthesize bHaveValidData  = _bHaveValidData;
@synthesize sCurType        = _sCurType;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (NSString*)sCurType
{
    if( _sCurType == nil )
        _sCurType = [[NSString alloc] init];
        
    return _sCurType;
}

- (void)setCurType:(NSString*)type
{    
    _sCurType = nil;
    _sCurType = [[NSString alloc] initWithString:type];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if( [self.sCurType isEqualToString:@""] )
        self.bHaveValidData = NO;
    else
        self.bHaveValidData = YES;
    
    self.eCurType = ID_DEVICE;

    self.delegate = (ISYControllerAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.brain = self.delegate.brain;
    
    self.refreshView.layer.cornerRadius = 20.0f;
}

- (void)viewDidAppear:(BOOL)animated
{
    if ( [[[NSUserDefaults standardUserDefaults] stringForKey:@"Hostname"] isEqualToString:@""] ) 
    {
        // user hasn't configured us yet!  oh no!  
        UITabBarController* parentTabbar = self.delegate.tabBar;
        
        [parentTabbar setSelectedIndex:2];
    }
    else
    {
        if( !self.bHaveValidData )
        {
            [self refreshDevices:nil];
            self.bHaveValidData = YES;
        }
    }
    
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [self setDeviceTableView:nil];
    [self setRefreshButton:nil];
    [self setRefreshView:nil];
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
    if( [self.sCurType isEqualToString:@""] )
        return [[self.brain getAllDeviceTypes] count];
    else
        return [[self.brain getDeviceArrayForType:self.sCurType] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = nil;
    
    if( [self.sCurType isEqualToString:@""] )
    {
        static NSString *CellIdentifier = @"ISYDeviceTypeCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier];
        }
        
        // device types
        cell.textLabel.text = [[self.brain getAllDeviceTypes] objectAtIndex:[indexPath row]];
    }
    else
    {
        // devices.
        static NSString *CellIdentifier = @"ISYDeviceCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell.
        ISYDevice* curDevice = (ISYDevice*)[[self.brain getDeviceArrayForType:self.sCurType] objectAtIndex:[indexPath row]];
        
        cell.textLabel.text = curDevice.sName;
        
        if( [curDevice.fValue floatValue] == 0.0f )
            cell.imageView.image = [UIImage imageNamed:@"Light_Off.png"];
        else
            cell.imageView.image = [UIImage imageNamed:@"Light_On.png"];
    }

    return cell;
} 

- (void)tableView:(UITableView *)aTableView 
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( self.splitViewController == nil )
    {
        // iphone version
        if( ! [self.sCurType isEqualToString:@""] )
        {
            NSIndexPath *indexPath = [self.deviceTableView indexPathForSelectedRow];
                
            ISYDevice* curDevice = (ISYDevice*)[[self.brain getDeviceArrayForType:self.sCurType] objectAtIndex:[indexPath row]];
            
            [self performSegueWithIdentifier:@"LightDeviceDetails" sender:self];
        }
    }
    else
    {
        [self setSelectedDevice:indexPath];

    }
}

- (void)lightDetailsViewControllerClose:(LightDetailsViewController *)controller
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setSelectedDevice:(NSIndexPath *)indexPath
{
    LightDetailsViewController *lightDetailsViewController = [[self.splitViewController viewControllers] lastObject];
    
    if( lightDetailsViewController != nil )
    {
        lightDetailsViewController.delegate = self;
        
        ISYDevice* curDevice = (ISYDevice*)[[self.brain getArrayForType:self.eCurType] objectAtIndex:[indexPath row]];
        
        lightDetailsViewController.sCurDeviceName = curDevice.sName;
        lightDetailsViewController.sCurDeviceID   = curDevice.sID;
        
        [lightDetailsViewController refreshView];
        
        NSLog( @"Selection of %@", curDevice.sName );     
    }
}

- (void)tableReset
{
    //NSIndexPath *indexPath = [self.deviceTableView indexPathForSelectedRow];

    //if( [indexPath row] < 1 )
    //{
    //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection: 0];
    //
    //    [self.deviceTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone ];
    //    
    //    [self setSelectedDevice:indexPath];
    //}
}

- (void)toggleDevice:(NSString*)sID setOn:(BOOL)bOn
{
    NSURL* url;
    
    if( bOn )
    {
        NSLog(@"Setting Device %@ ON", sID );
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/%@/cmd/DFON", self.brain.sServerAddress, [sID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ] ];
    }
    else
    {
        NSLog(@"Setting Device %@ OFF", sID );
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/%@/cmd/DFOF", self.brain.sServerAddress, [sID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ] ];
    }
    
    [self.brain execCmd:url];
}

- (void)dimDevice:(NSString*)sID setDim:(int)iValue
{
    NSURL* url;
        
    NSLog(@"Setting Device %@ to DIM: %d", sID, iValue );
    url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/%@/cmd/DON/%d", 
                                         self.brain.sServerAddress, 
                                         [sID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                         iValue
                                         ] ];

    
    [self.brain execCmd:url];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.deviceTableView indexPathForSelectedRow];

	if ([segue.identifier isEqualToString:@"LightDeviceDetails"])
	{
		LightDetailsViewController *lightDetailsViewController = segue.destinationViewController;
		lightDetailsViewController.delegate = self;
                
        ISYDevice* curDevice = (ISYDevice*)[[self.brain getDeviceArrayForType:self.sCurType] objectAtIndex:[indexPath row]];
        
        lightDetailsViewController.sCurDeviceName = curDevice.sName;
        lightDetailsViewController.sCurDeviceID   = curDevice.sID;
        
        // clear selection
        [self.deviceTableView deselectRowAtIndexPath:[self.deviceTableView indexPathForSelectedRow] animated:NO];
        
        NSLog( @"Seg from %@", curDevice.sName );
	}
    else if( [segue.identifier isEqualToString:@"TypesToDevice"] )
    {
        ISYControllerDeviceViewController *deviceController = segue.destinationViewController;
        
        [deviceController setCurType:[[self.brain getAllDeviceTypes] objectAtIndex:[indexPath row]]];
        
        // clear selection
        [self.deviceTableView deselectRowAtIndexPath:[self.deviceTableView indexPathForSelectedRow] animated:NO];
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
            [self.deviceTableView reloadData];
            [self.refreshView setHidden:YES];
            [self tableReset];
        });
    });
}

- (IBAction)selectDevice:(id)sender
{

}

@end
