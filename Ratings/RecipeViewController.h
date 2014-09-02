//
//  RecipeViewController.h
//  Ratings
//
//  Created by MASTER on 2014/08/18.
//  Copyright (c) 2014年 ogaki.yusuke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "WebViewController.h"

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