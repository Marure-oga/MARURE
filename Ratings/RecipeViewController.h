#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "SearchViewController.h"
#import "WebViewController.h"

//ネットワーク接続確認のために必要
#import "Reachability.h"
@class Reachability;

@interface RecipeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *Menu_Img01;
@property (weak, nonatomic) IBOutlet UIImageView *Menu_Img02;
@property (weak, nonatomic) IBOutlet UIImageView *Menu_Img03;
@property (weak, nonatomic) IBOutlet UIImageView *Menu_Img04;

@property (weak, nonatomic) IBOutlet UILabel *Recipe_Text01;
@property (weak, nonatomic) IBOutlet UILabel *Recipe_Text02;
@property (weak, nonatomic) IBOutlet UILabel *Recipe_Text03;
@property (weak, nonatomic) IBOutlet UILabel *Recipe_Text04;
@end
