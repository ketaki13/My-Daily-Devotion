//
//  scripturePrayerVC.h
//  DailyDevotional
//
//  Created by ketaki on 6/25/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface scripturePrayerVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property NSArray *arrScriputreGuide;
@property (weak, nonatomic) IBOutlet UITableView *praylerTbl;

@property (weak, nonatomic) IBOutlet UITableView *scriptureTbl;
@property NSString *prayerLineStr;
@property(nonatomic,assign) NSInteger currentPrayerId;
@property NSString *textAboveLineStr;
@property NSMutableArray *arrPrayer;
- (IBAction)next:(id)sender;
- (IBAction)previous:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *nextbtn;
@property (strong, nonatomic) IBOutlet UIButton *previousBtn;

@end
