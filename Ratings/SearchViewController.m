//
//  SearchViewController.m
//  Ratings
//
//  Created by MASTER on 2014/08/11.
//  Copyright (c) 2014年 Yuta.Kasiwabara. All rights reserved.
//

#import "SearchViewController.h"
#import "JsonSerchClass.h"

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SearchViewController


int Event_NO = -1,
    Ambience_NO = -1;

BOOL Selected_flag = false;


NSIndexPath *bak_indexPath;
UITableViewCell *bak_cell;

NSIndexPath *bak_indexPath_2;
UITableViewCell *bak_cell_2;

//ネットワークに接続しているかを判断する時間（秒）
double searchTime;
//並列処理　メイン処理
dispatch_queue_t mainQueue;
//並列処理　サブ処理
dispatch_queue_t subQueue;

//355行目からのアラート表示に使用
MenuViewController *MVC_Ctl;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.Event_Table.delegate = self;
    self.Event_Table.dataSource = self;

    self.dataSourceEvent = @[@"女子会", @"誕生日", @"クリスマス"];
    self.dataSourceAmbience = @[@"わいわい", @"和やか", @"ロマンチック"];
    
    self.Event_Table.bounces = NO;
    
    
    searchTime = 5.0;
    
    //メイン処理とサブ処理を設定
    mainQueue = dispatch_get_main_queue();
    subQueue = dispatch_queue_create("sub1",0);
    
    //デフォルトのBACKボタンの非表示
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger dataCount;

    switch (section) {
        case 0:
            dataCount = self.dataSourceEvent.count;
            break;
        case 1:
            dataCount = self.dataSourceAmbience.count;
            break;
        default:
            break;
    }
    return dataCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = self.dataSourceEvent[indexPath.row];
            break;
        case 1:
            cell.textLabel.text = self.dataSourceAmbience[indexPath.row];
            break;
        default:
            break;
    }
    
    return cell;
}

//セクション件数を指定
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//セクション名を指定
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger) section {
	switch(section) {
		case 0:
			return @"イベント";
		case 1:
			return @"雰囲気";
		default:
			return @"その他";
	}
}

//セクションの高さ調整
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0:
            return 30;
		case 1:
			return 25;
		default:
			return 0;
	}
}

//セル選択時の処理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 選択されたセルを取得
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // セルのアクセサリにチェックマークを指定
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
    /*
    NSString *Choose_1 = cell.textLabel.text;
    
    NSLog(@"選択：%@",Choose_1);
    NSLog(@"セクション：%ld",(long)indexPath.section);
    NSLog(@"Index：%ld",(long)indexPath.row);
    */
    
    
    //選択されたセクションがイベントの場合
    if((int)indexPath.section == 0)
    {
        if((int)indexPath.row != (int)bak_indexPath.row){
            [tableView deselectRowAtIndexPath:bak_indexPath animated:YES];
            bak_cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        //選択された最新indexを格納
        Event_NO = (int)indexPath.row;
        bak_indexPath = indexPath;
        bak_cell = cell;
        Selected_flag = true;
    }
    //選択されたセクションが雰囲気の場合
    else if ((int)indexPath.section == 1)
    {
        if((int)indexPath.row != (int)bak_indexPath_2.row){
            [tableView deselectRowAtIndexPath:bak_indexPath_2 animated:YES];
            bak_cell_2.accessoryType = UITableViewCellAccessoryNone;
        }
        
        //選択された最新indexを格納
        Ambience_NO = (int)indexPath.row;
        bak_indexPath_2 = indexPath;
        bak_cell_2 = cell;
    }
}

// セルの選択がはずれた時に呼び出される
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 選択がはずれたセルを取得
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // セルのアクセサリを解除する（チェックマークを外す）
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ((int)indexPath.section == 0) {
        Selected_flag = false;
    }
}

//ボタンがタップされたとき
-(IBAction)Button_Tapped:(id)sender {
    
    
    if (Selected_flag){
        dispatch_async(mainQueue,^{
            [self mainQueueMethod];
        });
        
    }
    else {
        
        UIAlertView *alert;
        
        alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                           message:@"イベントを選択してください。"
                                         delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil];
        [alert show];
    }
    Selected_flag = false;
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
//アラート表示の共通化に伴って削除希望（Kasiwabara）
/*
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
*/

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
        NSLog(@"画面2:ネットワーク接続確認OK");dispatch_async(mainQueue,^{
            [self nextPage];
        });
    }else{
        dispatch_async(mainQueue,^{
            
            //MenuViewController *MVC_Ctl = [[MenuViewController alloc]init];
            MVC_Ctl = [[MenuViewController alloc]init]; //MenuViewController *MVC_Ctl;の宣言を３８行目に移動しました
            
            [MVC_Ctl showAlert:@"エラー" MESSAGE_Str:@"ネットワークに接続していません\n再試行しますか？" CANCEL_Str:@"後で" OTHER_Str:@"はい"];
            
            //[self showAlert];
        });
        
    }
    
}

//画面3へ遷移
-(void)nextPage
{
    SearchViewController *viewCont =[self.storyboard instantiateViewControllerWithIdentifier:@"menu"];
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
