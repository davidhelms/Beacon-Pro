//
//  MasterViewController.h
//  Beacon Pro
//
//  Created by David Helms on 6/21/15.
//  Copyright (c) 2015 Dojbol LLC. All rights reserved.
//

@import UIKit;
@import CoreLocation;
@import MessageUI;

@class DetailViewController;

@interface MasterViewController : UITableViewController <CLLocationManagerDelegate, MFMailComposeViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

- (IBAction)composeEmail:(id)sender;
- (IBAction)viewHelp:(id)sender;


@end

