#import "NewJsonSearch.h"

@implementation NewJsonSearch

@synthesize key1NameArr,key2NameArr,key3NameArr,key4NameArr;
@synthesize key1ImgArr,key2ImgArr,key3ImgArr,key4ImgArr;
@synthesize key1UrlArr,key2UrlArr,key3UrlArr,key4UrlArr;

//初期化
-(id)init
{
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

/**
 *引数：
 *　eventindex : ユーザーが選択したイベントのインデックス
 *　moodyindex : ユーザーが選択した雰囲気のインデックス
 */
-(void)SetMarureKeyword:(NSInteger)eventindex moody:(NSInteger)moodyindex
{
    //キーワード格納用の配列
    NSMutableArray *KeyRecipe01 = [NSMutableArray array];//主菜
    NSMutableArray *KeyRecipe02 = [NSMutableArray array];//副菜
    NSMutableArray *KeyRecipe03 = [NSMutableArray array];//デザート
    NSMutableArray *KeyRecipe04 = [NSMutableArray array];//ドリンク
    //バンドルの取得
    NSBundle *bundle = [NSBundle mainBundle];
    //バンドルから指定したリソース(jsonファイル)のパスを取得
    NSString *path = [bundle pathForResource:@"KeyDefine" ofType:@"json"];
    //jsonファイルハンドラの取得
    NSFileHandle *filehandle = [NSFileHandle fileHandleForReadingAtPath:path];
    //jsonファイルの内容を読み込み変数jsonDataに格納
    NSData *jsonData = [filehandle readDataToEndOfFile];
    
    if (jsonData) {
        NSError * jsonErr = nil;
        //NSDataからJsonオブジェクトにコンバート
        NSDictionary * AllJsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&jsonErr];
        //KeySearchListをNSArrayに格納
        NSArray * arrayEvent = [AllJsonDic objectForKey:@"SearchKeyList"];
        //選択されたイベントのインデックスから、該当するイベントのJsonオブジェクトを特定
        NSDictionary * SelectEventDic = [arrayEvent objectAtIndex:eventindex];
        
        //※雰囲気インデックスのランダム機能が出来るまでの対応
        //if(moodyindex < 0) moodyindex = 0;
        
        //主菜のAPI用カテゴリIDを格納
        NSArray * arraySyusai01 = [SelectEventDic objectForKey:@"Syusai01"];
        [KeyRecipe01 addObject:[arraySyusai01 objectAtIndex:moodyindex]];
        NSArray * arraySyusai02 = [SelectEventDic objectForKey:@"Syusai02"];
        [KeyRecipe01 addObject:[arraySyusai02 objectAtIndex:moodyindex]];
        //副菜のAPI用カテゴリIDを格納
        NSArray * arrayHuksai01 = [SelectEventDic objectForKey:@"Huksai01"];
        [KeyRecipe02 addObject:[arrayHuksai01 objectAtIndex:moodyindex]];
        NSArray * arrayHuksai02 = [SelectEventDic objectForKey:@"Huksai02"];
        [KeyRecipe02 addObject:[arrayHuksai02 objectAtIndex:moodyindex]];
        //デザートのAPI用カテゴリIDを格納
        NSArray * arrayDesert01 = [SelectEventDic objectForKey:@"Desert01"];
        [KeyRecipe03 addObject:[arrayDesert01 objectAtIndex:moodyindex]];
        NSArray * arrayDesert02 = [SelectEventDic objectForKey:@"Desert02"];
        [KeyRecipe03 addObject:[arrayDesert02 objectAtIndex:moodyindex]];
        //ドリンクのAPI用カテゴリIDを格納
        NSArray * arrayDrink01 = [SelectEventDic objectForKey:@"Drink01"];
        [KeyRecipe04 addObject:[arrayDrink01 objectAtIndex:moodyindex]];
        NSArray * arrayDrink02 = [SelectEventDic objectForKey:@"Drink01"];
        [KeyRecipe04 addObject:[arrayDrink02 objectAtIndex:moodyindex]];
    }
    
    //APIリクエスト送信間隔を設定
    const float intervalTime = 1.0;
    
    for (NSString *str in KeyRecipe01) {
        //主菜のカテゴリIDをAPIに投げる
        [self MarureWebRequest:str nameArr:key1NameArr imgArr:key1ImgArr urlArr:key1UrlArr];
        //カテゴリID１つに対して1s待機
        [NSThread sleepForTimeInterval:intervalTime];
    }
    for (NSString *str in KeyRecipe02) {
        //副菜のカテゴリIDをAPIに投げる
        [self MarureWebRequest:str nameArr:key2NameArr imgArr:key2ImgArr urlArr:key2UrlArr];
        //カテゴリID１つに対して1s待機
        [NSThread sleepForTimeInterval:intervalTime];
    }
    for (NSString *str in KeyRecipe03) {
        //デザートのカテゴリIDをAPIに投げる
        [self MarureWebRequest:str nameArr:key3NameArr imgArr:key3ImgArr urlArr:key3UrlArr];
        //カテゴリID１つに対して1s待機
        [NSThread sleepForTimeInterval:intervalTime];
    }
    for (NSString *str in KeyRecipe04) {
        //ドリンクのカテゴリIDをAPIに投げる
        [self MarureWebRequest:str nameArr:key4NameArr imgArr:key4ImgArr urlArr:key4UrlArr];
        //カテゴリID１つに対して1s待機
        [NSThread sleepForTimeInterval:intervalTime];
    }
}

-(void)MarureWebRequest:(NSString *)keyword nameArr:(NSMutableArray *)nameArr imgArr:(NSMutableArray *)imgArr urlArr:(NSMutableArray *)urlArr
{
    //取得したカテゴリIDを楽天レシピURLに追加
    NSString *str = [NSString stringWithFormat:@"https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20121121?format=json&categoryId=%@&applicationId=1055797974705259361",keyword];
    //NSURLに変換
    NSURL *jsonUrl = [NSURL URLWithString:str];
    //NSDataに変換
    NSData *data = [NSData dataWithContentsOfURL:jsonUrl options:kNilOptions error:nil];
    
    NSError * jsonErr = nil;
    
    if(data){
        //楽天レシピAPIのリクエスト実行
        NSDictionary *Resultdic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonErr];
        //リクエストの返却値をNSDicからNSArrayに変換
        NSArray *resultArr = [Resultdic objectForKey:@"result"];
        
        //APIリクエストの返却値のカウント分ループ
        for (int i = 0 ;i < resultArr.count; i++) {
            //ネストされているJsonオブジェクトを格納
            NSDictionary *_ResultDic = [resultArr objectAtIndex:i];
            //タイトル文字列格納
            [nameArr addObject:[_ResultDic objectForKey:@"recipeTitle"]];
            //イメージURL文字列格納
            [imgArr addObject:[_ResultDic objectForKey:@"foodImageUrl"]];
            //レシピのWEBサイトURL文字列を格納
            [urlArr addObject:[_ResultDic objectForKey:@"recipeUrl"]];
        }
    }
    else{
        NSLog(@"Error GetRequest");
    }
    
}

@end
