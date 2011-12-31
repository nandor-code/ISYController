//
//  ISYControllerConfigViewController.m
//  ISYController2
//
//  Created by Nandor Szots on 12/24/11.
//  Copyright (c) 2011 Umbra LLC. All rights reserved.
//

#import "ISYControllerConfigViewController.h"
#import "SceneDetailsViewController.h"

@implementation ISYControllerConfigViewController
@synthesize hostName;
@synthesize userName;
@synthesize passWord;
@synthesize useSSLSwitch;

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
    
    [hostName setText:[[NSUserDefaults standardUserDefaults] stringForKey:@"Hostname"]];
    [userName setText:[[NSUserDefaults standardUserDefaults] stringForKey:@"Username"]];
    [passWord setText:[[NSUserDefaults standardUserDefaults] stringForKey:@"Password"]];
    useSSLSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"UseSSL"];

    SceneDetailsViewController *sceneDetailsViewController = [[self.splitViewController viewControllers] lastObject];
    
    if( sceneDetailsViewController != nil )
    {
        [sceneDetailsViewController showConfigPage];
    }
}


- (void)viewDidUnload
{
    [self setHostName:nil];
    [self setUserName:nil];
    [self setPassWord:nil];
    [self setUseSSLSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

-(IBAction)updated:(id)sender
{
    if (sender == passWord) 
    {
        [[NSUserDefaults standardUserDefaults] setValue:passWord.text forKey:@"Password"];
    }
    else if( sender == hostName )
    {
        [[NSUserDefaults standardUserDefaults] setValue:hostName.text forKey:@"Hostname"];
    }
    else if( sender == userName )
    {
        [[NSUserDefaults standardUserDefaults] setValue:userName.text forKey:@"Username"];
    }
    else if( sender == useSSLSwitch )
    {
        [[NSUserDefaults standardUserDefaults] setBool:useSSLSwitch.on forKey:@"UseSSL"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    if (textField == passWord) 
    {
        [textField resignFirstResponder];
    }
    else if( textField == hostName )
    {
        [userName becomeFirstResponder];
    }
    else if( textField == userName )
    {
        [passWord becomeFirstResponder];
    }
    
    return NO;
}

@end
