//  Magic_MinderAppDelegate.h
//  Magic Minder
//  Created by Shawn Stricker on 5/14/08.

#import <UIKit/UIKit.h>
#import <sqlite3.h>

extern UIImage *setRarityImage;
extern sqlite3 *dictionary;
extern sqlite3 *inventory;
extern NSMutableDictionary *sets;

@class Card, SetViewController, Set, Inventory;

@interface Magic_MinderAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet UITabBarController *tabBarController;
}

@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) UIWindow *window;

@end

