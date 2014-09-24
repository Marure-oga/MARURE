

#import <UIKit/UIKit.h>

//ネットワーク接続確認のために必要
#import "Reachability.h"
@class Reachability;

@interface WebViewController : UIViewController<UIWebViewDelegate>
- (IBAction)BackButton:(id)sender;
- (IBAction)UpdateButton:(id)sender;
@property NSString *getUrl;
@end
