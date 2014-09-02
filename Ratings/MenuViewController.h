//
//  MenuViewController.h
//  Ratings
//
//  Created by MASTER on 2014/08/18.
//  Copyright (c) 2014年 ogaki.yusuke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonSerchClass.h"
#import "SearchViewController.h"

@interface MenuViewController : UIViewController

extern int Send_Flag;

extern NSMutableArray *Select_URL;
extern NSMutableArray *Recipe_URL;
extern NSMutableArray *Recipe_Title_Arr;

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
-(void) Menu_Img_SET;

@end
