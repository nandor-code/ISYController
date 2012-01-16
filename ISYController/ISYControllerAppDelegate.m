//
//  ISYControllerAppDelegate.m
//  ISYController
//
//  Created by Nandor Szots on 12/23/11.
//  Copyright (c) 2011 Umbra LLC. All rights reserved.
//

#import "ISYControllerAppDelegate.h"
#import "ISYServiceExample.h"

@implementation ISYControllerAppDelegate

@synthesize window = _window;
@synthesize brain  = _brain;
@synthesize tabBar = _tabBar;

- (ISYBrain*)brain
{
    if( _brain == nil )
    {
        _brain = [[ISYBrain alloc] init];
    }
    
    return _brain;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSDictionary *appDefaults = [NSDictionary
                                 dictionaryWithObjects:
                                    [NSArray arrayWithObjects:
                                        [NSString stringWithString:@""],
                                        [NSString stringWithString:@"admin"],
                                        [NSString stringWithString:@""],
                                        nil ] 
                                 forKeys:
                                    [NSArray arrayWithObjects:
                                        [NSString stringWithString:@"Hostname"],
                                        [NSString stringWithString:@"Username"],
                                        [NSString stringWithString:@"Password"],
                                        nil ] ];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
    if ( [self.window.rootViewController isKindOfClass:[UITabBarController class]] ) 
    {
        self.tabBar = (UITabBarController*)self.window.rootViewController;
    }
    
    ISYServiceExample* example1 = [[ISYServiceExample alloc] init];
    [example1 run];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (NSMutableArray*)getScenes
{
    return [self.brain getArrayForType:ID_SCENE];
}

- (NSMutableArray*)getDevices
{
    return [self.brain getArrayForType:ID_DEVICE];
}

- (void)refreshBrain
{ 
    [self.brain setBaseURL:[[NSUserDefaults standardUserDefaults] stringForKey:@"Hostname"]
                  userName:[[NSUserDefaults standardUserDefaults] stringForKey:@"Username"]
                  passWord:[[NSUserDefaults standardUserDefaults] stringForKey:@"Password"]
                  useSSL:[[NSUserDefaults standardUserDefaults] boolForKey:@"UseSSL"]];
    
    NSString* ret = [self.brain getData:[[NSURL alloc] initWithString:self.brain.sServerAddress]];
    
    if( [ret isEqualToString:@"ERROR"] )
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"There was an error getting data from your ISY.  Please make sure your configuration is correct." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
    }
    
    NSLog( @"Ret = %@", ret );
}

@end
