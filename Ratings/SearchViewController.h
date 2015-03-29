//
//  SearchViewController.h
//  Ratings
//
//  Created by MASTER on 2014/08/11.
//  Copyright (c) 2014年 Yuta.Kasiwabara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "JsonSerchClass.h"
#import "ShowAppAlert.h"
#import "NetworkConCheck.h"
#import "WebViewController.h"
#import "RecipeSelect.h"

//ネットワーク接続確認のために必要
#import "Reachability.h"
@class Reachability;

@interface SearchViewController : UIViewController

extern int Event_NO;
extern int Ambience_NO;
extern int Display_ID;

extern NSString *Event_Str;
extern NSString *Ambience_Str;

extern Boolean recipeselectact;

@property UIActivityIndicatorView *Ac;

@property (weak, nonatomic) IBOutlet UITableView *Event_Table;
@property (weak, nonatomic) IBOutlet UITableView *Ambience_Table;

@property (nonatomic, strong) NSArray *dataSourceEvent;
@property (nonatomic, strong) NSArray *dataSourceAmbience;



@end
