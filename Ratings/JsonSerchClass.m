//
//  JsonSerchClass.m
//  Marure
//
//  Created by yo_i on 2014/08/08.
//  Copyright (c) 2014年 yo_i. All rights reserved.
//


#import "JsonSerchClass.h"
@implementation MarureKeyS

//破棄
//@synthesize eventName,ekey1,ekey2,ekey3,moodyName,mkey1,mkey2,mkey3,recipeArr;
//@synthesize recipeNameArr ,recipeImgArr,recipUrlArr;


@synthesize key1NameArr,key2NameArr,key3NameArr,key4NameArr;
@synthesize key1ImgArr,key2ImgArr,key3ImgArr,key4ImgArr;
@synthesize key1UrlArr,key2UrlArr,key3UrlArr,key4UrlArr;
//初期化
-(id)init
{
    //破棄
    //recipeNameArr = [NSMutableArray array];
    //recipeImgArr = [NSMutableArray array];
    //recipUrlArr = [NSMutableArray array];
    
    key1NameArr = [NSMutableArray array];
    key1ImgArr = [NSMutableArray array];
    key1UrlArr = [NSMutableArray array];
    
    key2NameArr = [NSMutableArray array];
    key2ImgArr = [NSMutableArray array];
    key2UrlArr = [NSMutableArray array];
    
    key3NameArr = [NSMutableArray array];
    key3ImgArr = [NSMutableArray array];
    key3UrlArr = [NSMutableArray array];
    
    key4NameArr = [NSMutableArray array];
    key4ImgArr = [NSMutableArray array];
    key4UrlArr = [NSMutableArray array];
    return self;
}

-(void)SetEventAndMoody:(NSInteger)eventindex moody:(NSInteger)moodyindex
{
    //キーワード格納する配列
    NSMutableArray *keyword1 = [NSMutableArray array];
    NSMutableArray *keyword2 = [NSMutableArray array];
    NSMutableArray *keyword3 = [NSMutableArray array];
    NSMutableArray *keyword4 = [NSMutableArray array];
    //ローカルファイル読み込み
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"MARUREJson" ofType:@"json"];
    NSFileHandle *filehandle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *data = [filehandle readDataToEndOfFile];
    //データセット
    if (data) {
        NSError * jsonErr = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonErr];
        if (eventindex >= 0)
        {
            //イベントのセット
            NSLog(@"eventindex >= 0");
            NSArray* arrayEvent =[dic objectForKey:@"event"];
            NSDictionary * eventDic = [arrayEvent objectAtIndex:eventindex];
            //キーワードを検索
            NSString* _eventName = [eventDic objectForKey:@"name"];
            NSString* _ekey1 = [eventDic objectForKey:@"key1"];
            NSString* _ekey2 = [eventDic objectForKey:@"key2"];
            NSString* _ekey3 = [eventDic objectForKey:@"key3"];
            NSString* _ekey4 = [eventDic objectForKey:@"key4"];
            
            //キーワードセット
            eventName = _eventName;
            self->eventName = _eventName;
            self->ekey1 = _ekey1;
            self->ekey2 = _ekey2;
            self->ekey3 = _ekey3;
            self->ekey4 = _ekey4;
            
            //キーワードが空白出はない時セットする
            if (_ekey1.length > 0){[keyword1 addObject:_ekey1];}
            if (_ekey2.length > 0){[keyword2 addObject:_ekey2];}
            if (_ekey3.length > 0){[keyword3 addObject:_ekey3];}
            if (_ekey4.length > 0){[keyword4 addObject:_ekey4];}
        }
        else
        {
            NSLog(@"eventindex < 0");
        }
        //雰囲気のセット　上と同じような処理
        if (moodyindex >= 0)
        {
            NSLog(@"modeyindex >= 0");
            NSArray* arrayMoody = [dic objectForKey:@"moody"];
            
            NSDictionary * moodyDic = [arrayMoody objectAtIndex:moodyindex];
            
            NSString* _moodyName = [moodyDic objectForKey:@"name"];
            NSString* _mkey1 = [moodyDic objectForKey:@"key1"];
            NSString* _mkey2 = [moodyDic objectForKey:@"key2"];
            NSString* _mkey3 = [moodyDic objectForKey:@"key3"];
            NSString* _mkey4 = [moodyDic objectForKey:@"key4"];
            
            self->moodyName = _moodyName;
            self->mkey1 = _mkey1;
            self->mkey2 = _mkey2;
            self->mkey3 = _mkey3;
            self->mkey4 = _mkey4;
            
            if (_mkey1.length > 0){[keyword1 addObject:_mkey1];}
            if (_mkey2.length > 0){[keyword2 addObject:_mkey2];}
            if (_mkey3.length > 0){[keyword3 addObject:_mkey3];}
            if (_mkey4.length > 0){[keyword4 addObject:_mkey4];}
        }
        else
        {
            NSLog(@"modeyindex < 0");
        }
        
    }
    else
    {
        NSLog(@"file is missing.");
    }
    NSLog(@"keyword set");
    const float intervalTime = 1.0;//   webapi検索のため最小間隔時間
    //キーワードによる検索
    for (NSString *str in keyword1)
    {
        [self WebSerchApi:str nameArr:key1NameArr imgArr:key1ImgArr urlArr:key1UrlArr];
        [NSThread sleepForTimeInterval:intervalTime];
    }
    
    for (NSString *str in keyword2)
    {
        [self WebSerchApi:str nameArr:key2NameArr imgArr:key2ImgArr urlArr:key2UrlArr];
        [NSThread sleepForTimeInterval:intervalTime];
    }
    for (NSString *str in keyword3)
    {
        [self WebSerchApi:str nameArr:key3NameArr imgArr:key3ImgArr urlArr:key3UrlArr];
        [NSThread sleepForTimeInterval:intervalTime];
    }
    for (NSString *str in keyword4)
    {
        [self WebSerchApi:str nameArr:key4NameArr imgArr:key4ImgArr urlArr:key4UrlArr];
        [NSThread sleepForTimeInterval:intervalTime];
    }
    
}

-(void)WebSerchApi:(NSString *)keyword nameArr:(NSMutableArray *)nameArr imgArr:(NSMutableArray *)imgArr urlArr:(NSMutableArray *)urlArr
{
    //~~~~~~~~~~テスト　ローカルファイルを使う~~~~~~~~~~~~~~~
    /*
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"webapi" ofType:@"json"];
    NSFileHandle *filehandle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *data = [filehandle readDataToEndOfFile];
    */
    
    //=================本番webapi使う=================
    
     NSString *str = [NSString stringWithFormat:@"https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20121121?format=json&categoryId=%@&applicationId=1055797974705259361",keyword];
     NSURL *jsonUrl = [NSURL URLWithString:str];
     NSData *data = [NSData dataWithContentsOfURL:jsonUrl options:kNilOptions error:nil];

    //検索結果をセット
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
            
            //破棄
            //[self->recipeNameArr addObject:recipName];
            //[self->recipeImgArr addObject:recipImage];
            //[self->recipUrlArr addObject:recipURL];
            
            //引数の配列にセット
            [nameArr addObject:recipName];
            [imgArr addObject:recipImage];
            [urlArr addObject:recipURL];
            
            NSLog(@"key = %@ \n",keyword);
            //NSLog(@"name = %@ \n",recipName);
            
        }
        
    }
    else
    {
        NSLog(@"some error.");
    }
}

@end