//  Card.m
//  Magic Minder
//  Created by Shawn Stricker on 6/7/08.

#import "Card.h"
#import "Inventory.h"
#import "Magic_MinderAppDelegate.h"


static sqlite3_stmt *initCardStatement = nil;
static sqlite3_stmt *hydrateCardStatement = nil;

@implementation Card
@synthesize cardName, cardText, rarity, rarityImage, mana, cardType, inventory, toughness, power;

+ (void)finalizeStatements {
    if (initCardStatement) sqlite3_finalize(initCardStatement);
    if (hydrateCardStatement) sqlite3_finalize(hydrateCardStatement);
}
- (id)initWithPrimaryKey:(NSInteger)pk{
    if (self = [super init]) {
        cardID = pk;
        if (initCardStatement == nil) {
            const char *sql = "SELECT c.cardName,c.cardNumber,c.rarity FROM cardInfo AS c WHERE c.id=?";
            if (sqlite3_prepare_v2(dictionary, sql, -1, &initCardStatement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dictionary));
            }
        }
        sqlite3_bind_int(initCardStatement, 1, cardID);
        if (sqlite3_step(initCardStatement) == SQLITE_ROW) {
            self.cardName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(initCardStatement, 0)];
			cardNumber = sqlite3_column_int(initCardStatement,1);
            self.rarity = [NSString stringWithUTF8String:(char *)sqlite3_column_text(initCardStatement, 2)];
        } else {
            self.cardName = @"No title";
			cardNumber = 0;
			self.rarity = @"C";
        }
        // Reset the statement for future reuse.
        sqlite3_reset(initCardStatement);
        dirty = NO;
    }
	[self hydrate];
    return self;
}

- (void)dealloc {
	[self dehydrate];
	[inventory dealloc];
    [cardName release];
    [cardText release];
	[rarity release];
	[mana release];
	[cardType release];
	[power release];
	[toughness release];
    [super dealloc];
}

-(NSInteger)cardID {
	return cardID;
}
-(NSInteger)cardNumber {
	return cardNumber;
}
- (void)hydrate {
    if (hydrated) return;
    if (hydrateCardStatement == nil) {
        const char *sql = "SELECT text, mana, type, power, tough FROM cardInfo WHERE id=?";
        if (sqlite3_prepare_v2(dictionary, sql, -1, &hydrateCardStatement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dictionary));
        }
    }
    sqlite3_bind_int(hydrateCardStatement, 1, cardID);
    int success =sqlite3_step(hydrateCardStatement);
    if (success == SQLITE_ROW) {
		char *tmpText = (char *)sqlite3_column_text(hydrateCardStatement, 0);
		if(tmpText != nil){
			self.cardText = [NSString stringWithUTF8String:tmpText];
		}else{
			self.cardText = @"";
		}
		char *tmpMana = (char *)sqlite3_column_text(hydrateCardStatement, 1);
		if(tmpMana != nil){
		self.mana = [NSString stringWithUTF8String:tmpMana];
		}else{
			self.mana = @"";
		}
        self.cardType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(hydrateCardStatement, 2)];
		char *tmpPower = (char*)sqlite3_column_text(hydrateCardStatement, 3);
		if(tmpPower != nil){
			self.power = [NSString stringWithUTF8String:tmpPower];
		}else{
			self.power = @"";
		}
		char *tmpTough = (char*)sqlite3_column_text(hydrateCardStatement, 4);
		if(tmpTough != nil){
			self.toughness = [NSString stringWithUTF8String:tmpTough];
		}else{
			self.toughness = @"";
		}
    } else {
        self.cardText = @"Unknown";
		self.mana = @"";
		self.cardType = @"";
		self.power = @"";
		self.toughness = @"";
    }
    sqlite3_reset(hydrateCardStatement);
    hydrated = YES;
}

- (void)dehydrate {
	[inventory dehydrate];
    [cardText release];
    cardText = nil;
    [mana release];
    mana = nil;
    [cardType release];
    cardType = nil;
    hydrated = NO;
}


@end
