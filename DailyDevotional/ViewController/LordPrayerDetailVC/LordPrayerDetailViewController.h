//
//  LordPrayerDetailViewController.h
//  DailyDevotional
//
//  Created by ketaki on 6/22/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LordPrayerDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property UIColor *textColor;
@property NSArray *arrPrayerLineStr;
@property NSString *titleText;
@property NSString *textAboveLineStr;
@property (weak, nonatomic) IBOutlet UITableView *lordPrayerTbl;
@property (strong, nonatomic) IBOutlet UIButton *nextbtn;
@property(nonatomic,assign) NSInteger currentPrayerId;
- (IBAction)next:(id)sender;
- (IBAction)previous:(id)sender;
@property NSArray *arrPrayer;
@property (strong, nonatomic) IBOutlet UIButton *previous;
-(void)nextButton;
@end
