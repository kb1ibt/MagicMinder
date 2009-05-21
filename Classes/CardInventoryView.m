//  CardInventoryPage.m
//  Magic Minder
//  Created by Shawn Stricker on 7/12/08.

#import "CardInventoryView.h"
#import "Card.h"
#import "Inventory.h"

@implementation CardInventoryView
@synthesize cardHolder,labelTotalCards,labelNormalCards,labelFoilCards;

#define kLeftMargin				20.0
#define kTopMargin				20.0
#define kRightMargin			20.0
#define kBottomMargin			20.0
#define kTweenMargin			10.0
#define kLabelHeight			20.0
#define kTextFieldHeight		25.0

- (id)init
{
	self = [super init];
	return self;
}

+ (UILabel *)labelWithFrame:(CGRect)frame title:(NSString *)title
{
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    
	label.textAlignment = UITextAlignmentLeft;
    label.text = title;
    label.font = [UIFont boldSystemFontOfSize:17.0];
    label.textColor = [UIColor colorWithRed:76.0/255.0 green:86.0/255.0 blue:108.0/255.0 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

+ (UITextField *)textFieldWithFrame:(CGRect)frame text:(NSString *)text
{
	UITextField *textField = [[[UITextField alloc] initWithFrame:frame] autorelease];
	textField.textAlignment = UITextAlignmentCenter;
	textField.text = text;
	textField.userInteractionEnabled = NO;
	textField.borderStyle = UITextBorderStyleBezel;
	textField.backgroundColor = [UIColor whiteColor];
	return textField;
}
-(void)createView{
	CGFloat yPlacement = kTopMargin;
	CGRect frame = CGRectMake(kLeftMargin, yPlacement, (self.view.bounds.size.width - (kRightMargin * 2.0)) / 2, kLabelHeight);
	//
	//Total Cards
	//
	[self.view addSubview:[CardInventoryView labelWithFrame:frame title:@"Total Cards:"]];
	frame = CGRectMake(self.view.bounds.size.width / 2, yPlacement, (self.view.bounds.size.width - (kRightMargin * 2.0)) / 2, kLabelHeight);
	UILabel *tempTotal = [CardInventoryView labelWithFrame:frame title:[[NSString alloc] initWithFormat:@"%i", [cardHolder.inventory totalCards]]];
	[self.view addSubview:tempTotal];
	self.labelTotalCards = tempTotal;
	[tempTotal release];

	//
	//Normal Cards
	//
	yPlacement += kLabelHeight+(kTweenMargin*2);
	frame = CGRectMake(	kLeftMargin, yPlacement, self.view.bounds.size.width - (kRightMargin * 2.0), kLabelHeight);
	[self.view addSubview:[CardInventoryView labelWithFrame:frame title:@"Normal Cards:"]];
	yPlacement += kLabelHeight+kTweenMargin;
	frame = CGRectMake(50.0 + kRightMargin, yPlacement,(self.view.bounds.size.width-100) - (kRightMargin * 2.0), kTextFieldHeight);
	UITextField *tempNormal = [CardInventoryView textFieldWithFrame:frame text:[[NSString alloc] initWithFormat:@"%i", [cardHolder.inventory normalCards]]];
	[self.view addSubview:tempNormal];
	self.labelNormalCards = tempNormal;
	[tempNormal release];
	UIButton *decrNormButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	[decrNormButton setBackgroundImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateNormal];
	decrNormButton.frame = CGRectMake(kRightMargin, yPlacement, 25.0, 25.0);
	decrNormButton.backgroundColor = [UIColor clearColor];
	[decrNormButton addTarget:self action:@selector(decrementNormal) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:decrNormButton];
	UIButton *incrNormButton = [[UIButton buttonWithType:UIButtonTypeContactAdd] retain];
	incrNormButton.frame = CGRectMake((self.view.bounds.size.width-kRightMargin)-(25.0), yPlacement, 25.0, 25.0);
	incrNormButton.backgroundColor = [UIColor clearColor];
	[incrNormButton addTarget:self action:@selector(incrementNormal) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:incrNormButton];

	//
	//Foil Cards
	//
	yPlacement += kTextFieldHeight+(kTweenMargin*2);
	frame = CGRectMake(kLeftMargin, yPlacement, (self.view.bounds.size.width - (kRightMargin * 2.0)) / 2, kLabelHeight);
	[self.view addSubview:[CardInventoryView labelWithFrame:frame title:@"Foil Cards:"]];
	yPlacement += kLabelHeight+kTweenMargin;
	frame = CGRectMake(50.0 + kRightMargin, yPlacement,(self.view.bounds.size.width-100) - (kRightMargin * 2.0), kTextFieldHeight);
	UITextField *tempFoil = [CardInventoryView textFieldWithFrame:frame text:[[NSString alloc] initWithFormat:@"%i", [cardHolder.inventory foilCards]]];
	[self.view addSubview:tempFoil];
	self.labelFoilCards = tempFoil;
	[tempFoil release];

	UIButton *decrFoilButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	decrFoilButton.frame = CGRectMake(kRightMargin, yPlacement, 25.0, 25.0);
	[decrFoilButton setBackgroundImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateNormal];
	decrFoilButton.backgroundColor = [UIColor clearColor];
	[decrFoilButton addTarget:self action:@selector(decrementFoil) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:decrFoilButton];
	UIButton *incrFoilButton = [[UIButton buttonWithType:UIButtonTypeContactAdd] retain];
	incrFoilButton.frame = CGRectMake((self.view.bounds.size.width-kRightMargin)-(25.0), yPlacement, 25.0, 25.0);
	incrFoilButton.backgroundColor = [UIColor clearColor];
	[incrFoilButton addTarget:self action:@selector(incrementFoil) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:incrFoilButton];
	
}

- (void)loadView
{	
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	[contentView setAutoresizesSubviews:YES];
	[contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	[self setView:contentView];
	[contentView release];
	
	[self createView];
}
-(void)incrementNormal{
	[[cardHolder inventory] incrementNormal];
	labelNormalCards.text = [[NSString alloc] initWithFormat:@"%i", [cardHolder.inventory normalCards]];
	labelTotalCards.text = [[NSString alloc] initWithFormat:@"%i", [cardHolder.inventory totalCards]];
}
-(void)incrementFoil{
	[[cardHolder inventory] incrementFoil];
	labelFoilCards.text = [[NSString alloc] initWithFormat:@"%i", [cardHolder.inventory foilCards]];
	labelTotalCards.text = [[NSString alloc] initWithFormat:@"%i", [cardHolder.inventory totalCards]];
}
-(void)decrementNormal{
	[[cardHolder inventory] decrementNormal];
	labelNormalCards.text = [[NSString alloc] initWithFormat:@"%i", [cardHolder.inventory normalCards]];
	labelTotalCards.text = [[NSString alloc] initWithFormat:@"%i", [cardHolder.inventory totalCards]];
}
-(void)decrementFoil{
	[[cardHolder inventory] decrementFoil];
	labelFoilCards.text = [[NSString alloc] initWithFormat:@"%i", [cardHolder.inventory foilCards]];
	labelTotalCards.text = [[NSString alloc] initWithFormat:@"%i", [cardHolder.inventory totalCards]];
}

@end
