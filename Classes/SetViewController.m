//  SetViewController.m
//  Magic Minder
//  Created by Shawn Stricker on 6/15/08.

#import "CardTableController.h"
#import "SetViewController.h"
#import "Set.h"
#import "Magic_MinderAppDelegate.h"

@implementation SetViewController
@synthesize displayList;


- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		self.title = @"Sets";
	}
	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [displayList count];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	array = [[displayList objectAtIndex:section] sets];
	return [array count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[displayList objectAtIndex:section] blockName];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Sets"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Sets"] autorelease];
    }
    cell.textLabel.text = [[[[displayList objectAtIndex:indexPath.section] sets] objectAtIndex:indexPath.row] setName];
    return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Set *tempSet = [[[displayList objectAtIndex:indexPath.section] sets] objectAtIndex:indexPath.row];
	[tempSet hydrate];
	CardTableController *cardController = [[CardTableController alloc] init];
	cardController.holderOfSet = tempSet;
	[[self navigationController] pushViewController:cardController animated:YES];
	[cardController release];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dealloc {
	[displayList release];
	[super dealloc];
}

- (void)viewDidLoad {
	[self setUpDisplayList];
	self.tableView.rowHeight = 30;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}
- (void)setUpDisplayList {
	self.displayList = [blocks allValues];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

