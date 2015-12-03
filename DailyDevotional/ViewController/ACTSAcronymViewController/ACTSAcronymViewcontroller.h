//
//  ACTSAcronymViewcontroller.h
//  DailyDevotional
//
//  Created by ketaki on 6/19/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACTSAcronymViewcontroller : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property  NSMutableArray *arrPrayer;
@property NSArray *arrAcronym;
@property (weak, nonatomic) IBOutlet UITableView *acronymTbl;

@end
