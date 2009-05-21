//  CardTextView.h
//  Magic Minder
//  Created by Shawn Stricker on 7/9/08.

#import <UIKit/UIKit.h>

@class Card;

@interface CardTextView : UITableViewController {
	Card *cardHolder;
}
@property (nonatomic, retain) Card *cardHolder;

@end
