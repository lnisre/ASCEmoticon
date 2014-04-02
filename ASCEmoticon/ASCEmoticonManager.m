//
//  ASCEmoticonManager.m
//  ASCEmoticon
//
//  Created by wenlonggao on 14-3-30.
//  Copyright (c) 2014年 wenlonggao. All rights reserved.
//

#import "ASCEmoticonManager.h"
#import "FMDatabase.h"
#import "ASCEmoticon.h"
#import "FMDatabaseQueue.h"

#define CREATE_EMOTICON_TABLE @"CREATE TABLE 'Emoticon' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'name' TEXT, 'type' INTEGER, 'description' TEXT, 'filePath' TEXT)"
#define INSERT_EMOTICON @"insert into Emoticon (name, type, description, filePath) values(?,?,?,?)"
#define QUERY_EMOTICON_BYTYPE @"select * from Emoticon where type = ?"
#define QUERY_EMOTICON_BYDESCRIPTION @"select * from Emoticon where description like '%?%'"

@interface ASCEmoticonManager ()

@property (nonatomic, retain) NSString * dbPath;
@property (nonatomic, retain) dispatch_queue_t queryQueue;
@property (nonatomic, retain) dispatch_queue_t updateQueue;
@property (nonatomic, retain) FMDatabaseQueue *dbQuery;
@property (nonatomic, retain) FMDatabaseQueue *dbUpdate;

@end

@implementation ASCEmoticonManager

@synthesize dbPath;
@synthesize queryQueue;
@synthesize updateQueue;
@synthesize dbQuery;
@synthesize dbUpdate;

+(ASCEmoticonManager *)sharedManager
{
    static ASCEmoticonManager *sharedEmoticonManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedEmoticonManager = [[self alloc] init];
    });
    return sharedEmoticonManager;
}

-(dispatch_queue_t)queryQueue
{
    if (queryQueue == nil) {
        queryQueue = dispatch_queue_create("query", NULL);
    }
    return queryQueue;
}

-(dispatch_queue_t)updateQueue
{
    if (updateQueue == nil) {
        updateQueue = dispatch_queue_create("update", NULL);
    }
    return updateQueue;
}

-(FMDatabaseQueue *)dbUpdate
{
    if (dbUpdate == nil) {
        dbUpdate = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    }
    return dbUpdate;
}

-(FMDatabaseQueue *)dbQuery
{
    if (dbQuery == nil) {
        dbQuery = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    }
    return dbQuery;
}

+(void)createDataBase
{
    [[ASCEmoticonManager sharedManager] createDataBase];
}

-(void)createDataBase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.dbPath = [documentsDirectory stringByAppendingPathComponent:@"user.sqlite"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.dbPath] == NO) {
        FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open]) {
            BOOL result = [db executeUpdate:CREATE_EMOTICON_TABLE];
            if (!result) {
                NSLog(@"create DB Error!!!");
            }
            [db close];
        }
        
    }
}

+(void)insertEmoticon:(ASCEmoticon *)emoticon
{
    [[ASCEmoticonManager sharedManager] insert:emoticon.type name:emoticon.name description:emoticon.description path:emoticon.path];
}

-(void)insert:(NSInteger)type name:(NSString*)name description:(NSString*)description path:(NSString*)path
{
    dispatch_async(self.updateQueue, ^{
        [self.dbUpdate inDatabase:^(FMDatabase *db) {
        
            BOOL result = [db executeUpdate:INSERT_EMOTICON, name, [NSNumber numberWithInt:type], description, path];
            if (!result) {
                NSLog(@"insert DB Error!!\nname:%@ type:%d description:%@ path:%@", name, type, description, path);
            }
        }];
    });
}

+(void)queryEmoticonByType:(uint32_t)type complete:(void (^)(NSArray *))block
{
    [[ASCEmoticonManager sharedManager] queryEmoticonByType:type complete:block];
}
-(void)queryEmoticonByType:(uint32_t)type complete:(void (^)(NSArray *))block
{
    dispatch_async(self.queryQueue, ^{
        [self.dbQuery inDatabase:^(FMDatabase *db) {
        __block NSMutableArray *result = [[NSMutableArray alloc] init];
        
        FMResultSet *resultSet = [db executeQuery:QUERY_EMOTICON_BYTYPE, [NSNumber numberWithInteger:type]];
        while (resultSet.next) {
            NSString *name = [resultSet stringForColumn:@"name"];
            NSString *des = [resultSet stringForColumn:@"description"];
            uint32_t type = [resultSet intForColumn:@"type"];
            NSString *path = [resultSet stringForColumn:@"path"];
            ASCEmoticon *emoticon = [[ASCEmoticon alloc] initWithName:name description:des type:type path:path];
            [result addObject:emoticon];
        }
        [resultSet close];

        dispatch_async(dispatch_get_main_queue(), ^{
            block(result);
        });
            
        }];
    });
}

+(void)queryEmoticonByKey:(NSString *)key complete:(void (^)(NSArray *))block
{
    [[ASCEmoticonManager sharedManager] queryEmoticonByKey:key complete:block];
}
-(void)queryEmoticonByKey:(NSString *)key complete:(void (^)(NSArray *))block
{
    dispatch_async(self.queryQueue, ^{
        [self.dbQuery inDatabase:^(FMDatabase *db) {
            __block NSMutableArray *result = [[NSMutableArray alloc] init];
            
            FMResultSet *resultSet = [db executeQuery:QUERY_EMOTICON_BYDESCRIPTION, key];
            while (resultSet.next) {
                NSString *name = [resultSet stringForColumn:@"name"];
                NSString *des = [resultSet stringForColumn:@"description"];
                uint32_t type = [resultSet intForColumn:@"type"];
                NSString *path = [resultSet stringForColumn:@"path"];
                ASCEmoticon *emoticon = [[ASCEmoticon alloc] initWithName:name description:des type:type path:path];
                [result addObject:emoticon];
            }
            [resultSet close];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                block(result);
            });
            
        }];
    });
}
@end
