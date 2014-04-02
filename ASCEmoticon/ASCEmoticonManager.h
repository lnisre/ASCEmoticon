//
//  ASCEmoticonManager.h
//  ASCEmoticon
//
//  Created by wenlonggao on 14-3-30.
//  Copyright (c) 2014年 wenlonggao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASCEmoticon;

@interface ASCEmoticonManager : NSObject

+(void)createDataBase;
+(void)insertEmoticon:(ASCEmoticon *)emoticon;

+(void)queryEmoticonByType:(uint32_t)type complete:(void (^)(NSArray*))block;
+(void)queryEmoticonByKey:(NSString*)key complete:(void (^)(NSArray*))block;
@end
