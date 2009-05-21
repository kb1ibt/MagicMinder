//  CardSpecialCell.h
//  Magic Minder
//  Created by Shawn Stricker on 6/23/08.

#import <UIKit/UIKit.h>



@interface CardSpecialCell : UITableViewCell {
	Card *cardHolder;
	UILabel *cardNameLabel;
	UILabel *cardNumberLabel;
	UILabel *cardInventories;
	UIImageView *imageView;
}

@property (nonatomic, retain) Card *cardHolder;
@property (nonatomic, assign) UILabel *cardNameLabel, *cardNumberLabel, *cardInventories;

- (UILabel *)newLabelForMainText:(BOOL)main;
@end
