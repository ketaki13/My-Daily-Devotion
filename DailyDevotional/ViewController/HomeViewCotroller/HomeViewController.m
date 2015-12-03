//
//  HomeViewController.m
//  DailyDevotional
//
//  Created by webwerks on 5/6/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "HomeViewController.h"
#import "Flurry.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "constants.h"
#import "VersesDetailViewController.h"
#import "TenjinSDK.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *attributes = @{ @"mdd" : @YES};
    NSDictionary *tags = [NSDictionary dictionaryWithObjectsAndKeys:
                           @YES,@"mdd_android",
                          nil];
    PushNotificationManager * pushManager = [PushNotificationManager pushManager];
    pushManager.delegate = self;
    [ pushManager setTags:tags];
    [pushManager postEvent:@"test" withAttributes:attributes completion:nil];
    self.lblNotification.layer.cornerRadius = 10;
    self.lblNotification.clipsToBounds = YES;
    self.lbl_moreApp.layer.cornerRadius = 10;
    self.lbl_moreApp.clipsToBounds = YES;
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isFirst"] integerValue]==NO &&
        [[[NSUserDefaults standardUserDefaults] valueForKey:@"BtnClicked"] integerValue]==YES &&
        [[[NSUserDefaults standardUserDefaults] valueForKey:@"moreClicked"] integerValue]==NO)
    {
        self.lbl_moreApp.hidden=false;
    }
    else
    {
        self.lbl_moreApp.hidden=true;
    }

       // Do any additional setup after loading the view.
    
    NSLog(@"In HomeViewController");
    self.todaysDate.text = [self getCurrentDay];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UIImage *imgBG = [UIImage imageNamed:@"devotion-screen-background-DDA"];
    self.bgImageView.image = imgBG;

}
-(void)checkIfFirstInstance
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isFirst"] integerValue]==YES)
    {
        self.lblNotification.hidden=false;
    }
    else
    {
        self.lblNotification.hidden=true;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [Flurry logEvent:@"Home Screen"];
    [TenjinSDK sendEventWithName:@"Home Screen"];
    [self checkIfFirstInstance];
    [self.navigationController setNavigationBarHidden: YES animated:NO];
    
    // [FBSDKAppEvents logEvent:@"Home Screen"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)fnGetMoreApps:(UIButton *)sender
{
    [Flurry logEvent:@"HomeScreen - More Apps Clicked On Home Screen"];
     [TenjinSDK sendEventWithName:@"HomeScreen - More Apps Clicked On Home Screen"];
    [FBSDKAppEvents logEvent:@"More Apps Clicked On Home Screen"];
    [appDelegate moreAppsClicked:sender fromController:self];
     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"moreClicked"];
    self.lbl_moreApp.hidden=true;
}

- (IBAction)fnGetTodaysApp:(UIButton *)sender
{
    
    [Flurry logEvent:@"HomeScreen - Today's Apps Clicked On Category Screen"];
    [TenjinSDK sendEventWithName:@"HomeScreen - Today's Apps Clicked On Category Screen"];
    [FBSDKAppEvents logEvent:@"Todays Apps Clicked On Home Screen"];
    [appDelegate appOfTheDayClicked:sender fromController:self];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFirst"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BtnClicked"];
}
-(NSString*) getCurrentDay
{
    NSString *strCurrentDay;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd yyyy"];
    NSDate *date = [NSDate date];
    strCurrentDay = [dateFormatter stringFromDate:date];    
    NSLog(@"Date is : %@", strCurrentDay);
    return strCurrentDay;
}

- (IBAction)fnGoToHomeScreen:(id)sender
{
    VersesDetailViewController *objVerseDetail=(VersesDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"VersesDetailViewController"];
    [self.navigationController pushViewController:objVerseDetail animated:YES];
    
}
-(void)onInAppDisplayed:(NSString *)code
{
     NSLog(@"*********--Code--%@*********",code);
}
-(void)onInAppClosed:(NSString *)code
{
     NSLog(@"*********--Code--%@*********",code);
}
@end
