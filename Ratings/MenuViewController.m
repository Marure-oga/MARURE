//
//  MenuViewController.m
//  Ratings
//
//  Created by MASTER on 2014/08/18.
//  Copyright (c) 2014年 Yuta.Kasiwabara. All rights reserved.
//

#import "MenuViewController.h"
//左から表示させるアニメーションのために必要
#import <QuartzCore/QuartzCore.h>

@interface MenuViewController ()
@end

@implementation MenuViewController


//Send_Flag : 画面3で選択したボタン
// -1: 画面4の戻るボタン
// 0 : 戻るボタン
// 1 : 献立（上）
// 2 : 献立（下）
int Send_Flag;

NSString *Url_Str;
NSString *Name_Str;
NSString *R_Url_Str;

NSURL *Img_URL;
NSData *Img_Data;
UIImage *Recipe_Img;

MarureKeyS *mrks;


//料理の画像URL格納用配列
//主菜
NSMutableArray *Select_URL_1;
//副菜
NSMutableArray *Select_URL_2;
//デザート
NSMutableArray *Select_URL_3;
//ドリンク
NSMutableArray *Select_URL_4;

//ウェブサイトのURL格納配列
//主菜
NSMutableArray *Recipe_URL_1;
//副菜
NSMutableArray *Recipe_URL_2;
//デザート
NSMutableArray *Recipe_URL_3;
//ドリンク
NSMutableArray *Recipe_URL_4;

//レシピタイトルの格納配列
//主菜
NSMutableArray *Recipe_Title_Arr_1;
//副菜
NSMutableArray *Recipe_Title_Arr_2;
//デザート
NSMutableArray *Recipe_Title_Arr_3;
//ドリンク
NSMutableArray *Recipe_Title_Arr_4;

//Menu_Image_01〜Menu_Image_08に対応するレシピ番号
//(0:1つ目の献立の主菜　1:1つ目の献立の副菜　2:1つ目の献立のデザート　3:1つ目の献立のドリンク)
//(4:2つ目の献立の主菜　1:2つ目の献立の副菜　2:2つ目の献立のデザート　3:一2目の献立のドリンク)
NSMutableArray *indexnumber;
//今表示されている料理の画像の番号
NSMutableArray *nownumber;

//ネットワークに接続しているかを判断する時間（秒）
double searchTime;
//並列処理　メイン処理
dispatch_queue_t mainQueue;
//並列処理　サブ処理
dispatch_queue_t subQueue;
//どのボタンが押されたかを数字で保存
int buttontapped = -1;

//最初にMenu_Img_Changeを呼び出したときnownumberResetを呼び出す
bool hantei0 = true;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//献立の情報取得
- (Boolean)Menu_Img_GET
{
    mrks = [[MarureKeyS alloc]init];
    
    Select_URL_1 = [NSMutableArray array];
    Select_URL_2 = [NSMutableArray array];
    Select_URL_3 = [NSMutableArray array];
    Select_URL_4 = [NSMutableArray array];
    
    
    Recipe_URL_1 = [NSMutableArray array];
    Recipe_URL_2 = [NSMutableArray array];
    Recipe_URL_3 = [NSMutableArray array];
    Recipe_URL_4 = [NSMutableArray array];
    
    Recipe_Title_Arr_1 = [NSMutableArray array];
    Recipe_Title_Arr_2 = [NSMutableArray array];
    Recipe_Title_Arr_3 = [NSMutableArray array];
    Recipe_Title_Arr_4 = [NSMutableArray array];
    
    int i;
    
    //ユーザーが選択した検索条件をAPIに投げる
    //テスト用：
    //[mrks SetEventAndMoody:0 moody:0];
    //本番用
    [mrks SetEventAndMoody:Event_NO moody:Ambience_NO];
    
    //=========================nilチェック=========================
    if ([mrks.key1ImgArr count] > 0) {
        NSLog(@"Key1ImgArr COUNT = %d\n",[mrks.key1ImgArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey1ImgArr COUNT = %d\n",[mrks.key1ImgArr count]);
        return false;
    }
    
    if ([mrks.key2ImgArr count] > 0) {
        NSLog(@"Key2ImgArr COUNT = %d\n",[mrks.key2ImgArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey2ImgArr COUNT = %d\n",[mrks.key2ImgArr count]);
        return false;
    }
    
    if ([mrks.key3ImgArr count] > 0) {
        NSLog(@"Key3ImgArr COUNT = %d\n",[mrks.key3ImgArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey3ImgArr COUNT = %d\n",[mrks.key3ImgArr count]);
        return false;
    }
    
    if ([mrks.key4ImgArr count] > 0) {
        NSLog(@"Key4ImgArr COUNT = %d\n",[mrks.key4ImgArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey4ImgArr COUNT = %d\n",[mrks.key4ImgArr count]);
        return false;
    }
    
    if ([mrks.key1NameArr count] > 0) {
        NSLog(@"Key1NameArr COUNT = %d\n",[mrks.key1NameArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey1NameArr COUNT = %d\n",[mrks.key1NameArr count]);
        return false;
    }
    
    if ([mrks.key2NameArr count] > 0) {
        NSLog(@"Key2NameArr COUNT = %d\n",[mrks.key2NameArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey2NameArr COUNT = %d\n",[mrks.key2NameArr count]);
        return false;
    }
    
    if ([mrks.key3NameArr count] > 0) {
        NSLog(@"Key3NameArr COUNT = %d\n",[mrks.key3NameArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey3NameArr COUNT = %d\n",[mrks.key3NameArr count]);
        return false;
    }
    
    if ([mrks.key4NameArr count] > 0) {
        NSLog(@"Key4NameArr COUNT = %d\n",[mrks.key4NameArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey4NameArr COUNT = %d\n",[mrks.key4NameArr count]);
        return false;
    }
    
    if ([mrks.key1UrlArr count] > 0) {
        NSLog(@"Key1UrlArr COUNT = %d\n",[mrks.key1UrlArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey1UrlArr COUNT = %d\n",[mrks.key1NameArr count]);
        return false;
    }
    
    if ([mrks.key2UrlArr count] > 0) {
        NSLog(@"Key2UrlArr COUNT = %d\n",[mrks.key2UrlArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey2UrlArr COUNT = %d\n",[mrks.key2UrlArr count]);
        return false;
    }
    
    if ([mrks.key3UrlArr count] > 0) {
        NSLog(@"Key3UrlArr COUNT = %d\n",[mrks.key3UrlArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey3UrlArr COUNT = %d\n",[mrks.key3UrlArr count]);
        return false;
    }
    
    if ([mrks.key4UrlArr count] > 0) {
        NSLog(@"Key4UrlArr COUNT = %d\n",[mrks.key4UrlArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey4UrlArr COUNT = %d\n",[mrks.key4UrlArr count]);
        return false;
    }
    
    
    //==================================================
    

    //APIからの返却数までループ
    for(i = 0;i < [mrks.key1ImgArr count];i++){
        
        //主菜の画像URLの文字列格納
        Url_Str = [mrks.key1ImgArr objectAtIndex:i];
        //主菜のレシピタイトルの文字列格納
        Name_Str = [mrks.key1NameArr objectAtIndex:i];
        //主菜のレシピURLの文字列格納
        R_Url_Str = [mrks.key1UrlArr objectAtIndex:i];

        [self Menu_Img_UrlSet:0];
    }
    for(i = 0;i < [mrks.key2ImgArr count];i++){
        //副菜の画像URLの文字列格納
        Url_Str = [mrks.key2ImgArr objectAtIndex:i];
        //副菜のレシピタイトルの文字列格納
        Name_Str = [mrks.key2NameArr objectAtIndex:i];
        //副菜のレシピURLの文字列格納
        R_Url_Str = [mrks.key2UrlArr objectAtIndex:i];
                
        [self Menu_Img_UrlSet:1];
    }
    for (i = 0; i < [mrks.key3ImgArr count]; i++) {
        //デザートの画像URLの文字列格納
        Url_Str = [mrks.key3ImgArr objectAtIndex:i];
        //デザートのレシピタイトルの文字列格納
        Name_Str = [mrks.key3NameArr objectAtIndex:i];
        //デザートのレシピURLの文字列格納
        R_Url_Str = [mrks.key3UrlArr objectAtIndex:i];
                
        [self Menu_Img_UrlSet:2];
    }
    for (i = 0; i < [mrks.key4ImgArr count]; i++) {
        //ドリンクの画像URLの文字列格納
        Url_Str = [mrks.key4ImgArr objectAtIndex:i];
        //ドリンクのレシピタイトルの文字列格納
        Name_Str = [mrks.key4NameArr objectAtIndex:i];
        //ドリンクのレシピURLの文字列格納
        R_Url_Str = [mrks.key4UrlArr objectAtIndex:i];
        
        [self Menu_Img_UrlSet:3];
    }
    return true;
}

//文字列を表示可能な型に変換・格納処理
- (Boolean)Menu_Img_UrlSet:(NSInteger)Category_Num
{
    /*
     Category_Num
     
     0:主菜
     1:副菜
     2:デザート
     3:ドリンク
     */
    
    //レシピ画像URLの文字列をNSURL型に変換し格納
    if(Url_Str.length > 0){
        Img_URL = [NSURL URLWithString:Url_Str];
    }
    else{
        NSLog(@"ERROR!! Url_Str.LENGTH = %d",Url_Str.length);
        return false;
    }
    
    //レシピ画像URLのNSURL型をNSData型に変換し格納
    if (Img_URL != nil) {
        Img_Data = [NSData dataWithContentsOfURL:Img_URL];
    }
    else{
        NSLog(@"ERROR!! Img_Data = nil");
        return false;
    }
    
    //レシピ画像URLのNSData型をUIImage型に変換し格納
    if (Img_Data != nil) {
        Recipe_Img = [UIImage imageWithData:Img_Data];
    }
    else{
        NSLog(@"ERROR!! Recipe_Img = nil");
        return false;
    }
    
    switch (Category_Num) {
        case 0:
            //主菜の料理画像URL情報を格納
            [Select_URL_1 addObject:Recipe_Img];
            [Recipe_Title_Arr_1 addObject:Name_Str];
            [Recipe_URL_1 addObject:R_Url_Str];
            break;
        case 1:
            //副菜の料理画像URL情報を格納
            [Select_URL_2 addObject:Recipe_Img];
            [Recipe_Title_Arr_2 addObject:Name_Str];
            [Recipe_URL_2 addObject:R_Url_Str];
            break;
        case 2:
            //デザートの料理画像URL情報を格納
            [Select_URL_3 addObject:Recipe_Img];
            [Recipe_Title_Arr_3 addObject:Name_Str];
            [Recipe_URL_3 addObject:R_Url_Str];
            break;
        case 3:
            //ドリンクの料理画像URL情報を格納
            [Select_URL_4 addObject:Recipe_Img];
            [Recipe_Title_Arr_4 addObject:Name_Str];
            [Recipe_URL_4 addObject:R_Url_Str];
            break;
        default:
            NSLog(@"不正な引数が入力されました。\n");
            return false;
            break;
    }
    
    return true;
}

//料理画像の表示処理
- (void)Menu_Img_Show
{
    //画面4から遷移していない場合
    if (Send_Flag != -1)
    {
        if(hantei0)
        {
            [self nownumberReset];
        }
        
        indexnumber = [NSMutableArray array];
        
        //Menu_Img_Changeを８回呼び出す　引数１：ImgNumber(0〜7) 引数２：maxNumber（APIからの戻り値により変動）
        for(int i = 0; i < 2; i++)
        {
            [self Menu_Img_Change:0 + 4 * i maxNumber:[Select_URL_1 count]];
            [self Menu_Img_Change:1 + 4 * i maxNumber:[Select_URL_2 count]];
            [self Menu_Img_Change:2 + 4 * i maxNumber:[Select_URL_3 count]];
            [self Menu_Img_Change:3 + 4 * i maxNumber:[Select_URL_4 count]];
        }
        
        
        
        NSLog(@"--------------------------------");
        NSLog(@"Send?flg%d",Send_Flag);
        NSLog(@"now");
        for(int i = 0;i < 2; i++){
            NSLog(@"(%d)%d (%d)%d",0 + 4 * i,[[nownumber objectAtIndex:0 + 4 * i] intValue],
                  1 + 4 * i,[[nownumber objectAtIndex:1 + 4 * i] intValue]);
            NSLog(@"(%d)%d (%d)%d",2 + 4 * i,[[nownumber objectAtIndex:2 + 4 * i] intValue],
                  3 + 4 * i,[[nownumber objectAtIndex:3 + 4 * i] intValue]);
        }
        NSLog(@"index");
        for(int i = 0;i < 2; i++){
            NSLog(@"(%d)%d (%d)%d",0 + 4 * i,[[indexnumber objectAtIndex:0 + 4 * i] intValue],
                  1 + 4 * i,[[indexnumber objectAtIndex:1 + 4 * i] intValue]);
            NSLog(@"(%d)%d (%d)%d",2 + 4 * i,[[indexnumber objectAtIndex:2 + 4 * i] intValue],
                  3 + 4 * i,[[indexnumber objectAtIndex:3 + 4 * i] intValue]);
        }
        NSLog(@"--------------------------------");
        
        //今回の処理でindexnumberにセットされた値をnownumberにセット
        nownumber = [NSMutableArray array];
        for(int i = 0;i < 8; i++){
            [nownumber addObject:[indexnumber objectAtIndex:i]];
        }
    }
    NSLog(@"画面3:Send_Flag = %d\n",Send_Flag);
    //Send_Flag = 0;
    
    
    //====================献立.1====================
    //主菜
    //self.Menu_Image_01.image = [Select_URL_1 objectAtIndex:Select_Index];
    self.Menu_Image_01.image = [Select_URL_1 objectAtIndex:[[indexnumber objectAtIndex:0] intValue]];
    
    //副菜
    //self.Menu_Image_02.image = [Select_URL_2 objectAtIndex:Select_Index];
    self.Menu_Image_02.image = [Select_URL_2 objectAtIndex:[[indexnumber objectAtIndex:1] intValue]];
    
    //デザート
    //self.Menu_Image_03.image = [Select_URL_3 objectAtIndex:Select_Index];
    self.Menu_Image_03.image = [Select_URL_3 objectAtIndex:[[indexnumber objectAtIndex:2] intValue]];

    //ドリンク
    //self.Menu_Image_04.image = [Select_URL_4 objectAtIndex:Select_Index];
    self.Menu_Image_04.image = [Select_URL_4 objectAtIndex:[[indexnumber objectAtIndex:3] intValue]];
    
    //====================献立.2====================
    //主菜
    //self.Menu_Image_05.image = [Select_URL_1 objectAtIndex:Select_Index];
    self.Menu_Image_05.image = [Select_URL_1 objectAtIndex:[[indexnumber objectAtIndex:4] intValue]];

    //副菜
    //self.Menu_Image_06.image = [Select_URL_2 objectAtIndex:Select_Index];
    self.Menu_Image_06.image = [Select_URL_2 objectAtIndex:[[indexnumber objectAtIndex:5] intValue]];
    
    //デザート
    //self.Menu_Image_07.image = [Select_URL_3 objectAtIndex:Select_Index];
    self.Menu_Image_07.image = [Select_URL_3 objectAtIndex:[[indexnumber objectAtIndex:6] intValue]];

    //ドリンク
    //self.Menu_Image_08.image = [Select_URL_4 objectAtIndex:Select_Index];
    self.Menu_Image_08.image = [Select_URL_4 objectAtIndex:[[indexnumber objectAtIndex:7] intValue]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *Merge_Text;
    
    if (Ambience_NO == -1) {
        Merge_Text = Event_Str;
    }
    else{
        Merge_Text = [Event_Str stringByAppendingFormat:@" × %@",Ambience_Str];
    }
    // Do any additional setup after loading the view.
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.font = [UIFont boldSystemFontOfSize:16.0];
    title.textColor = [UIColor whiteColor];
    title.text = Merge_Text;
    [title sizeToFit];
    
    self.navigationItem.titleView = title;
    
    //画面2から遷移した場合
    if(Send_Flag != -1)
    {
        //取得した文字列から画像表示するための前処理
        if([self Menu_Img_GET]){
            //APIからの返却数が正常だった場合
            //画像の表示処理
            [self Menu_Img_Show];
        }
        else{
            NSLog(@"API取得値が不正\n");
            [self showAlert:@"エラー" MESSAGE_Str:@"献立の取得に失敗しました。" CANCEL_Str:nil OTHER_Str:@"はい"];
            [self previousPage];
        }
    }
    else if(Send_Flag == -1){
        [self Menu_Img_Show];
        Send_Flag = 0;
    }
    
    //右へスワイプしたときの処理
    UISwipeGestureRecognizer *swiperight = [[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(swipe:)];
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
    swiperight.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swiperight];
    
    //左へスワイプしたときの処理
    UISwipeGestureRecognizer *swipeleft = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(swipe:)];
    swipeleft.direction = UISwipeGestureRecognizerDirectionRight;
    swipeleft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeleft.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipeleft];
    
    searchTime = 5.0;
    buttontapped = -1;
    
    //メイン処理とサブ処理を設定
    mainQueue = dispatch_get_main_queue();
    subQueue = dispatch_queue_create("sub1",0);
    
    //デフォルトのBACKボタンの非表示
    [self.navigationItem setHidesBackButton:YES animated:NO];
    //戻るボタンの追加
    UIBarButtonItem* backButton =[[UIBarButtonItem alloc]
                                  initWithTitle:@"戻る"
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(BackBtn)];
    self.navigationItem.leftBarButtonItems = @[backButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//=======================各ボタン押下時の処理===========================


//戻るボタンを押したとき左から前の画面を出す
-(void)BackBtn
{
    [self previousPage];
}

- (IBAction)Menu_01:(id)sender {
    buttontapped = 1;
    dispatch_async(mainQueue,^{
        [self mainQueueMethod];
    });
    //Send_Flag = 1;
    //NSLog(@"\nSend_Flag = %d\n",Send_Flag);
}
- (IBAction)Menu_02:(id)sender {
    buttontapped = 2;
    dispatch_async(mainQueue,^{
        [self mainQueueMethod];
    });
    //Send_Flag = 2;
    //NSLog(@"\nSend_Flag = %d\n",Send_Flag);
}


//=======================献立切り替え時の処理===========================

//スワイプしたときMenu_Img_Changeを呼び出し、その後Menu_Img_Showを呼び出す
-(void)swipe:(UISwipeGestureRecognizer *)gesture
{
    [self Menu_Img_Show];
}

//nownumberに-1をセット
-(void)nownumberReset
{
    hantei0 = false;
    nownumber = [NSMutableArray array];
    for(int i = 0;i < 8; i++){
        [nownumber addObject:@"-1"];
    }
}

//表示されているメニューの画像をランダムに更新する　引数１：ImgNumber(0〜7) 引数２：maxNumber（APIからの戻り値により変動）
-(void)Menu_Img_Change:(int)ImgNumber maxNumber:(int)maxNumber
{
    int random = 0;
    bool hantei = false;
    
    //まだ選ばれていないレシピ番号が出るまで乱数を発生させる
    do{
        random = (int)(arc4random() % maxNumber);
        hantei = false;
        //ImgNumberが4未満のとき、直前の献立ての同じカテゴリで選ばれていない番号がでるまでループ
        if(ImgNumber < 4){
            if([[nownumber objectAtIndex:ImgNumber] intValue] == random
                ||[[nownumber objectAtIndex:(ImgNumber+4)] intValue] == random){
                hantei = true;
            }
        //ImgNumberが4以上のとき、直前の献立ての同じカテゴリと今回の処理の一つ目の献立で選ばれていない番号がでるまでループ
        }else{
            if([[nownumber objectAtIndex:ImgNumber] intValue] == random
                ||[[nownumber objectAtIndex:(ImgNumber-4)] intValue] == random
                ||[[indexnumber objectAtIndex:(ImgNumber-4)] intValue] == random){
                hantei = true;
            }
        }
        
        //発生した値が今表示されている料理の番号でないなら発生した値がすでにあるかどうかの判定（すでにあるならもう一度ループ）
        /*if(!(hantei)){
            for(int j =0;j<i;j++){
                if([[indexnumber objectAtIndex:j] intValue] == random){
                    hantei = true;
                    break;
                }
            }
        }*/
    }while(hantei);
        
    [indexnumber addObject:[NSNumber numberWithInteger:random]];
}

//=======================ネットワーク接続確認===========================

//メイン処理　最初のネットワーク接続確認を実行　プログレスバーの表示
-(void)mainQueueMethod
{
    [self network_first];
}

//サブ処理　ネットワーク接続確認（２回目以降）を実行
-(void)subQueueMethod
{
    [self network];
}

//ネットワーク接続判定１回目
-(void)network_first
{
    Boolean accessstate = false;
    
    //networksearchメソッドの呼び出し
    accessstate = [self networksearch];
    //networkaccessHanteiメソッドの呼び出し
    [self networkaccessHantei:accessstate];
    
}

//ネットワーク接続判定２回目以降
-(void)network
{
    //ネットワーク接続が確認できたかどうか
    Boolean accessstate = false;
    
    //このメソッドが呼び出された時間の変数
    NSDate *startDate;
    //startDateからどれほど時間がたったかをはかるための変数
    NSDate *endDate;
    //startDateからendDateまでにかかっった時間
    NSTimeInterval interval;
    
    startDate = [NSDate date];
    
    //ネットワーク接続確認がとれるかserrchTimeで設定した時間がたつまで　networksearchメソッドを呼び出すことを繰り返す
    do{
        accessstate = [self networksearch];
        endDate = [NSDate date];
        interval = [endDate timeIntervalSinceDate:startDate];
    }while(accessstate == false && interval <= searchTime);
    NSLog(@"ループを抜けた");
    
    //networkaccsessHanteiメソッドの呼び出し
    [self networkaccessHantei:accessstate];
}

//ネットワーク接続判定を行うメソッド
-(Boolean)networksearch
{
    //ネットワーク接続ができているかどうかの変数
    Boolean networkaccess = false;
    
    //ネットワーク接続確認
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus =[curReach currentReachabilityStatus];
    
    if(netStatus == NotReachable){
        //ネットワーク説毒ができていないとき
        networkaccess = false;
    }else{
        //ネットワーク接続ができているとき
        networkaccess = true;
    }
    
    return networkaccess;
}

//ネットワーク接続ができているかどうか
-(void)networkaccessHantei:(Boolean)accessstate
{
    if(accessstate){
        NSLog(@"画面3:ネットワーク接続確認OK");
        dispatch_async(mainQueue,^{
           if(buttontapped == 1){
                [self nextPage1];
            }else if(buttontapped == 2){
                [self nextPage2];
            }else{
                NSLog(@"buttontappedが不正です buttontapped = %d",buttontapped);
            }
        });
    }else{
        dispatch_async(mainQueue,^{
            [self showAlert:@"エラー" MESSAGE_Str:@"ネットワークに接続していません\n再試行しますか？" CANCEL_Str:@"後で" OTHER_Str:@"はい"];
        });
    }
    
}

//=======================アラーム表示処理==============================

//アラート表示
-(void)showAlert:(NSString*)TITLE_Str MESSAGE_Str:(NSString*)MESSAGE_Str CANCEL_Str:(NSString*)CANCEL_Str OTHER_Str:(NSString*)OTHER_Str
{
    //アラート
    UIAlertView *alert;
    /*
    alert =[[UIAlertView alloc]
            initWithTitle:@"エラー"
            message:@"ネットワークに接続していません\n再試行しますか？"
            delegate:self
            cancelButtonTitle:@"後で"
            otherButtonTitles:@"はい",
            nil];
     */
    
    alert =[[UIAlertView alloc]
            initWithTitle:TITLE_Str
            message:MESSAGE_Str
            delegate:self
            cancelButtonTitle:CANCEL_Str
            otherButtonTitles:OTHER_Str,
            nil];
    
    alert.alertViewStyle = UIAlertViewStyleDefault;
    
    
    
    [alert show];
    
}

//アラートのボタンが押されたときの処理（イベント未選択のアラートとネットワーク接続確認のアラートの両方が実行する）
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch(buttonIndex){
        case 0:
            break;
        case 1:
            //はいが押されたらサブ処理でネットワーク接続確認を再試行
            dispatch_async(subQueue,^{
                [self subQueueMethod];
                
            });
            break;
    }
}


//=======================画面遷移==============================


//前のページに遷移
-(void)previousPage
{
    CATransition * transition = [CATransition animation];
    
    transition.duration = 0.4;
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    
    MenuViewController *push =[self.storyboard instantiateViewControllerWithIdentifier:@"search"];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:push animated:NO];
    
    Send_Flag = 0;
    
    [Select_URL_1 removeAllObjects];
    [Select_URL_2 removeAllObjects];
    [Select_URL_3 removeAllObjects];
    [Select_URL_4 removeAllObjects];
    
    [Recipe_Title_Arr_1 removeAllObjects];
    [Recipe_Title_Arr_2 removeAllObjects];
    [Recipe_Title_Arr_3 removeAllObjects];
    [Recipe_Title_Arr_4 removeAllObjects];
    
    [Recipe_URL_1 removeAllObjects];
    [Recipe_URL_2 removeAllObjects];
    [Recipe_URL_3 removeAllObjects];
    [Recipe_URL_4 removeAllObjects];
}

//上の献立に遷移
-(void)nextPage1
{
    Send_Flag = 1;
    
    NSLog(@"\nSend_Flag = %d\n",Send_Flag);
    
    MenuViewController *viewCont =[self.storyboard instantiateViewControllerWithIdentifier:@"recipe"];
    
    [self.navigationController pushViewController:viewCont animated:YES];
}

//下の献立に遷移
-(void)nextPage2
{
    Send_Flag = 2;
    NSLog(@"\nSend_Flag = %d\n",Send_Flag);
    MenuViewController *viewCont =[self.storyboard instantiateViewControllerWithIdentifier:@"recipe"];
    [self.navigationController pushViewController:viewCont animated:YES];
}

@end
