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
	return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	return [displayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Sets"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Sets"] autorelease];
    }
    cell.textLabel.text = [[displayList objectAtIndex:indexPath.row] setName];
    return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Set *tempSet = [Set setNamed:[[displayList objectAtIndex:indexPath.row] setName]];
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
	self.displayList = [Set setNameList];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

