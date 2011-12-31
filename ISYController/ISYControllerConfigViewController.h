//
//  ISYControllerConfigViewController.h
//  ISYController
//
//  Created by Nandor Szots on 12/24/11.
//  Copyright (c) 2011 Umbra LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISYControllerConfigViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *hostName;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UISwitch *useSSLSwitch;

-(IBAction)updated:(id)sender;

@end
