//
//  SearchViewController.m
//  Ratings
//
//  Created by MASTER on 2014/08/11.
//  Copyright (c) 2014年 Yuta.Kasiwabara. All rights reserved.
//

#import "SearchViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SearchViewController


int Event_NO = -1,
    Ambience_NO = -1;

Boolean recipeselectact = false;//雰囲気未選択時にtrueになる

//画面ID：遷移元情報
// 1 : 画面1
// 2 : 画面2
// 3 : 画面3
// 4 : 画面4
int Display_ID = 1;

NSString *Event_Str,*Ambience_Str;
UIActivityIndicatorView *Ac;

//検索条件判定フラグ
//true : 遷移可能
//false: 検索条件が不正
BOOL Selected_flag = false;

//選択されたセルのバックアップ変数
UITableViewCell *bak_cell = nil;

//並列処理　メイン処理
dispatch_queue_t mainQueue;
//並列処理　サブ処理
dispatch_queue_t subQueue;

ShowAppAlert *saa;
NetworkConCheck *ncc;
RecipeSelect *rs;


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
    
    self.Ambience_Table.delegate = self;
    self.Ambience_Table.dataSource = self;

    self.dataSourceEvent = @[@"女子会", @"誕生日", @"クリスマス"];
    self.dataSourceAmbience = @[@"わいわい", @"和やか", @"ロマンチック"];
    
    //メイン処理とサブ処理を設定
    mainQueue = dispatch_get_main_queue();
    subQueue = dispatch_queue_create("sub1",0);
    
    //ナビゲーションバーの表示
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //ナビゲーションバーの色選択
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:243/255.0 green:126/255.0 blue:74/255.0 alpha:1.000];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.font = [UIFont boldSystemFontOfSize:16.0];
    title.textColor = [UIColor whiteColor];
    title.text = @"マルレ";
    [title sizeToFit];
    
    self.navigationItem.titleView = title;
    
    //デフォルトのBACKボタンの非表示
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

-(void) viewWillAppear:(BOOL)animated{
    [Ac stopAnimating];
}

- (void) viewDidAppear:(BOOL)animated
{
    if(Display_ID > 2){
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:Event_NO inSection:0];
        [self.Event_Table selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//テーブルのセル数を指定
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //イベントのセル数：イベントのデータソースカウント分
    if(tableView.tag == 0){
        return self.dataSourceEvent.count;
    }
    //雰囲気のセル数：雰囲気のデータソースカウント分
    else{
        return self.dataSourceAmbience.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    switch (tableView.tag) {
        case 0:
            cell.textLabel.text = self.dataSourceEvent[indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            if(Display_ID == 3){
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:Event_NO inSection:0];
                [self.Event_Table selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            }
            break;
        case 1:
            cell.textLabel.text = self.dataSourceAmbience[indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            if(Display_ID == 3){
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:Ambience_NO inSection:0];
                [self.Ambience_Table selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            }
            break;
        default:
            break;
    }
    
    return cell;
}

//セル選択時の処理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //選択されたテーブルがイベントの場合
    if(tableView.tag == 0)
    {
        //すでに選択しているイベントである場合
        if((int)indexPath.row == Event_NO){
            //選択状態を解除
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            //イベントの選択インデックス初期化
            Event_NO = -1;
            Event_Str = nil;
            NSLog(@"Event_NO : %d\n",Event_NO);
            
            //選択条件：不正
            Selected_flag = false;
        }
        else{
            //選択された最新indexを格納
            Event_NO = (int)indexPath.row;
            Event_Str = nil;
            Event_Str = self.dataSourceEvent[indexPath.row];
            NSLog(@"Event_NO : %d\n",Event_NO);
            NSLog(@"Event_Str : %@\n",Event_Str);
            
            //選択条件：正
            Selected_flag = true;
        }
    }
    //選択されたテーブルが雰囲気の場合
    else{
        //すでに選択している雰囲気である場合
        if((int)indexPath.row == Ambience_NO){
            //選択状態を解除
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            //雰囲気の選択インデックス初期化
            Ambience_NO = -1;
            Ambience_Str = nil;
            NSLog(@"Ambience_NO : %d\n",Ambience_NO);
        }
        else{
            //選択された最新indexを格納
            Ambience_NO = (int)indexPath.row;
            Ambience_Str = self.dataSourceAmbience[indexPath.row];
            NSLog(@"Ambience_NO : %d\n",Ambience_NO);
            NSLog(@"Ambience_Str : %@\n",Ambience_Str);
        }
    }
}

//次へボタンがタッチアップされたとき
-(IBAction)Button_Tapped:(id)sender {
    //検索条件が正しい場合
    if(Selected_flag){
        Display_ID = 2;
        
        recipeselectact = false;
        if(Ambience_NO == -1)
        {
            rs = [[RecipeSelect alloc]init];
            Ambience_NO = [rs recipeselect];
            Ambience_Str = self.dataSourceAmbience[Ambience_NO];
            recipeselectact = true;
        }
        
        Ac = [[UIActivityIndicatorView alloc] init];
        Ac.frame = CGRectMake(0, 0, 50, 50);
        Ac.center = self.view.center;
        Ac.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        Ac.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
        [self.view addSubview:Ac];
        
        [Ac startAnimating];

        NSLog(@"イベント：%d / 雰囲気 %d",Event_NO,Ambience_NO);
        dispatch_async(mainQueue,^{
            [self mainQueueMethod];
        });
    }
    //検索条件不正
    else{
        saa = [[ShowAppAlert alloc]init];
        [saa showAlert:@"エラー" MESSAGE_Str:@"イベントを選択してください。" CANCEL_Str:@"確認" OTHER_Str:nil];
    }
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

//アラートのボタンが押されたときの処理
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch(buttonIndex){
        case 0:
            [Ac stopAnimating];
            
            if(recipeselectact)
            {
                Ambience_NO = -1;
                Ambience_Str = nil;
            }
            
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
-(void)networkconHantei:(Boolean)constate
{
    saa = [[ShowAppAlert alloc]init];
    
    if(constate){
        NSLog(@"画面2:ネットワーク接続確認OK");dispatch_async(mainQueue,^{
            [self nextPage];
        });
    }else{
        dispatch_async(mainQueue,^{
            /*[saa showAlert:@"エラー" MESSAGE_Str:@"ネットワークに接続していません\n再試行しますか？" CANCEL_Str:@"後で" OTHER_Str:@"はい"];*/
            
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

//画面3へ遷移
-(void)nextPage
{
    Display_ID = 2;
    MenuViewController *menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menu"];
    [self.navigationController pushViewController:menuViewController animated:YES];
}

@end
