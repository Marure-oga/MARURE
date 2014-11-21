
//

#import <UIKit/UIKit.h>

//ネットワーク接続確認のために必要
#import "Reachability.h"

@interface NetworkConCheck : UIViewController

-(bool)network_first;
-(bool)network;
-(bool)networksearch;
@end
