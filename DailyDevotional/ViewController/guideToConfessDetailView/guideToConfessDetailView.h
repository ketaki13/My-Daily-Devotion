//
//  guideToConfessDetailView.h
//  DailyDevotional
//
//  Created by ketaki on 6/18/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface guideToConfessDetailView : UIViewController
@property NSString *heading;
@property NSString *chapterdescription;
@property (weak, nonatomic) IBOutlet UILabel *headingLbl;
@property (weak, nonatomic) IBOutlet UITextView *txtChapterDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
- (IBAction)nextPage:(id)sender;
- (IBAction)prevPage:(id)sender;
@property(nonatomic,strong) NSArray *confessionArr;
@property(nonatomic,assign) NSInteger currentConffessionId;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UIButton *previousBtn;

@end
