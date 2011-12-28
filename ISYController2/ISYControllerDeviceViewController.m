//
//  ISYControllerDeviceViewController.m
//  ISYController2
//
//  Created by Nandor Szots on 12/23/11.
//  Copyright (c) 2011 Umbra LLC. All rights reserved.
//

#import "ISYControllerDeviceViewController.h"
#import "dispatch/dispatch.h"

@implementation ISYControllerDeviceViewController

@synthesize delegate = _delegate;
@synthesize brain    = _brain;
@synthesize eCurType = _eCurType;
@synthesize deviceTableView = _deviceTableView;
@synthesize refreshButton = _refreshButton;
@synthesize refreshView = _refreshView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
        [self refreshDevices:nil];
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

- (void)sceneDetailsViewControllerClose:(SceneDetailsViewController *)controller
{
	[self dismissViewControllerAnimated:YES completion:nil];
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
	if ([segue.identifier isEqualToString:@"DeviceDetails"])
	{
		SceneDetailsViewController *sceneDetailsViewController = segue.destinationViewController;
		sceneDetailsViewController.delegate = self;
        
        NSIndexPath *indexPath = [self.deviceTableView indexPathForSelectedRow];
        
        ISYDevice* curDevice = (ISYDevice*)[[self.brain getArrayForType:self.eCurType] objectAtIndex:[indexPath row]];
        
        sceneDetailsViewController.sCurDeviceName = curDevice.sName;
        sceneDetailsViewController.sCurDeviceID   = curDevice.sID;
        
        // clear selection
        [self.deviceTableView deselectRowAtIndexPath:[self.deviceTableView indexPathForSelectedRow] animated:NO];
        
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
            [self.deviceTableView reloadData];
            [self.refreshView setHidden:YES];
        });
    });
}

@end
