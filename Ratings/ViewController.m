
#import "ViewController.h"
#import "JsonSerchClass.h"
@interface ViewController ()

@end

@implementation ViewController
//タイマー１　画面遷移の時間用の変数
NSTimer *timer;
//タイマー２　最初のアラート表示の時間用
NSTimer *timer2;
//プログレスバー進捗度（０〜１）
double progresslevel = 0;
//ネットワークに接続しているかを判断する時間（秒）
//double searchTime;
//最初のネットワーク接続確認を行っているかどうかの判定
Boolean firstcheck = true;

// 08/08 by yo
MarureKeyS *mrks;
ShowAppAlert *saa;
//以上 08/08 by yo

//プログレスバー
UIProgressView *progressView;

//アラート
UIAlertView *alert;

//並列処理　メイン処理
dispatch_queue_t mainQueue;

//並列処理　サブ処理
dispatch_queue_t subQueue;

NetworkConCheck *ncc;

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
    
    
    //メイン処理とサブ処理を設定
    mainQueue = dispatch_get_main_queue();
    subQueue = dispatch_queue_create("sub1",0);
    
    //Threadメソッドの呼び出し
    [self Thread];
    
    // 08/09 by yo
    //イベントと雰囲気　を記録するファイルを呼び出す
    //第一引数はイベントindex
    //第二引数は雰囲気index
    //追加の時MARUREJson例のように追加してください
    //結果はログで確認してください　＝。＝
    //mrks = [[MarureKeyS alloc]init]; //インスタンスを生成して初期化
    //[mrks SetEventAndMoody:0 moody:0];//ここでAPI呼び出す（今は仮データを呼び出す）画面遷移の時を呼び出してください
    //apiの制限によって、１秒で４つのレシピを出せる、最大で６秒
    //mrks.recipeNameArr   レシピ名配列
    //mrks.recipeImgArr　レシピ画像配列
    //mrks.recipUrlArr　　レシピurl配列
    //配列は[mrks SetEventAndMoody:0 moody:0];を呼び出す後からデータが入るのでその前にnilになっている
    //
    //以上 08/09 by yo
    
    //ナビゲーションバーの非表示
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    

}

//メイン処理としてmainQueueメソッドの実行
-(void)Thread
{
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
    if(hantei){
        //最初のときプログレスバーの進行
        progresslevel = progresslevel + 0.5;
        [progressView setProgress:progresslevel animated:YES];
        [self.view addSubview:progressView];

    }
    
    [self networkconHantei:hantei];
    
    [progressView setProgress:progresslevel animated:YES];
    [self.view addSubview:progressView];
}

//サブ処理　ネットワーク接続確認（２回目以降）を実行
-(void)subQueueMethod
{
    firstcheck = false;
    
    bool hantei = false;
    hantei = [ncc network];
    if(hantei){
        //２回目以降のときメイン処理でプログレスバーの進行　メイン処理側で実行
        dispatch_async(mainQueue,^{
            progresslevel = progresslevel + 0.5;
            [progressView setProgress:progresslevel animated:YES];
            [self.view addSubview:progressView];
        });
    }
    
    [self networkconHantei:hantei];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//変数初期化 プログレスバーを0.5進行
-(void)syokika
{
    progresslevel = 0;
    firstcheck = true;
    //searchTime = 5.0;
    
    progresslevel = progresslevel + 0.5;
}

//アラートの表示
-(void)showAlert
{
    saa = [[ShowAppAlert alloc]init];
    
    //[saa showAlert:@"エラー"MESSAGE_Str:@"ネットワークに接続していません\n再試行しますか？"CANCEL_Str:@"いいえ"OTHER_Str:@"はい"];
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


//ネットワーク接続ができているかどうかとそれに対応する処理
-(void)networkconHantei:(Boolean)constate
{
    saa = [[ShowAppAlert alloc]init];
    
    if(constate){
        if(firstcheck){
            //最初の確認でネットワーク接続ができているとき1.2秒後画面遷移
            timer = [NSTimer scheduledTimerWithTimeInterval:1.2
                                               target:self
                                             selector:@selector(nextPage:)
                                             userInfo:nil
                                              repeats:NO];
        }else{
            //２回目以降の確認でネットワーク接続ができたときメイン処理で0.7秒後画面遷移
            dispatch_async(mainQueue,^{
                timer = [NSTimer scheduledTimerWithTimeInterval:0.7
                                                       target:self
                                                     selector:@selector(nextPage:)
                                                     userInfo:nil
                                                      repeats:NO];
            });

        }
    }else{
        if(firstcheck){
            //最初の確認でネットワーク接続ができていないときアラート表示
            timer2 = [NSTimer scheduledTimerWithTimeInterval:0.5
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

//検索条件入力画面へ遷移
-(void)nextPage:(NSTimer*)timer{
    ViewController *viewCont =[self.storyboard instantiateViewControllerWithIdentifier:@"search"];
    [self.navigationController pushViewController:viewCont animated:YES];
}

@end
