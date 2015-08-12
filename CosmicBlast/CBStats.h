//
//  CBStats.h
//  CosmicBlast
//
//  Created by Teddy Kitchen on 8/10/15.
//  Copyright (c) 2015 Teddy Kitchen. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface CBStats : NSObject <NSCoding>

@property int kills;
@property int totalKills;

@property NSString *docPath;

+(id)stats;

-(void)encodeWithCoder:

(NSCoder *)aCoder;

-(id)initWithCoder:(NSCoder *)aDecoder;

-(void)killDidHappen;

-(void)saveData;

-(void)deleteData;




@end
