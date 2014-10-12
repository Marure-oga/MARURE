
#import "WebViewController.h"
#import "MenuViewController.h"

//左から表示させるアニメーションのために必要
#import <QuartzCore/QuartzCore.h>

@interface WebViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
//@property NSString *getUrl;//segueで値をセットして表示できる
@end

@implementation WebViewController

//ネットワークに接続しているかを判断する時間（秒）
double searchTime;
//並列処理　メイン処理
dispatch_queue_t mainQueue;
//並列処理　サブ処理
dispatch_queue_t subQueue;
//どのボタンが押されたかを数字で保存
int webbuttontapped = -1;

UIWebView *webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self Display];
    
    // Do any additional setup after loading the view.
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.font = [UIFont boldSystemFontOfSize:16.0];
    title.textColor = [UIColor whiteColor];
    title.text = Merge_Text;
    [title sizeToFit];
    
    self.navigationItem.titleView = title;
    
    //右へスワイプしたときの処理
    UISwipeGestureRecognizer *swiperight = [[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(swipe:)];
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
    swiperight.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swiperight];
    
    searchTime = 5.0;
    webbuttontapped = -1;
    
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

//画面表示
-(void)Display
{
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    NSURL *url = [NSURL URLWithString:@"http://www.apple.jp"];
    if (self.getUrl) {
        url = [NSURL URLWithString:self.getUrl];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

//ウェブサイトの戻る
-(void)webBack
{
    [self.webView goBack];
}

//ウェブサイトの更新
-(void)Update
{
    [self.webView reload];
}

//アプリに戻る
-(void)AppBack
{
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.4;
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    
    WebViewController *push =[self.storyboard instantiateViewControllerWithIdentifier:@"recipe"];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:push animated:NO];
}

//ナビゲーションバーの戻るボタンを押したときの処理　前の画面に戻る
-(void)BackBtn
{
    webbuttontapped = 2;
    dispatch_async(mainQueue,^{
        [self mainQueueMethod];
    });
}

//右スワイプを行ったとき献立詳細画面に遷移
-(void)swipe:(UISwipeGestureRecognizer *)gesture
{
    //[self Back];
    webbuttontapped = 2;
    dispatch_async(mainQueue,^{
        [self mainQueueMethod];
    });
}

//戻るボタンを押したときBackメソッドを呼び出す
- (IBAction)BackButton:(id)sender {
    //[self Back];
    webbuttontapped = 0;
    dispatch_async(mainQueue,^{
        [self mainQueueMethod];
    });
}

//更新ボタンを押したときDisplayメソッドを呼び出す
- (IBAction)UpdateButton:(id)sender {
    //[self Display];
    webbuttontapped = 1;
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
            if(webbuttontapped == 0){
                [self webBack];
            }else if(webbuttontapped == 1){
                [self Update];
            }else if(webbuttontapped == 2){
                [self AppBack];
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
