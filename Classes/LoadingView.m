//
//  LoadingView.m
//  Magic Minder
//
//  Created by Shawn Stricker on 6/5/09.
//

#import "LoadingView.h"
#import "Magic_MinderAppDelegate.h"


@implementation LoadingView
@synthesize labelSet,labelBlock,labelCard,progressSets,progressBlocks,progressCards;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	[labelSet release];
	[labelBlock release];
	[labelCard release];
	[progressSets release];
	[progressCards release];
	[progressBlocks release];
    [super dealloc];
}


@end
