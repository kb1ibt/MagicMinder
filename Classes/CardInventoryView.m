//  CardInventoryPage.m
//  Magic Minder
//  Created by Shawn Stricker on 7/12/08.

#import "CardInventoryView.h"
#import "Card.h"
#import "Inventory.h"

@implementation CardInventoryView
@synthesize cardHolder,labelTotalCards,labelNormalCards,labelFoilCards;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	}
	return self;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
- (void)viewWillAppear:(BOOL)animated
{	
	labelFoilCards.text = [[NSString alloc] initWithFormat:@"%i", [cardHolder.inventory foilCards]];
	labelTotalCards.text = [[NSString alloc] initWithFormat:@"%i", [cardHolder.inventory totalCards]];
	labelNormalCards.text = [[NSString alloc] initWithFormat:@"%i", [cardHolder.inventory normalCards]];
}
-(IBAction)incrementNormal{
	[[cardHolder inventory] incrementNormal];
	labelNormalCards.text = [[NSString alloc] initWithFormat:@"%i", [cardHolder.inventory normalCards]];
	labelTotalCards.text = [[NSString alloc] initWithFormat:@"%i", [cardHolder.inventory totalCards]];
}
-(IBAction)incrementFoil{
	[[cardHolder inventory] incrementFoil];
	labelFoilCards.text = [[NSString alloc] initWithFormat:@"%i", [cardHolder.inventory foilCards]];
	labelTotalCards.text = [[NSString alloc] initWithFormat:@"%i", [cardHolder.inventory totalCards]];
}
-(IBAction)decrementNormal{
	[[cardHolder inventory] decrementNormal];
	labelNormalCards.text = [[NSString alloc] initWithFormat:@"%i", [cardHolder.inventory normalCards]];
	labelTotalCards.text = [[NSString alloc] initWithFormat:@"%i", [cardHolder.inventory totalCards]];
}
-(IBAction)decrementFoil{
	[[cardHolder inventory] decrementFoil];
	labelFoilCards.text = [[NSString alloc] initWithFormat:@"%i", [cardHolder.inventory foilCards]];
	labelTotalCards.text = [[NSString alloc] initWithFormat:@"%i", [cardHolder.inventory totalCards]];
}
@end
