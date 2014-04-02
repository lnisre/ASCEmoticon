//
//  ASCEmoticon.m
//  ASCEmoticon
//
//  Created by wenlonggao on 14-3-30.
//  Copyright (c) 2014年 wenlonggao. All rights reserved.
//

#import "ASCEmoticon.h"

@implementation ASCEmoticon

-(id)initWithName:(NSString *)name description:(NSString *)description type:(uint32_t)type path:(NSString *)path
{
    self = [self init];
    if (self) {
        self.name = name;
        self.description = description;
        self.type = type;
        self.path = path;
    }
    return self;
}

@end
