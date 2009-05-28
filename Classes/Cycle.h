//
//  Cycle.h
//  Magic Minder
//
//  Created by Shawn Stricker on 5/28/09.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface Cycle : NSObject {
    NSInteger primaryKey;
	NSString *blockName;
	NSMutableArray *sets;
	BOOL hydrated;
}
@property (assign, nonatomic, readonly) NSInteger primaryKey;
@property (copy, nonatomic) NSString *blockName;
@property (nonatomic, retain) NSMutableArray *sets;

- (id)initWithPrimaryKey:(NSInteger)pk;
+ (void)finalizeStatements;
- (void)hydrate;
- (void)dehydrate;

@end
