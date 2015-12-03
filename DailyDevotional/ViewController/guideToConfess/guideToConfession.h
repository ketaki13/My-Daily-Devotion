//
//  guideToConfession.h
//  DailyDevotional
//
//  Created by ketaki on 6/18/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface guideToConfession : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
//    NSArray *confessionArr;
}
@property (weak, nonatomic) IBOutlet UITableView *confessionTbl;
@property(nonatomic,strong) NSArray *confessionArr;
@property NSArray *confesTitleArr;

@end
