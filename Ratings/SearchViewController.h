//
//  SearchViewController.h
//  Ratings
//
//  Created by MASTER on 2014/08/11.
//  Copyright (c) 2014年 Yuta.Kasiwabara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *Event_Table;

@property (nonatomic, strong) NSArray *dataSourceEvent;
@property (nonatomic, strong) NSArray *dataSourceAmbience;

@end
