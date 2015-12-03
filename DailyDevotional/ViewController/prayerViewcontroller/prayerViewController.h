//
//  prayerViewController.h
//  DailyDevotional
//
//  Created by ketaki on 6/19/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "prayerTableViewCell.h"
@interface prayerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property NSArray *arrAcronym;
 @property(nonatomic,assign) NSInteger currentPrayerId;
@property NSString *prayerLineStr;
@property NSString *textAboveLineStr;
@property NSMutableArray *prayerHeader;
@property (weak, nonatomic) IBOutlet UITableView *prayerTbl;
- (IBAction)previous:(id)sender;
- (IBAction)next:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *nextbtn;
@property (strong, nonatomic) IBOutlet UIButton *previousBtn;

@end
