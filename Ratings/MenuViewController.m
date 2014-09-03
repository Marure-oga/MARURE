//
//  MenuViewController.m
//  Ratings
//
//  Created by MASTER on 2014/08/18.
//  Copyright (c) 2014年 Yuta.Kasiwabara. All rights reserved.
//

#import "MenuViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MenuViewController ()
@end

@implementation MenuViewController

int Send_Flag;

NSString *Url_Str;
NSURL *Img_URL;
NSData *Img_Data;
UIImage *Recipe_Img;

NSMutableArray *Select_URL;

//Menu_Image_01〜Menu_Image_08に対応するレシピ番号
NSMutableArray *indexnumber;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)Menu_Img_SET
{
    
    MarureKeyS *mrks;
    mrks = [[MarureKeyS alloc]init];
    
    if([Select_URL count] == 0) Select_URL = [NSMutableArray array];
    
    if(Send_Flag != -1){
        Send_Flag = 0;
    }
    
    int Img_Count = 0,
    Name_Count = 0;
    
    if(Send_Flag == 0){
        [mrks SetEventAndMoody:0 moody:0];
    }
    
    //NSLog(@"\nSend_Flag = %d\n",Send_Flag);
    
    Img_Count = [mrks.recipeImgArr count];
    Name_Count = [mrks.recipeNameArr count];
    
    if(Img_Count > 0 || Send_Flag == -1){
        int i;
        
        for(i = 0;i < 8;i++){
            if(Send_Flag == 0){
                Url_Str = [mrks.recipeImgArr objectAtIndex:i];
                Img_URL = [NSURL URLWithString:Url_Str];
                Img_Data = [NSData dataWithContentsOfURL:Img_URL];
                Recipe_Img = [UIImage imageWithData:Img_Data];
                [Select_URL addObject:Recipe_Img];
                
                [indexnumber addObject:[NSNumber numberWithInteger:i]];
                
            }
            //NSLog(@"カウント：%d\n",[Select_URL count]);
            
            switch (i) {
                case 0:
                    //self.Menu_Image_01.contentMode = UIViewContentModeScaleAspectFit;
                    //戻るボタンでselfに遷移していない場合
                    if (Send_Flag == 0) {
                        self.Menu_Image_01.image = Recipe_Img;
                    }
                    //戻るボタンでselfに遷移した場合
                    else{
                        self.Menu_Image_01.image = [Select_URL objectAtIndex:0];
                    }
                    break;
                case 1:
                    //self.Menu_Image_02.contentMode = UIViewContentModeScaleAspectFit;
                    if (Send_Flag == 0) {
                        self.Menu_Image_02.image = Recipe_Img;
                    }
                    else{
                        self.Menu_Image_02.image = [Select_URL objectAtIndex:1];
                    }
                case 2:
                    //self.Menu_Image_03.contentMode = UIViewContentModeScaleAspectFit;
                    if (Send_Flag == 0) {
                        self.Menu_Image_03.image = Recipe_Img;
                    }
                    else{
                        self.Menu_Image_03.image = [Select_URL objectAtIndex:2];
                    }
                case 3:
                    //self.Menu_Image_04.contentMode = UIViewContentModeScaleAspectFit;
                    if (Send_Flag == 0) {
                        self.Menu_Image_04.image = Recipe_Img;
                    }
                    else{
                        self.Menu_Image_04.image = [Select_URL objectAtIndex:3];
                    }
                case 4:
                    //self.Menu_Image_05.contentMode = UIViewContentModeScaleAspectFit;
                    if (Send_Flag == 0) {
                        self.Menu_Image_05.image = Recipe_Img;
                    }
                    else{
                        self.Menu_Image_05.image = [Select_URL objectAtIndex:4];
                    }
                case 5:
                    //self.Menu_Image_06.contentMode = UIViewContentModeScaleAspectFit;
                    if (Send_Flag == 0) {
                        self.Menu_Image_06.image = Recipe_Img;
                    }
                    else{
                        self.Menu_Image_06.image = [Select_URL objectAtIndex:5];
                    }
                case 6:
                    //self.Menu_Image_07.contentMode = UIViewContentModeScaleAspectFit;
                    if (Send_Flag == 0) {
                        self.Menu_Image_07.image = Recipe_Img;
                    }
                    else{
                        self.Menu_Image_07.image = [Select_URL objectAtIndex:6];
                    }
                case 7:
                    //self.Menu_Image_08.contentMode = UIViewContentModeScaleAspectFit;
                    if (Send_Flag == 0) {
                        self.Menu_Image_08.image = Recipe_Img;
                    }
                    else{
                        self.Menu_Image_08.image = [Select_URL objectAtIndex:7];
                    }
                default:
                    break;
            }
        }
    }
    else{
        NSLog(@"\n画像が取得出来ません！\n");
        NSLog(@"\nrecipeImgArr_Count = %d\n",Img_Count);
        NSLog(@"\nrecipeNameArr_Count = %d\n",Name_Count);
        
        UIAlertView *alert;
        
        alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                           message:@"画像が取得出来ません！"
                                          delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil];
        [alert show];
        Send_Flag = 0;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //ナビゲーションバーの非表示
    [self.navigationController setNavigationBarHidden:YES];
    
    
    [self Menu_Img_SET];
    
    //右へスワイプしたときの処理
    UISwipeGestureRecognizer *swiperight = [[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(swipe:)];
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
    swiperight.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swiperight];
    
    //左へスワイプしたときの処理
    UISwipeGestureRecognizer *swipeleft = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(swipe:)];
    swipeleft.direction = UISwipeGestureRecognizerDirectionRight;
    swipeleft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeleft.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipeleft];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//戻るボタンを押したとき左から前の画面を出す
- (IBAction)BackButton:(id)sender {
    CATransition * transition = [CATransition animation];
    
    transition.duration = 0.4;
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    
    MenuViewController *push =[self.storyboard instantiateViewControllerWithIdentifier:@"search"];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:push animated:NO];
    
    Send_Flag = 0;
    [Select_URL removeAllObjects];
}


- (IBAction)Menu_01:(id)sender {
    Send_Flag = 1;
    //NSLog(@"\nSend_Flag = %d\n",Send_Flag);
}
- (IBAction)Menu_02:(id)sender {
    Send_Flag = 2;
    //NSLog(@"\nSend_Flag = %d\n",Send_Flag);
}

//スワイプしたときMenu_Img_Changeを呼び出す
-(void)swipe:(UISwipeGestureRecognizer *)gesture
{
    [self Menu_Img_Change];
}

//表示されているメニューの画像をランダムに更新する
-(void)Menu_Img_Change{
    int i;
    int random = 0;
    bool hantei = true;
    indexnumber = [NSMutableArray array];
    for(i = 0;i < 8;i++){
        do{
            random = (int)(arc4random() %8);
            hantei = false;
            for(int j =0;j<i;j++){
                if([[indexnumber objectAtIndex:j] intValue] == random){
                    hantei = true;
                    break;
                }
            }
        }while(hantei);
        [indexnumber addObject:[NSNumber numberWithInteger:random]];
        
        switch (i) {
            case 0:
                self.Menu_Image_01.image = [Select_URL objectAtIndex:random];
                break;
            case 1:
                self.Menu_Image_02.image = [Select_URL objectAtIndex:random];
                break;
            case 2:
                self.Menu_Image_03.image = [Select_URL objectAtIndex:random];
                break;
            case 3:
                self.Menu_Image_04.image = [Select_URL objectAtIndex:random];
                break;
            case 4:
                self.Menu_Image_05.image = [Select_URL objectAtIndex:random];
                break;
            case 5:
                self.Menu_Image_06.image = [Select_URL objectAtIndex:random];
                break;
            case 6:
                self.Menu_Image_07.image = [Select_URL objectAtIndex:random];
                break;
            case 7:
                self.Menu_Image_08.image = [Select_URL objectAtIndex:random];
                break;
            default:
                break;
        }
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
