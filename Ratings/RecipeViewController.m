#import "RecipeViewController.h"

//左から表示させるアニメーションのために必要
#import <QuartzCore/QuartzCore.h>

@interface RecipeViewController ()
@end

@implementation RecipeViewController

//ユーザーが選択した単品
// 0 : 初期値
int Select_Flag = 0;
int i=0;

//並列処理　メイン処理
dispatch_queue_t mainQueue;
//並列処理　サブ処理
dispatch_queue_t subQueue;
//どのボタンが押されたかを数字で保存
int recipebuttontapped = -1;

ShowAppAlert *saa;

NetworkConCheck *ncc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(Select_ID == 2) i = 4;
    //デフォルトのBACKボタンの非表示
    [self.navigationItem setHidesBackButton:YES animated:NO];
    //戻るボタンの追加
    UIBarButtonItem* backButton =[[UIBarButtonItem alloc]
                                  initWithTitle:@"戻る"
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(BackBtn)];
    self.navigationItem.leftBarButtonItems = @[backButton];
    
    // Do any additional setup after loading the view.
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.font = [UIFont boldSystemFontOfSize:16.0];
    title.textColor = [UIColor whiteColor];
    title.text = Merge_Text;
    [title sizeToFit];
    self.navigationItem.titleView = title;
    recipebuttontapped = -1;
    
    NSInteger i;
    NSString *Title_Text;
    //メイン処理とサブ処理を設定
    mainQueue = dispatch_get_main_queue();
    subQueue = dispatch_queue_create("sub1",0);
    
    if(Select_ID == 1){
        i = 0;
    }
    else{
        i = 4;
    }
    
    self.Menu_Img01.image = [Select_URL_1 objectAtIndex:[[indexnumber objectAtIndex:0+i] intValue]];
    self.Menu_Img02.image = [Select_URL_2 objectAtIndex:[[indexnumber objectAtIndex:1+i] intValue]];
    self.Menu_Img03.image = [Select_URL_3 objectAtIndex:[[indexnumber objectAtIndex:2+i] intValue]];
    self.Menu_Img04.image = [Select_URL_4 objectAtIndex:[[indexnumber objectAtIndex:3+i] intValue]];
    
    Title_Text = [Recipe_Title_Arr_1 objectAtIndex:[[indexnumber objectAtIndex:0+i] intValue]];
    [self Title_Set:0 :Title_Text];
    Title_Text = [Recipe_Title_Arr_2 objectAtIndex:[[indexnumber objectAtIndex:1+i] intValue]];
    [self Title_Set:1 :Title_Text];
    Title_Text = [Recipe_Title_Arr_3 objectAtIndex:[[indexnumber objectAtIndex:2+i] intValue]];
    [self Title_Set:2 :Title_Text];
    Title_Text = [Recipe_Title_Arr_4 objectAtIndex:[[indexnumber objectAtIndex:3+i] intValue]];
    [self Title_Set:3 :Title_Text];
}

- (void)Title_Set:(NSInteger)Label_Id :(NSString*)Recipe_Title
{
    switch (Label_Id) {
        case 0:
            self.Recipe_Text01.text = Recipe_Title;
            self.Recipe_Text01.numberOfLines = 0;
            [self.Recipe_Text01 sizeToFit];
            break;
        case 1:
            self.Recipe_Text02.text = Recipe_Title;
            self.Recipe_Text02.numberOfLines = 0;
            [self.Recipe_Text02 sizeToFit];
            break;
        case 2:
            self.Recipe_Text03.text = Recipe_Title;
            self.Recipe_Text03.numberOfLines = 0;
            [self.Recipe_Text03 sizeToFit];
            break;
        case 3:
            self.Recipe_Text04.text = Recipe_Title;
            self.Recipe_Text04.numberOfLines = 0;
            [self.Recipe_Text04 sizeToFit];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//戻るボタンを押したとき左から前の画面を出す
- (IBAction)BackButton:(id)sender {
    
    recipebuttontapped = 0;
    dispatch_async(mainQueue,^{
        [self mainQueueMethod];
    });
}

-(void)BackBtn
{
    recipebuttontapped = 0;
    dispatch_async(mainQueue,^{
        [self mainQueueMethod];
    });
}


//最初に戻るのボタンを押したとき
- (IBAction)BackStart:(id)sender {
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

    
    //検索画面に戻る
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

//料理1のボタンを選択
- (IBAction)Recipe_Button_01:(id)sender {
    recipebuttontapped = 1;
    getUrl = [Recipe_URL_1 objectAtIndex:[[indexnumber objectAtIndex:i+0] intValue]];
    dispatch_async(mainQueue,^{
        [self mainQueueMethod];
    });
}
//料理2のボタンを選択
- (IBAction)Recipe_Button_02:(id)sender {
    recipebuttontapped = 2;
    getUrl = [Recipe_URL_2 objectAtIndex:[[indexnumber objectAtIndex:i+1] intValue]];
    dispatch_async(mainQueue,^{
        [self mainQueueMethod];
    });
}
//料理3のボタンを選択
- (IBAction)Recipe_Button_03:(id)sender {
    recipebuttontapped = 3;
    getUrl = [Recipe_URL_3 objectAtIndex:[[indexnumber objectAtIndex:i+2] intValue]];
    dispatch_async(mainQueue,^{
        [self mainQueueMethod];
    });
}
//料理4のボタンを選択
- (IBAction)Recipe_Button_04:(id)sender {
    recipebuttontapped = 4;
    getUrl = [Recipe_URL_4 objectAtIndex:[[indexnumber objectAtIndex:i+3] intValue]];
    dispatch_async(mainQueue,^{
        [self mainQueueMethod];
    });
}

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

//ネットワーク確認後の処理振り分け
-(void)BranchProcess
{
    //戻るボタン押下時
    if(recipebuttontapped == 0){
        //画面3へ遷移
        [self previousPage];
        /*
        //料理1を選択時
    }else if(recipebuttontapped == 1){
        [self nextPage1];
        //料理2を選択時
    }else if(recipebuttontapped == 2){
        [self nextPage2];
        //料理3を選択時
    }else if(recipebuttontapped == 3){
        [self nextPage3];
        //料理4を選択時
    }else if(recipebuttontapped == 4){
        [self nextPage4];*/
    }else{
        //NSLog(@"buttontappedが不正です");
        WebViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"web"];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

//ネットワーク接続ができているかどうか
-(void)networkconHantei:(Boolean)constate
{
    saa = [[ShowAppAlert alloc]init];
    
    if(constate){
        NSLog(@"ネットワーク接続確認OK");
        dispatch_async(mainQueue,^{
            [self BranchProcess];
            
        });
    }else{
        dispatch_async(mainQueue,^{
            //[saa showAlert:@"エラー" MESSAGE_Str:@"ネットワークに接続していません\n再試行しますか？" CANCEL_Str:@"後で" OTHER_Str:@"はい"];
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

-(void)previousPage
{
    CATransition * transition = [CATransition animation];
    
    transition.duration = 0.4;
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
/*
-(void)nextPage1
{

}

-(void)nextPage2
{

}

-(void)nextPage3
{

}

-(void)nextPage4
{

}*/
@end
