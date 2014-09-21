
#import <UIKit/UIKit.h>
#import "JsonSerchClass.h"
#import "SearchViewController.h"

@interface MenuViewController : UIViewController

extern int Send_Flag;

extern NSMutableArray *Select_URL_1;
extern NSMutableArray *Select_URL_2;
extern NSMutableArray *Select_URL_3;
extern NSMutableArray *Select_URL_4;

extern NSMutableArray *Recipe_URL_1;
extern NSMutableArray *Recipe_URL_2;
extern NSMutableArray *Recipe_URL_3;
extern NSMutableArray *Recipe_URL_4;

extern NSMutableArray *Recipe_Title_Arr_1;
extern NSMutableArray *Recipe_Title_Arr_2;
extern NSMutableArray *Recipe_Title_Arr_3;
extern NSMutableArray *Recipe_Title_Arr_4;

extern NSMutableArray *indexnumber;

@property (weak, nonatomic) IBOutlet UIImageView *Menu_Image_01;
@property (weak, nonatomic) IBOutlet UIImageView *Menu_Image_02;
@property (weak, nonatomic) IBOutlet UIImageView *Menu_Image_03;
@property (weak, nonatomic) IBOutlet UIImageView *Menu_Image_04;

@property (weak, nonatomic) IBOutlet UIImageView *Menu_Image_05;
@property (weak, nonatomic) IBOutlet UIImageView *Menu_Image_06;
@property (weak, nonatomic) IBOutlet UIImageView *Menu_Image_07;
@property (weak, nonatomic) IBOutlet UIImageView *Menu_Image_08;

@property (weak, nonatomic) IBOutlet UIButton *Menu_01;
@property (weak, nonatomic) IBOutlet UIButton *Menu_02;

-(void) Menu_Img_GET;
-(void) Menu_Img_UrlSet:(NSInteger)Category_Num;
-(void) Menu_Img_Show;

@end
