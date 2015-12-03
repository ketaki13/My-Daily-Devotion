//
//  AppDelegate.h
//  DailyDevotional
//
//  Created by webwerks on 5/6/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <GoogleMobileAds/GADInterstitialDelegate.h>
#import <Pushwoosh/PushNotificationManager.h>
#import "MBProgressHUD.h"
#import "imageViewController.h"
#import <AdSupport/ASIdentifierManager.h>
#import <CommonCrypto/CommonDigest.h>
//#import "MPInterstitialAdController.h"


@class GADInterstitial;
@class GADRequest;

@interface AppDelegate : UIResponder <UIApplicationDelegate, GADInterstitialDelegate, PushNotificationDelegate>
{
    UIView *addedView;  
    UIView *LoadingView;
    MBProgressHUD *hud;
    int adCount;
}
@property imageViewController *obj;
@property NSNumber *morappCount;
@property (strong, nonatomic) UIWindow *window;
@property  NSArray *products;
@property ( strong, nonatomic) UIViewController *viewController ;
@property(nonatomic, strong) GADInterstitial *interstitial;
//@property (nonatomic, retain) MPInterstitialAdController *MoPubinterstitial;
@property (nonatomic , assign) BOOL isLoading;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void)showLoadingView:(UIView*) onView;
-(void)hideLoadingView:(UIView*) onView;
-(void)moreAppsClicked:(id)sender fromController:(UIViewController *)fromController;
-(void)appOfTheDayClicked:(id)sender fromController:(UIViewController *)fromController;
-(void)showAddOnPayerCountHit: (UIViewController *)fromController;
+(BOOL)ReachebilityChecker;
+(NSString *)getCurrentTimeInMinute;
-(void)fetchAllPurchasedItemList;
-(void)InstanceCall: (UIViewController *)fromController adId:(NSString *)adId;
-(void)RVDelegateCall:(imageViewController *)toViewController;
@end

