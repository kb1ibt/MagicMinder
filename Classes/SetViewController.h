//  SetViewController.h
//  Magic Minder
//  Created by Shawn Stricker on 6/15/08.

#import <UIKit/UIKit.h>
@class Set;

@interface SetViewController : UITableViewController {
	NSArray *displayList;
}
@property (nonatomic, retain) NSArray *displayList;
- (void)setUpDisplayList;

@end
