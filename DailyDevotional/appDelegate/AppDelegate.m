//
//  AppDelegate.m
//  DailyDevotional
//
//  Created by webwerks on 5/6/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//


#import "AppDelegate.h"
#import <GoogleMobileAds/GADInterstitial.h>
#import "Flurry.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "constants.h"
#import "DailyDevotionalHelper.h"
#import "Reachability.h"
#import <Tapjoy/Tapjoy.h>
#import "ACTReporter.h"
#import "Flurry.h"
#import <TapIt/TapItAppTracker.h>
#import <MMAdSDK/MMAdSDK.h>
#import "SuperSonicRVDelegate.h"
#import "TenjinSDK.h"



@interface AppDelegate ()
@property (atomic,strong) SuperSonicRVDelegate *superSonicRVDelegate;
@end

@implementation AppDelegate
@synthesize superSonicRVDelegate,obj;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    BOOL yes=YES;
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"isFirstTimeLaunch"])
    {
         [self doubleClickBidManagerClicked];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFirstTimeLaunch"];
    }
   
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main~iPhone" bundle:nil];
    obj=(imageViewController *)[storyboard instantiateViewControllerWithIdentifier:@"imageViewController"];
    [self RVDelegateCall:obj];
      NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *strFileName=[[NSBundle mainBundle]pathForResource:@"inAppDetail" ofType:@"plist"];
     NSMutableArray *arrList=[[[NSMutableArray alloc]initWithContentsOfFile:strFileName] mutableCopy];
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * path =[[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:@"inAppDetail12.plist"]];
    if (![fileManager fileExistsAtPath:path])
    {
          BOOL success=[arrList writeToFile:path atomically:YES];
    }
//    imageViewController *obj=[[imageViewController alloc]init];
//    [self RVDelegateCall:obj];
    //TapIt sesession starts
    TapItAppTracker *appTracker = [TapItAppTracker sharedAppTracker];
    [appTracker reportApplicationOpen];
    
    //Millennial session starts
    [MMSDK setLogLevel:MMLogLevelDebug];
    [[MMSDK sharedInstance] initializeWithSettings:nil withUserSettings:nil];
    
    [self checkForDay];
    adCount=0;
    self.morappCount=0;
    // Override point for customization after application launch.
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstTime"])
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstTime"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isGetThis"];
    NSLog(@"In didFinishLaunchingWithOptions");
    [self fetchAllPurchasedItemList];
    sleep(1.5);
    [DailyDevotionalHelper sharedInstance];
    // Override point for customization after application launch.
    
    [[FBSDKApplicationDelegate sharedInstance]application:application didFinishLaunchingWithOptions:launchOptions];
    //-----------PUSHWOOSH PART-----------
    // set custom delegate for push handling, in our case - view controller
    PushNotificationManager * pushManager = [PushNotificationManager pushManager];
    pushManager.delegate = self;
       // handling push on app start
    [pushManager handlePushReceived:launchOptions];
    
    // make sure we count app open in Pushwoosh stats
    [pushManager sendAppOpen];
    
    // register for push notifications!
    [pushManager registerForPushNotifications];
    
       // Google iOS Download tracking snippet
    // To track downloads of your app, add this snippet to your
    // application delegate's application:didFinishLaunchingWithOptions: method.
    
    [ACTConversionReporter reportWithConversionID:@"940094520" label:@"eBDTCPukhGEQuOiiwAM" value:@"0.00" isRepeatable:NO];
    //flurry event starts
    [Flurry startSession:kFlurryApiKey];
    [Flurry setCrashReportingEnabled:YES];

    //Put tap joy id and secret key here
    [Tapjoy requestTapjoyConnect:TAPJOYID
                       secretKey:TAPJOYSCRETEKEY
                         options:@{ TJC_OPTION_ENABLE_LOGGING : @(YES) }];
    
    //***************Tenjin SDK********************//
    [TenjinSDK sharedInstanceWithToken:@"DNEWDXIVZ7FZSIVXXTGMCNVHQZ4WPSWD"];
    
    return YES;
}
-(void)doubleClickBidManagerClicked
{
    int r = arc4random_uniform(1000);
    [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *idfaString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    idfaString=[idfaString uppercaseString];
    const char *cStr = [idfaString UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
        
    }
    NSString *url=[NSString stringWithFormat:@"http://ad.doubleclick.net/ddm/activity/src=5139306;cat=bsr9a66a;type=invmedia;dc_muid=%@;ord=%d",output,r];
    NSURL *getURL=[NSURL URLWithString:url];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:getURL];
    [urlRequest setHTTPMethod:@"GET"];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    if (error == nil)
    {
        NSLog(@"DBM Response---%@",response);
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"url recieved: %@", url);
    NSLog(@"query string: %@", [url query]);
    NSLog(@"host: %@", [url host]);
    NSLog(@"url path: %@", [url path]);
    return YES;
}
-(void)fetchAllPurchasedItemList
{
    if ([[self class] ReachebilityChecker])
    {
        self.products = nil;
   
           [[DailyDevotionalHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            if (success) {
                self.products = products;
            }else{
            
                [self fetchAllPurchasedItemList];
            }
            
        }];
    }
    }

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    NSLog(@"**************************Device Token-%@**************************",deviceToken);
    
    [[PushNotificationManager pushManager] handlePushRegistration:deviceToken];
}


// system push notification registration error callback, delegate to pushManager
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[PushNotificationManager pushManager] handlePushRegistrationFailure:error];
}

// system push notifications callback, delegate to pushManager

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"**********Push Notification:-%@-******************",userInfo);
    [[PushNotificationManager pushManager] handlePushReceived:userInfo];
}

- (void) onPushAccepted:(PushNotificationManager *)pushManager withNotification:(NSDictionary *)pushNotification
{
    NSLog(@"Push notification received");
}

- (void)showLoadingView:(UIView*) onView
{
    hud = [MBProgressHUD showHUDAddedTo:onView animated:YES];
    hud.labelText = @"Loading";
    self.window.rootViewController.view.userInteractionEnabled = NO;
}

-(void)hideLoadingView:(UIView*) onView
{
    [hud hide:YES];
    self.window.rootViewController.view.userInteractionEnabled = YES;
}

-(void)startProgressHUD
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.labelText = @"Loading";
    self.window.rootViewController.view.userInteractionEnabled = NO;
    [self.window bringSubviewToFront:hud];
}
-(void)stopProgressHUD
{
    [self hideLoadingView:self.window];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    int value=[self.morappCount intValue];
    value=(value<4)?++value:0;
    self.morappCount=[NSNumber numberWithInt:value];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MoreAppNotification" object:self];
 }

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isGetThis"] integerValue]==YES)
    {
        return;
    }
    UINavigationController *navController =(UINavigationController *) self.window.rootViewController;
    //***********************Changes***********************//
    
    if (adCount==3)
    {
        [Flurry logEvent:@"Interstitial load - 3rd visit"];
        [TenjinSDK sendEventWithName:@"Interstitial load - 3rd visit"];
        [self InstanceCall:[[navController viewControllers] lastObject] adId:thirdInstance];
    }
    else if (adCount==5)
    {
        [Flurry logEvent:@"Interstitial load - 5th visit"];
        [TenjinSDK sendEventWithName:@"Interstitial load - 5th visit"];
        [self InstanceCall:[[navController viewControllers] lastObject] adId:fifthInstance];
    }
    else if (adCount==8 || adCount==10 || adCount==12 || adCount==14)
    {
        [Flurry logEvent:@"Interstitial load - 8th/10th/12th/14th visit"];
        [TenjinSDK sendEventWithName:@"Interstitial load - 8th/10th/12th/14th visit"];
        [self InstanceCall:[[navController viewControllers] lastObject] adId:eightStartInstance];
    }
    else if (adCount==16||adCount==18||adCount==20||adCount==22)
    {
         [Flurry logEvent:@"Interstitial load - 16th/18th/20th/22nd visit"];
         [TenjinSDK sendEventWithName:@"Interstitial load - 16th/18th/20th/22nd visit"];
        [self InstanceCall:[[navController viewControllers] lastObject] adId:sixteenStartInstance];
    }
    else if (adCount>=24)
    {
        if (adCount%2==0)
        {
            [Flurry logEvent:@"Interstitial load -24th and onward visit"];
             [TenjinSDK sendEventWithName:@"Interstitial load -24th and onward visit"];
            [self InstanceCall:[[navController viewControllers] lastObject] adId:aboveInstance];
        }
    }
    adCount++;
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  
    [self saveContext];
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.neoSoft.DailyDevotional" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DailyDevotional" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
      if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DailyDevotional.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
   
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark -
#pragma mark - Delegate Methods Implementation

-(void)moreAppsClicked:(id)sender fromController:(UIViewController *)fromController
{
    
    self.viewController=fromController;
    [Flurry logEvent:@"AdMob more app interstitial"];
     [TenjinSDK sendEventWithName:@"AdMob more app interstitial"];
        self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-8594467615871430/3648052909"];
        self.interstitial.delegate = self;
        [self.interstitial loadRequest:[self request]];
    [self startLoading:fromController.view];
}
-(void)RVDelegateCall:(imageViewController *)toViewController
{
    [self setSuperSonicRVDelegate: [[SuperSonicRVDelegate alloc] initWithView:toViewController]];
    [[Supersonic sharedInstance] setRVDelegate:[self superSonicRVDelegate]];
    [[Supersonic sharedInstance] initRVWithAppKey:superSonicAppKey withUserId:superSonicUserId];
}
-(void)appOfTheDayClicked:(id)sender fromController:(UIViewController *)fromController {
    
    self.viewController=fromController;
         [Flurry logEvent:@"AdMob app of the day interstitial"];
     [TenjinSDK sendEventWithName:@"AdMob app of the day interstitial"];
        self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-8594467615871430/2171319701"];
        self.interstitial.delegate = self;
        [self.interstitial loadRequest:[self request]];
    [self startLoading:fromController.view];
}

-(void)showAddOnPayerCountHit: (UIViewController *)fromController
{
    self.viewController=fromController;
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-8594467615871430/5124786100"];
    self.interstitial.delegate = self;
    [self.interstitial loadRequest:[self request]];
    [self startLoading:fromController.view];
}

- (GADRequest *)request
{
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ @"df7f8b757cc6be81e9dea3cb86844ca1a9ee1c02" ];
    return request;
}
-(void)InstanceCall: (UIViewController *)fromController adId:(NSString *)adId
{
    self.viewController=fromController;
    self.interstitial=[[GADInterstitial alloc] initWithAdUnitID:adId];
     self.interstitial.delegate = self;
    [self.interstitial loadRequest:[self request]];
    [self startLoading:fromController.view];
    
}
-(void)startLoading:(UIView *)View
{
    self.isLoading = TRUE;
    if(LoadingView)
    {
        [LoadingView removeFromSuperview];
        LoadingView = nil;
    }
    UILabel *Label=nil;
    UIActivityIndicatorView *activityIndicator=nil;
    UIDeviceOrientation orientation =(UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    if (IS_IPAD)
    {
        if ((orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown)) {
            
            LoadingView =[[UIView alloc]initWithFrame:CGRectMake(0,0,768,1000)];
            addedView=[[UIView alloc]initWithFrame:CGRectMake(184,360,400,200)];
            addedView.layer.cornerRadius=15.0;
            addedView.layer.borderWidth=2.0;
            Label = [[UILabel alloc]initWithFrame:CGRectMake(118,20,196,60)];
            Label.font=[UIFont systemFontOfSize:35.0f];
            activityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [activityIndicator setFrame:CGRectMake(148,86,100,100)];
        }
    }
    else
    {
        if (SCREEN_HEIGHT==736.0f)
        {
            LoadingView =[[UIView alloc]initWithFrame:CGRectMake(0,0,320,736)];
            addedView=[[UIView alloc]initWithFrame:CGRectMake(130,188,155,75)];
        }
        else
        {
            LoadingView =[[UIView alloc]initWithFrame:CGRectMake(0,0,320,458)];
            addedView=[[UIView alloc]initWithFrame:CGRectMake(85,188,155,75)];
        }
        addedView.layer.cornerRadius=10.0;
        addedView.layer.borderWidth=1.0;
        Label = [[UILabel alloc]initWithFrame:CGRectMake(45,5,94,21)];
        activityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicator setFrame:CGRectMake(60,30,37,37)];
    }
    Label.text = @"Loading...";
    [LoadingView setBackgroundColor:[UIColor clearColor]];
    [addedView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    addedView.layer.borderColor=[UIColor whiteColor].CGColor;
    
    Label.textColor = [UIColor whiteColor];
    Label.backgroundColor = [UIColor clearColor];
    [addedView addSubview:Label];
    
    [activityIndicator startAnimating];
    [addedView addSubview:activityIndicator];
    
    [LoadingView addSubview:addedView];
    [View addSubview:LoadingView];    
}

-(void)stopLoading
{
    self.isLoading = FALSE;
    [LoadingView removeFromSuperview];
}
+(BOOL)ReachebilityChecker
{
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    return [reachability isReachable];
    
}
#pragma mark -
#pragma mark - GADInterstitialDelegate implementation

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
{
    [self stopLoading];
    
    // Show the interstitial.
    [self.interstitial presentFromRootViewController:self.viewController];
}

- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error {
    
    [self stopLoading];
    NSLog(@"*****************************Error-%@*****************************",[error description]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Problem in loading ad...."
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    [alert show];
}
-(void)checkForDay
{
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today=[DateFormatter stringFromDate:[NSDate date]];
    if (![today isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"lastDate"]])
    {
        [[NSUserDefaults standardUserDefaults] setValue:today forKey:@"lastDate"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirst"];
    }

  
}
+(NSString *)getCurrentTimeInMinute
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSLog(@"The Current Time is %@",[dateFormatter stringFromDate:now]);
    NSArray *min=[[dateFormatter stringFromDate:now] componentsSeparatedByString:@":"];
    return [min objectAtIndex:1];
}
@end
