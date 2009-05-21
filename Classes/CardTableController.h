//  CardTableController.h
//  Magic Minder
//  Created by Shawn Stricker on 7/20/08.

#import <UIKit/UIKit.h>
@class Set, Card;

@interface CardTableController : UITableViewController {
	Set *holderOfSet;
}
@property (nonatomic, retain) Set *holderOfSet;

- (Card *)cardForIndexPath:(NSIndexPath *)indexPath;

@end
