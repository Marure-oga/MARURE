
#import "RecipeViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RecipeViewController ()
@end

@implementation RecipeViewController

int Select_Flag = 0;

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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //ナビゲーションバーの非表示
    [self.navigationController setNavigationBarHidden:YES];
    
    //NSLog(@"\n【Fig4】Select_URL_COUNT = %d\n",[Select_URL count]);
    
    MenuViewController *mvc;
    mvc = [[MenuViewController alloc]init];

    int i,
    j = 0;
    NSString *Title_Text;
    
    if(Send_Flag == 1){
        i = 0;
    }
    else{
        i = 4;
        j = 4;
    }
    /*self.Menu_Img01.image = [Select_URL objectAtIndex:0+i];
    self.Menu_Img02.image = [Select_URL objectAtIndex:1+i];
    self.Menu_Img03.image = [Select_URL objectAtIndex:2+i];
    self.Menu_Img04.image = [Select_URL objectAtIndex:3+i];*/
    
    self.Menu_Img01.image = [Select_URL objectAtIndex:[[indexnumber objectAtIndex:0+i] intValue]];
    self.Menu_Img02.image = [Select_URL objectAtIndex:[[indexnumber objectAtIndex:1+i] intValue]];
    self.Menu_Img03.image = [Select_URL objectAtIndex:[[indexnumber objectAtIndex:2+i] intValue]];
    self.Menu_Img04.image = [Select_URL objectAtIndex:[[indexnumber objectAtIndex:3+i] intValue]];

    if ([Recipe_Title_Arr count] == 0) {
        NSLog(@"\n【Fig4】Recipe_Title_Arr_COUNT = %d\n",[Recipe_Title_Arr count]);
    }
    else{
        for (i = 0; i < 4; i++) {
            //Title_Text = [Recipe_Title_Arr objectAtIndex:i+j];
            Title_Text = [Recipe_Title_Arr objectAtIndex:[[indexnumber objectAtIndex:i+j] intValue]];
            [self Title_Set:i :Title_Text];
            //NSLog(@"\n【Fig4】i = %d j= %d\n",i,j);
        }
        //NSLog(@"\n【Fig4】Recipe_Title_Arr_COUNT = %d\n",[Recipe_Title_Arr count]);
    }
}

- (void)Title_Set:(NSInteger)Label_Id :(NSString*)Recipe_Title
{
    switch (Label_Id) {
        case 0:
            self.Recipe_Text01.text = Recipe_Title;
            self.Recipe_Text01.numberOfLines = 0;
            [self.Recipe_Text01 sizeToFit];
            break;
        case 1:
            self.Recipe_Text02.text = Recipe_Title;
            self.Recipe_Text02.numberOfLines = 0;
            [self.Recipe_Text02 sizeToFit];
            break;
        case 2:
            self.Recipe_Text03.text = Recipe_Title;
            self.Recipe_Text03.numberOfLines = 0;
            [self.Recipe_Text03 sizeToFit];
            break;
        case 3:
            self.Recipe_Text04.text = Recipe_Title;
            self.Recipe_Text04.numberOfLines = 0;
            [self.Recipe_Text04 sizeToFit];
            break;
        default:
            break;
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    int i = 0;
    if(Send_Flag == 2){
        i =4;
    }
    
    if ([[segue identifier] isEqualToString:@"Select_Recipe_01"]) {
        WebViewController *vcntl = [segue destinationViewController];
        if(Send_Flag == 2) i = 4;
        //vcntl.getUrl = [Recipe_URL objectAtIndex:0+i];
        vcntl.getUrl = [Recipe_URL objectAtIndex:[[indexnumber objectAtIndex:i+0] intValue]];
    }
    if([[segue identifier] isEqualToString:@"Select_Recipe_02"]){
        WebViewController *vcntl = [segue destinationViewController];
        //vcntl.getUrl = [Recipe_URL objectAtIndex:1+i];
        vcntl.getUrl = [Recipe_URL objectAtIndex:[[indexnumber objectAtIndex:i+1] intValue]];
    }
    if([[segue identifier] isEqualToString:@"Select_Recipe_03"]){
        WebViewController *vcntl = [segue destinationViewController];
        //vcntl.getUrl = [Recipe_URL objectAtIndex:2+i];
        vcntl.getUrl = [Recipe_URL objectAtIndex:[[indexnumber objectAtIndex:i+2] intValue]];
    }
    if([[segue identifier] isEqualToString:@"Select_Recipe_04"]){
        WebViewController *vcntl = [segue destinationViewController];
        //vcntl.getUrl = [Recipe_URL objectAtIndex:3+i];
        vcntl.getUrl = [Recipe_URL objectAtIndex:[[indexnumber objectAtIndex:i+3] intValue]];
    }
}

- (IBAction)Recipe_Button_01:(id)sender {
    Select_Flag = 1;
}
- (IBAction)Recipe_Button_02:(id)sender {
    Select_Flag = 2;
}
- (IBAction)Recipe_Button_03:(id)sender {
    Select_Flag = 3;
}
- (IBAction)Recipe_Button_04:(id)sender {
    Select_Flag = 4;
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
