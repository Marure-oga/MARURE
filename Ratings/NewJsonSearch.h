#import <Foundation/Foundation.h>

@interface NewJsonSearch : NSObject
{
    //結果格納する配列
    NSMutableArray *key1NameArr,*key1ImgArr,*key1UrlArr;
    NSMutableArray *key2NameArr,*key2ImgArr,*key2UrlArr;
    NSMutableArray *key3NameArr,*key3ImgArr,*key3UrlArr;
    NSMutableArray *key4NameArr,*key4ImgArr,*key4UrlArr;
    
    //NSString *SyusaiKey01,*SyusaiKey02;
    //NSString *HuksaiKey01,*HuksaiKey02;
    //NSString *DesertKey01,*DesertKey02;
    //NSString *DrinkKey01 ,*DrinkKey02;
}
@property NSMutableArray *key1NameArr,*key1ImgArr,*key1UrlArr;//キーワード１に関するすべての情報
@property NSMutableArray *key2NameArr,*key2ImgArr,*key2UrlArr;//キーワード２に関するすべての情報
@property NSMutableArray *key3NameArr,*key3ImgArr,*key3UrlArr;//キーワード３に関するすべての情報
@property NSMutableArray *key4NameArr,*key4ImgArr,*key4UrlArr;//キーワード４に関するすべての情報

-(void)SetMarureKeyword:(NSInteger)eventindex moody:(NSInteger)moodyindex;
-(void)MarureWebRequest:(NSString *)keyword nameArr:(NSMutableArray *)nameArr imgArr:(NSMutableArray *)imgArr urlArr:(NSMutableArray *)urlArr;
@end