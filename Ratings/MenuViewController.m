//
//  MenuViewController.m
//  Ratings
//
//  Created by MASTER on 2014/08/18.
//  Copyright (c) 2014年 Yuta.Kasiwabara. All rights reserved.
//

#import "MenuViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MenuViewController ()
@end

@implementation MenuViewController

int Send_Flag;

NSString *Url_Str;
NSString *Name_Str;
NSString *R_Url_Str;

NSURL *Img_URL;
NSData *Img_Data;
UIImage *Recipe_Img;

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
NSMutableArray *indexnumber;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//献立の情報取得
- (void)Menu_Img_GET
{
    
    MarureKeyS *mrks;
    
    mrks = [[MarureKeyS alloc]init];
    
    //nilチェック用の変数
    Boolean nil_Flag = false;
    
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
    [mrks SetEventAndMoody:0 moody:0];
    //本番用：
    //[mrks SetEventAndMoody:Event_NO moody:Ambience_NO];

    //APIからの返却数までループ
    for(i = 0;i < [mrks.key1ImgArr count];i++){
        //画面2から遷移　かつ　格納値がnilでない時
        if(!nil_Flag){

            //主菜の画像URLの文字列格納
            Url_Str = [mrks.key1ImgArr objectAtIndex:i];
            //主菜のレシピタイトルの文字列格納
            Name_Str = [mrks.key1NameArr objectAtIndex:i];
            //主菜のレシピURLの文字列格納
            R_Url_Str = [mrks.key1UrlArr objectAtIndex:i];

            [self Menu_Img_UrlSet:0];
                
            //副菜の画像URLの文字列格納
            Url_Str = [mrks.key2ImgArr objectAtIndex:i];
            //副菜のレシピタイトルの文字列格納
            Name_Str = [mrks.key2NameArr objectAtIndex:i];
            //副菜のレシピURLの文字列格納
            R_Url_Str = [mrks.key2UrlArr objectAtIndex:i];
                
            [self Menu_Img_UrlSet:1];
                
            //デザートの画像URLの文字列格納
            Url_Str = [mrks.key3ImgArr objectAtIndex:i];
            //デザートのレシピタイトルの文字列格納
            Name_Str = [mrks.key3NameArr objectAtIndex:i];
            //デザートのレシピURLの文字列格納
            R_Url_Str = [mrks.key3UrlArr objectAtIndex:i];
                
            [self Menu_Img_UrlSet:2];
                
            //ドリンクの画像URLの文字列格納
            Url_Str = [mrks.key4ImgArr objectAtIndex:i];
            //ドリンクのレシピタイトルの文字列格納
            Name_Str = [mrks.key4NameArr objectAtIndex:i];
            //ドリンクのレシピURLの文字列格納
            R_Url_Str = [mrks.key4UrlArr objectAtIndex:i];
                
            [self Menu_Img_UrlSet:3];
        }
    }
}

//文字列を表示可能な型に変換・格納処理
- (void)Menu_Img_UrlSet:(NSInteger)Category_Num
{
    /*
     Category_Num
     
     0:主菜
     1:副菜
     2:デザート
     3:ドリンク
     */
    
    //レシピ画像URLの文字列をNSURL型に変換し格納
    Img_URL = [NSURL URLWithString:Url_Str];
    
    //レシピ画像URLのNSURL型をNSData型に変換し格納
    Img_Data = [NSData dataWithContentsOfURL:Img_URL];
    
    //レシピ画像URLのNSData型をUIImage型に変換し格納
    Recipe_Img = [UIImage imageWithData:Img_Data];
    
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
            return;
            break;
    }
}

//料理画像の表示処理
- (void)Menu_Img_Show
{
    if (Send_Flag != -1) {
        [self Menu_Img_Change];
    }
    
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
    // Do any additional setup after loading the view.
    
    //ナビゲーションバーの非表示
    [self.navigationController setNavigationBarHidden:YES];
    
    //
    if(Send_Flag != -1)
    {
        //取得した文字列から画像表示するための前処理
        [self Menu_Img_GET];
    }
    
    //画像の表示処理
    [self Menu_Img_Show];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//戻るボタンを押したとき左から前の画面を出す
- (IBAction)BackButton:(id)sender {
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
- (IBAction)Menu_01:(id)sender {
    Send_Flag = 1;
    //NSLog(@"\nSend_Flag = %d\n",Send_Flag);
}
- (IBAction)Menu_02:(id)sender {
    Send_Flag = 2;
    //NSLog(@"\nSend_Flag = %d\n",Send_Flag);
}

//スワイプしたときMenu_Img_Changeを呼び出す
-(void)swipe:(UISwipeGestureRecognizer *)gesture
{
    [self Menu_Img_Change];
}

//表示されているメニューの画像をランダムに更新する
-(void)Menu_Img_Change{
    int i;
    int random = 0;
    bool hantei = true;
    indexnumber = [NSMutableArray array];
    for(i = 0;i < 8;i++){
        do{
            random = (int)(arc4random() %8);
            hantei = false;
            for(int j =0;j<i;j++){
                if([[indexnumber objectAtIndex:j] intValue] == random){
                    hantei = true;
                    break;
                }
            }
        }while(hantei);
        
        [indexnumber addObject:[NSNumber numberWithInteger:random]];
        
        switch (i) {
            case 0:
                self.Menu_Image_01.image = [Select_URL_1 objectAtIndex:random];
                break;
            case 1:
                self.Menu_Image_02.image = [Select_URL_2 objectAtIndex:random];
                break;
            case 2:
                self.Menu_Image_03.image = [Select_URL_3 objectAtIndex:random];
                break;
            case 3:
                self.Menu_Image_04.image = [Select_URL_4 objectAtIndex:random];
                break;
            case 4:
                self.Menu_Image_05.image = [Select_URL_1 objectAtIndex:random];
                break;
            case 5:
                self.Menu_Image_06.image = [Select_URL_2 objectAtIndex:random];
                break;
            case 6:
                self.Menu_Image_07.image = [Select_URL_3 objectAtIndex:random];
                break;
            case 7:
                self.Menu_Image_08.image = [Select_URL_4 objectAtIndex:random];
                break;
            default:
                break;
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
