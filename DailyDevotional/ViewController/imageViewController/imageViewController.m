//
//  imageViewController.m
//  DailyDevotional
//
//  Created by ketaki on 7/2/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "imageViewController.h"
#import "InAppDetailViewController.h"
#import "bibleNameDictViewController.h"
#import "guideToConfession.h"
#import "ACTSModelViewController.h"
#import "prayerGuide.h"
#import "PrayerToStChristopher.h"
#import "scriptureGuideVC.h"
#import "constants.h"
#import "database.h"
#import "DailyDevotionalHelper.h"
#import <StoreKit/StoreKit.h>
#import "AppDelegate.h"
#import "Flurry.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Supersonic/Supersonic.h>
#import "SuperSonicRVDelegate.h"
#import "VersesDetailViewController.h"
#import "TenjinSDK.h"
@interface imageViewController()

@property (atomic,strong) SuperSonicRVDelegate *superSonicRVDelegate;
@end

@implementation imageViewController
@synthesize products,superSonicRVDelegate;
#pragma mark-view
-(void)viewDidLoad
{
     self.isbtnClicked=false;
    self.title=@"My Daily Devotion";
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self setNavigationBar];
    self.strFileName=[[NSBundle mainBundle]pathForResource:@"inAppDetail" ofType:@"plist"];
    self.arrList=[[[NSMutableArray alloc]initWithContentsOfFile:self.strFileName] mutableCopy];
     getIt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     [getIt addTarget:self action:@selector(getIt) forControlEvents:UIControlEventTouchUpInside];
    getItFree = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [getItFree addTarget:self action:@selector(freegetIt) forControlEvents:UIControlEventTouchUpInside];
  
       UIImage *newImage1 = [[UIImage imageNamed:@"Get This"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
            [getIt setBackgroundImage:newImage1 forState:UIControlStateNormal];
    
    UIImage *newImage2 = [[UIImage imageNamed:@"Watch-Video-Button.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
    [getItFree setBackgroundImage:newImage2 forState:UIControlStateNormal];
    
    if (![[[self.arrList objectAtIndex:self.key] objectForKey:@"tier"] isEqualToString:@"1"])
    {
        getItFree.hidden=true;
        if (ISIPHONE4)
        {
            getIt.frame=CGRectMake(self.view.frame.size.width/2-50,self.getThisOutlet.frame.origin.y+20, 120, 45);
            getItFree.frame=CGRectMake(self.getItFreeOutlet.frame.origin.x,self.getItFreeOutlet.frame.origin.y+20, 120,40);
        }
        else if (ISIPHONE6PLUS)
        {
            getIt.frame=CGRectMake(self.view.frame.size.width/2-100,self.getThisOutlet.frame.origin.y+20, 120, 45);
        }

        else
        {
            getIt.frame=CGRectMake(self.view.frame.size.width/2-50,self.getThisOutlet.frame.origin.y, 120, 45);
            getItFree.frame=CGRectMake(self.getItFreeOutlet.frame.origin.x,self.getItFreeOutlet.frame.origin.y, 120,40);
        }
    }
    else
    {
        getItFree.hidden=false;
        if (ISIPHONE4)
        {
            getIt.frame=CGRectMake(self.getThisOutlet.frame.origin.x,self.getThisOutlet.frame.origin.y+20, 120, 45);
            getItFree.frame=CGRectMake(self.getItFreeOutlet.frame.origin.x,self.getItFreeOutlet.frame.origin.y+20, 120,40);
        }
        else
        {
            getIt.frame=CGRectMake(self.getThisOutlet.frame.origin.x,self.getThisOutlet.frame.origin.y, 120, 45);
            getItFree.frame=CGRectMake(self.getItFreeOutlet.frame.origin.x,self.getItFreeOutlet.frame.origin.y, 120,40);
        }
    }
    [self.backButtonView addSubview:getIt];
    [self.backButtonView addSubview:getItFree];

}
-(void)getIt
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isGetThis"];
    if (products.productIdentifier==NULL)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Product not found.Please check your internetconnection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        NSLog(@"Buying %@...", products.productIdentifier);
        [APP_Delegate hideLoadingView:self.view];
        
    }
    else
    {
        [APP_Delegate showLoadingView:self.view];
        NSLog(@"Buying %@...", products.productIdentifier);
        [[DailyDevotionalHelper sharedInstance] buyProduct:products];
    }
}
-(void)freegetIt
{
    //show video
    //SuperSonic set Delegate and set App key for user id
    [APP_Delegate showLoadingView:self.view];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self callRVShowVideo];
    });

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
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
   [APP_Delegate hideLoadingView:self.view];
    UIImage *newImage1=nil;
     self.imageView.image=[UIImage imageNamed:self.imageName];
    
    [[ NSUserDefaults standardUserDefaults] setInteger:self.key+1 forKey:@"indexKey"];
    newImage1=([[[self.arrList objectAtIndex:self.key] objectForKey:@"tier"] isEqualToString:@"1"])?[[UIImage imageNamed:@"Purchase-Button.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0]:[[UIImage imageNamed:@"Get This.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
    [getIt setTitle:@"" forState:UIControlStateNormal];
    [getIt setBackgroundImage:newImage1 forState:UIControlStateNormal];
    self.strFileName=[[NSBundle mainBundle]pathForResource:@"inAppDetail" ofType:@"plist"];
    self.arrList=[[[NSMutableArray alloc]initWithContentsOfFile:self.strFileName] mutableCopy];
    if (![[[self.arrList objectAtIndex:self.key] objectForKey:@"tier"] isEqualToString:@"1"])
    {
        getItFree.hidden=true;
        if (ISIPHONE4)
        {
            getIt.frame=CGRectMake(self.view.frame.size.width/2-50,self.getThisOutlet.frame.origin.y+20, 120, 45);
            getItFree.frame=CGRectMake(self.getItFreeOutlet.frame.origin.x,self.getItFreeOutlet.frame.origin.y+20, 120,40);
        }
        else if (ISIPHONE6PLUS)
        {
            getIt.frame=CGRectMake(self.view.frame.size.width/2-100,self.getThisOutlet.frame.origin.y+20, 120, 45);
        }

        else
        {
            getIt.frame=CGRectMake(self.view.frame.size.width/2-50,self.getThisOutlet.frame.origin.y, 120, 45);
            getItFree.frame=CGRectMake(self.getItFreeOutlet.frame.origin.x,self.getItFreeOutlet.frame.origin.y, 120,40);
        }
    }
    else
    {
        getItFree.hidden=false;
          if (ISIPHONE4)
        {
            getIt.frame=CGRectMake(self.getThisOutlet.frame.origin.x,self.getThisOutlet.frame.origin.y+20, 120, 45);
            getItFree.frame=CGRectMake(self.getItFreeOutlet.frame.origin.x,self.getItFreeOutlet.frame.origin.y+20, 120,40);
        }
        else
        {
            getIt.frame=CGRectMake(self.getThisOutlet.frame.origin.x,self.getThisOutlet.frame.origin.y, 120, 45);
            getItFree.frame=CGRectMake(self.getItFreeOutlet.frame.origin.x,self.getItFreeOutlet.frame.origin.y, 120,40);
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchasedFails:) name:fail object:nil];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchasedSuccess:) name:IAPHelperProductPurchasedNotification object:nil];
}
-(void)productPurchasedFails:(NSNotification *)notification
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Transaction Fails" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [APP_Delegate hideLoadingView:self.view];
    
}
#pragma mark-Product Purchase
- (void)productPurchasedSuccess:(NSNotification *)notification
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isGetThis"];
     [APP_Delegate hideLoadingView:self.view];
    int index=self.key ;
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"selectedKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * path =[[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:@"inAppDetail12.plist"]];
    
    NSMutableArray *arrList=[[[NSMutableArray alloc]initWithContentsOfFile:path] mutableCopy];
    
    NSLog(@"-----%@",[arrList objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"selectedKey"]]);
    
    NSMutableDictionary *dict = [[arrList objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"selectedKey"]] mutableCopy];
    
    if(dict)
        [dict setObject:[NSNumber numberWithBool:YES] forKey:@"isPurchase"];
    BOOL doesExist= [fileManager fileExistsAtPath:path];
    if (doesExist)
    {
         [arrList replaceObjectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"selectedKey"] withObject:dict];
        
        NSLog(@"-----%@",[arrList objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"selectedKey"]]);
        
        BOOL success=[arrList writeToFile:path atomically:YES];
    }

    [self gotoPurchasedScreen];
}
-(void)gotoPurchasedScreen
{
       switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"indexKey"])
    {
        case 6:{
            [Flurry logEvent:@"Purchase - Love Prayer Booklet"];
            [TenjinSDK sendEventWithName:@"Purchase - Love Prayer Booklet"];
            [FBSDKAppEvents logEvent:@"In App Love Prayer Booklet Clicked"];
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
            break;
        }
        case 7:{
            [Flurry logEvent:@"Purchase - Inspiration Prayer Booklet"];
            [TenjinSDK sendEventWithName:@"Purchase - Inspiration Prayer Booklet"];
            [FBSDKAppEvents logEvent:@"In App Inspiration Prayer Booklet Clicked"];
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
            break;

            }
            
        case 8:{
            [Flurry logEvent:@"Purchase - Women Prayer Booklet"];
              [TenjinSDK sendEventWithName:@"Purchase - Women Prayer Booklet"];
            [FBSDKAppEvents logEvent:@"In App Women Prayer Booklet Clicked"];
            
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
            break;
        }
        case 9:{
            [Flurry logEvent:@"Purchase - Family Prayer Booklet"];
            [TenjinSDK sendEventWithName:@"Purchase - Family Prayer Booklet"];
            [FBSDKAppEvents logEvent:@"In App Family Prayer Booklet Clicked"];
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
            break;
        }
        case 10:
        {
            [Flurry logEvent:@"Purchase - St. Christopher Prayer Booklet"];
             [TenjinSDK sendEventWithName:@"Purchase - St. Christopher Prayer Booklet"];
            [FBSDKAppEvents logEvent:@"In App Bible Dictionary Clicked"];
            PrayerToStChristopher *objPrayerToStChristoper=(PrayerToStChristopher *)[self.storyboard instantiateViewControllerWithIdentifier:@"PrayerToStChristopher"];
            NSString *maxId=[[database getSharedInstance] getMaxPrayerBooklet:@"1"];
            NSString *bookletid=[[database getSharedInstance] getMinPrayerBooklet:@"1"];
            NSMutableArray *arrStSchristoper=[[database getSharedInstance] fetchChristoperText:@"1" prayerId:bookletid];
            NSString *Prayercount=[[database getSharedInstance] getountPrayerBooklet:@"1"];
            objPrayerToStChristoper.currentPrayerId=1;
            objPrayerToStChristoper.prayerCount=Prayercount;
            objPrayerToStChristoper.maxId=[maxId intValue];
            objPrayerToStChristoper.bookletId=[bookletid intValue];
            objPrayerToStChristoper.bookletprayerId=@"1";
            objPrayerToStChristoper.arrChristPrayer=arrStSchristoper;
            [self.navigationController pushViewController:objPrayerToStChristoper animated:YES];
            break;
   
            }
        case 11:
            {
            [Flurry logEvent:@"Purchase - St. Jude Prayer Booklet"];
            [TenjinSDK sendEventWithName:@"Purchase - St. Jude Prayer Booklet"];
            [FBSDKAppEvents logEvent:@"In App St. Jude Prayer Booklet Clicked"];
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
            break;
            }
        case 12:{
            [Flurry logEvent:@"Purchase - St. Peregrine Prayer Booklet"];
             [TenjinSDK sendEventWithName:@"Purchase - St. Peregrine Prayer Booklet"];
            [FBSDKAppEvents logEvent:@"In App St. Peregrine Prayer Booklet Clicked"];
            
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
            break;
        }
        case 13:{
            
            [Flurry logEvent:@"Purchase - St. Anthony Prayer Booklet"];
            [TenjinSDK sendEventWithName:@"Purchase - St. Anthony Prayer Booklet"];
            [FBSDKAppEvents logEvent:@"In App St. Anthony Prayer Booklet Clicked"];
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
            break;
        }
            
        case 14:{
            
            [Flurry logEvent:@"Purchase - All Content Purchased"];
            [TenjinSDK sendEventWithName:@"Purchase - All Content Purchased"];
            [FBSDKAppEvents logEvent:@"In App All Content clicked"];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
            
        case 15:{
            [Flurry logEvent:@"Purchase - Scripture Guide For Stress"];
             [TenjinSDK sendEventWithName:@"Purchase - Scripture Guide For Stress"];
            [FBSDKAppEvents logEvent:@"In App Scripture Guide For Stress Clicked"];
            
            scriptureGuideVC *objScriptureGuide=(scriptureGuideVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"scriptureGuideVC"];
            objScriptureGuide.view.tag=self.key;
            [self.navigationController pushViewController:objScriptureGuide animated:YES];
            break;
        }
            
        case 16:{
            
            [Flurry logEvent:@"Purchase - Prayer Guide (the Lord's Prayer)"];
            [TenjinSDK sendEventWithName:@"Purchase - Prayer Guide (the Lord's Prayer)"];
            [FBSDKAppEvents logEvent:@"In App Prayer Guide (the Lord's Prayer) Clicked"];
            prayerGuide *objPrayerGuide=(prayerGuide *)[self.storyboard instantiateViewControllerWithIdentifier:@"prayerGuide"];
            objPrayerGuide.view.tag=self.key;
            [self.navigationController pushViewController:objPrayerGuide animated:YES];
            break;
            }
            
        case 17:{
            [Flurry logEvent:@"Purchase - Bible Dictionary"];
            [TenjinSDK sendEventWithName:@"Purchase - Bible Dictionary"];
            [FBSDKAppEvents logEvent:@"In App Bible Dictionary Clicked"];
            InAppDetailViewController *inAppDetailViewController = (InAppDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"InAppDetailViewController"];
            inAppDetailViewController.view.tag=self.key;
            inAppDetailViewController.arrAlphabet=alphabet;
            [self.navigationController pushViewController: inAppDetailViewController animated:YES];
            break;
            }
            
        case 18:{
            [Flurry logEvent:@"Purchase - Bible Name Dictionary"];
            [TenjinSDK sendEventWithName:@"Purchase - Bible Name Dictionary"];
            [FBSDKAppEvents logEvent:@"In App Bible Name Dictionary Clicked"];
            
            bibleNameDictViewController *inbibleNameDictViewController = (bibleNameDictViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"bibleNameDictViewController"];
            inbibleNameDictViewController.view.tag=self.key;
            inbibleNameDictViewController.arrAlphabet=alphabet;
            [self.navigationController pushViewController: inbibleNameDictViewController animated:YES];
            break;
        }
            
        case 19:{
            [Flurry logEvent:@"Purchase - Guide To Confession"];
            [TenjinSDK sendEventWithName:@"Purchase - Guide To Confession"];
            [FBSDKAppEvents logEvent:@"In App Guide To Confession Clicked"];
            guideToConfession *inguideToConfession = (guideToConfession *)[self.storyboard instantiateViewControllerWithIdentifier:@"guideToConfession"];
            inguideToConfession.view.tag=self.key;
            [self.navigationController pushViewController: inguideToConfession animated:YES];
            break;
            }
        case 20:{
            [Flurry logEvent:@"Purchase - ACTS Prayer Guide"];
            [TenjinSDK sendEventWithName:@"Purchase - ACTS Prayer Guide"];
            [FBSDKAppEvents logEvent:@"In App ACTS Prayer Guide Clicked"];
            ACTSModelViewController *inACTSModelViewController = (ACTSModelViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ACTSModelViewController"];
            inACTSModelViewController.view.tag=self.key;
            [self.navigationController pushViewController: inACTSModelViewController animated:YES];
            break;
           }
        default:
            break;
    }
 
}

- (IBAction)buyIt:(id)sender
{
    }

- (IBAction)getItFree:(id)sender
{
    
}
-(void)callRVShowVideo
{
    self.isbtnClicked=true;
    [[Supersonic sharedInstance] showRV];
    int index=self.key ;
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"selectedKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
-(void)AfterCallBack
{
     [self gotoPurchasedScreen];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * path =[[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:@"inAppDetail12.plist"]];
    
    NSMutableArray *arrList=[[[NSMutableArray alloc]initWithContentsOfFile:path] mutableCopy];
    
    NSLog(@"-----%@",[arrList objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"selectedKey"]]);
    
    NSMutableDictionary *dict = [[arrList objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"selectedKey"]] mutableCopy];
    
    if(dict)
        [dict setObject:[NSNumber numberWithBool:YES] forKey:@"isPurchase"];
    BOOL doesExist= [fileManager fileExistsAtPath:path];
    if (doesExist)
    {
        
        [arrList replaceObjectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"selectedKey"] withObject:dict];
        
        NSLog(@"-----%@",[arrList objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"selectedKey"]]);
        
        BOOL success=[arrList writeToFile:path atomically:YES];
    }
    


}
@end
