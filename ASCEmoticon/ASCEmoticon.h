//
//  ASCEmoticon.h
//  ASCEmoticon
//
//  Created by wenlonggao on 14-3-30.
//  Copyright (c) 2014年 wenlonggao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASCEmoticon : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, assign) uint32_t type;
@property (nonatomic, retain) NSString *path;

-(id)initWithName:(NSString*)name description:(NSString*)description type:(uint32_t)type path:(NSString*)path;

@end
