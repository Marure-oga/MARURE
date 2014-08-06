
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
NSTimer *ter;
NSTimer *ter2;
NSInteger event=0;
NSInteger atomosphere = 0;
double progresslevel = 0;

double searchTime = 5;

Boolean first = true;
Boolean bol = false;
Boolean bol2 = false;

int clickbuttonindex = -1;

UIProgressView *progressView;

UIAlertView *alert;

dispatch_queue_t mainQueue;
dispatch_queue_t subQueue;
//dispatch_queue_t subQueue2;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self syokika];
    
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault ];
    CGSize pSize = progressView.frame.size;
    CGSize vSize = self.view.frame.size;
    progressView.frame = CGRectMake((vSize.width-pSize.width)/2,(vSize.height-pSize.height)/2+100,pSize.width,pSize.height);
    progressView.progress = 0.0;
    progressView.trackTintColor = [UIColor blackColor];
    [progressView setProgress:progresslevel animated:YES];
    [self.view addSubview:progressView];
    
    mainQueue = dispatch_get_main_queue();
    subQueue = dispatch_queue_create("sub1",0);
    //subQueue2 = dispatch_queue_create("sub2",0);
    
    [self Thread];
}

-(void)Thread
{
    dispatch_async(mainQueue,^{
        [self mainQueueMethod];
    });

    /*dispatch_async(subQueue,^{
        [self subQueueMethod];
        
    });*/
    
}

-(void)mainQueueMethod
{
    
    [self network_first];
    
    [progressView setProgress:progresslevel animated:YES];
    [self.view addSubview:progressView];
}

-(void)subQueueMethod
{
    while(true)
    {
        
        if(clickbuttonindex == 1){
            clickbuttonindex = -1;
            NSLog(@"入った");
            [self network];
            if(bol){
                bol = false;
                [self networkaccessHantei:false];
            }
            break;
            
        }
    }
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
    progresslevel = 0;
    clickbuttonindex = -1;
    progresslevel = progresslevel + 0.5;
}

//ネットワーク接続判定最初の一回
-(void)network_first
{
    Boolean accessstate = false;
    
    accessstate = [self networksearch];
    
    [self networkaccessHantei:accessstate];
    
}

-(void)network
{
    first = false;
    Boolean accessstate = false;
    
    NSDate *startDate;
    NSDate *endDate;
    NSTimeInterval interval;
    
    
    clickbuttonindex = -1;
    startDate = [NSDate date];
    
    do{
        accessstate = [self networksearch];
        endDate = [NSDate date];
        interval = [endDate timeIntervalSinceDate:startDate];
    }while(accessstate == false && interval <= searchTime);
    
    if(accessstate){
        [self networkaccessHantei:accessstate];
    }else{
        bol = true;
    }
    
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
        if(first){
            progresslevel = progresslevel + 0.5;
            [progressView setProgress:progresslevel animated:YES];
            [self.view addSubview:progressView];
        }else{
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
    
    /*while(clickbuttonindex == -1){
        [[NSRunLoop currentRunLoop]
         runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5f]];
    }*/
}

//アラートのボタンが押されたときの処理
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch(buttonIndex){
        case 0:
            clickbuttonindex = 0;
            exit(1);
            break;
        case 1:
            //[self network];
            clickbuttonindex = 1;
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
            ter = [NSTimer scheduledTimerWithTimeInterval:1.2
                                               target:self
                                             selector:@selector(nextPage:)
                                             userInfo:nil
                                              repeats:NO];
        }else{
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
            ter2 = [NSTimer scheduledTimerWithTimeInterval:0.5
                                            target:self
                                             selector:@selector(showAlert)
                                            userInfo:nil
                                            repeats:NO];
        }else{
            dispatch_async(mainQueue,^{
                [self showAlert];
            });

        }
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
