//
//  bibleDictonaryViewController.h
//  DailyDevotional
//
//  Created by ketaki on 6/18/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bibleDictonaryViewController : UIViewController<UISearchBarDelegate, UISearchDisplayDelegate,UITableViewDelegate>

@property NSArray *arrValue;
@property (weak, nonatomic) IBOutlet UISearchBar *seachBar;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic,weak)NSString *key;

@end
