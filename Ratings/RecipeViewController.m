
#import "RecipeViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RecipeViewController ()
@end

@implementation RecipeViewController

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
    NSMutableArray *_Select_URL;
    _Select_URL = [NSMutableArray array];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //ナビゲーションバーの非表示
    [self.navigationController setNavigationBarHidden:YES];
    
    //NSLog(@"\n【Fig4】Select_URL_COUNT = %d\n",[Select_URL count]);
    
    int i;
    
    if(Send_Flag == 1){
        i = 0;
    }
    else{
        i = 4;
    }
    self.Menu_Img01.image = [Select_URL objectAtIndex:0+i];
    self.Menu_Img02.image = [Select_URL objectAtIndex:1+i];
    self.Menu_Img03.image = [Select_URL objectAtIndex:2+i];
    self.Menu_Img04.image = [Select_URL objectAtIndex:3+i];
    
    /*self.Menu_Img01.image = [Select_URL objectAtIndex:[[indexnumber objectAtIndex:0+i] intValue]];
    self.Menu_Img02.image = [Select_URL objectAtIndex:[[indexnumber objectAtIndex:1+i] intValue]];
    self.Menu_Img03.image = [Select_URL objectAtIndex:[[indexnumber objectAtIndex:2+i] intValue]];
    self.Menu_Img04.image = [Select_URL objectAtIndex:[[indexnumber objectAtIndex:3+i] intValue]];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//戻るボタンを押したとき左から前の画面を出す
- (IBAction)BackButton:(id)sender {
    
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


//最初に戻るのボタンを押したとき
- (IBAction)BackStart:(id)sender {
    RecipeViewController *push =[self.storyboard instantiateViewControllerWithIdentifier:@"search"];
    
    push.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:push];
    [self presentViewController:navigation animated:YES completion:nil];
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
