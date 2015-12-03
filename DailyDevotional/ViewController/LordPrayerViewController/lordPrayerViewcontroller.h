//
//  lordPrayerViewcontroller.h
//  DailyDevotional
//
//  Created by ketaki on 6/22/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lordPrayerViewcontroller : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *prayerTbl;
@property NSArray *headingColor;
@property NSArray *arrPrayer;
@end
