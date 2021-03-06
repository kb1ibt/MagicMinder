//  CardViewController.h
//  Magic Minder
//  Created by Shawn Stricker on 7/9/08.

#import <UIKit/UIKit.h>
@class Card;
@class CardTextView;
@class CardInventoryView;

@interface CardViewController : UIViewController {
	Card *cardHolder;
	CardTextView *cardTextPage;
	CardInventoryView *cardInventoryPage;
}
@property (nonatomic, retain) Card *cardHolder;
@property (nonatomic,retain) CardTextView *cardTextPage;
@property (nonatomic,retain) CardInventoryView *cardInventoryPage;

- (IBAction)segmentAction:(id)sender;
- (void)loadInventoryView;
- (void)loadtextView;
- (void)loadSegmentController;

@end
