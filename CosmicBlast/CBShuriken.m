//
//  CBShuriken.m
//  CosmicBlast
//
//  Created by Teddy Kitchen on 9/10/14.
//  Copyright (c) 2014 Teddy Kitchen. All rights reserved.
//

#import "CBShuriken.h"


@implementation CBShuriken

+(id)shurikenWithImageNamed:(NSString *)name{
    CBShuriken * shuriken = [CBShuriken spriteNodeWithImageNamed:name];
    return shuriken;
    
}

+(id)shuriken {
    //GameValues * gameValues = [[GameValues alloc] init];
    return [CBShuriken shurikenWithImageNamed:@"Shot"];
}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}


@end
