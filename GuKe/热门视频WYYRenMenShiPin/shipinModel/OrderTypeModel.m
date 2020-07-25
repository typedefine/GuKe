//
//  OrderTypeModel.m
//  GuKe
//
//  Created by yu on 2018/1/20.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "OrderTypeModel.h"

@implementation OrderTypeModel
- (void)makeModelWithDic:(NSDictionary *)dic{
    self.videoTypeId = [dic objectForKey:@"videoTypeId"];
    self.typeName = [dic objectForKey:@"typeName"];
    self.compositor = [dic objectForKey:@"compositor"];
    self.typeParent = [dic objectForKey:@"typeParent"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.videoTypeId = [aDecoder decodeObjectForKey:@"videoTypeId"];
        self.typeName = [aDecoder decodeObjectForKey:@"typeName"];
        self.compositor = [aDecoder decodeObjectForKey:@"compositor"];
        self.typeParent = [aDecoder decodeObjectForKey:@"typeParent"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.videoTypeId forKey:@"videoTypeId"];
    [aCoder encodeObject:self.typeName forKey:@"typeName"];
    [aCoder encodeObject:self.compositor forKey:@"compositor"];
    [aCoder encodeObject:self.typeParent forKey:@"typeParent"];
}
@end
