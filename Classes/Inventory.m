//  Inventory.m
//  Magic Minder
//  Created by Shawn Stricker on 7/2/08.

#import "Inventory.h"
#import "Magic_MinderAppDelegate.h"


static sqlite3_stmt *insertInvenStatement = nil;
static sqlite3_stmt *initInvenStatement = nil;
static sqlite3_stmt *updateInvenStatement = nil;

@implementation Inventory
@synthesize totalCards, normalCards, foilCards;
+ (void)finalizeStatements {
    if (initInvenStatement) sqlite3_finalize(initInvenStatement);
    if (updateInvenStatement) sqlite3_finalize(updateInvenStatement);
    if (insertInvenStatement) sqlite3_finalize(insertInvenStatement);
}

- (id)initWithCardNumber:(NSInteger)pk setInitials:(NSString *)initials{
    if (self = [super init]) {
		cardNumber = pk;
		setInitials = (NSString *)initials;
        if (initInvenStatement == nil) {
            const char *sql = "SELECT id, totalQuantity, normal, foil FROM inventory WHERE cardNumber=? AND setID=?";
            if (sqlite3_prepare_v2(inventory, sql, -1, &initInvenStatement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(inventory));
            }
        }
        sqlite3_bind_int(initInvenStatement, 1, cardNumber);
		sqlite3_bind_text(initInvenStatement, 2, [setInitials UTF8String], -1 ,NULL);
        if (sqlite3_step(initInvenStatement) == SQLITE_ROW) {
            primaryKey = sqlite3_column_int(initInvenStatement,0);
            totalCards = sqlite3_column_int(initInvenStatement,1);
            normalCards = sqlite3_column_int(initInvenStatement,2);
            foilCards = sqlite3_column_int(initInvenStatement,3);
        } else {
			primaryKey = -1;
			totalCards = 0;
			normalCards = 0;
			foilCards = 0;
        }
        // Reset the statement for future reuse.
        sqlite3_reset(initInvenStatement);
        dirty = NO;
    }
    return self;
}
- (NSInteger)primaryKey {
    return primaryKey;
}
-(NSInteger)cardNumber {
	return cardNumber;
}
-(NSString *)setInitials {
	return setInitials;
}
-(void)incrementFoil{
	foilCards++;
	totalCards++;
	dirty = YES;
}
-(void)decrementFoil{
	if(foilCards > 0){		
	foilCards--;
	totalCards--;
	dirty = YES;
	}
}
-(void)incrementNormal{
	normalCards++;
	totalCards++;
	dirty = YES;
}
-(void)decrementNormal{
	if(normalCards > 0){
	normalCards--;
	totalCards--;
	dirty = YES;
	}
}

- (void)dehydrate {
	if(dirty){
		if(primaryKey == -1){
			if (insertInvenStatement == nil) {
				const char *sql = "INSERT INTO inventory (cardNumber, setID, totalQuantity, normal, foil) VALUES (?,?,?,?,?)";
				if (sqlite3_prepare_v2(inventory, sql, -1, &insertInvenStatement, NULL) != SQLITE_OK) {
					NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(inventory));
				}
			}
			sqlite3_bind_int(insertInvenStatement, 1, cardNumber);
			sqlite3_bind_text(insertInvenStatement, 2, [setInitials UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(insertInvenStatement, 3, totalCards);
			sqlite3_bind_int(insertInvenStatement, 4, normalCards);
			sqlite3_bind_int(insertInvenStatement, 5, foilCards);
			int success = sqlite3_step(insertInvenStatement);
			sqlite3_reset(insertInvenStatement);
			if (success != SQLITE_DONE) {
				NSAssert1(0, @"Error: failed to dehydrate with message '%s'.", sqlite3_errmsg(inventory));
			}
			dirty = NO;
		}else{
			if (updateInvenStatement == nil) {
				const char *sql = "UPDATE inventory SET totalQuantity=?, normal=?, foil=? WHERE id=?";
				if (sqlite3_prepare_v2(inventory, sql, -1, &updateInvenStatement, NULL) != SQLITE_OK) {
					NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(inventory));
				}
			}
			sqlite3_bind_int(updateInvenStatement, 1, totalCards);
			sqlite3_bind_int(updateInvenStatement, 2, normalCards);
			sqlite3_bind_int(updateInvenStatement, 3, foilCards);
			sqlite3_bind_int(updateInvenStatement, 4, primaryKey);
			int success = sqlite3_step(updateInvenStatement);
			sqlite3_reset(updateInvenStatement);
			if (success != SQLITE_DONE) {
				NSAssert1(0, @"Error: failed to dehydrate with message '%s'.", sqlite3_errmsg(inventory));
			}
			dirty = NO;
		}
	}
}

@end
