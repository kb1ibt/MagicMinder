//  CardViewController.m
//  Magic Minder
//  Created by Shawn Stricker on 7/9/08.

#import "Magic_MinderAppDelegate.h"
#import "Card.h"
#import "Inventory.h"
#import "CardTextView.h"
#import "CardInventoryView.h"
#import "CardViewController.h"


@implementation CardViewController
@synthesize cardHolder;
@synthesize cardTextPage;
@synthesize cardInventoryPage;

- (id)init {
	if (self = [super init]) {
		cardHolder = nil;
		cardTextPage = nil;
		cardInventoryPage = nil;
		self.hidesBottomBarWhenPushed = YES;
	}
	return self;
}
- (void)loadInventoryView{
	CardInventoryView *localInventoryView = [[CardInventoryView alloc] initWithNibName:@"CardInventoryView" bundle:nil];
	self.cardInventoryPage = localInventoryView;
	cardInventoryPage.cardHolder = cardHolder;
	[localInventoryView release];
}
- (void)loadtextView{
	CardTextView *localTextView = [[CardTextView alloc] init];
	self.cardTextPage = localTextView;
	[localTextView release];
	cardTextPage.cardHolder = cardHolder;
}
- (void)loadSegmentController{
	NSArray *segmentTextContent = [NSArray arrayWithObjects:NSLocalizedString(@"Inventory", @""), NSLocalizedString(@"Text", @""),nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.frame = CGRectMake(0, 0, 400, 30);
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = segmentedControl;
	[segmentedControl release];
}
- (void)viewDidLoad {
	[self loadSegmentController];
	self.navigationItem.prompt = cardHolder.cardName;
	[self loadInventoryView];
	[cardInventoryPage viewWillAppear:NO];
	[self.view addSubview:[cardInventoryPage view]];
}

- (IBAction)segmentAction:(id)sender
{
	if(cardTextPage == nil){
		[self loadtextView];
	}
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:((segmentedControl.selectedSegmentIndex == 0) ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) forView:self.view cache:YES];

	if(segmentedControl.selectedSegmentIndex == 1){
		[cardTextPage viewWillAppear:YES];
		[cardInventoryPage viewWillDisappear:YES];
		[cardInventoryPage.view removeFromSuperview];
		[self.view addSubview:[cardTextPage tableView]];
		[cardInventoryPage viewDidDisappear:YES];
		[cardTextPage viewDidAppear:YES];
	}else{
		[cardInventoryPage viewWillAppear:YES];
		[cardTextPage viewWillDisappear:YES];
		[cardTextPage.tableView removeFromSuperview];
		[self.view addSubview:[cardInventoryPage view]];
		[cardTextPage viewDidDisappear:YES];
		[cardInventoryPage viewDidAppear:YES];
	}
	[UIView commitAnimations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)dealloc {
	[cardTextPage release];
	[cardInventoryPage release];
	[cardHolder release];
	[super dealloc];
}

@end
