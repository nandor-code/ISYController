//
//  ISYControllerDeviceViewController.m
//  ISYController
//
//  Created by Nandor Szots on 12/23/11.
//  Copyright (c) 2011 Umbra LLC. All rights reserved.
//

#import "ISYControllerDeviceViewController.h"
#import "dispatch/dispatch.h"

@interface ISYControllerDeviceViewController()

@property (nonatomic) BOOL bHaveValidData;

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
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ISYDeviceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    if( [self.sCurType isEqualToString:@""] )
    {
        // device types
        cell.textLabel.text = [[self.brain getAllDeviceTypes] objectAtIndex:[indexPath row]];
    }
    else
    {
        // devices.
        
        // Configure the cell.
        ISYDevice* curDevice = (ISYDevice*)[[self.brain getDeviceArrayForType:self.sCurType] objectAtIndex:[indexPath row]];
        
        cell.textLabel.text = curDevice.sName;
    }

    return cell;
} 

- (void)tableView:(UITableView *)aTableView 
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setSelectedDevice:indexPath];
}

- (void)sceneDetailsViewControllerClose:(SceneDetailsViewController *)controller
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setSelectedDevice:(NSIndexPath *)indexPath
{
    SceneDetailsViewController *sceneDetailsViewController = [[self.splitViewController viewControllers] lastObject];
    
    if( sceneDetailsViewController != nil )
    {
        sceneDetailsViewController.delegate = self;
        
        ISYDevice* curDevice = (ISYDevice*)[[self.brain getArrayForType:self.eCurType] objectAtIndex:[indexPath row]];
        
        sceneDetailsViewController.sCurDeviceName = curDevice.sName;
        sceneDetailsViewController.sCurDeviceID   = curDevice.sID;
        
        [sceneDetailsViewController refreshView];
        
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

	if ([segue.identifier isEqualToString:@"DeviceDetails"])
	{
		SceneDetailsViewController *sceneDetailsViewController = segue.destinationViewController;
		sceneDetailsViewController.delegate = self;
                
        ISYDevice* curDevice = (ISYDevice*)[[self.brain getArrayForType:self.eCurType] objectAtIndex:[indexPath row]];
        
        sceneDetailsViewController.sCurDeviceName = curDevice.sName;
        sceneDetailsViewController.sCurDeviceID   = curDevice.sID;
        
        // clear selection
        [self.deviceTableView deselectRowAtIndexPath:[self.deviceTableView indexPathForSelectedRow] animated:NO];
        
        NSLog( @"Seg from %@", curDevice.sName );
	}
    else if( [segue.identifier isEqualToString:@"TypesToDevice"] )
    {
        ISYControllerDeviceViewController *deviceController = segue.destinationViewController;
        
        [deviceController setCurType:[[self.brain getAllDeviceTypes] objectAtIndex:[indexPath row]]];
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
