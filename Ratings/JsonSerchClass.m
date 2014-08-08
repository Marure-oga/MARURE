//
//  JsonSerchClass.m
//  Marure
//
//  Created by yo_i on 2014/08/08.
//  Copyright (c) 2014年 yo_i. All rights reserved.
//


#import "JsonSerchClass.h"



@implementation MarureKeyS

@synthesize eventName,ekey1,ekey2,ekey3,moodyName,mkey1,mkey2,mkey3;

-(void)SetEventAndMoody:(NSInteger)eventindex moody:(NSInteger)moodyindex
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"MARUREJson" ofType:@"json"];
    NSFileHandle *filehandle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *data = [filehandle readDataToEndOfFile];
    
    if (data) {
        NSError * jsonErr = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonErr];
        
        
        
        NSArray* arrayEvent =[dic objectForKey:@"event"];
        NSDictionary * eventDic = [arrayEvent objectAtIndex:eventindex];
        
        NSString* _eventName = [eventDic objectForKey:@"name"];
        NSString* _ekey1 = [eventDic objectForKey:@"key1"];
        NSString* _ekey2 = [eventDic objectForKey:@"key2"];
        NSString* _ekey3 = [eventDic objectForKey:@"key3"];
        
        eventName = _eventName;
        self->eventName = _eventName;
        self->ekey1 = _ekey1;
        self->ekey2 = _ekey2;
        self->ekey3 = _ekey3;

        
        NSArray* arrayMoody = [dic objectForKey:@"moody"];
        
        NSDictionary * moodyDic = [arrayMoody objectAtIndex:moodyindex];
        
        NSString* _moodyName = [moodyDic objectForKey:@"name"];
        NSString* _mkey1 = [moodyDic objectForKey:@"key1"];
        NSString* _mkey2 = [moodyDic objectForKey:@"key2"];
        NSString* _mkey3 = [moodyDic objectForKey:@"key3"];
        
        self->moodyName = _moodyName;
        self->mkey1 = _mkey1;
        self->mkey2 = _mkey2;
        self->mkey3 = _mkey3;
        
    }
    else
    {
        NSLog(@"file is missing.");
    }

}

@end