//
//  Cycle.m
//  Magic Minder
//
//  Created by Shawn Stricker on 5/28/09.
//

#import "Cycle.h"
#import "Set.h"
#import "Card.h"
#import "Inventory.h"
#import "Magic_MinderAppDelegate.h"

static sqlite3_stmt *initBlockStatement = nil;

@implementation Cycle
@synthesize primaryKey,blockName,sets;

- (id)initWithPrimaryKey:(NSInteger)pk{
    if (self = [super init]) {
        primaryKey = pk;
        if (initBlockStatement == nil) {
            const char *sql = "SELECT name FROM block WHERE id=?";
            if (sqlite3_prepare_v2(dictionary, sql, -1, &initBlockStatement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dictionary));
            }
        }
        sqlite3_bind_int(initBlockStatement, 1, primaryKey);
        if (sqlite3_step(initBlockStatement) == SQLITE_ROW) {
            self.blockName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(initBlockStatement, 0)];
        } else {
            self.blockName = @"No title";
        }
        // Reset the statement for future reuse.
        sqlite3_reset(initBlockStatement);
		NSMutableArray *array = [[NSMutableArray alloc] init];
		self.sets = array;
		[array release];
    }
	[self hydrate];
    return self;
}
+ (void)finalizeStatements {
    if (initBlockStatement) sqlite3_finalize(initBlockStatement);
}
-(void)dehydrate {
	[sets makeObjectsPerformSelector:@selector(dehydrate)];
	hydrated = NO;
}
- (void)dealloc {
	[sets makeObjectsPerformSelector:@selector(dealloc)];	
	[blockName release];
    [super dealloc];
}
-(void)hydrate{
	if(!hydrated){
		sqlite3_stmt *statement = nil;
		const char *sql = "SELECT id, blockItem FROM sets WHERE block=? ORDER BY blockItem";
		if (sqlite3_prepare_v2(dictionary, sql, -1, &statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dictionary));
		}
		sqlite3_bind_int(statement, 1, primaryKey);
		while (sqlite3_step(statement) == SQLITE_ROW) {
			int setID = sqlite3_column_int(statement, 0);
			Set *indivSet = [[Set alloc] initWithPrimaryKey:setID];

			[sets addObject:indivSet];
			[indivSet release];
		}
		sqlite3_finalize(statement);
		hydrated = YES;
	}
}

const char *sqlSet = "SELECT id, blockItem FROM sets WHERE block=?";
@end
