  //
//  VersesDetailViewController.m
//  DailyDevotional
//
//  Created by webwerks on 5/7/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
#define kBannerAdUnitID @"ca-app-pub-8594467615871430/9694586509"
#define kBannerAdUnitId250 @"ca-app-pub-8594467615871430/8217853304"
#define firstID 1
#import "VersesDetailViewController.h"
#import "Reachability.h"
#import "Flurry.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "InAppDetailViewController.h"
#import "bibleNameDictViewController.h"
#import "guideToConfession.h"
#import "ACTSModelViewController.h"
#import "prayerGuide.h"
#import "PrayerToStChristopher.h"
#import "database.h"
#import "scriptureGuideVC.h"
#import "constants.h"
#import "DailyDevotionalHelper.h"
#import "imageViewController.h"
#import <StoreKit/StoreKit.h>
#import "MBProgressHUD.h"
#import <UIKit/UIKit.h>
#import "TenjinSDK.h"
@interface VersesDetailViewController () <ViewPagerDelegate, ViewPagerDataSource>
{
    NSArray *arrTabText;
    AppDelegate *app;
   
   
}

@property (nonatomic) NSUInteger numberOfTabs;
@end

@implementation VersesDetailViewController
@synthesize arrList,arrnav;
#pragma mark-View
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationIcon];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self setNavigationBar];
    self.lblHomeNotification.layer.cornerRadius = 10;
    self.lblHomeNotification.clipsToBounds = YES;
    sleep(1.0);
    app=APP_Delegate;
    arrColor=[[NSMutableArray alloc]init];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    [refreshControl beginRefreshing];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height-114, self.view.frame.size.width, 50)];
    self.bannerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bannerView];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30.0/255.0 green:188.0/255.0 blue:248.0/255.0 alpha:1]];
    NSInteger savedCount = kSavedCount == nil ? 0 : [kSavedCount integerValue];
    nPrayerHitCount = savedCount + 1;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",nPrayerHitCount] forKey:@"prayerCount"];
    NSLog(@"Prayer tab hit %d times", nPrayerHitCount);
    
    if (0 == (nPrayerHitCount % 6))
    {
        NSLog(@"Show Ad");
        [appDelegate showAddOnPayerCountHit:self];
    }
    arrTabText = [[NSArray alloc]initWithObjects:@"Today's Prayer",@"Today's Verse",@"Today's  Sponsor",@"Deluxe  Tools",nil];
    self.numberOfTabs = arrTabText.count;
    
    self.delegate = self;
    self.dataSource = self;
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"My Daily Devotion";
    NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIColor whiteColor],     NSForegroundColorAttributeName, [UIFont fontWithName:@"SegoeUISymbol" size:(IS_IPAD ? 26 : 18 )],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:textTitleOptions];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:30.0 green:188.0 blue:248.0 alpha:1]];
    self.bannerView.adUnitID = kBannerAdUnitID;
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    [self.bannerView loadRequest:request];
    [self fnCheckReachability];
 }
-(void)setNavigationIcon
{
    NSString *strFileName=[[NSBundle mainBundle]pathForResource:@"NavIconList" ofType:@"plist"];
    arrnav=[[NSMutableArray alloc]initWithContentsOfFile:strFileName];
    UIImage *btnImage = [UIImage imageNamed:[[arrnav objectAtIndex:[[APP_Delegate morappCount] intValue]] objectForKey:@"icon"]];
    [self.navicon setBackgroundImage:btnImage forState:UIControlStateNormal];
    self.navLbl.text=[[arrnav objectAtIndex:[[APP_Delegate morappCount] intValue]] objectForKey:@"lbl"];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}
-(void)setNavigationBar
{
    UIImage *backImg = [UIImage imageNamed:@"back arrow"];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = back;
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * path =[[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:@"inAppDetail12.plist"]];
    arrList=[[NSMutableArray alloc]initWithContentsOfFile:path];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setNavigationIcon)
                                                 name:@"MoreAppNotification"
                                               object:nil];
    
    if(app.products){
    }else{
        
        [app fetchAllPurchasedItemList];
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isFirst"] integerValue]==YES)
    {
        self.lblHomeNotification.hidden=false;
    }
    else
    {
        self.lblHomeNotification.hidden=true;
    }
    [super viewWillAppear:animated];
    [Flurry logEvent:@"Daily Devotion Screen"];
    [TenjinSDK sendEventWithName:@"Daily Devotion Screen"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchasedFails:) name:fail object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [self.navigationController setNavigationBarHidden: NO animated:NO];
    [self.view bringSubviewToFront:self.bannerView];
    [tableView reloadData];
}
- (void)productPurchased:(NSNotification *)notification
{
    if (allFlag)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"All Purchased restored" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        allFlag=NO;
    }
    [APP_Delegate hideLoadingView:self.view];
    NSString * productIdentifier = notification.object;
    [app.products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier])
        {
            
        }
    }];
}
-(void)productPurchasedFails:(NSNotification *)notification
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Restore Faild please check internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [APP_Delegate hideLoadingView:self.view];
    
}
#pragma mark-check internet
-(void)fnCheckReachability
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus == NotReachable)
    {
        [self hideBannerView];
    }
    else
    {
        [self showBannerView];
    }
}
#pragma mark-hide Banner view
- (void)hideBannerView
{
    _bannerView.hidden=YES;
    [_bannerView removeFromSuperview];
 }
#pragma mark-show Banner view
- (void)showBannerView
{
    _bannerView.hidden=NO;
}
#pragma mark-ICViewPager Delegate
-(NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager
{
    return self.numberOfTabs;
}

-(UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    UILabel *label = nil;
    
    if (UIUserInterfaceIdiomPad == [[UIDevice currentDevice]userInterfaceIdiom ])
    {
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 262, 60)];
        label.font = [UIFont fontWithName:@"SegoeUISymbol" size:24];
    }
    else
    {
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 100)];
        NSLog(@"%@",NSStringFromCGRect(label.frame));
        label.numberOfLines=2;
        label.font = [UIFont fontWithName:@"SegoeUISymbol" size:14];
    }
    label.backgroundColor = [UIColor clearColor];
    label.text = [arrTabText objectAtIndex:index];
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    if (0 == index)
    {
        label.textColor = [UIColor colorWithRed:173.0/255.0 green:25.0/255.0 blue:31.0/255.0 alpha:1];
    }
    else
    {
        label.textColor = [UIColor whiteColor];
    }
    
    [label sizeToFit];
    
    return label;
}

-(UIView *)viewPager:(ViewPagerController *)viewPager contentViewForTabAtIndex:(NSUInteger)index
{
    
    NSLog(@"tab index is : %lu", (unsigned long)index);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"mm/dd/yyyy";
    int nCurrentDay = [self getCurrentDay];
    NSDate *nCurrenttime=[self getCurrentTime];
    UILabel *oTitleLabel = nil;
    int nCalculatedIndexMorning,nCalculatedIndexEvening;
    UIButton *shareBtn=nil;
    NSLog(@"Current day is : %d", nCurrentDay);
    strTableName = @"Prayer";
    NSCalendar *gregorian = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [gregorian components:(NSYearCalendarUnit |
                                                          NSMonthCalendarUnit |
                                                          NSDayCalendarUnit)
                                                fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:1];
    NSDate *midnight1 = [gregorian dateFromComponents:components];
    [components setHour:19];
    [components setMinute:30];
    [components setSecond:0];
    NSDate *endDate = [gregorian dateFromComponents:components];
    
    NSComparisonResult resultafternoon = [nCurrenttime compare:midnight1];
    NSComparisonResult resultevening = [nCurrenttime compare:endDate];
    int nMaxId ;
    nMaxId = [self getMaxIdFromPrayer:strTableName];
    NSLog(@"Max Id is : %d", nMaxId);
    
    UIView *oContentView = nil;
    oContentView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    
    
    if (0 == index)
    {
        
        NSLog(@"%@",NSStringFromCGRect(self.view.frame));
        nCalculatedIndexMorning = (nCurrentDay % nMaxId)+1;
        if (resultafternoon == NSOrderedDescending &&resultevening ==NSOrderedAscending)
        {
            arrPrayerDetails = [self fnGetTodaysPrayer:nCalculatedIndexMorning];
        }
        if (resultevening == NSOrderedDescending||
            resultafternoon == NSOrderedAscending)
        {
            nCalculatedIndexEvening=nMaxId-nCurrentDay;
            if (nCalculatedIndexMorning==nCalculatedIndexEvening)
            {
                arrPrayerDetails = [self fnGetTodaysPrayer:firstID];
            }
            else
            {
                arrPrayerDetails = [self fnGetTodaysPrayer:nCalculatedIndexEvening];
            }
            
        }
        oContentView.backgroundColor = [UIColor colorWithRed:11.0/255.0 green:43.0/255.0 blue:65.0/255.0 alpha:0.75];
        if([arrPrayerDetails count]>0){
            if (UIUserInterfaceIdiomPad == IS_IPAD)
            {
                oTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 30)];
                oTitleLabel.font = [UIFont fontWithName:@"SegoeUISymbol" size:22];
            }
            else
            {
                oTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,10, self.view.frame.size.width - 20, 20)];
                oTitleLabel.font = [UIFont fontWithName:@"SegoeUISymbol" size:14];
                shareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [shareBtn addTarget:self
                             action:@selector(shareIt)
                   forControlEvents:UIControlEventTouchUpInside];
                [shareBtn setTitle:@"+Share" forState:UIControlStateNormal];
                
            }
            oTitleLabel.backgroundColor = [UIColor clearColor];
            oTitleLabel.text = [arrPrayerDetails objectAtIndex:0];
            oTitleLabel.textColor = [UIColor whiteColor];
            oTitleLabel.numberOfLines = 0;
            [oTitleLabel sizeToFit];
            CGSize oTitleLabelSize = [oTitleLabel.text sizeWithFont:oTitleLabel.font
                                                  constrainedToSize:oTitleLabel.frame.size
                                                      lineBreakMode:NSLineBreakByWordWrapping];
            CGRect frmTitle = oTitleLabel.frame;
            frmTitle.size.height = oTitleLabelSize.height;
            
            oTitleLabel.frame =frmTitle;
            UITextView *oPrayerLabel = nil;
            if (UIUserInterfaceIdiomPad == IS_IPAD)
            {
                oPrayerLabel = [[UITextView alloc]initWithFrame:CGRectMake(10, 10+frmTitle.size.height+10, self.view.frame.size.width - 20, 100)];
                oPrayerLabel.font = [UIFont fontWithName:@"SegoeUISymbol" size:22];
            }
            else
            {
                oPrayerLabel = [[UITextView alloc]initWithFrame:CGRectMake(10, 10+frmTitle.size.height+10, self.view.frame.size.width - 20, 200)];
                oPrayerLabel.font = [UIFont fontWithName:@"SegoeUISymbol" size:14];
            }
            oPrayerLabel.backgroundColor = [UIColor clearColor];
            oPrayerLabel.text = [arrPrayerDetails objectAtIndex:1];
            
            oPrayerLabel.textColor = [UIColor whiteColor];
            oPrayerLabel.editable=NO;
            if (!ISIPHONE4)
            {
                [oPrayerLabel sizeToFit];
            }
            
            CGSize oPrayerLabelSize = [oPrayerLabel.text sizeWithFont:oPrayerLabel.font
                                                    constrainedToSize:oPrayerLabel.frame.size
                                                        lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat oPrayerLabelHeight = oPrayerLabelSize.height;
            CGRect frame= oPrayerLabel.frame;
            frame.size.height = oPrayerLabelHeight+frame.origin.y ;
            
            CGRect frame1 = oContentView.frame;
            
            
            if((210+frame1.size.height)>[UIScreen mainScreen].bounds.size.height){
                
                frame1.size.height = [UIScreen mainScreen].bounds.size.height - (210 + frame.origin.y + frmTitle.origin.y);
                frame.size.height = frame1.size.height - frame.origin.y;
                
            }
            
            oPrayerLabel.frame = frame;
            if (ISIPHONE4)
            {
                shareBtn.frame = CGRectMake(self.view.frame.size.width-80,oPrayerLabel.frame.size.height+30, 80.0, 40.0);
                
            }
            else
            {
                
                shareBtn.frame = CGRectMake(self.view.frame.size.width-80,oPrayerLabel.frame.size.height+20, 80.0, 40.0);
                
            }
            frame1.size.height =shareBtn.frame.size.height+oPrayerLabel.frame.size.height+30;
            oContentView.frame = frame1;
            [oContentView addSubview:oTitleLabel];
            [oContentView addSubview:oPrayerLabel];
            [oContentView addSubview:shareBtn];
            
        }
    }
    else if (1 == index)
    {
        oContentView.backgroundColor = [UIColor colorWithRed:11.0/255.0 green:43.0/255.0 blue:65.0/255.0 alpha:0.75];
        nMaxId = [self getMaxIdFromPrayer:@"Verses"];
        NSLog(@"Max Id is : %d", nMaxId);
        nCalculatedIndexMorning = (nCurrentDay % nMaxId)+1;
        if (resultafternoon == NSOrderedDescending &&resultevening ==NSOrderedAscending)
        {
            arrPrayerDetails = [self fnGetTodaysVerse:nCalculatedIndexMorning];
        }
        if (resultevening == NSOrderedDescending||
            resultafternoon == NSOrderedAscending)
        {
            nCalculatedIndexEvening=nMaxId-nCurrentDay;
            if (nCalculatedIndexMorning==nCalculatedIndexEvening)
            {
                arrPrayerDetails = [self fnGetTodaysVerse:firstID];
            }
            else
            {
                arrPrayerDetails = [self fnGetTodaysVerse:nCalculatedIndexEvening];
            }
            
        }
        if([arrPrayerDetails count]>0){
            UILabel *oCommentLabel = nil;
            if (UIUserInterfaceIdiomPad == IS_IPAD)
            {
                oCommentLabel =  [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 30)];
                oCommentLabel.font = [UIFont fontWithName:@"SegoeUISymbol" size:22];
            }
            else
            {
                oCommentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20 , 30)];
                oCommentLabel.font = [UIFont fontWithName:@"SegoeUISymbol" size:14];
                shareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [shareBtn addTarget:self
                             action:@selector(shareIt)
                   forControlEvents:UIControlEventTouchUpInside];
                [shareBtn setTitle:@"+Share" forState:UIControlStateNormal];
            }
            oCommentLabel.text = [arrPrayerDetails objectAtIndex:1]; // item 0 == comment
            oCommentLabel.backgroundColor = [UIColor clearColor];
            oCommentLabel.textColor = [UIColor whiteColor];
            oCommentLabel.numberOfLines = 0;
            [oCommentLabel sizeToFit];
            CGSize oCommentLabelSize = [oCommentLabel.text sizeWithFont:oCommentLabel.font
                                                      constrainedToSize:oCommentLabel.frame.size
                                                          lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat oCommentLabelHeight = oCommentLabelSize.height;
            UITextView *oVerseLabel = nil;
            if (UIUserInterfaceIdiomPad == IS_IPAD)
            {
                oVerseLabel = [[UITextView alloc]initWithFrame:CGRectMake(10, 10 + oCommentLabelHeight + 10, self.view.frame.size.width - 20, 200)];
                oVerseLabel.font = [UIFont fontWithName:@"SegoeUISymbol" size:22];
            }
            else
            {
                oVerseLabel = [[UITextView alloc]initWithFrame:CGRectMake(10, 5 + oCommentLabelHeight + 10, self.view.frame.size.width - 20, 200)];
                oVerseLabel.font = [UIFont fontWithName:@"SegoeUISymbol" size:14];
            }
            oVerseLabel.backgroundColor = [UIColor clearColor];
            oVerseLabel.text = [arrPrayerDetails objectAtIndex:0]; // item 1 == verse
            oVerseLabel.textColor = [UIColor whiteColor];
            oVerseLabel.editable=NO;
            CGSize verseLabelSize = [oVerseLabel.text sizeWithFont:oVerseLabel.font
                                                 constrainedToSize:oVerseLabel.frame.size
                                                     lineBreakMode:NSLineBreakByWordWrapping];
            
            CGFloat verseLabelHeight = verseLabelSize.height+oVerseLabel.frame.origin.y;
            
            CGRect frame = oVerseLabel.frame;
            
            
            if((210+40+verseLabelHeight+50)>[UIScreen mainScreen].bounds.size.height){
                verseLabelHeight = [UIScreen mainScreen].bounds.size.height - (210+40+50);
            }
            
            frame.size.height = verseLabelHeight;
            
            oVerseLabel.frame = frame;
            
            
            NSLog(@"verse label height set to : %f", oVerseLabel.frame.size.height);
            UILabel *oScriptureLabel = nil;
            if (UIUserInterfaceIdiomPad == IS_IPAD)
            {
                oScriptureLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 + oCommentLabelHeight + 10 + verseLabelHeight + 10, self.view.frame.size.width - 20, 30)];
                oScriptureLabel.font = [UIFont fontWithName:@"SegoeUISymbol" size:22];
            }
            else
            {
                if (ISIPHONE4)
                {
                    oScriptureLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 + oCommentLabelHeight +3+ verseLabelHeight + 3, self.view.frame.size.width - 20, 20)];
                }
                else
                {
                    oScriptureLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 + oCommentLabelHeight + 10 + verseLabelHeight + 10, self.view.frame.size.width - 20, 20)];
                }
                oScriptureLabel.font = [UIFont fontWithName:@"SegoeUISymbol" size:14];
            }
            oScriptureLabel.backgroundColor = [UIColor clearColor];
            oScriptureLabel.text = [arrPrayerDetails objectAtIndex:2]; // item 2 == Scripture
            oScriptureLabel.textColor = [UIColor whiteColor];
            oScriptureLabel.textAlignment = NSTextAlignmentRight;
            [oContentView addSubview:oCommentLabel];
            [oContentView addSubview:oVerseLabel];
            [oContentView addSubview:oScriptureLabel];
            [oContentView addSubview:shareBtn];
            CGRect frame1 = oContentView.frame;
            frame1.size.height = 10 + oCommentLabelHeight + 10 + verseLabelHeight + 30;
            
            
            frame1.size.height = verseLabelHeight+oCommentLabelHeight + frame.origin.y + oCommentLabel.frame.origin.y+20;
            oContentView.frame = frame1;
            
            if (ISIPHONE4)
            {
                shareBtn.frame = CGRectMake(self.view.frame.size.width-80, verseLabelHeight+oCommentLabelHeight +30, 80.0, 40.0);
                
                
            }
            else
            {
                
                shareBtn.frame = CGRectMake(self.view.frame.size.width-80, verseLabelHeight+oCommentLabelHeight +35, 80.0, 40.0);
                
            }
            oContentView.frame = frame1;
            
        }
    }
    else if (2 == index)
    {
        oContentView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-150)];
        
        [self fnCheckReachability];
        GADBannerView *bannerView = [[GADBannerView alloc]initWithFrame:CGRectMake((CGRectGetWidth(oContentView.frame)/2)-150,10, 300, 250)];
        bannerView.adUnitID = kBannerAdUnitId250;
        bannerView.rootViewController = self;
        GADRequest *request = [GADRequest request];
        [bannerView loadRequest:request];
        bannerView.userInteractionEnabled = YES;
        bannerView.multipleTouchEnabled = YES;
        [oContentView addSubview:bannerView];
    }
    else if(3 == index)
    {
        oContentView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-150)];
        
        if (ISIPHONE4)
        {
            
            tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,  10, self.view.frame.size.width, self.view.frame.size.height -150)];
        }
        else
        {
            tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,  10, self.view.frame.size.width, self.view.frame.size.height -170)];
        }
        tableView.delegate = self;
        tableView.dataSource = self;
        [oContentView addSubview:tableView];
        tableView.backgroundColor=[UIColor clearColor];
        tableView.clipsToBounds=YES;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    else
    {
        [self restoreTapped:self];
    }
    oContentView.clipsToBounds=YES;
    return oContentView;
}

-(void)shareIt
{
    activityItems=[[NSArray alloc] initWithObjects:@"I'd like to share this daily devotion with you, please read it. - www.FreeDailyDevotion.com", nil];
    UIActivityViewController *act =
    [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                      applicationActivities:nil];
    
    act.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll];
    
    
    [act setCompletionHandler:^(NSString *activityType, BOOL completed) {
        if(completed){
            
        }
    }];
    
    [self presentViewController:act animated:YES completion:nil];
}
-(void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index fromIndex:(NSUInteger)previousIndex didSwipe:(BOOL)didSwipe
{
    NSMutableArray *tabs = viewPager.tabs;
    NSArray *subviews = [tabs[index] subviews];
    if (index==0)
    {
        self.bannerView.hidden=false;
        [Flurry logEvent:@"Todays Prayer clicked/loaded"];
        [TenjinSDK sendEventWithName:@"Todays Prayer clicked/loaded"];
    }
    else if (index==1)
    {
        self.bannerView.hidden=false;
        [Flurry logEvent:@"Todays Verse clicked/loaded"];
        [TenjinSDK sendEventWithName:@"Todays Verse clicked/loaded"];
    }
    else if (index==2)
    {
        self.bannerView.hidden=true;
        [Flurry logEvent:@"Todays Sponsor clicked/loaded"];
        [TenjinSDK sendEventWithName:@"Todays Sponsor clicked/loaded"];
    }
    else if (index==3)
    {
        self.bannerView.hidden=false;
        [Flurry logEvent:@"Deluxe tool clicked/loaded"];
        [TenjinSDK sendEventWithName:@"Deluxe tool clicked/loaded"];
    }
    if ([subviews count] > 0)
    {
        for (UILabel *subview in subviews)
        {
            [subview setTextColor:[UIColor colorWithRed:173.0/255.0 green:25.0/255.0 blue:31.0/255.0 alpha:1]];
            subview.font=[UIFont boldSystemFontOfSize:13.0f];
        }
    }
    NSArray *subviews1 = [tabs[previousIndex] subviews];
    if ([subviews1 count] > 0)
    {
        for (UILabel *subview1 in subviews1)
        {
            [subview1 setTextColor:[UIColor whiteColor]];
            subview1.font=[UIFont fontWithName:@"SegoeUISymbol" size:13.0f];
        }
    }
    
}

#pragma mark-Today Prayer
-(NSMutableArray *) fnGetTodaysPrayer: (int) prayer_Id

{
    strTableName = @"Prayer";
    NSMutableArray *arrVerse=[[database getSharedInstance] fnGetTodaysPrayer:prayer_Id tableName:strTableName];
    return arrVerse;
    
}
#pragma  mark-Today's Verse
-(NSMutableArray *) fnGetTodaysVerse: (int) verse_Id
{
    NSMutableArray *arrVerseDetails = [[NSMutableArray alloc]init];
    
    NSString *selectQry = nil;
    
    NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"Devotional-1-2" ofType:@"sqlite"];
    
    const char *dbpath = [databasePath UTF8String];
    
    NSString *strTableVerseName = @"Verses";
    
    if (sqlite3_open(dbpath, &dbInstance) == SQLITE_OK)
    {
        selectQry = [NSString stringWithFormat:@"Select * from %@ WHERE id='%d'",strTableVerseName, verse_Id];
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(dbInstance, [selectQry cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                int nID = sqlite3_column_int(statement, 2) ;
                NSLog(@"Verses ID is : %d", nID);
                NSString *strVerseComment = [NSString stringWithCString:(sqlite3_column_text(statement, 0)) encoding:NSUTF8StringEncoding];
                [arrVerseDetails addObject:strVerseComment];
                NSString *strVerse =  NSSRING_FROM_CSTRING(sqlite3_column_text(statement, 1));
                [arrVerseDetails addObject:strVerse];
                NSLog(@"Verse is : %@", strVerse);
                NSString *strVerseScripture =  NSSRING_FROM_CSTRING(sqlite3_column_text(statement, 2));
                [arrVerseDetails addObject:strVerseScripture];
                NSLog(@"Verse scripture is : %@", strVerseScripture);
            }
        }
    }
    
    return arrVerseDetails;
}

-(int) getMaxIdFromPrayer : (NSString*) strTableVerseName
{
    int nMaxId=0;
    
    NSString *selectQry = nil;
    
    NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"Devotional-1-2" ofType:@"sqlite"];
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &dbInstance) == SQLITE_OK)
    {
        selectQry = [NSString stringWithFormat:@"select MAX(ID) from %@", strTableVerseName];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(dbInstance, [selectQry cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                nMaxId = sqlite3_column_int(statement, 0) ;
                NSLog(@"nMax Id : %d", nMaxId);
            }
        }
    }
    return nMaxId;
}
#pragma mark-current day
-(int) getCurrentDay
{
    int currentDay;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"D"];
    NSDate *date = [NSDate date];
    currentDay = [[dateFormatter stringFromDate:date] intValue];
    
    return currentDay;
}
-(NSDate *)getCurrentTime
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"mm/dd/yyyy HH:mm";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSLog(@"The Current Time is %@",[dateFormatter stringFromDate:now]);
    return now;
}

#pragma mark-Back
- (IBAction)fnBack:(UIButton *)sender
{
    [Flurry logEvent:@"NavigationBar -  Go to itunes"];
    NSString *customURL = @"BibleVersesByTopic://";
    
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:customURL]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
    }
    else
    {
    NSString *iTunesLink = @"https://itunes.apple.com/app/id937269996?mt=8&&referrer=click%3Dd375b06d-b1a9-4c73-ad71-cc1eda0f8c69";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
    
    
}
#pragma mark-Get More App
- (IBAction)fnGetMoreApps:(id)sender
{
    if ([AppDelegate ReachebilityChecker])
    {
        NSURL *url = [ [ NSURL alloc ] initWithString:[[arrnav objectAtIndex:[[APP_Delegate morappCount] intValue]] objectForKey:@"link"]];
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"Please check internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
   
}
#pragma mark-get Today app
- (IBAction)fnGetTodaysApp:(UIButton *)sender
{
     [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFirst"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BtnClicked"];
    [Flurry logEvent:@"NavigationBar - Today's Apps Clicked On Daily Devotion Screen"];
    
    [FBSDKAppEvents logEvent:@"Todays Apps Clicked On Devotion Screen"];
    
    [appDelegate appOfTheDayClicked:sender fromController:self];
}
#pragma mark-Background Click
- (IBAction)fnBackgraoundsClicked:(id)sender
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://click.clicktrkr.net/a68251fe-0c81-4d5d-a3e4-1f782ae28c48"]];
}


#pragma mark -
#pragma mark Table view Data Source and delegate methods -
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==[arrList count])
    {
        return 66.0f;
    }
    else
    {
    return 100.0f;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrList count]+1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 10;
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    
    
    view.tintColor = [UIColor clearColor];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
  
    if (indexPath.section==[arrList count])
    {
        UIButton *allPurchased = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(0.0,0.0,self.view.frame.size.width,66.0)];
        allPurchased.frame=CGRectMake(0, 0, self.view.frame.size.width, 66);
        [allPurchased setTitle:@"" forState:UIControlStateNormal];
        [allPurchased addTarget:self action:@selector(restoreTapped:) forControlEvents:UIControlEventTouchUpInside];
        allPurchased.backgroundColor=[UIColor colorWithRed:255.f/255.0 green:255.f/255.0 blue:255.f/255.0 alpha:0.4f];
        lbl.text=@"Restore Previous Purchases";
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.textColor=[UIColor darkGrayColor];
        lbl.font=[UIFont fontWithName:@"SegoeUISymbol" size:18.0f];
        lbl.numberOfLines = 1;
        lbl.lineBreakMode = NSLineBreakByWordWrapping;
         [cell.contentView addSubview:allPurchased];
          lbl.userInteractionEnabled=NO;
        [cell.contentView addSubview:lbl];
    }
    else if (indexPath.section<5)
    {
        UIImage *img=[UIImage imageNamed:[[arrList objectAtIndex:indexPath.section]objectForKey:@"bgImage"]];
        UIImageView *ac=[[UIImageView alloc] initWithImage:img];
        ac.frame=CGRectMake(0, 0, cell.frame.size.width, 100);
        ac.contentMode=UIViewContentModeScaleToFill;
        cell.backgroundView =ac;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

    }
    else
    {
        UIImage *newImage1=nil;
    moreInfo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *img=[UIImage imageNamed:[[arrList objectAtIndex:indexPath.section] objectForKey:@"cellImage"]];
    UIImageView *ac=[[UIImageView alloc] initWithImage:img];
    ac.frame=CGRectMake(0, 0, cell.frame.size.width, 100);
    ac.contentMode=UIViewContentModeScaleToFill;
    cell.backgroundView =ac;
    if ([[DailyDevotionalHelper sharedInstance] productPurchased:[[arrList objectAtIndex:indexPath.section] objectForKey:@"bundle"]]||[[[arrList objectAtIndex:indexPath.section] objectForKey:@"isPurchase"]integerValue]==YES)
               {
            moreInfo.frame = CGRectMake(self.view.frame.size.width/2-50  ,cell.frame.origin.y+60, 90, 30);

            if (indexPath.section==14)
            {
                moreInfo.hidden=true;
                
            }
            else
            {
                newImage1 = [[UIImage imageNamed:@"read button.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
                [moreInfo setTitle:@"" forState:UIControlStateNormal];
                [moreInfo setBackgroundImage:newImage1 forState:UIControlStateNormal];
                
            }
        }
        else
        {
            moreInfo.frame = CGRectMake(self.view.frame.size.width/2-50  ,cell.frame.origin.y+60, 90, 40);
            newImage1 = [[UIImage imageNamed:@"get more info button"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
             [moreInfo setTitle:@"" forState:UIControlStateNormal];
            [moreInfo setBackgroundImage:newImage1 forState:UIControlStateNormal];
        }
    [moreInfo addTarget:self action:@selector(gotoDetailview:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:moreInfo];
    NSString *requestTag = [NSString stringWithFormat:@"%ld", (long)indexPath.section];
    moreInfo.accessibilityIdentifier = requestTag;
        [moreInfo setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = [UIColor clearColor];
       return  cell;
}
- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [arrList count];
}

- (NSIndexPath *)getIndexPath:(id)sender
{
    NSString *requestTag = [sender accessibilityIdentifier];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:[requestTag integerValue]];
    return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SKProduct * product = nil;
    for (SKProduct *prod in app.products)
    {
        if ([prod.productIdentifier isEqualToString:[[arrList objectAtIndex:indexPath.section] valueForKey:@"bundle"]])
        {
            product  = prod;
        }
    }
    if (indexPath.section<5)
    {
        NSURL *url = [ [ NSURL alloc ] initWithString:[[arrList objectAtIndex:indexPath.section]objectForKey:@"AppURL"]];
        [[UIApplication sharedApplication] openURL:url];

    }
    else
    {
    if ([[DailyDevotionalHelper sharedInstance] productPurchased:product.productIdentifier] ||[[DailyDevotionalHelper sharedInstance] productPurchased:@"com.brian.allcontent"]|| [[[arrList objectAtIndex:indexPath.section] objectForKey:@"itemKey"]integerValue]==YES||[[[arrList objectAtIndex:8] objectForKey:@"itemKey"]integerValue]==YES)
    {
        NSLog(@"Already Purchased");
        if (indexPath.section==5)
        {
            PrayerToStChristopher *objPrayerToStChristoper=(PrayerToStChristopher *)[self.storyboard instantiateViewControllerWithIdentifier:@"PrayerToStChristopher"];
            NSString *maxId=[[database getSharedInstance] getMaxPrayerBooklet:@"5"];
            NSString *bookletid=[[database getSharedInstance] getMinPrayerBooklet:@"5"];
            NSMutableArray *arrStSchristoper=[[database getSharedInstance] fetchChristoperText:@"5" prayerId:bookletid];
            NSString *Prayercount=[[database getSharedInstance] getountPrayerBooklet:@"5"];
            objPrayerToStChristoper.currentPrayerId=5;
            objPrayerToStChristoper.prayerCount=Prayercount;
            objPrayerToStChristoper.maxId=[maxId intValue];
            objPrayerToStChristoper.bookletId=[bookletid intValue];
            objPrayerToStChristoper.bookletprayerId=@"5";
            objPrayerToStChristoper.arrChristPrayer=arrStSchristoper;
            [self.navigationController pushViewController:objPrayerToStChristoper animated:YES];
            
            
            
            
           }
        else if (indexPath.section==6)
        {
            PrayerToStChristopher *objPrayerToStChristoper=(PrayerToStChristopher *)[self.storyboard instantiateViewControllerWithIdentifier:@"PrayerToStChristopher"];
            NSString *maxId=[[database getSharedInstance] getMaxPrayerBooklet:@"7"];
            NSString *bookletid=[[database getSharedInstance] getMinPrayerBooklet:@"7"];
            NSMutableArray *arrStSchristoper=[[database getSharedInstance] fetchChristoperText:@"7" prayerId:bookletid];
            NSString *Prayercount=[[database getSharedInstance] getountPrayerBooklet:@"7"];
            objPrayerToStChristoper.currentPrayerId=7;
            objPrayerToStChristoper.prayerCount=Prayercount;
            objPrayerToStChristoper.maxId=[maxId intValue];
            objPrayerToStChristoper.bookletId=[bookletid intValue];
            objPrayerToStChristoper.bookletprayerId=@"7";
            objPrayerToStChristoper.arrChristPrayer=arrStSchristoper;
            [self.navigationController pushViewController:objPrayerToStChristoper animated:YES];
           
        }
        
        else if (indexPath.section==7)
        {
            PrayerToStChristopher *objPrayerToStChristoper=(PrayerToStChristopher *)[self.storyboard instantiateViewControllerWithIdentifier:@"PrayerToStChristopher"];
            NSString *maxId=[[database getSharedInstance] getMaxPrayerBooklet:@"6"];
            NSString *bookletid=[[database getSharedInstance] getMinPrayerBooklet:@"6"];
            NSMutableArray *arrStSchristoper=[[database getSharedInstance] fetchChristoperText:@"6" prayerId:bookletid];
            NSString *Prayercount=[[database getSharedInstance] getountPrayerBooklet:@"6"];
            objPrayerToStChristoper.currentPrayerId=6;
            objPrayerToStChristoper.prayerCount=Prayercount;
            objPrayerToStChristoper.maxId=[maxId intValue];
            objPrayerToStChristoper.bookletId=[bookletid intValue];
            objPrayerToStChristoper.bookletprayerId=@"6";
            objPrayerToStChristoper.arrChristPrayer=arrStSchristoper;
            [self.navigationController pushViewController:objPrayerToStChristoper animated:YES];

        }
        
        else if (indexPath.section==8)
        {
            PrayerToStChristopher *objPrayerToStChristoper=(PrayerToStChristopher *)[self.storyboard instantiateViewControllerWithIdentifier:@"PrayerToStChristopher"];
            NSString *maxId=[[database getSharedInstance] getMaxPrayerBooklet:@"8"];
            NSString *bookletid=[[database getSharedInstance] getMinPrayerBooklet:@"8"];
            NSMutableArray *arrStSchristoper=[[database getSharedInstance] fetchChristoperText:@"8" prayerId:bookletid];
            NSString *Prayercount=[[database getSharedInstance] getountPrayerBooklet:@"8"];
            objPrayerToStChristoper.currentPrayerId=8;
            objPrayerToStChristoper.prayerCount=Prayercount;
            objPrayerToStChristoper.maxId=[maxId intValue];
            objPrayerToStChristoper.bookletId=[bookletid intValue];
            objPrayerToStChristoper.bookletprayerId=@"8";
            objPrayerToStChristoper.arrChristPrayer=arrStSchristoper;
            [self.navigationController pushViewController:objPrayerToStChristoper animated:YES];
        }
        
        else if (indexPath.section==9)
        {
            PrayerToStChristopher *objPrayerToStChristoper=(PrayerToStChristopher *)[self.storyboard instantiateViewControllerWithIdentifier:@"PrayerToStChristopher"];
            objPrayerToStChristoper.currentPrayerId=1;
            objPrayerToStChristoper.titleStr=@"Prayer To St. Christopher";
            NSString *maxId=[[database getSharedInstance] getMaxPrayerBooklet:@"1"];
            NSString *bookletid=[[database getSharedInstance] getMinPrayerBooklet:@"1"];
            NSMutableArray *arrStSchristoper=[[database getSharedInstance] fetchChristoperText:@"1" prayerId:bookletid];
            NSString *Prayercount=[[database getSharedInstance] getountPrayerBooklet:@"1"];
            objPrayerToStChristoper.prayerCount=Prayercount;
            objPrayerToStChristoper.maxId=[maxId intValue];
            objPrayerToStChristoper.bookletId=[bookletid intValue];
            objPrayerToStChristoper.bookletprayerId=@"1";
            objPrayerToStChristoper.arrChristPrayer=arrStSchristoper;
            [self.navigationController pushViewController:objPrayerToStChristoper animated:YES];
            }
        
        else if (indexPath.section==10)
        {
            PrayerToStChristopher *objPrayerToStChristoper=(PrayerToStChristopher *)[self.storyboard instantiateViewControllerWithIdentifier:@"PrayerToStChristopher"];
            NSString *maxId=[[database getSharedInstance] getMaxPrayerBooklet:@"2"];
            NSString *bookletid=[[database getSharedInstance] getMinPrayerBooklet:@"2"];
            NSMutableArray *arrStSchristoper=[[database getSharedInstance] fetchChristoperText:@"2" prayerId:bookletid];
            NSString *Prayercount=[[database getSharedInstance] getountPrayerBooklet:@"2"];
            objPrayerToStChristoper.currentPrayerId=2;
            objPrayerToStChristoper.prayerCount=Prayercount;
            objPrayerToStChristoper.maxId=[maxId intValue];
            objPrayerToStChristoper.bookletId=[bookletid intValue];
            objPrayerToStChristoper.bookletprayerId=@"2";
            objPrayerToStChristoper.arrChristPrayer=arrStSchristoper;
            [self.navigationController pushViewController:objPrayerToStChristoper animated:YES];
        }
        
        else if (indexPath.section==11)
        {
            PrayerToStChristopher *objPrayerToStChristoper=(PrayerToStChristopher *)[self.storyboard instantiateViewControllerWithIdentifier:@"PrayerToStChristopher"];
            NSString *maxId=[[database getSharedInstance] getMaxPrayerBooklet:@"3"];
            NSString *bookletid=[[database getSharedInstance] getMinPrayerBooklet:@"3"];
            NSMutableArray *arrStSchristoper=[[database getSharedInstance] fetchChristoperText:@"3" prayerId:bookletid];
            NSString *Prayercount=[[database getSharedInstance] getountPrayerBooklet:@"3"];
            objPrayerToStChristoper.currentPrayerId=3;
            objPrayerToStChristoper.prayerCount=Prayercount;
            objPrayerToStChristoper.maxId=[maxId intValue];
            objPrayerToStChristoper.bookletId=[bookletid intValue];
            objPrayerToStChristoper.bookletprayerId=@"3";
            objPrayerToStChristoper.arrChristPrayer=arrStSchristoper;
            [self.navigationController pushViewController:objPrayerToStChristoper animated:YES];
        }
        else if (indexPath.section==12)
        {
            PrayerToStChristopher *objPrayerToStChristoper=(PrayerToStChristopher *)[self.storyboard instantiateViewControllerWithIdentifier:@"PrayerToStChristopher"];
            NSString *maxId=[[database getSharedInstance] getMaxPrayerBooklet:@"4"];
            NSString *bookletid=[[database getSharedInstance] getMinPrayerBooklet:@"4"];
            NSMutableArray *arrStSchristoper=[[database getSharedInstance] fetchChristoperText:@"4" prayerId:bookletid];
            NSString *Prayercount=[[database getSharedInstance] getountPrayerBooklet:@"4"];
            objPrayerToStChristoper.currentPrayerId=4;
            objPrayerToStChristoper.prayerCount=Prayercount;
            objPrayerToStChristoper.maxId=[maxId intValue];
            objPrayerToStChristoper.bookletId=[bookletid intValue];
            objPrayerToStChristoper.bookletprayerId=@"4";
            objPrayerToStChristoper.arrChristPrayer=arrStSchristoper;
            [self.navigationController pushViewController:objPrayerToStChristoper animated:YES];
        }
        else if (indexPath.section==13)
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"You have already purchased!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if (indexPath.section==14)
        {
            scriptureGuideVC *objScriptureGuide=(scriptureGuideVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"scriptureGuideVC"];
            [self.navigationController pushViewController:objScriptureGuide animated:YES];
        }
        else if (indexPath.section==15)
        {
            prayerGuide *objPrayerGuide=(prayerGuide *)[self.storyboard instantiateViewControllerWithIdentifier:@"prayerGuide"];
            [self.navigationController pushViewController:objPrayerGuide animated:YES];
        }
        else if (indexPath.section==16)
        {
            InAppDetailViewController *inAppDetailViewController = (InAppDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"InAppDetailViewController"];
            inAppDetailViewController.arrAlphabet=alphabet;
            [self.navigationController pushViewController: inAppDetailViewController animated:YES];
            }
        else if (indexPath.section==17)
        {
            bibleNameDictViewController *inbibleNameDictViewController = (bibleNameDictViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"bibleNameDictViewController"];
            inbibleNameDictViewController.arrAlphabet=alphabet;
            [self.navigationController pushViewController: inbibleNameDictViewController animated:YES];
        }
        else if (indexPath.section==18)
        {
            guideToConfession *inguideToConfession = (guideToConfession *)[self.storyboard instantiateViewControllerWithIdentifier:@"guideToConfession"];
            [self.navigationController pushViewController: inguideToConfession animated:YES];
        }
        else if (indexPath.section==19)
        {
            ACTSModelViewController *inACTSModelViewController = (ACTSModelViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ACTSModelViewController"];
            [self.navigationController pushViewController: inACTSModelViewController animated:YES];

        }
    }
    else
    {
        app.obj.products=product;
        app.obj.key=[[[arrList objectAtIndex:indexPath.section] objectForKey:@"key"] intValue];
        app.obj.imageName=[[arrList objectAtIndex:indexPath.section] objectForKey:@"bgImage"];
        sleep(0.7);
        [self.navigationController pushViewController:app.obj animated:YES];
       }
    }
}
- (void)restoreTapped:(id)sender
{
     if([AppDelegate ReachebilityChecker])
     {
    [APP_Delegate showLoadingView:self.view];
    [[DailyDevotionalHelper sharedInstance] restoreCompletedTransactions];
         allFlag=YES;
         [tableView reloadData];
     }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"No Internet found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
-(void)gotoDetailview:(id)sender
{
     NSIndexPath *indexPath = [self getIndexPath:sender];
     [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}
#pragma mark -
#pragma mark Button Buy from Cell  -

-(void)btnBuyTapped:(id)sender
{
    
}
@end
