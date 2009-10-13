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
	cards = array;
	hydrated = NO;
}
-(void)hydrate{
	if(!hydrated){
		sqlite3_stmt *statement,*statementCount;
		const char *sql = "SELECT id FROM cardInfo WHERE setID=? ORDER BY cardNumber";
		if (sqlite3_prepare_v2(dictionary, sql, -1, &statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dictionary));
		}
		sqlite3_bind_int(statement, 1, primaryKey);
		const char *sqlCount = "SELECT COUNT(*) FROM cardInfo WHERE setID=?";
		sqlite3_prepare_v2(dictionary, sqlCount, -1, &statementCount, NULL);
		sqlite3_bind_int(statementCount, 1, primaryKey);
		sqlite3_step(statementCount);
		int cardCount = sqlite3_column_int(statementCount, 0);
		CGFloat cardI = 0;
		NSDictionary *tempDict,*tempDict2;
		Magic_MinderAppDelegate *delagate = [(Magic_MinderAppDelegate *)[UIApplication sharedApplication] delegate];
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
			int cardID = sqlite3_column_int(statement, 0);
			Card *indivCard = [[Card alloc] initWithPrimaryKey:cardID];
			tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"textCard",@"Type",[indivCard cardName],@"Value",nil];
			[delagate performSelectorOnMainThread:@selector(progressUpdate:) withObject:tempDict waitUntilDone:NO];
			NSNumber *tempPercent = [[NSNumber alloc] initWithFloat:(cardI++/cardCount)];
			tempDict2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"progressCard",@"Type",tempPercent,@"Value",nil];
			[delagate performSelectorOnMainThread:@selector(progressUpdate:) withObject:tempDict2 waitUntilDone:NO];
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
			[tempDict release];
			[tempDict2 release];
			[tempPercent release];			
			[pool release];
		}
		sqlite3_finalize(statement);
		sqlite3_finalize(statementCount);
		hydrated = YES;
	}
}
@end
