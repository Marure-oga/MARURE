//
//  JsonSerchClass.m
//  Marure
//
//  Created by yo_i on 2014/08/08.
//  Copyright (c) 2014年 yo_i. All rights reserved.
//


#import "JsonSerchClass.h"
//url https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20121121?format=json&categoryId=10&applicationId=1055797974705259361
@implementation MarureKeyS

//@synthesize eventName,ekey1,ekey2,ekey3,moodyName,mkey1,mkey2,mkey3,recipeArr;
@synthesize recipeNameArr ,recipeImgArr,recipUrlArr;
-(id)init
{
    recipeNameArr = [NSMutableArray array];
    recipeImgArr = [NSMutableArray array];
    recipUrlArr = [NSMutableArray array];
    return self;
}

-(void)SetEventAndMoody:(NSInteger)eventindex moody:(NSInteger)moodyindex
{
    NSMutableArray *keyword = [NSMutableArray array];
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
        
        if (_ekey1.length > 0){[keyword addObject:_ekey1];}
        if (_ekey2.length > 0){[keyword addObject:_ekey2];}
        if (_ekey3.length > 0){[keyword addObject:_ekey3];}
        
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
        
        if (_mkey1.length > 0){[keyword addObject:_mkey1];}
        if (_mkey2.length > 0){[keyword addObject:_mkey2];}
        if (_mkey3.length > 0){[keyword addObject:_mkey3];}
        
    }
    else
    {
        NSLog(@"file is missing.");
    }
    
    
    for (NSString *str in keyword)
    {
        [self WebSerchApi:str];
        [NSThread sleepForTimeInterval:1.0];
    }
    
}

-(void)WebSerchApi:(NSString *)keyword
{
    //~~~~~~~~~~テスト　ローカルファイルを使う~~~~~~~~~~~~~~~
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"webapi" ofType:@"json"];
    NSFileHandle *filehandle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *data = [filehandle readDataToEndOfFile];
    
    
    //=================本番webapi使う=================
    /*
     NSString *str = [NSString stringWithFormat:@"https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20121121?format=json&categoryId=%@&applicationId=1055797974705259361",keyword];
     NSURL *jsonUrl = [NSURL URLWithString:str];
     NSData *data = [NSData dataWithContentsOfURL:jsonUrl options:kNilOptions error:nil];
     */
    
    if(data)
    {
        NSError * jsonErr = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonErr];
        
        
        NSArray *resultArr = [dic objectForKey:@"result"];
        for(int i = 0 ; i < resultArr.count ; i++)
        {
            NSDictionary *resultDic = [resultArr objectAtIndex:i];
            NSString *recipName     = [resultDic objectForKey:@"recipeTitle"];
            NSString *recipURL      = [resultDic objectForKey:@"recipeUrl"];
            NSString *recipImage    = [resultDic objectForKey:@"foodImageUrl"];
            
            [self->recipeNameArr addObject:recipName];
            [self->recipeImgArr addObject:recipImage];
            [self->recipUrlArr addObject:recipURL];
            
            NSLog(@"key = %@ \n",keyword);
            NSLog(@"name = %@ \n",recipName);
            
        }
        
    }
    else
    {
        NSLog(@"some error.");
    }
}

@end