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
		sqlite3_stmt *statement,*statementCount;
		const char *sql = "SELECT id, blockItem FROM sets WHERE block=? ORDER BY blockItem";
		if (sqlite3_prepare_v2(dictionary, sql, -1, &statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dictionary));
		}
		const char *sqlCount = "SELECT COUNT(*) FROM sets WHERE block=?";
		sqlite3_prepare_v2(dictionary, sqlCount, -1, &statementCount, NULL);
		sqlite3_bind_int(statementCount, 1, primaryKey);
		sqlite3_step(statementCount);
		int setCount = sqlite3_column_int(statementCount, 0);
		CGFloat setI = 0;
		NSDictionary *tempDict,*tempDict2;
		sqlite3_bind_int(statement, 1, primaryKey);
		Magic_MinderAppDelegate *delagate = [(Magic_MinderAppDelegate *)[UIApplication sharedApplication] delegate];
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
			int setID = sqlite3_column_int(statement, 0);
			Set *indivSet = [[Set alloc] initWithPrimaryKey:setID];
			tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"textSet",@"Type",[indivSet setName],@"Value",nil];
			[delagate performSelectorOnMainThread:@selector(progressUpdate:) withObject:tempDict waitUntilDone:NO];
			NSNumber *tempPercent = [[NSNumber alloc] initWithFloat:(setI++/setCount)];
			tempDict2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"progressSet",@"Type",tempPercent,@"Value",nil];
			[delagate performSelectorOnMainThread:@selector(progressUpdate:) withObject:tempDict2 waitUntilDone:NO];
			[indivSet hydrate];
			[sets addObject:indivSet];
			[indivSet release];
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
