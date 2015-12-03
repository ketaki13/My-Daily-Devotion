//
//  HomeViewController.h
//  DailyDevotional
//
//  Created by webwerks on 5/6/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <Pushwoosh/PushNotificationManager.h>
@interface HomeViewController : UIViewController<PushNotificationDelegate>
{
    AppDelegate *appDelegate;
}
@property (weak, nonatomic) IBOutlet UILabel *todaysDate;

- (IBAction)fnGetMoreApps:(UIButton *)sender;
- (IBAction)fnGetTodaysApp:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;


- (IBAction)fnGoToHomeScreen:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblNotification;
@property (strong, nonatomic) IBOutlet UILabel *lbl_moreApp;

@end
