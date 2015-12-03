//
//  InAppDetailViewController.h
//  DailyDevotional
//
//  Created by webwerks on 6/17/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InAppDetailViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
   }
@property UIColor *bgColor;
@property (weak, nonatomic) IBOutlet UILabel *titleOfCategeory;
@property NSArray *arrAlphabet;
@property(nonatomic,strong) NSMutableDictionary *screenData;
@end
