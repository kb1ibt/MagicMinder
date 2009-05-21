//  Card.h
//  Magic Minder
//  Created by Shawn Stricker on 6/7/08.

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@class Inventory;

@interface Card : NSObject {
    NSInteger cardID;
	NSString *cardName;
    NSString *cardText;
    NSString *rarity;
	NSString *mana;
	NSString *cardType;
	NSString *power;
	NSString *toughness;
	NSInteger cardNumber;
	UIImage *rarityImage;
	Inventory *inventory;
    BOOL hydrated;
    BOOL dirty;
    NSData *data;
	
}
@property (assign, nonatomic, readonly) NSInteger cardID;
@property (copy, nonatomic) NSString *cardName;
@property (copy, nonatomic) NSString *cardText;
@property (copy, nonatomic) NSString *rarity;
@property (copy, nonatomic) NSString *mana;
@property (copy, nonatomic) NSString *cardType;
@property (copy, nonatomic) NSString *power;
@property (copy, nonatomic) NSString *toughness;
@property (assign, nonatomic, readonly) NSInteger cardNumber;
@property (nonatomic, retain) UIImage *rarityImage;
@property (nonatomic, retain) Inventory *inventory;


- (id)initWithPrimaryKey:(NSInteger)pk;

+ (void)finalizeStatements;
- (void)hydrate;
- (void)dehydrate;

@end
