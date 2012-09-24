//
//  MasterViewController.m
//  CoffeeShop
//
//  Created by Romy Ilano on 9/13/12.
//  Copyright (c) 2012 Snowyla. All rights reserved.
//
#import <RestKit/RestKit.h>
#import "Venue.h"

#import "MasterViewController.h"
#define kCLIENTID "WK0K22EAUNOXAKH0RAQDS0F5G23NR43JQQOLR35R2F0GRAFU"
#define kCLIENTSECRET "SRVNOFRVKGNZNRC23YFCUVCM1WOLX2FQJITRC5GM0UB2CGAR"

// #import "DetailViewController.h"

@interface MasterViewController () {
  
}

@property (strong, nonatomic) NSArray *data;

@end

@implementation MasterViewController
@synthesize data;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    // RestKit
    // define base URL for Foursquare's API
    RKURL *baseURL = [RKURL URLWithBaseURLString:@"https://api.Foursquare.com/v2"];
    
    // RKObjectManager is primary interface for interacting with RESTful services via HTTP
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:baseURL];
    objectManager.client.baseURL = baseURL;
    
    // RKObjectMapping class used to define mapping between JSON data & your data model class
    RKObjectMapping *venueMapping = [RKObjectMapping mappingForClass:[Venue class]];
    // mapKeyPathsToAttributes: maps JSON fields to your data model's attributes
    [venueMapping mapKeyPathsToAttributes:@"name", @"name", nil];
    // it's name in JSON, then name in our class
    
    [objectManager.mappingProvider setMapping:venueMapping forKeyPath:@"response.venues"];
    
    
    // RKObjectMapping *locationMapping
    RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[Location class]];
    [locationMapping mapKeyPathsToAttributes:@"address", @"address", @"city", @"city", @"country", @"country", @"crossStreet", @"crossStreet", @"postalCode", @"postalCode", @"state", @"state", @"distance", @"distance", @"lat", @"lat", @"lng", @"lng", nil];
    
    // withMapping: informs the venueMapping instance of the location property
    [venueMapping mapRelationship:@"location" withMapping:locationMapping];
    // setMapping: tells objectManager to use locationMapping for location key in JSON data
    [objectManager.mappingProvider setMapping:locationMapping forKeyPath:@"location"];
    
    [self sendRequest];
    
    
}

// sendRequest: retrieves data for tableView
- (void)sendRequest
{
    NSString *latLon = @"37.33,-122.03";
    NSString *clientID = [NSString stringWithUTF8String:kCLIENTID];
    NSString *clientSecret = [NSString stringWithUTF8String:kCLIENTSECRET];
    
    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:latLon, @"ll", clientID, @"client_id", clientSecret, @"client_secret", @"coffee", @"query", @"20120602", @"v", nil];
    
    //
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    RKURL *URL = [RKURL URLWithBaseURL:[objectManager baseURL] resourcePath:@"/venues/search" queryParameters:queryParams];
    [objectManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?%@", [URL resourcePath], [URL query]] delegate:self];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

/* removing insertNewObject: for purposes of the tutorial
- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
 */

#pragma mark -
#pragma mark RKObjectLoaderDelegate methods
// objectLoader:didFailWithError: <--required method
-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error localizedDescription]);
}
// request:didLoadResponse: <-- need this to retrieve request data -
//      here it returns an array of Venue objects based on the object mapping requested in viewDidLoad:
-(void)request:(RKRequest *)request didLoadResponse:(RKResponse*)response {
    NSLog(@"response code: %d", [response statusCode]);
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSLog(@"objects[%d]", [objects count]);
    data = objects;
    
    [self.tableView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return _objects.count;
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    /*
    // NSDate *object = [_objects objectAtIndex:indexPath.row];
    // cell.textLabel.text = [object description];
    
     // v1 - just lists the coffeeshops, no details
     Venue *venue = [data objectAtIndex:indexPath.row];
    cell.textLabel.text = [venue name];
       */
    
    Venue *venue = [data objectAtIndex:indexPath.row];
    cell.textLabel.text = [venue.name length] > 24 ? [venue.name substringToIndex:24] : venue.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0fm", [venue.location.distance floatValue]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
/* removing for tutorial
 // tableView:commitEditingStyle:
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

 */
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = [_objects objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}
 */

@end
