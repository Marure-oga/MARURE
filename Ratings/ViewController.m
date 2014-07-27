
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
NSTimer *ter;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextStrokeRect(context,CGRectMake(50,50,100,100));
    //CGContextSetRGBFillColor(context,0.0,0.0,1.0,1.0);
    //CGContextFillRect(context,CGRectMake(50,50,100,100));
    
    ter = [NSTimer scheduledTimerWithTimeInterval:1
                                           target:self
                                         selector:@selector(nextPage:)
                                         userInfo:nil
                                          repeats:NO];
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault ];
    CGSize pSize = progressView.frame.size;
    CGSize vSize = self.view.frame.size;
    progressView.frame = CGRectMake((vSize.width-pSize.width)/2,(vSize.height-pSize.height)/2+100,pSize.width,pSize.height);
    progressView.progress = 0.0;
    [progressView setProgress:1.0 animated:YES];
    progressView.trackTintColor = [UIColor blackColor];
    [self.view addSubview:progressView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)nextPage:(NSTimer*)timer{
    ViewController *viewCont =[self.storyboard instantiateViewControllerWithIdentifier:@"main"];
    //[self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:viewCont animated:YES];
}

@end
