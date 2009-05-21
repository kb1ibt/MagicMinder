//  Inventory.h
//  Magic Minder
//  Created by Shawn Stricker on 7/2/08.

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface Inventory : NSObject {
    BOOL hydrated;
    BOOL dirty;
    NSData *data;
	NSInteger primaryKey;
	NSInteger totalCards;
	NSInteger normalCards;
	NSInteger foilCards;
	NSInteger cardNumber;
	NSString *setInitials;
}
@property (assign, nonatomic, readonly) NSInteger primaryKey;
@property (assign, nonatomic, readonly) NSInteger cardNumber;
@property (assign, nonatomic, readonly) NSString *setInitials;
@property (assign, nonatomic) NSInteger totalCards;
@property (assign, nonatomic) NSInteger normalCards;
@property (assign, nonatomic) NSInteger foilCards;

- (id)initWithCardNumber:(NSInteger)pk setInitials:(NSString *)intials;
+ (void)finalizeStatements;
- (void)dehydrate;
- (void)incrementFoil;
- (void)decrementFoil;
- (void)incrementNormal;
- (void)decrementNormal;

@end
