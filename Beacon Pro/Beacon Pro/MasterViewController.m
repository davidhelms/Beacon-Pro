//
//  MasterViewController.m
//  Beacon Pro
//
//  Created by David Helms on 6/21/15.
//  Copyright (c) 2015 Dojbol LLC. All rights reserved.
//

#define RadiusTest 1
//#define DummyDataTest 1

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "BeaconTableViewSectionHeader.h"
#import "BeaconTableViewCell.h"
#import "BeaconSighting.h"
#import "Settings.h"


@interface MasterViewController ()
@property (strong, nonatomic) CLLocationManager *lm;
@property (strong, nonatomic) NSMutableArray *regions;
@property (strong, nonatomic) __block NSMutableArray *beaconSightings;@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"regionDataKey" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    
    [self startRangingRegions];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    NSLog(@"Defaults changed, %@.%@", object, keyPath);
    
    if ((object == [NSUserDefaults standardUserDefaults]) && [keyPath isEqualToString:@"regionDataKey" ]) {
        NSLog(@"regionDataKey changed in defaults");
        [self stopRangingRegions];
        [self startRangingRegions];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)insertNewObject:(id)sender {
    if (!self.beaconSightings) {
        self.beaconSightings = [[NSMutableArray alloc] init];
    }
    [self.beaconSightings insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
 */

-(NSArray *)loadRegionsFromUserDefaults
{
    // get regions from nsuserdefaults
    NSData *regionData = [[NSUserDefaults standardUserDefaults] objectForKey:@"regionDataKey"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:regionData];
}

-(void)startRangingRegions
{
    // check if ranging available on this hardware
    if ([CLLocationManager isRangingAvailable])
    {
        NSLog(@"yes available");
        //create location manager
        self.lm = [[CLLocationManager alloc]init];
        self.lm.delegate = self;
        
        Settings *settings = [[Settings alloc]init];
        self.regions = [NSMutableArray arrayWithArray:settings.beaconRegions];
        
        // request when in use authorization for ranging
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusRestricted:
                return;
            case kCLAuthorizationStatusDenied:
                return;
            case kCLAuthorizationStatusNotDetermined:
                [self.lm requestWhenInUseAuthorization];
                NSLog(@"requested auth");
                break;
            default:
                break;
        }
        
        self.beaconSightings = [NSMutableArray arrayWithCapacity:1];
        [self.regions enumerateObjectsUsingBlock:^(CLBeaconRegion *region, NSUInteger idx, BOOL *stop) {
            NSArray *emptyArray = [[NSArray alloc]init];
            [self.beaconSightings addObject:emptyArray];
            [self.lm startRangingBeaconsInRegion:region];
        }];
    }
}

-(void)stopRangingRegions
{
    [self.regions enumerateObjectsUsingBlock:^(CLBeaconRegion *region, NSUInteger idx, BOOL *stop) {
        [self.lm stopRangingBeaconsInRegion:region];
    }];
    self.lm = nil;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.beaconSightings[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.regions count];
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 85.0F;
}
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.beaconSightings.count)
    {
        NSArray *sightings = [self.beaconSightings objectAtIndex:section];
        return sightings.count;
    }
    else
    {
        return 0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    BeaconTableViewSectionHeader *cell = [tableView dequeueReusableCellWithIdentifier:@"SightingHeader"];
    
    if (section < self.regions.count)
    {
        CLBeaconRegion *region = (CLBeaconRegion *)self.regions[section];
        cell.labelName.text = region.identifier;
        cell.labelUUID.text = region.proximityUUID.UUIDString;
        return cell;
    }
    return nil;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BeaconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SightingCell" forIndexPath:indexPath];
    
    if (indexPath.section < self.beaconSightings.count)
    {
        NSArray *sightings = [self.beaconSightings objectAtIndex:indexPath.section];
    
        NSLog(@"section %ld sightings %@\n", (long)indexPath.section, sightings);
        
        if (indexPath.row < sightings.count)
        {
            BeaconSighting *sighting = [sightings objectAtIndex:indexPath.row];
            cell.labelMajor.text = sighting.major;
            cell.labelMinor.text = sighting.minor;
            cell.labelRSSI.text = sighting.rssi;
        }
    
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.beaconSightings removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
 */

#pragma mark - Location Manager

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    
    
    NSLog(@"locationManager %@ didRangeBeacons %@ inRegion %@\n", manager, beacons, region);
    
    // if region is currently displayed in table view, then update table view
    NSUInteger regionIndex = [self.regions indexOfObject:region];
    if (regionIndex != NSNotFound)
    {
        
        
        // create section index set
        NSIndexSet *sectionIndexSet = [NSIndexSet indexSetWithIndex:regionIndex];
        
        // if there are current sightings then remove this region from displayed regions
        NSArray *currentSightings = [self.beaconSightings objectAtIndex:regionIndex];
        if ((beacons.count <= 0) && (currentSightings.count <=0))
        {
            [self.regions removeObjectAtIndex:regionIndex];
            [self.tableView deleteSections:sectionIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];

            return;
        }
        
        // assemble unsorted sightings array
        __block NSMutableArray *unsortedSightings = [NSMutableArray arrayWithCapacity:beacons.count];
        [beacons enumerateObjectsUsingBlock:^(CLBeacon *theBeacon, NSUInteger idx, BOOL *stop)
         {
             BeaconSighting *sighting = [[BeaconSighting alloc]initWithBeacon:theBeacon];
             [unsortedSightings addObject: sighting];
         }];
        
        NSLog(@"unsortedSightings %@\n", unsortedSightings);
        
        // derive sorted sightings array
        NSSortDescriptor *minorSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"minor" ascending:YES selector:@selector(localizedStandardCompare:)];
        NSSortDescriptor *majorSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"major" ascending:YES selector:@selector(localizedStandardCompare:)];
        NSArray *sortedSightings = [unsortedSightings sortedArrayUsingDescriptors:@[minorSortDescriptor, majorSortDescriptor]];
        
        NSLog(@"sortedSightings %@\n", sortedSightings);
        
        // update sightings array & reload table data
        NSLog(@"beacons.count %ld", beacons.count);
        NSLog(@"currentSightings.count %ld", currentSightings.count);
        NSLog(@"newSightings.count %ld", self.beaconSightings.count);
        [self.beaconSightings replaceObjectAtIndex:regionIndex withObject:sortedSightings];
        [self.tableView reloadSections:sectionIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        //[self.tableView reloadData];
        
    }
    // if region is not in table view but had ranged beacons,
    // add the region to the table view
    else if (beacons.count > 0)
    {
        [self.regions addObject:region];
        NSUInteger regionIndex = [self.regions indexOfObject:region];
        if (regionIndex != NSNotFound)
        {
            // create section index set
            NSIndexSet *sectionIndexSet = [NSIndexSet indexSetWithIndex:regionIndex];
            [self.tableView insertSections:sectionIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    
}

- (void)locationManager:(CLLocationManager *)manager
rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error
{
    NSLog(@"locationManager %@ rangingBeaconsDidFailForRegion %@ withError %@", manager, region, error);
}


- (IBAction)composeEmail:(id)sender
{
    NSLog(@"Compose Email");
    
    if ([MFMailComposeViewController canSendMail])
    {
        // prep formatted date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd HH:mm"];

        // Email Subject
        NSString *emailTitle = [NSString stringWithFormat:@"Beacon Sightings Report %@\n", [dateFormatter stringFromDate:[NSDate date]]];
        
        // Email Content
        __block NSMutableString *messageBody = [NSMutableString stringWithString:emailTitle];
        
        
        
        [self.beaconSightings enumerateObjectsUsingBlock:^(NSArray *sightings, NSUInteger idx, BOOL *stop)
        {
                CLBeaconRegion *region = (CLBeaconRegion *)self.regions[idx];
                [messageBody appendFormat:@"\n\n%@\n", region.identifier];
                [messageBody appendFormat:@"%@\n", region.proximityUUID.UUIDString];
                [messageBody appendFormat:@"%ld Beacons\n", (unsigned long)sightings.count];
                
                [sightings enumerateObjectsUsingBlock:^(BeaconSighting *sighting, NSUInteger idx, BOOL *stop)
                 {
                     NSInteger beaconID = idx + 1;
                     [messageBody appendFormat:@"\n     Beacon #%ld\n", (long)beaconID];
                     [messageBody appendFormat:@"          UUID %@\n", region.proximityUUID.UUIDString];
                     [messageBody appendFormat:@"          Major %@\n", sighting.minor];
                     [messageBody appendFormat:@"          Minor %@\n", sighting.major];
                     [messageBody appendFormat:@"          RSSI %@\n", sighting.rssi];
                     [messageBody appendFormat:@"          Distance %@\n", sighting.distance];
                     [messageBody appendFormat:@"          Proximity %@\n", sighting.proximity];
                     
                 }];
        }];
        

        // To address
        //NSArray *toRecipents = [NSArray arrayWithObject:@"help@wendys.com"];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        //[mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }
}

- (IBAction)viewHelp:(id)sender
{
    NSLog(@"View Help");
}

#pragma mark - Mail Compose

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
