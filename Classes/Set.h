//  Set.h
//  Magic Minder
//  Created by Shawn Stricker on 6/7/08.

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Set : NSObject {
    NSInteger primaryKey;
    NSInteger blockOrder;
	NSString *setName;
	NSString *setInitial;
	BOOL hydrated;
    BOOL dirty;
	BOOL released;
	NSMutableArray *cards;
}
@property (assign, nonatomic, readonly) NSInteger primaryKey;
@property (copy, nonatomic) NSString *setName;
@property (copy, nonatomic) NSString *setInitial;
@property (nonatomic, retain) NSMutableArray *cards;

//+ (Set *)setNamed:(NSString *)name;
//+ (Set *)newSetWithName:(NSString *)setName;
//+ (NSArray *)setNameList;
- (id)initWithPrimaryKey:(NSInteger)pk;

+ (void)finalizeStatements;
- (void)hydrate;
- (void)dehydrate;
- (BOOL)hasBeenReleased;
@end
