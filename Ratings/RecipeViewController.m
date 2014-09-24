
#import "RecipeViewController.h"

//左から表示させるアニメーションのために必要
#import <QuartzCore/QuartzCore.h>

@interface RecipeViewController ()
@end

@implementation RecipeViewController

int Select_Flag = 0;

//ネットワークに接続しているかを判断する時間（秒）
double searchTime;
//並列処理　メイン処理
dispatch_queue_t mainQueue;
//並列処理　サブ処理
dispatch_queue_t subQueue;
//どのボタンが押されたかを数字で保存
int recipebuttontapped = -1;

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
    
    //ナビゲーションバーの非表示
    [self.navigationController setNavigationBarHidden:YES];
    
    searchTime = 5.0;
    recipebuttontapped = -1;
    
    //メイン処理とサブ処理を設定
    mainQueue = dispatch_get_main_queue();
    subQueue = dispatch_queue_create("sub1",0);
    
    //NSLog(@"\n【Fig4】Select_URL_COUNT = %d\n",[Select_URL count]);
    
    MenuViewController *mvc;
    mvc = [[MenuViewController alloc]init];

    int i;
    
    NSString *Title_Text;
    
    if(Send_Flag == 1){
        i = 0;
    }
    else{
        i = 4;
    }
    /*self.Menu_Img01.image = [Select_URL objectAtIndex:0+i];
    self.Menu_Img02.image = [Select_URL objectAtIndex:1+i];
    self.Menu_Img03.image = [Select_URL objectAtIndex:2+i];
    self.Menu_Img04.image = [Select_URL objectAtIndex:3+i];*/
    
    /*
    for (int k = 0; k < 4; k++) {
        if(nil == [Select_URL objectAtIndex:[[indexnumber objectAtIndex:k+i] intValue]]){
            NSLog(@"\n[画面4]Select_URL[%d] = nil\n",k);
            return;
        }
    }
    */
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
    
    /*Send_Flag = -1;
    
    CATransition * transition = [CATransition animation];
    
    transition.duration = 0.4;
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    
    RecipeViewController *push =[self.storyboard instantiateViewControllerWithIdentifier:@"menu"];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:push animated:NO];*/
}


//最初に戻るのボタンを押したとき
- (IBAction)BackStart:(id)sender {
    RecipeViewController *push =[self.storyboard instantiateViewControllerWithIdentifier:@"search"];
    
    push.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:push];
    [self presentViewController:navigation animated:YES completion:nil];
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    int i = 0;
    
    //画面3で2つ目の献立を選択された場合
    if(Send_Flag == 2){
        i =4;
    }
    
    if ([[segue identifier] isEqualToString:@"Select_Recipe_01"]) {
        WebViewController *vcntl = [segue destinationViewController];
        if(Send_Flag == 2) i = 4;
        vcntl.getUrl = [Recipe_URL_1 objectAtIndex:[[indexnumber objectAtIndex:i+0] intValue]];
    }
    if([[segue identifier] isEqualToString:@"Select_Recipe_02"]){
        WebViewController *vcntl = [segue destinationViewController];
        //vcntl.getUrl = [Recipe_URL objectAtIndex:1+i];
        vcntl.getUrl = [Recipe_URL_2 objectAtIndex:[[indexnumber objectAtIndex:i+1] intValue]];
    }
    if([[segue identifier] isEqualToString:@"Select_Recipe_03"]){
        WebViewController *vcntl = [segue destinationViewController];
        //vcntl.getUrl = [Recipe_URL objectAtIndex:2+i];
        vcntl.getUrl = [Recipe_URL_3 objectAtIndex:[[indexnumber objectAtIndex:i+2] intValue]];
    }
    if([[segue identifier] isEqualToString:@"Select_Recipe_04"]){
        WebViewController *vcntl = [segue destinationViewController];
        //vcntl.getUrl = [Recipe_URL objectAtIndex:3+i];
        vcntl.getUrl = [Recipe_URL_4 objectAtIndex:[[indexnumber objectAtIndex:i+3] intValue]];
    }
}

- (IBAction)Recipe_Button_01:(id)sender {
    //Select_Flag = 1;
    recipebuttontapped = 1;
    dispatch_async(mainQueue,^{
        [self mainQueueMethod];
    });
}
- (IBAction)Recipe_Button_02:(id)sender {
    //Select_Flag = 2;
    recipebuttontapped = 2;
    dispatch_async(mainQueue,^{
        [self mainQueueMethod];
    });
}
- (IBAction)Recipe_Button_03:(id)sender {
    //Select_Flag = 3;
    recipebuttontapped = 3;
    dispatch_async(mainQueue,^{
        [self mainQueueMethod];
    });
}
- (IBAction)Recipe_Button_04:(id)sender {
    //Select_Flag = 4;
    recipebuttontapped = 4;
    dispatch_async(mainQueue,^{
        [self mainQueueMethod];
    });
}

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

//ネットワーク接続エラーのアラート表示
-(void)showAlert
{
    //アラート
    UIAlertView *alert;
    
    alert =[[UIAlertView alloc]
            initWithTitle:@"エラー"
            message:@"ネットワークに接続していません\n再試行しますか？"
            delegate:self
            cancelButtonTitle:@"後で"
            otherButtonTitles:@"はい",
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

//ネットワーク接続ができているかどうか
-(void)networkaccessHantei:(Boolean)accessstate
{
    if(accessstate){
        NSLog(@"ネットワーク接続確認OK");
        dispatch_async(mainQueue,^{
            if(recipebuttontapped == 0){
                [self previousPage];
            }else if(recipebuttontapped == 1){
                [self nextPage1];
            }else if(recipebuttontapped == 2){
                [self nextPage2];
            }else if(recipebuttontapped == 3){
                [self nextPage3];
            }else if(recipebuttontapped == 4){
                [self nextPage4];
            }else{
                NSLog(@"buttontappedが不正です");
            }
            
        });
    }else{
        dispatch_async(mainQueue,^{
            [self showAlert];
        });
    }
    
}

-(void)previousPage
{
    Send_Flag = -1;
    
    CATransition * transition = [CATransition animation];
    
    transition.duration = 0.4;
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    
    RecipeViewController *push =[self.storyboard instantiateViewControllerWithIdentifier:@"menu"];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:push animated:NO];
}

-(void)nextPage1
{
    Select_Flag = 1;
    RecipeViewController *viewCont =[self.storyboard instantiateViewControllerWithIdentifier:@"web"];
    [self.navigationController pushViewController:viewCont animated:YES];
}

-(void)nextPage2
{
    Select_Flag = 2;
    RecipeViewController *viewCont =[self.storyboard instantiateViewControllerWithIdentifier:@"web"];
    [self.navigationController pushViewController:viewCont animated:YES];
}

-(void)nextPage3
{
    Select_Flag = 3;
    RecipeViewController *viewCont =[self.storyboard instantiateViewControllerWithIdentifier:@"web"];
    [self.navigationController pushViewController:viewCont animated:YES];
}

-(void)nextPage4
{
    Select_Flag = 4;
    RecipeViewController *viewCont =[self.storyboard instantiateViewControllerWithIdentifier:@"web"];
    [self.navigationController pushViewController:viewCont animated:YES];
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
