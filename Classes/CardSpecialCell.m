//  CardSpecialCell.m
//  Magic Minder
//  Created by Shawn Stricker on 6/23/08.
#import "Magic_MinderAppDelegate.h"
#import "Card.h"
#import "Inventory.h"
#import "CardSpecialCell.h"
#import "SetViewController.h"


@implementation CardSpecialCell
@synthesize cardHolder;
@synthesize cardNameLabel, cardNumberLabel, cardInventories;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		UIView *myContentView = self.contentView;

		cardNameLabel = [self newLabelForMainText:YES];
		cardNameLabel.textAlignment = UITextAlignmentLeft;
		[myContentView addSubview:cardNameLabel];
		[cardNameLabel release];
		
		cardNumberLabel = [self newLabelForMainText:NO];
		cardNumberLabel.textAlignment = UITextAlignmentLeft;
		[myContentView addSubview:cardNumberLabel];
		[cardNumberLabel release];
		
		cardInventories = [self newLabelForMainText:NO];
		cardInventories.textAlignment = UITextAlignmentRight;
		[myContentView addSubview:cardInventories];
		[cardInventories release];
		
		imageView = [[UIImageView alloc] initWithImage:setRarityImage];
		[myContentView addSubview:imageView];
		[imageView release];
	}
	return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}


- (void)dealloc {
	[cardHolder release];
	[super dealloc];
}
- (UILabel *)newLabelForMainText:(BOOL)main {
	UIColor *primaryColor, *selectedColor;
	UIFont *font;
	if (main) {
		primaryColor = [UIColor blackColor];
		selectedColor = [UIColor whiteColor];
		font = [UIFont systemFontOfSize:16];
	} else {
		primaryColor = [UIColor darkGrayColor];
		selectedColor = [UIColor lightGrayColor];
		font = [UIFont systemFontOfSize:10];
	}		
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	newLabel.backgroundColor = [UIColor whiteColor];
	newLabel.opaque = YES;
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
	return newLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
	
	CGFloat boundsX = contentRect.origin.x;
	CGRect frame;
	frame = CGRectMake(boundsX + 5, 3, 25, 20);
	cardNumberLabel.frame = frame;
	frame = CGRectMake(boundsX + 30, 5, (self.contentView.bounds.size.width-80)-(boundsX+30), 20);
	cardNameLabel.frame = frame;
	frame = CGRectMake(self.contentView.bounds.size.width-80, 5, 50, 20);
	cardInventories.frame = frame;
	frame = [imageView frame];
	frame.origin.x = self.contentView.bounds.size.width-25;
	frame.origin.y = 5;
	imageView.frame = frame;
}

- (void)setCardHolder:(Card *)newCard {
	
	if (cardHolder != newCard) {
		[cardHolder release];
		cardHolder = [newCard retain];
	}
	cardNameLabel.text = cardHolder.cardName;
	NSString *string = [[NSString alloc] initWithFormat:@"%i / %i / %i", [cardHolder.inventory normalCards], [cardHolder.inventory foilCards], [cardHolder.inventory totalCards]];
	cardInventories.text = string;
	[string release];
	NSString *label=[[NSString alloc] initWithFormat:@"%i", (long) cardHolder.cardNumber];
	cardNumberLabel.text = label;
	[label release];
	imageView.image = cardHolder.rarityImage;
	CGRect frame;
	frame = [imageView frame];
	frame.size.height = cardHolder.rarityImage.size.height;
	frame.size.width = cardHolder.rarityImage.size.width;
	imageView.frame = frame;
}


@end
