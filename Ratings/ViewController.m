
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
NSTimer *ter;
NSInteger event=0;
NSInteger atomosphere = 0;
double progresslevel = 0;
UIProgressView *progressView;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextStrokeRect(context,CGRectMake(50,50,100,100));
    //CGContextSetRGBFillColor(context,0.0,0.0,1.0,1.0);
    //CGContextFillRect(context,CGRectMake(50,50,100,100));
    
    
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault ];
    CGSize pSize = progressView.frame.size;
    CGSize vSize = self.view.frame.size;
    progressView.frame = CGRectMake((vSize.width-pSize.width)/2,(vSize.height-pSize.height)/2+100,pSize.width,pSize.height);
    progressView.progress = 0.0;
    progressView.trackTintColor = [UIColor blackColor];
    [progressView setProgress:progresslevel animated:YES];
    [self.view addSubview:progressView];
    
    
    [self syokika];
    
    [self network];
    
    [progressView setProgress:progresslevel animated:YES];
    [self.view addSubview:progressView];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//初期化用
-(void)syokika
{
    event = 0;
    atomosphere = 0;
    progresslevel = progresslevel + 0.5;
}

//ネットワーク接続判定の中枢
-(void)network
{
    Boolean accessstate = false;
    
    accessstate = [self networksearch];
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
        networkaccess = true;
        progresslevel = progresslevel + 0.5;
        [progressView setProgress:progresslevel animated:YES];
        [self.view addSubview:progressView];
    }
    
    return networkaccess;
}

//アラートの表示
-(void)showAlert
{
    UIAlertView *alert =[[UIAlertView alloc]
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
            exit(1);
            break;
        case 1:
            [self network];
            break;
    }
}

//ネットワーク接続ができているかどうか
-(void)networkaccessHantei:(Boolean)accessstate
{
    if(accessstate){
        ter = [NSTimer scheduledTimerWithTimeInterval:1.2
                                               target:self
                                             selector:@selector(nextPage:)
                                             userInfo:nil
                                              repeats:NO];
    }else{
        [self showAlert];
    }

}

//次の画面へ遷移
-(void)nextPage:(NSTimer*)timer{
    ViewController *viewCont =[self.storyboard instantiateViewControllerWithIdentifier:@"main"];
    //[self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:viewCont animated:YES];
}

@end
