//
//  JsonSerchClass.h
//  Marure
//
//  Created by yo_i on 2014/08/08.
//  Copyright (c) 2014年 yo_i. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface MarureKeyS : NSObject
{
    /*
    NSString *eventName;
    NSString *ekey1,*ekey2,*ekey3;
    NSString *moodyName;
    NSString *mkey1,*mkey2,*mkey3;
     */
}

@property(assign) NSString *eventName;
@property(assign) NSString *ekey1,*ekey2,*ekey3;
@property(assign) NSString *moodyName;
@property(assign) NSString *mkey1,*mkey2,*mkey3;


-(void)SetEventAndMoody:(NSInteger)eventindex moody:(NSInteger)moodyindex;

@end
