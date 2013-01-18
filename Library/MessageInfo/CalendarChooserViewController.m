//
//  CalendarChooserViewController.m
//  e-Management
//
//  Created by 【羊】 on 2010/10/19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CalendarChooserViewController.h"
#import "CalendarTableViewCellController.h"
#import "SVProgressHUD.h"

@implementation CalendarChooserViewController
@synthesize currentSelection;
@synthesize delegate;

#pragma mark -
#pragma mark View lifecycle


- (id)initWithStyle:(UITableViewStyle)style {

	if (self = [super initWithStyle:style]) {		
		self.title = @"請選擇行事曆";
	}
	return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    calendars = [[NSMutableArray alloc] init];
    eventStore = [[EKEventStore alloc] init];
    currentSelection = nil;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
    {
        [SVProgressHUD showWithStatus:@"準備中"];
        [eventStore requestAccessToEntityType:EKEntityTypeEvent
                                   completion:^(BOOL granted, NSError *error) {
                                       if(granted && error == nil)
                                       {
                                           [SVProgressHUD dismiss];
                                           [self.tableView reloadData];
                                       }
                                       else
                                           [SVProgressHUD showErrorWithStatus:@"讀取行事曆失敗"];
                                   }];
    }
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[calendars removeAllObjects];
	
	for (EKCalendar *cal in eventStore.calendars) {
		if (cal.allowsContentModifications) {
			[calendars addObject:[cal retain]];
		}
	}
	[self.tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Navigation Bar Item Action

- (void)cancel {
	
	[delegate calendarChooserDidCancel];
}

- (void)done {
	
	[delegate calendarChooserDidFinishChooseWithCalendar:currentSelection];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [calendars count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"CalendarTableViewCell";
	
	CalendarTableViewCellController *cell 
		= (CalendarTableViewCellController *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
		NSArray *topLabelObjects = [[NSBundle mainBundle] loadNibNamed:@"CalendarTableViewCell"
																 owner:nil
															   options:nil];
		for (id currentObject in topLabelObjects) {
			if ([currentObject isKindOfClass:[UITableViewCell class]]) {
				cell = (CalendarTableViewCellController *)currentObject;
				break;
			}
		}
	}
    
    // Configure the cell...
	EKCalendar *calendar = (EKCalendar *)[calendars objectAtIndex:indexPath.row];
	
	cell.textLabel.text = calendar.title;
	cell.circleLabel.backgroundColor = [UIColor colorWithCGColor:[calendar CGColor]];
	
	if (nil != currentSelection && currentSelectionIndex == indexPath.row) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	currentSelection = (EKCalendar *)[calendars objectAtIndex:indexPath.row];
	currentSelectionIndex = indexPath.row;
	
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	
	[eventStore release];
	[calendars release];
    [super dealloc];
}


@end

