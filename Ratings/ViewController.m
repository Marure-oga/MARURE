
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
//タイマー１
NSTimer *ter;
//タイマー２
NSTimer *ter2;
//イベント
NSInteger event=0;
//雰囲気
NSInteger atomosphere = 0;
//プログレスバー進捗度（０〜１）
double progresslevel = 0;
//ネットワークに接続しているかを判断する時間（秒）
double searchTime = 5;
//最初のネットワーク接続確認か
Boolean first = true;


UIProgressView *progressView;

UIAlertView *alert;

dispatch_queue_t mainQueue;
dispatch_queue_t subQueue;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self syokika];
    
    //プログレスバーの作成
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault ];
    CGSize pSize = progressView.frame.size;
    CGSize vSize = self.view.frame.size;
    progressView.frame = CGRectMake((vSize.width-pSize.width)/2,(vSize.height-pSize.height)/2+175,pSize.width,pSize.height);
    progressView.transform = CGAffineTransformMakeScale(1.0f,2.0f);
    progressView.progress = 0.0;
    progressView.trackTintColor = [UIColor blackColor];
    [progressView setProgress:progresslevel animated:YES];
    [self.view addSubview:progressView];
    
    
    mainQueue = dispatch_get_main_queue();
    subQueue = dispatch_queue_create("sub1",0);
    
    [self Thread];
}

//メイン処理の実行
-(void)Thread
{
    dispatch_async(mainQueue,^{
        [self mainQueueMethod];
    });
}

//メイン処理
-(void)mainQueueMethod
{
    
    [self network_first];
    
    [progressView setProgress:progresslevel animated:YES];
    [self.view addSubview:progressView];
}

//サブ処理
-(void)subQueueMethod
{
    [self network];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//変数初期化
-(void)syokika
{
    event = 0;
    atomosphere = 0;
    progresslevel = 0;
    first = true;
    
    progresslevel = progresslevel + 0.5;
}

//ネットワーク接続判定１回目
-(void)network_first
{
    Boolean accessstate = false;
    
    accessstate = [self networksearch];
    
    [self networkaccessHantei:accessstate];
    
}

//ネットワーク接続判定２回目以降
-(void)network
{
    first = false;
    Boolean accessstate = false;
    
    NSDate *startDate;
    NSDate *endDate;
    NSTimeInterval interval;
    
    startDate = [NSDate date];
    
    do{
        accessstate = [self networksearch];
        endDate = [NSDate date];
        interval = [endDate timeIntervalSinceDate:startDate];
    }while(accessstate == false && interval <= searchTime);
    
    [self networkaccessHantei:accessstate];
}


//ネットワーク検索用
-(Boolean)networksearch
{
    Boolean networkaccess = false;
    
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus =[curReach currentReachabilityStatus];
    
    if(netStatus == NotReachable){
        
        networkaccess = false;
    }else{
        //ネットワーク接続ができているとき
        networkaccess = true;
        if(first){
            //最初のときプログレスバーの進行
            progresslevel = progresslevel + 0.5;
            [progressView setProgress:progresslevel animated:YES];
            [self.view addSubview:progressView];
        }else{
            //２回目以降のときメイン処理でプログレスバーの進行
            dispatch_async(mainQueue,^{
                progresslevel = progresslevel + 0.5;
                [progressView setProgress:progresslevel animated:YES];
                [self.view addSubview:progressView];
            });
        }
    }
    
    return networkaccess;
}

//アラートの表示
-(void)showAlert
{
    alert =[[UIAlertView alloc]
            initWithTitle:@"エラー"
            message:@"ネットワークに接続していません\n再試行しますか？"
            delegate:self
            cancelButtonTitle:@"いいえ"
            otherButtonTitles:@"はい",
            nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    
    [alert show];
    
}

//アラートのボタンが押されたときの処理
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch(buttonIndex){
        case 0:
            //いいえが押されたらアプリを終了
            exit(1);
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
        if(first){
            //最初の時点でネットワーク接続ができているとき1.2秒後画面遷移
            ter = [NSTimer scheduledTimerWithTimeInterval:1.2
                                               target:self
                                             selector:@selector(nextPage:)
                                             userInfo:nil
                                              repeats:NO];
        }else{
            //２回目以降でネットワーク接続ができたときメイン処理で0.7秒後画面遷移
            dispatch_async(mainQueue,^{
                ter = [NSTimer scheduledTimerWithTimeInterval:0.7
                                                       target:self
                                                     selector:@selector(nextPage:)
                                                     userInfo:nil
                                                      repeats:NO];
            });

        }
    }else{
        if(first){
            //最初の時点でネットワーク接続ができていないときアラート表示
            ter2 = [NSTimer scheduledTimerWithTimeInterval:0.5
                                            target:self
                                             selector:@selector(showAlert)
                                            userInfo:nil
                                            repeats:NO];
        }else{
            //２回目以降でネットワーク接続ができていないときメイン処理でアラート表示
            dispatch_async(mainQueue,^{
                [self showAlert];
            });

        }
    }

}

//次の画面へ遷移
-(void)nextPage:(NSTimer*)timer{
    ViewController *viewCont =[self.storyboard instantiateViewControllerWithIdentifier:@"main"];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:viewCont animated:YES];
}

@end
