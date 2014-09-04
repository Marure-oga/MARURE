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
    //一時格納用変数
    NSString *eventName;                        //イベント名
    NSString *ekey1,*ekey2,*ekey3,*ekey4;       //イベントに紐付けキーワード
    NSString *moodyName;                        //雰囲気名
    NSString *mkey1,*mkey2,*mkey3,*mkey4;       //雰囲気名に紐付けキーワード
    //単一配列　破棄
    //NSMutableArray *recipeNameArr ,*recipeImgArr,*recipUrlArr;
    
    //結果格納する配列
    NSMutableArray *key1NameArr,*key1ImgArr,*key1UrlArr;
    NSMutableArray *key2NameArr,*key2ImgArr,*key2UrlArr;
    NSMutableArray *key3NameArr,*key3ImgArr,*key3UrlArr;
    NSMutableArray *key4NameArr,*key4ImgArr,*key4UrlArr;
}


//破棄
//@property(assign) NSString *eventName;
//@property(assign) NSString *ekey1,*ekey2,*ekey3;
//@property(assign) NSString *moodyName;
//@property(assign) NSString *mkey1,*mkey2,*mkey3;
//@property NSMutableArray *recipeNameArr ,*recipeImgArr,*recipUrlArr;

//外で呼び出せるように宣言
@property NSMutableArray *key1NameArr,*key1ImgArr,*key1UrlArr;//キーワード１に関するすべての情報
@property NSMutableArray *key2NameArr,*key2ImgArr,*key2UrlArr;//キーワード２に関するすべての情報
@property NSMutableArray *key3NameArr,*key3ImgArr,*key3UrlArr;//キーワード３に関するすべての情報
@property NSMutableArray *key4NameArr,*key4ImgArr,*key4UrlArr;//キーワード４に関するすべての情報


//イベントと雰囲気をセットする
-(void)SetEventAndMoody:(NSInteger)eventindex moody:(NSInteger)moodyindex;
//WEBAPI検索
-(void)WebSerchApi:(NSString *)keyword nameArr:(NSMutableArray *)nameArr imgArr:(NSMutableArray *)imgArr urlArr:(NSMutableArray *)urlArr;
@end
