//
//  MLDBTools.m
//  FMDB-singleton
//
//  Created by 李明禄 on 15/12/26.
//  Copyright © 2015年 SocererGroup. All rights reserved.
//

#import "MLDBTools.h"

@implementation MLDBTools

+ (instancetype)sharedDBTools {
    static MLDBTools *_instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        // 提示：可以使用其他的文件名替代my.db，从而保护数据库文件
        dbPath = [dbPath stringByAppendingPathComponent:@"my.db"];
        
        //创建数据库队列，如果不存在会自动生成数据库文件
        _queue = [[FMDatabaseQueue alloc] initWithPath:dbPath];
        
        [self createTables];
    }
    
    return self;
    
}

- (void)createTables {
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL result = NO;
        
        // 创建个人表
        result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS T_Person ("
                  "personId integer PRIMARY KEY AUTOINCREMENT NOT NULL,"
                  "personName text,"
                  "age integer,"
                  "phoneNo text,"
                  "companyId integer,"
                  "FOREIGN KEY (companyId) REFERENCES T_Company (companyId) ON DELETE SET NULL"
                  ");"];
        
        //如果创建表失败就回滚事物
        if (!result) {
            NSLog(@"创建表失败，进行进行回滚");
            
            *rollback = YES;
            
             // 如果不return，会继续执行后续的语句，但是rollback已经标记为回滚，如果继续执行会报错
            return ;
        }
        
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS T_Company ("
         "companyId integer PRIMARY KEY AUTOINCREMENT NOT NULL,"
         "companyName text"
         ");"];
        
        NSLog(@"创建数据表完成！！");
    }];
}



@end
