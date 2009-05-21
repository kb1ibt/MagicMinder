//  Magic_MinderAppDelegate.m
//  Magic Minder
//  Created by Shawn Stricker on 5/14/08.

#import "Magic_MinderAppDelegate.h"
#import "Card.h"
#import "SetViewController.h"
#import "Set.h"
#import "Inventory.h"

UIImage *setRarityImage;
sqlite3 *dictionary;
sqlite3 *inventory;
NSMutableDictionary *sets;

@interface Magic_MinderAppDelegate (Private)
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)initializeDatabase;
- (void)initializeDisplay;
@end

@implementation Magic_MinderAppDelegate
@synthesize tabBarController;
@synthesize window;

- init {
	if (self = [super init]) {
		window = nil;
		tabBarController = nil;
	}
	return self;
}

- (void)initializeDisplay{
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
	[window setBackgroundColor:[UIColor blackColor]];
	tabBarController = [[UITabBarController alloc] init];
	NSMutableArray *localViewControllersArray = [[NSMutableArray alloc] initWithCapacity:4];
	SetViewController *setViewController = [[SetViewController alloc] initWithStyle:UITableViewStylePlain];
	UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:setViewController];
	aNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	[localViewControllersArray addObject:aNavigationController];
	[aNavigationController release];
	[setViewController release];
	tabBarController.viewControllers = localViewControllersArray;
	[window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
}
- (void)applicationDidFinishLaunching:(UIApplication *)application {
	setRarityImage = [[UIImage imageNamed:@"exp_sym_SHM_R.gif"] retain];
	[self createEditableCopyOfDatabaseIfNeeded];
	[self initializeDatabase];
	[self initializeDisplay];
}

- (void)dealloc {
    [tabBarController release];
	[window release];
	[super dealloc];
}

- (void)createEditableCopyOfDatabaseIfNeeded {
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"inventory.db"];
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (success) return;
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"inventory.db"];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (!success) {
		NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}

- (void)initializeDatabase {
    NSString *dictionaryPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"dictionary.db"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *inventoryPath = [documentsDirectory stringByAppendingPathComponent:@"inventory.db"];
    if (sqlite3_open([dictionaryPath UTF8String], &dictionary) == SQLITE_OK) {
        sqlite3_stmt *statement;
		const char *sql = "SELECT id, name, initials FROM sets";
		if (sqlite3_open([inventoryPath UTF8String], &inventory) == SQLITE_OK) {
			if (sqlite3_prepare_v2(dictionary, sql, -1, &statement, NULL) == SQLITE_OK) {
				while (sqlite3_step(statement) == SQLITE_ROW) {
					int primaryKey = sqlite3_column_int(statement, 0);
					Set *indivSet = [[Set alloc] initWithPrimaryKey:primaryKey];
					[indivSet release];
				}
			}
			sqlite3_finalize(statement);
		}
    } else {
        sqlite3_close(dictionary);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(dictionary));
    }
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[sets allValues] makeObjectsPerformSelector:@selector(dehydrate)];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[sets allValues] makeObjectsPerformSelector:@selector(dealloc)];
    [Card finalizeStatements];
    [Set finalizeStatements];
    if (sqlite3_close(dictionary) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(dictionary));
    }
}

@end
