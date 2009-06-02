//  Set.m
//  Magic Minder
//  Created by Shawn Stricker on 6/7/08.

#import "Set.h"
#import "Card.h"
#import "Inventory.h"
#import "Magic_MinderAppDelegate.h"

static sqlite3_stmt *initSetStatement = nil;

@implementation Set
@synthesize cards, setName, setInitial;
/*+ (Set *)setNamed:(NSString *)name {
	return [blocks objectForKey:name];
}
+ (NSArray *)setNameList{
	NSSortDescriptor *pkDescript = [[NSSortDescriptor alloc] initWithKey:@"primaryKey" ascending:YES selector:@selector(compare:)];
	NSArray *tempArray = [sets allValues];
	NSArray *sortedArray;
	sortedArray = [tempArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:pkDescript]];
	[pkDescript release];
	return sortedArray;
}
+ (Set *)newSetWithName:(NSString *)setName {
	Set *newSet = [[Set alloc] init];
	newSet.setName = setName;
	NSMutableArray *array = [[NSMutableArray alloc] init];
	newSet.cards = array;
	[array release];
	[sets setObject:newSet forKey:setName];
	return newSet;
}*/
+ (void)finalizeStatements {
    if (initSetStatement) sqlite3_finalize(initSetStatement);
}
- (id)initWithPrimaryKey:(NSInteger)pk{
    if (self = [super init]) {
        primaryKey = pk;
        if (initSetStatement == nil) {
            const char *sql = "SELECT name,initials,released,blockItem FROM sets WHERE id=?";
            if (sqlite3_prepare_v2(dictionary, sql, -1, &initSetStatement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dictionary));
            }
        }
        sqlite3_bind_int(initSetStatement, 1, primaryKey);
        if (sqlite3_step(initSetStatement) == SQLITE_ROW) {
            self.setName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(initSetStatement, 0)];
            self.setInitial = [NSString stringWithUTF8String:(char *)sqlite3_column_text(initSetStatement, 1)];
			if(sqlite3_column_int(initSetStatement,2) == 1){released = TRUE;}else{released = FALSE;}
			blockOrder = sqlite3_column_int(initSetStatement,3);
        } else {
            self.setName = @"No title";
			self.setInitial = @"C";
			released=FALSE;
        }
        // Reset the statement for future reuse.
        sqlite3_reset(initSetStatement);
		NSMutableArray *array = [[NSMutableArray alloc] init];
		self.cards = array;
		[array release];
    }
    return self;
}
- (NSInteger)primaryKey {
    return primaryKey;
}
- (NSInteger)blockOrder {
    return blockOrder;
}
- (BOOL)hasBeenReleased {
	if(released){
		return TRUE;
	}else{
		return FALSE;
	}
}
- (void)dealloc {
	[self dehydrate];
	[cards makeObjectsPerformSelector:@selector(dealloc)];	
	[setName release];
	[setInitial release];
    [super dealloc];
}

-(void)dehydrate {
	[cards makeObjectsPerformSelector:@selector(dehydrate)];
	[cards release];
	NSMutableArray *array = [[NSMutableArray alloc] init];
	self.cards = array;
	hydrated = NO;
}
-(void)hydrate{
	if(!hydrated){
		sqlite3_stmt *statement = nil;
		const char *sql = "SELECT id FROM cardInfo WHERE setID=? ORDER BY cardNumber";
		if (sqlite3_prepare_v2(dictionary, sql, -1, &statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dictionary));
		}
		sqlite3_bind_int(statement, 1, primaryKey);
		while (sqlite3_step(statement) == SQLITE_ROW) {
			int cardID = sqlite3_column_int(statement, 0);
			Card *indivCard = [[Card alloc] initWithPrimaryKey:cardID];
			NSString *string = NULL;
			if([setInitial isEqualToString:@"TSB"]){
				string = [[NSString alloc] initWithFormat:@"exp_sym_TSB_P.gif"];
			}else{
				if([indivCard.rarity isEqualToString:@"R"]){
					string = [[NSString alloc] initWithFormat:@"exp_sym_%@_R.gif", (NSString *)setInitial];
				}else if([indivCard.rarity isEqualToString:@"U"]){
					string = [[NSString alloc] initWithFormat:@"exp_sym_%@_U.gif", (NSString *)setInitial];
				}else if([indivCard.rarity isEqualToString:@"M"]){
					string = [[NSString alloc] initWithFormat:@"exp_sym_%@_M.gif", (NSString *)setInitial];
				}else{
					string = [[NSString alloc] initWithFormat:@"exp_sym_%@_C.gif", (NSString *)setInitial];
				}
			}
			indivCard.rarityImage = [UIImage imageNamed: string];
			indivCard.inventory = [[Inventory alloc] initWithCardNumber:indivCard.cardNumber setInitials:setInitial];
			[string release];
			[cards addObject:indivCard];
			[indivCard release];
		}
		sqlite3_finalize(statement);
		hydrated = YES;
	}
}
@end
