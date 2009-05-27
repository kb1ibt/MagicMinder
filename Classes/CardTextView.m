//  CardTextView.m
//  Magic Minder
//  Created by Shawn Stricker on 7/9/08.

#import "CardTextView.h"
#import "Card.h"

@implementation CardTextView
@synthesize cardHolder;

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
	}
	return self;
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *title;
	switch (section)
	{
		case 0:
		{
			title = @"Card Name";
			break;
		}
		case 1:
		{
			title = @"Type";
			break;
		}
		case 2:
		{
			title = @"Mana";
			break;
		}
		case 4:
		{
			title = @"Text";
			break;
		}
		case 3:
		{
			title = @"Power - Toughness";
			break;
		}
	}
	return title;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat result = 38.0f;
	switch (indexPath.section){
		case 4:
			result = [self calculateRowHeightForString:[cardHolder cardText] withFont:[UIFont systemFontOfSize:18.0f]];
			break;
		case 0:
			result = [self calculateRowHeightForString:[cardHolder cardName] withFont:[UIFont systemFontOfSize:18.0f]];
			break;
	}
	return result;
}
- (CGFloat)calculateRowHeightForString:(NSString *)holderString withFont:(UIFont *)font
{
	CGFloat		result = 44.0f;
	CGFloat		width = 0;
	CGFloat		tableViewWidth;
	CGRect		bounds = [[UIScreen mainScreen] bounds];
	
	if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
		tableViewWidth = bounds.size.width;
	else
		tableViewWidth = bounds.size.height;
	
	width = tableViewWidth - 110;		// fudge factor
		CGSize		textSize = { width, 20000.0f };		// width and height of text area
		CGSize		size = [holderString sizeWithFont:font constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
		
		size.height += 10.0f;			// top and bottom margin
		result = MAX(size.height, 38.0f);	// at least one row
	
	return result;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CardInfo"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"CardInfo"] autorelease];
	}
	switch (indexPath.section)
	{
		case 4:
		{
			cell.textLabel.text = [cardHolder cardText];
			cell.textLabel.numberOfLines=0;
			[cell.textLabel sizeToFit];
			break;
		}
		case 0:
		{
			cell.textLabel.text = [cardHolder cardName];
			cell.textLabel.numberOfLines=0;
			[cell.textLabel sizeToFit];
			break;
		}
		case 1:
		{
			cell.textLabel.text = [cardHolder cardType];
			break;
		}
		case 2:
		{
			cell.textLabel.text = [cardHolder mana];
			break;
		}
		case 3:
		{
			cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ - %@ ", [cardHolder power], [cardHolder toughness]];
			break;
		}
	}
	return cell;
}

- (void)dealloc {
	[cardHolder release];
	[super dealloc];
}


@end
