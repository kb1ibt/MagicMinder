//  CardInventoryPage.h
//  Magic Minder
//  Created by Shawn Stricker on 7/12/08.

#import <UIKit/UIKit.h>

@class Card;

@interface CardInventoryView : UIViewController{
	Card *cardHolder;
	IBOutlet UILabel *labelTotalCards;
	IBOutlet UITextField *labelNormalCards;
	IBOutlet UITextField *labelFoilCards;
}
@property (nonatomic, retain) Card *cardHolder;
@property (nonatomic, retain) UILabel *labelTotalCards;
@property (nonatomic, retain) UITextField *labelNormalCards;
@property (nonatomic, retain) UITextField *labelFoilCards;
-(IBAction)incrementNormal;
-(IBAction)incrementFoil;
-(IBAction)decrementNormal;
-(IBAction)decrementFoil;

@end
