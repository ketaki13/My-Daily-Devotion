//
//  imageViewController.h
//  DailyDevotional
//
//  Created by ketaki on 7/2/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
@interface imageViewController : UIViewController
{
    UIButton *getIt;
    UIButton *getItFree;
    
}

@property  SKProduct *products;
@property  NSArray *arr_products;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property int key;
@property NSMutableArray *arrList;
@property NSString *imageName;
- (IBAction)getItFree:(id)sender;
-(void)gotoPurchasedScreen;
-(void)AfterCallBack;
@property NSString *strFileName;
@property BOOL isbtnClicked;
@property (strong, nonatomic) IBOutlet UIButton *inAppButton;
@property (strong, nonatomic) IBOutlet UIButton *getItFreeOutlet;
@property (strong, nonatomic) IBOutlet UIView *backButtonView;
@property (strong, nonatomic) IBOutlet UIButton *getThisOutlet;
@end
