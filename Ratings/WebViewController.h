

#import <UIKit/UIKit.h>

//ネットワーク接続確認のために必要
#import "Reachability.h"
#import "NetworkConCheck.h"
#import "RecipeViewController.h"
@class Reachability;

@interface WebViewController : UIViewController<UIWebViewDelegate>
- (IBAction)BackButton:(id)sender;
- (IBAction)UpdateButton:(id)sender;
//@property NSString *getUrl;
extern NSString *getUrl;
@end
