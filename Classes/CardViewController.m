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
@synthesize cardHolder, frontViewIsVisible;
@synthesize cardTextPage;
@synthesize cardInventoryPage;

- (id)init {
	if (self = [super init]) {
		cardHolder = nil;
		cardTextPage = nil;
		cardInventoryPage = nil;
		frontViewIsVisible = NO;
		self.hidesBottomBarWhenPushed = YES;
	}
	return self;
}

- (void)loadView {
	[cardHolder hydrate];
	self.title = cardHolder.cardName;
	CardTextView *localTextView = [[CardTextView alloc] initWithStyle:UITableViewStylePlain];
	self.cardTextPage = localTextView;
	[localTextView release];
	CardInventoryView *localInventoryView = [[CardInventoryView alloc] init];
	self.cardInventoryPage = localInventoryView;
	[localInventoryView release];
	cardTextPage.cardHolder = cardHolder;
	cardInventoryPage.cardHolder = cardHolder;
	[self switchView];
}

-(void)switchView{
	if(frontViewIsVisible){
		[self setView:[cardTextPage tableView]];
		flipperButton = [[UIButton buttonWithType:UIButtonTypeDetailDisclosure] retain];
		flipperButton.frame = CGRectMake(0.0, 0.0, 25.0, 25.0);
		[flipperButton setTitle:@"Detail Disclosure" forState:UIControlStateNormal];
		flipperButton.backgroundColor = [UIColor clearColor];
		[flipperButton addTarget:self action:@selector(switchView) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *flipButtonBarItem;
		flipButtonBarItem=[[UIBarButtonItem alloc] initWithCustomView:flipperButton];
		[self.navigationItem setRightBarButtonItem:flipButtonBarItem animated:YES];
		[flipButtonBarItem release];
	}else{
		[self setView:[cardInventoryPage view]];
		flipperButton = [[UIButton buttonWithType:UIButtonTypeInfoLight] retain];
		flipperButton.frame = CGRectMake(0.0, 0.0, 25.0, 25.0);
		[flipperButton setTitle:@"Detail Disclosure" forState:UIControlStateNormal];
		flipperButton.backgroundColor = [UIColor clearColor];
		[flipperButton addTarget:self action:@selector(switchView) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *flipButtonBarItem;
		flipButtonBarItem=[[UIBarButtonItem alloc] initWithCustomView:flipperButton];
		[self.navigationItem setRightBarButtonItem:flipButtonBarItem animated:YES];
		[flipButtonBarItem release];
	}
	frontViewIsVisible = !frontViewIsVisible;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
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
