//
//  SuperSonicRVDelegate.m
//  DailyDevotional
//
//  Created by ketaki on 9/15/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "SuperSonicRVDelegate.h"
#import "imageViewController.h"
#import "constants.h"
#import "Flurry.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@interface SuperSonicRVDelegate ()
@property (atomic,strong) imageViewController *objimageViewController;
@end
@implementation SuperSonicRVDelegate
@synthesize objimageViewController;
- (id) initWithView:(imageViewController*) view{
    [self setObjimageViewController:view];
    return self;
}

//Fired when callback was successfully made
- (void)supersonicRVInitSuccess{
     //[[Supersonic sharedInstance] showRV];
    NSLog(@"DEMO APP|%s|%s", "DemoRVDelegate", "supersonicRVInitSuccess");
   // [APP_Delegate hideLoadingView:objimageViewController.view];
}

- (void)supersonicRVInitFailedWithError:(NSError *)error{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"Please check internet connection" delegate:objimageViewController cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    self.isWatched=NO;
    NSLog(@"DEMO APP|%s|%s|%@", "DemoRVDelegate", "supersonicRVInitFailedWithError", [error description]);
}

- (void)supersonicRVAdAvailabilityChanged:(BOOL)hasAvailableAds{
    NSLog(@"DEMO APP|%s|%s|%@", "DemoRVDelegate", "supersonicRVAdAvailabilityChanged", hasAvailableAds ? @"Yes" : @"No");
    if (hasAvailableAds == TRUE)
    {
        if (objimageViewController.isbtnClicked)
        {
            [[Supersonic sharedInstance] showRV];
        }
       
    }
    else
    {
        NSLog(@"*****************No Ads*****************");
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"No Ads are Available" delegate:objimageViewController cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)supersonicRVAdOpened{
     [APP_Delegate hideLoadingView:objimageViewController.view];
    NSLog(@"DEMO APP|%s|%s", "DemoRVDelegate", "supersonicRVAdOpened");
}

- (void)supersonicRVAdStarted{
    NSLog(@"DEMO APP|%s|%s", "DemoRVDelegate", "supersonicRVAdStarted");
}

- (void)supersonicRVAdEnded
{
    
    NSLog(@"DEMO APP|%s|%s", "DemoRVDelegate", "supersonicRVAdEnded");
}

- (void)supersonicRVAdClosed{
    //go to next screen
    if (self.isWatched)
    {
        self.isWatched=NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString * path =[[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:@"inAppDetail12.plist"]];
        
               NSMutableArray *arrList=[[[NSMutableArray alloc]initWithContentsOfFile:path] mutableCopy];

        NSLog(@"-----%@",[arrList objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"selectedKey"]]);
        
        NSMutableDictionary *dict = [[arrList objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"selectedKey"]] mutableCopy];
        
        if(dict)
            [dict setObject:[NSNumber numberWithBool:YES] forKey:@"itemKey"];
        BOOL doesExist= [fileManager fileExistsAtPath:path];
        if (doesExist)
        {
            
            [arrList replaceObjectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"selectedKey"] withObject:dict];
            
            NSLog(@"-----%@",[arrList objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"selectedKey"]]);
            
            BOOL success=[arrList writeToFile:path atomically:YES];
             [objimageViewController AfterCallBack];
         
        }

       
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"To enable Reward please watch full Video" delegate:objimageViewController cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    NSLog(@"DEMO APP|%s|%s", "DemoRVDelegate", "supersonicRVAdClosed");
}

- (void)supersonicRVAdRewarded:(SupersonicPlacementInfo*)placementInfo{

    self.isWatched=YES;
    NSLog(@"DEMO APP|%s|%s|placementInfo = %@", "DemoRVDelegate", "supersonicRVAdRewarded", placementInfo);
}

- (void)supersonicRVAdFailedWithError:(NSError *)error{
    NSLog(@"DEMO APP|%s|%s|%@", "DemoRVDelegate", "supersonicRVAdFailedWithError", [error description]);
}

@end
