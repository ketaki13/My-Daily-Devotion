//
//  VersesDetailViewController.h
//  DailyDevotional
//
//  Created by webwerks on 5/7/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPagerController.h"
#import <sqlite3.h>
#import "AppDelegate.h"
//#import "MPConstants.h"
//#import "MPAdView.h"

@import GoogleMobileAds;
// @class GADBannerView;

@interface VersesDetailViewController : ViewPagerController<UITableViewDataSource,UITableViewDelegate>
{
    sqlite3 *dbInstance;
    AppDelegate *appDelegate;
    NSString *strTableName;
    NSMutableArray *arrColor;
     NSMutableArray *menu;
    int nPrayerHitCount;
     NSArray *_products;
    BOOL isPurchase;
    UITableView *tableView;
    UIButton *moreInfo;
    NSArray *arrPrayerDetails;
    BOOL allFlag;
    NSArray *activityItems;


}
@property (strong, nonatomic) IBOutlet UILabel *navLbl;
@property (strong, nonatomic) IBOutlet UIButton *navicon;
@property (strong, nonatomic) IBOutlet UIView *crossView;
@property (weak, nonatomic) IBOutlet UILabel *lblHomeNotification;
@property NSArray *arrList;
@property NSArray *arrCrossPromoLink;
@property NSArray *arrnav;
@property (strong, nonatomic) IBOutlet GADBannerView *bannerView;
//@property (strong, nonatomic) MPAdView *adView;



- (IBAction)fnBack:(UIButton *)sender;
- (IBAction)fnGetMoreApps:(id)sender;
- (IBAction)fnGetTodaysApp:(UIButton *)sender;
- (IBAction)fnBackgraoundsClicked:(id)sender;
-(NSDate *)getCurrentTime;
-(void)gotoDetailview:(id)sender;
-(void)productPurchasedFails:(NSNotification *)notification;

@end
