#import "ShowAppAlert.h"

/*
 引数：
 　TITLE_Str:@"タイトル"
 　MESSAGE_Str:@"文言"
 　CANCEL_Str:@"キャンセルボタンラベル名"
 　OTHER_Str:@"OKボタンラベル名"
 返却値：
 　アラートをポップアップで表示
 */

@implementation ShowAppAlert

//アラート表示
-(void)showAlert:(NSString*)TITLE_Str MESSAGE_Str:(NSString*)MESSAGE_Str CANCEL_Str:(NSString*)CANCEL_Str OTHER_Str:(NSString*)OTHER_Str{
    UIAlertView *alert;
    
    alert =[[UIAlertView alloc]
            initWithTitle:TITLE_Str
            message:MESSAGE_Str
            delegate:self
            cancelButtonTitle:CANCEL_Str
            otherButtonTitles:OTHER_Str,
            nil];
    
    alert.alertViewStyle = UIAlertViewStyleDefault;
    
    [alert show];
    
}
@end
