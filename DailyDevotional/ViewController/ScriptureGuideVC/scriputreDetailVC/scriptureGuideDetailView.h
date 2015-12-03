//
//  scriptureGuideDetailView.h
//  DailyDevotional
//
//  Created by ketaki on 6/25/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface scriptureGuideDetailView : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *scriputreTbl;
@property NSArray *arrScriputreGuide;
@end
