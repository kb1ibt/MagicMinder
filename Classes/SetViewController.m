//  SetViewController.m
//  Magic Minder
//  Created by Shawn Stricker on 6/15/08.

#import "CardTableController.h"
#import "SetViewController.h"
#import "Set.h"
#import "Cycle.h"
#import "Magic_MinderAppDelegate.h"

@implementation SetViewController


- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		self.title = @"Sets";
	}
	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [blocks count];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	array = [[blocks objectAtIndex:section] sets];
	return [array count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[blocks objectAtIndex:section] blockName];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Sets"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Sets"] autorelease];
    }
    cell.textLabel.text = [[[[blocks objectAtIndex:indexPath.section] sets] objectAtIndex:indexPath.row] setName];
    return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Set *tempSet = [[[blocks objectAtIndex:indexPath.section] sets] objectAtIndex:indexPath.row];
	if([tempSet hasBeenReleased]){
	[tempSet hydrate];
	CardTableController *cardController = [[CardTableController alloc] init];
	cardController.holderOfSet = tempSet;
	[[self navigationController] pushViewController:cardController animated:YES];
	[cardController release];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dealloc {
	[super dealloc];
}

- (void)viewDidLoad {
	self.tableView.rowHeight = 30;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

