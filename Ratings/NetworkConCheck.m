
//

#import "NetworkConCheck.h"

@interface NetworkConCheck ()

@end

@implementation NetworkConCheck

//ネットワークに接続しているかを判断する時間（秒）
double searchTime = 5.0;
//最初のネットワーク接続確認を行っているかどうかの判定
//Boolean firstcheck = true;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//ネットワーク接続判定１回目
-(bool)network_first
{
    //ネットワーク接続確認できたかどうか
    Boolean constate = false;
    
    //networksearchメソッドの呼び出し
    constate = [self networksearch];
    
    return constate;
    
}

//ネットワーク接続判定２回目以降
-(bool)network
{
    //ネットワーク接続が確認できたかどうか
    Boolean constate = false;
    
    //このメソッドが呼び出された時間の変数
    NSDate *startDate;
    //startDateからどれほど時間がたったかをはかるための変数
    NSDate *endDate;
    //startDateからendDateまでにかかっった時間
    NSTimeInterval interval;
    
    startDate = [NSDate date];
    
    //ネットワーク接続確認がとれるかserrchTimeで設定した時間がたつまで　networksearchメソッドを呼び出すことを繰り返す
    do{
        constate = [self networksearch];
        endDate = [NSDate date];
        interval = [endDate timeIntervalSinceDate:startDate];
    }while(constate == false && interval <= searchTime);
    
    return constate;
}


//ネットワーク接続判定を行うメソッド
-(bool)networksearch
{
    //ネットワーク接続ができているかどうかの変数
    bool networkcon = false;
    
    //ネットワーク接続確認
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus =[curReach currentReachabilityStatus];
    
    if(netStatus == NotReachable){
        //ネットワーク説毒ができていないとき
        networkcon = false;
    }else{
        //ネットワーク接続ができているとき
        networkcon = true;
    }
    
    return networkcon;
}

@end
