//  Magic_MinderAppDelegate.m
//  Magic Minder
//  Created by Shawn Stricker on 5/14/08.

#import "Magic_MinderAppDelegate.h"
#import "Card.h"
#import "SetViewController.h"
#import "Set.h"
#import "Cycle.h"
#import "Inventory.h"
#import "LoadingView.h"

UIImage *setRarityImage;
sqlite3 *dictionary;
sqlite3 *inventory;
NSMutableArray *blocks;

@interface Magic_MinderAppDelegate (Private)
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)initializeDatabase;
- (void)initializeDisplay;
- (void)displayProgress;
@end

@implementation Magic_MinderAppDelegate
@synthesize tabBarController,loadingView;
@synthesize window;

- init {
	if (self = [super init]) {
		window = nil;
		tabBarController = nil;
		loadingView = nil;
	}
	return self;
}
-(void)displayProgess{
	LoadingView *tempLoading = [[LoadingView alloc] initWithNibName:@"LoadingView" bundle:nil];
	self.loadingView = tempLoading;
	[window addSubview:tempLoading.view];
	[window makeKeyAndVisible];
	[self progressUpdate:[NSDictionary dictionaryWithObjectsAndKeys:@"textBlock",@"Type",@"",@"Value",nil]];
	[self progressUpdate:[NSDictionary dictionaryWithObjectsAndKeys:@"textSet",@"Type",@"",@"Value",nil]];
	[self progressUpdate:[NSDictionary dictionaryWithObjectsAndKeys:@"textCard",@"Type",@"",@"Value",nil]];
	[self progressUpdate:[NSDictionary dictionaryWithObjectsAndKeys:@"progressBlock",@"Type",0,@"Value",nil]];
	[self progressUpdate:[NSDictionary dictionaryWithObjectsAndKeys:@"progressSet",@"Type",0,@"Value",nil]];
	[self progressUpdate:[NSDictionary dictionaryWithObjectsAndKeys:@"progressCard",@"Type",0,@"Value",nil]];
	[tempLoading release];
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
	[localViewControllersArray release];
	[window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
}
- (void)applicationDidFinishLaunching:(UIApplication *)application {
	setRarityImage = [[UIImage imageNamed:@"exp_sym_SHM_R.gif"] retain];
	[self displayProgess];
	[NSThread detachNewThreadSelector:@selector(initializeDatabase) toTarget:self withObject:nil];
}

- (void)dealloc {
    [tabBarController release];
	[loadingView release];
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
	[self createEditableCopyOfDatabaseIfNeeded];
    NSString *dictionaryPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"dictionary.db"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	[paths release];
    NSString *inventoryPath = [documentsDirectory stringByAppendingPathComponent:@"inventory.db"];
	blocks = [[NSMutableArray alloc] init];	
    if (sqlite3_open([dictionaryPath UTF8String], &dictionary) == SQLITE_OK) {
        sqlite3_stmt *statement,*statementCount;
		const char *sqlBlockCount = "SELECT COUNT(*) FROM block";
		const char *sqlBlock = "SELECT id FROM block ORDER BY id";
		if (sqlite3_open([inventoryPath UTF8String], &inventory) == SQLITE_OK) {
			if (sqlite3_prepare_v2(dictionary, sqlBlock, -1, &statement, NULL) == SQLITE_OK) {
				sqlite3_prepare_v2(dictionary, sqlBlockCount, -1, &statementCount, NULL);
				sqlite3_step(statementCount);
				int blockCount = sqlite3_column_int(statementCount, 0);
				CGFloat blockI = 0;
				NSDictionary *tempDict,*tempDict2;
				while (sqlite3_step(statement) == SQLITE_ROW) {
					NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
					int primaryKey = sqlite3_column_int(statement, 0);
					Cycle *indivBlock = [[Cycle alloc] initWithPrimaryKey:primaryKey];
					tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"textBlock",@"Type",[indivBlock blockName],@"Value",nil];
					[self performSelectorOnMainThread:@selector(progressUpdate:) withObject:tempDict waitUntilDone:NO];
					NSNumber *tempPercent = [[NSNumber alloc] initWithFloat:(blockI++/blockCount)];
					tempDict2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"progressBlock",@"Type",tempPercent,@"Value",nil];
					[self performSelectorOnMainThread:@selector(progressUpdate:) withObject:tempDict2 waitUntilDone:NO];
					[indivBlock hydrate];
					[blocks addObject:indivBlock];
					[indivBlock release];
					[tempDict release];
					[tempPercent release];
					[tempDict2 release];
					[pool release];
				}
				sqlite3_finalize(statementCount);
			}
			sqlite3_finalize(statement);
		}
    } else {
        sqlite3_close(dictionary);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(dictionary));
    }
	[self initializeDisplay];
}
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[blocks makeObjectsPerformSelector:@selector(dehydrate)];
}
- (void)progressUpdate:(NSDictionary*)sender
{
	if([sender objectForKey:@"Type"] == @"textBlock"){
		[[loadingView labelBlock] setText:[sender valueForKey:@"Value"]];
	}else if([sender objectForKey:@"Type"] == @"textSet"){
		[loadingView labelSet].text = [sender valueForKey:@"Value"];		
	}else if([sender objectForKey:@"Type"] == @"textCard"){
		[loadingView labelCard].text = [sender valueForKey:@"Value"];
	}else if([sender objectForKey:@"Type"] == @"progressBlock"){
		[loadingView progressBlocks].progress = [[sender valueForKey:@"Value"] floatValue];
	}else if([sender objectForKey:@"Type"] == @"progressSet"){
		[loadingView progressSets].progress = [[sender valueForKey:@"Value"] floatValue];
	}else if([sender objectForKey:@"Type"] == @"progressCard"){
		[loadingView progressCards].progress = [[sender valueForKey:@"Value"] floatValue];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [blocks makeObjectsPerformSelector:@selector(dealloc)];
    [Card finalizeStatements];
    [Set finalizeStatements];
	[Cycle finalizeStatements];
    if (sqlite3_close(dictionary) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(dictionary));
    }
}

@end
