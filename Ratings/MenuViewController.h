
#import <UIKit/UIKit.h>
#import "JsonSerchClass.h"
#import "SearchViewController.h"

//ネットワーク接続確認のために必要
#import "Reachability.h"
@class Reachability;

@interface MenuViewController : UIViewController

extern int Send_Flag;

extern NSMutableArray *Select_URL_1;
extern NSMutableArray *Select_URL_2;
extern NSMutableArray *Select_URL_3;
extern NSMutableArray *Select_URL_4;

extern NSMutableArray *Recipe_URL_1;
extern NSMutableArray *Recipe_URL_2;
extern NSMutableArray *Recipe_URL_3;
extern NSMutableArray *Recipe_URL_4;

extern NSMutableArray *Recipe_Title_Arr_1;
extern NSMutableArray *Recipe_Title_Arr_2;
extern NSMutableArray *Recipe_Title_Arr_3;
extern NSMutableArray *Recipe_Title_Arr_4;

extern NSMutableArray *indexnumber;

@property (weak, nonatomic) IBOutlet UIImageView *Menu_Image_01;
@property (weak, nonatomic) IBOutlet UIImageView *Menu_Image_02;
@property (weak, nonatomic) IBOutlet UIImageView *Menu_Image_03;
@property (weak, nonatomic) IBOutlet UIImageView *Menu_Image_04;

@property (weak, nonatomic) IBOutlet UIImageView *Menu_Image_05;
@property (weak, nonatomic) IBOutlet UIImageView *Menu_Image_06;
@property (weak, nonatomic) IBOutlet UIImageView *Menu_Image_07;
@property (weak, nonatomic) IBOutlet UIImageView *Menu_Image_08;

@property (weak, nonatomic) IBOutlet UIButton *Menu_01;
@property (weak, nonatomic) IBOutlet UIButton *Menu_02;

-(Boolean) Menu_Img_GET;
-(Boolean) Menu_Img_UrlSet:(NSInteger)Category_Num;
-(void) Menu_Img_Show;
-(void)swipe:(UISwipeGestureRecognizer *)gesture;
-(void)nownumberReset;
-(void)Menu_Img_Change:(int)ImgNumber maxNumber:(int)maxNumber;


//メイン処理　最初のネットワーク接続確認を実行　プログレスバーの表示
-(void)mainQueueMethod;
//サブ処理　ネットワーク接続確認（２回目以降）を実行
-(void)subQueueMethod;
//ネットワーク接続判定１回目
-(void)network_first;
//ネットワーク接続判定２回目以降
-(void)network;
//ネットワーク接続判定を行うメソッド
-(Boolean)networksearch;
//ネットワーク接続ができているか確認処理
-(void)networkaccessHantei:(Boolean)accessstate;


//アラート表示
-(void)showAlert:(NSString*)TITLE_Str MESSAGE_Str:(NSString*)MESSAGE_Str CANCEL_Str:(NSString*)CANCEL_Str OTHER_Str:(NSString*)OTHER_Str;
//アラートのボタンが押されたときの処理
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;


//前のページに遷移
-(void)previousPage;
//上の献立に遷移
-(void)nextPage1;
//下の献立に遷移
-(void)nextPage2;

@end
