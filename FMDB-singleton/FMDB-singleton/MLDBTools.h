//
//  MLDBTools.h
//  FMDB-singleton
//
//  Created by 李明禄 on 15/12/26.
//  Copyright © 2015年 SocererGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface MLDBTools : NSObject

///fmdb单例
+ (instancetype)sharedDBTools;

@property (nonatomic, strong) FMDatabaseQueue *queue;
@end
