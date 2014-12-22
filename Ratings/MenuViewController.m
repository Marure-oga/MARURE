#import "MenuViewController.h"
//左から表示させるアニメーションのために必要
#import <QuartzCore/QuartzCore.h>

@interface MenuViewController ()
@end

@implementation MenuViewController

//Select_ID : ユーザーが選択したボタン
// 0 : 初期値
// 1 : 献立（上）
// 2 : 献立（下）
NSInteger Select_ID = 0;

NSString *Url_Str;
NSString *Name_Str;
NSString *R_Url_Str;

NSString *Merge_Text;

NSURL *Img_URL;
NSData *Img_Data;
UIImage *Recipe_Img;

//料理の画像URL格納用配列
NSMutableArray *Select_URL_1;//主菜
NSMutableArray *Select_URL_2;//副菜
NSMutableArray *Select_URL_3;//デザート
NSMutableArray *Select_URL_4;//ドリンク

//ウェブサイトのURL格納配列
NSMutableArray *Recipe_URL_1;//主菜
NSMutableArray *Recipe_URL_2;//副菜
NSMutableArray *Recipe_URL_3;//デザート
NSMutableArray *Recipe_URL_4;//ドリンク

//レシピタイトルの格納配列
NSMutableArray *Recipe_Title_Arr_1;//主菜
NSMutableArray *Recipe_Title_Arr_2;//副菜
NSMutableArray *Recipe_Title_Arr_3;//デザート
NSMutableArray *Recipe_Title_Arr_4;//ドリンク

//Menu_Image_01〜Menu_Image_08に対応するレシピ番号
//(0:1つ目の献立の主菜　1:1つ目の献立の副菜　2:1つ目の献立のデザート　3:1つ目の献立のドリンク)
//(4:2つ目の献立の主菜　1:2つ目の献立の副菜　2:2つ目の献立のデザート　3:一2目の献立のドリンク)
NSMutableArray *indexnumber;
//今表示されている料理の画像の番号
NSMutableArray *nownumber;

//並列処理　メイン処理
dispatch_queue_t mainQueue;
//並列処理　サブ処理
dispatch_queue_t subQueue;

//どのボタンが押されたかを数字で保存
int buttontapped = -1;
//最初にMenu_Img_Changeを呼び出したときnownumberResetを呼び出す
bool hantei0 = true;

//タッチした時の座標
CGPoint pickPos;
//初回表示かどうか
bool syokai = true;

NetworkConCheck *ncc;

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
    //MarureKeyS *mrks = [[MarureKeyS alloc]init];
    NewJsonSearch *njs = [[NewJsonSearch alloc]init];
    
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
    //[mrks SetEventAndMoody:Event_NO moody:Ambience_NO];
    [njs SetMarureKeyword:Event_NO moody:Ambience_NO];
    
    if([njs.key1NameArr count] > 0){
        for (int i = 0 ; i < [njs.key1NameArr count]; i++) {
            NSLog(@"%@",[njs.key1NameArr objectAtIndex:i]);
        }
    }
    
    //=========================nilチェック=========================
    if ([njs.key1ImgArr count] > 0) {
        NSLog(@"Key1ImgArr COUNT = %lu\n",(unsigned long)[njs.key1ImgArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey1ImgArr COUNT = %lu\n",(unsigned long)[njs.key1ImgArr count]);
        return false;
    }
    
    if ([njs.key2ImgArr count] > 0) {
        NSLog(@"Key2ImgArr COUNT = %lu\n",(unsigned long)[njs.key2ImgArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey2ImgArr COUNT = %lu\n",(unsigned long)[njs.key2ImgArr count]);
        return false;
    }
    
    if ([njs.key3ImgArr count] > 0) {
        NSLog(@"Key3ImgArr COUNT = %lu\n",(unsigned long)[njs.key3ImgArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey3ImgArr COUNT = %lu\n",(unsigned long)[njs.key3ImgArr count]);
        return false;
    }
    
    if ([njs.key4ImgArr count] > 0) {
        NSLog(@"Key4ImgArr COUNT = %lu\n",(unsigned long)[njs.key4ImgArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey4ImgArr COUNT = %lu\n",(unsigned long)[njs.key4ImgArr count]);
        return false;
    }
    
    if ([njs.key1NameArr count] > 0) {
        NSLog(@"Key1NameArr COUNT = %lu\n",(unsigned long)[njs.key1NameArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey1NameArr COUNT = %lu\n",(unsigned long)[njs.key1NameArr count]);
        return false;
    }
    
    if ([njs.key2NameArr count] > 0) {
        NSLog(@"Key2NameArr COUNT = %lu\n",(unsigned long)[njs.key2NameArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey2NameArr COUNT = %lu\n",(unsigned long)[njs.key2NameArr count]);
        return false;
    }
    
    if ([njs.key3NameArr count] > 0) {
        NSLog(@"Key3NameArr COUNT = %lu\n",(unsigned long)[njs.key3NameArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey3NameArr COUNT = %lu\n",(unsigned long)[njs.key3NameArr count]);
        return false;
    }
    
    if ([njs.key4NameArr count] > 0) {
        NSLog(@"Key4NameArr COUNT = %lu\n",(unsigned long)[njs.key4NameArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey4NameArr COUNT = %lu\n",(unsigned long)[njs.key4NameArr count]);
        return false;
    }
    
    if ([njs.key1UrlArr count] > 0) {
        NSLog(@"Key1UrlArr COUNT = %lu\n",(unsigned long)[njs.key1UrlArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey1UrlArr COUNT = %lu\n",(unsigned long)[njs.key1NameArr count]);
        return false;
    }
    
    if ([njs.key2UrlArr count] > 0) {
        NSLog(@"Key2UrlArr COUNT = %lu\n",(unsigned long)[njs.key2UrlArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey2UrlArr COUNT = %lu\n",(unsigned long)[njs.key2UrlArr count]);
        return false;
    }
    
    if ([njs.key3UrlArr count] > 0) {
        NSLog(@"Key3UrlArr COUNT = %lu\n",(unsigned long)[njs.key3UrlArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey3UrlArr COUNT = %lu\n",(unsigned long)[njs.key3UrlArr count]);
        return false;
    }
    
    if ([njs.key4UrlArr count] > 0) {
        NSLog(@"Key4UrlArr COUNT = %lu\n",(unsigned long)[njs.key4UrlArr count]);
    }
    else{
        NSLog(@"ERROR!!\nKey4UrlArr COUNT = %lu\n",(unsigned long)[njs.key4UrlArr count]);
        return false;
    }
    //==================================================
    

    //APIからの返却数までループ
    for(i = 0;i < [njs.key1ImgArr count];i++){
        
        //主菜の画像URLの文字列格納
        Url_Str = [njs.key1ImgArr objectAtIndex:i];
        //主菜のレシピタイトルの文字列格納
        Name_Str = [njs.key1NameArr objectAtIndex:i];
        //主菜のレシピURLの文字列格納
        R_Url_Str = [njs.key1UrlArr objectAtIndex:i];

        [self Menu_Img_UrlSet:0];
    }
    for(i = 0;i < [njs.key2ImgArr count];i++){
        //副菜の画像URLの文字列格納
        Url_Str = [njs.key2ImgArr objectAtIndex:i];
        //副菜のレシピタイトルの文字列格納
        Name_Str = [njs.key2NameArr objectAtIndex:i];
        //副菜のレシピURLの文字列格納
        R_Url_Str = [njs.key2UrlArr objectAtIndex:i];
                
        [self Menu_Img_UrlSet:1];
    }
    for (i = 0; i < [njs.key3ImgArr count]; i++) {
        //デザートの画像URLの文字列格納
        Url_Str = [njs.key3ImgArr objectAtIndex:i];
        //デザートのレシピタイトルの文字列格納
        Name_Str = [njs.key3NameArr objectAtIndex:i];
        //デザートのレシピURLの文字列格納
        R_Url_Str = [njs.key3UrlArr objectAtIndex:i];
                
        [self Menu_Img_UrlSet:2];
    }
    for (i = 0; i < [njs.key4ImgArr count]; i++) {
        //ドリンクの画像URLの文字列格納
        Url_Str = [njs.key4ImgArr objectAtIndex:i];
        //ドリンクのレシピタイトルの文字列格納
        Name_Str = [njs.key4NameArr objectAtIndex:i];
        //ドリンクのレシピURLの文字列格納
        R_Url_Str = [njs.key4UrlArr objectAtIndex:i];
        
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
        NSLog(@"ERROR!! Url_Str.LENGTH = %lu",(unsigned long)Url_Str.length);
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
    if(hantei0){
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
    //ランダム切り替えの処理を行えるようにする
    syokai = false;
    NSLog(@"ybefore = %f",pickPos.y);
    pickPos.y = 0;
    NSLog(@"yafter = %f",pickPos.y);
    
    NSLog(@"--------------------------------");
    //NSLog(@"Send?flg%d",Send_Flag);
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
    
    //====================献立.1====================
    self.Menu_Image_01.image = [Select_URL_1 objectAtIndex:[[indexnumber objectAtIndex:0] intValue]];//主菜
    self.Menu_Image_02.image = [Select_URL_2 objectAtIndex:[[indexnumber objectAtIndex:1] intValue]];//副菜
    self.Menu_Image_03.image = [Select_URL_3 objectAtIndex:[[indexnumber objectAtIndex:2] intValue]];//デザート
    self.Menu_Image_04.image = [Select_URL_4 objectAtIndex:[[indexnumber objectAtIndex:3] intValue]];//ドリンク
    //====================献立.2====================
    self.Menu_Image_05.image = [Select_URL_1 objectAtIndex:[[indexnumber objectAtIndex:4] intValue]];//主菜
    self.Menu_Image_06.image = [Select_URL_2 objectAtIndex:[[indexnumber objectAtIndex:5] intValue]];//副菜
    self.Menu_Image_07.image = [Select_URL_3 objectAtIndex:[[indexnumber objectAtIndex:6] intValue]];//デザート
    self.Menu_Image_08.image = [Select_URL_4 objectAtIndex:[[indexnumber objectAtIndex:7] intValue]];//ドリンク
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pickPos.y = 0;
    
    if (recipeselectact) {
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
    if(Display_ID == 2)
    {
        syokai = true;
        hantei0 = true;
        ShowAppAlert *saa = [[ShowAppAlert alloc]init];
        //取得した文字列から画像表示するための前処理
        if([self Menu_Img_GET]){
            //APIからの返却数が正常だった場合
            //画像の表示処理
            [self Menu_Img_Show];
        }
        else{
            NSLog(@"API取得値が不正\n");
            [saa showAlert:@"エラー" MESSAGE_Str:@"献立の取得に失敗しました。" CANCEL_Str:nil OTHER_Str:@"はい"];
            [self previousPage];
        }
    }
    //画面4から遷移した場合
    else{
        //以前の献立を表示
        [self Menu_Img_Show];
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
    
    //ボタンを押した瞬間にタッチ座標を変えるメソッドを呼ぶ
    [_Menu_01 addTarget:self action:@selector(PointSet01) forControlEvents:UIControlEventTouchDown];
    [_Menu_02 addTarget:self action:@selector(PointSet02) forControlEvents:UIControlEventTouchDown];
    
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

//ボタンを押した瞬間にタッチ座標を80に変える
-(void)PointSet01{
    pickPos.y = 80;
}

//ボタンを押した瞬間に立タッチ座標を330に変える
-(void)PointSet02{
    pickPos.y = 330;
}

- (IBAction)Menu_01:(id)sender {
    buttontapped = 1;
    dispatch_async(mainQueue,^{
        [self mainQueueMethod];
    });
}
- (IBAction)Menu_02:(id)sender {
    buttontapped = 2;
    dispatch_async(mainQueue,^{
        [self mainQueueMethod];
    });
}


//=======================献立切り替え時の処理===========================
//画面をタッチした位置を取得
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    pickPos = [touch locationInView:self.view];
    NSLog(@"x=%f",pickPos.x);
    NSLog(@"y = %f",pickPos.y);
}

//スワイプしたときMenu_Img_Changeを呼び出し、その後Menu_Img_Showを呼び出す
-(void)swipe:(UISwipeGestureRecognizer *)gesture
{
    //[self Menu_Img_Show];
    buttontapped = 0;
    dispatch_async(mainQueue,^{
        [self mainQueueMethod];
    });
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
    
    //初回表示もしくはスワイプされた側の献立をランダムに設定　スワイプされなかった側の献立は今の値を取得
    if(syokai || (70 <= pickPos.y && pickPos.y < 320 && ImgNumber < 4) || (pickPos.y >= 320 && ImgNumber >= 4)){
    
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
    }else{
        [indexnumber addObject:[nownumber objectAtIndex:ImgNumber]];
    }
}

//=======================ネットワーク接続確認===========================

//メイン処理　最初のネットワーク接続確認を実行　プログレスバーの表示
-(void)mainQueueMethod
{
    ncc = [[NetworkConCheck alloc]init];
    bool hantei = false;
    hantei = [ncc network_first];
    
    [self networkconHantei:hantei];
}

//サブ処理　ネットワーク接続確認（２回目以降）を実行
-(void)subQueueMethod
{
    bool hantei = false;
    hantei = [ncc network];
    
    [self networkconHantei:hantei];
}

//ネットワーク確認後の処理振り分け
-(void)BranchProcess
{
    if(buttontapped == 0){
        [self Menu_Img_Show];
    }else if(buttontapped == 1){
        [self nextPage1];
    }else if(buttontapped == 2){
        [self nextPage2];
    }else{
        NSLog(@"buttontappedが不正です buttontapped = %d",buttontapped);
    }
}

//ネットワーク接続ができているかどうか
-(void)networkconHantei:(Boolean)constate
{
    if(constate){
        NSLog(@"画面3:ネットワーク接続確認OK");
        dispatch_async(mainQueue,^{
            [self BranchProcess];
        });
    }else{
        dispatch_async(mainQueue,^{
            UIAlertView* alert =[[UIAlertView alloc]
                                 initWithTitle:@"エラー"
                                 message:@"ネットワークに接続していません\n再試行しますか？"
                                 delegate:self
                                 cancelButtonTitle:@"後で"
                                 otherButtonTitles:@"はい",
                                 nil];
            
            alert.alertViewStyle = UIAlertViewStyleDefault;
            
            [alert show];
        });
    }
    
}

//=======================アラーム表示処理==============================

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
    //遷移元画面設定
    Display_ID = 3;
    
    CATransition * transition = [CATransition animation];
    
    transition.duration = 0.4;
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    
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
    
    [nownumber removeAllObjects];
    [indexnumber removeAllObjects];
    
    if(recipeselectact)
    {
        Ambience_NO = -1;
        Ambience_Str = nil;
    }

    //前の画面に遷移
    [self.navigationController popViewControllerAnimated:YES];
}

//上の献立の詳細に遷移
-(void)nextPage1
{
    Select_ID = 1;
    RecipeViewController *recipeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"recipe"];
    [self.navigationController pushViewController:recipeViewController animated:YES];
}

//下の献立の詳細に遷移
-(void)nextPage2
{
    Select_ID = 2;
    RecipeViewController *recipeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"recipe"];
    [self.navigationController pushViewController:recipeViewController animated:YES];
}

@end
