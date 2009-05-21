//  CardTableController.m
//  Magic Minder
//  Created by Shawn Stricker on 7/20/08.

#import "Card.h"
#import "Set.h"
#import "CardTableController.h"
#import "Magic_MinderAppDelegate.h"
#import "CardSpecialCell.h"
#import "CardViewController.h"


@implementation CardTableController
@synthesize holderOfSet;

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		self.title = @"Set Name";
	}
	return self;
}

- (Card *)cardForIndexPath:(NSIndexPath *)indexPath {
	return [[holderOfSet cards] objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	CardSpecialCell *cell = (CardSpecialCell *)[tableView dequeueReusableCellWithIdentifier:@"CardSpecialCell"];
	if (cell == nil) {
		cell = [[[CardSpecialCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"CardSpecialCell"] autorelease];
	}
	cell.cardHolder = [self cardForIndexPath:indexPath];
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[holderOfSet cards]count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Card *tempCard = [self cardForIndexPath:indexPath];
	CardViewController *cardController = [[CardViewController alloc] init];
	cardController.cardHolder = tempCard;
	[[self navigationController] pushViewController:cardController animated:YES];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[cardController release];
}

- (void)dealloc {
	[super dealloc];
}

- (void)viewDidLoad {
	self.tableView.rowHeight = 30;
	self.title = holderOfSet.setName;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

