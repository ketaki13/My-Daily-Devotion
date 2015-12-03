//
//  PrayerToStChristopher.h
//  DailyDevotional
//
//  Created by ketaki on 6/22/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrayerToStChristopher : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property NSMutableArray *arrChristPrayer;
@property NSString *prayerCount;
@property int maxId;
@property NSString *bookletprayerId;
@property int bookletId;
@property int minId;
@property NSString *titleStr;
@property (weak, nonatomic) IBOutlet UITableView *christoperTbl;
- (IBAction)previous:(id)sender;
@property UIColor *bgColor;

- (IBAction)next:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *nextbtn;
@property (strong, nonatomic) IBOutlet UIButton *previousbBrtn;


@property(nonatomic,assign) NSInteger currentPrayerId;
@end
