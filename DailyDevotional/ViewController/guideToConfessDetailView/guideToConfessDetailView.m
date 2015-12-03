//
//  guideToConfessDetailView.m
//  DailyDevotional
//
//  Created by ketaki on 6/18/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "guideToConfessDetailView.h"

@interface guideToConfessDetailView ()

@end

@implementation guideToConfessDetailView

- (void)viewDidLoad {
    
    if (self.currentConffessionId==self.confessionArr.count-1)
    {
        self.nextBtn.hidden=true;
    }
    if (self.currentConffessionId==0)
    {
        self.previousBtn.hidden=true;
    }
    self.previousBtn.hidden=false;
    self.headingLbl.text=self.heading;
        [self setNavigationBar];

    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    
    self.headingLbl.attributedText = [[NSAttributedString alloc] initWithString:self.heading attributes:underlineAttribute];
    
    self.headingLbl.font=[UIFont fontWithName:@"SegoeUISymbol" size:20.0f];
    self.headingLbl.font= [UIFont italicSystemFontOfSize:20.0f];
    
    
    self.txtChapterDescription.text = self.chapterdescription;
    self.txtChapterDescription.textColor=[UIColor blueColor];
    self.txtChapterDescription.font=[UIFont fontWithName:@"SegoeUISymbol" size:20];
    self.lblDescription.text=self.chapterdescription;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.title=@"My Daily Devotion";

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setNavigationBar
{
    UIImage *backImg = [UIImage imageNamed:@"back arrow"];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = back;
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)nextPage:(id)sender {
    
    if(self.currentConffessionId<self.confessionArr.count-1){
        
        self.currentConffessionId++;
        self.nextBtn.hidden=false;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.headingLbl.alpha = 0.0f;
            self.txtChapterDescription.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            
            if(finished){
                
                NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
                
                self.headingLbl.attributedText = [[NSAttributedString alloc] initWithString:[[self.confessionArr objectAtIndex:self.currentConffessionId] valueForKey:@"chapterName"]attributes:underlineAttribute];
                
                self.headingLbl.font=[UIFont fontWithName:@"SegoeUISymbol" size:24.0f];
                self.headingLbl.font= [UIFont italicSystemFontOfSize:20.0f];
                
               

                self.txtChapterDescription.text = [[self.confessionArr objectAtIndex:self.currentConffessionId] valueForKey:@"Desc"];
                self.txtChapterDescription.textColor=[UIColor blueColor];
                self.txtChapterDescription.font=[UIFont fontWithName:@"SegoeUISymbol" size:20];
 self.lblDescription.text=self.chapterdescription;
                [UIView animateWithDuration:0.3 animations:^{
                    self.previousBtn.hidden=false;
                    self.headingLbl.alpha =1.0f;
                    self.txtChapterDescription.alpha = 1.0f;

                } completion:^(BOOL finished) {
                    
                    if(finished){
                        
                    }
                }];
                
            }
            if (self.currentConffessionId==self.confessionArr.count-1)
            {
                self.nextBtn.hidden=true;
            }
        }];
        

    }
    else
    {
        
        self.nextBtn.hidden=true;
    }

}

- (IBAction)prevPage:(id)sender {
    
    if(self.currentConffessionId<=0)
    {
        self.previousBtn.hidden=true;
        return;
    }

    self.currentConffessionId--;
    self.previousBtn.hidden=false;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.headingLbl.alpha = 0.0f;
        self.txtChapterDescription.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        if(finished){
            
           NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
            self.headingLbl.attributedText = [[NSAttributedString alloc] initWithString:[[self.confessionArr objectAtIndex:self.currentConffessionId] valueForKey:@"chapterName"]attributes:underlineAttribute];
            self.txtChapterDescription.text = [[self.confessionArr objectAtIndex:self.currentConffessionId] valueForKey:@"Desc"];
            self.txtChapterDescription.textColor=[UIColor blueColor];
            self.txtChapterDescription.font=[UIFont fontWithName:@"SegoeUISymbol" size:20];
             self.lblDescription.text=self.chapterdescription;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.previousBtn.hidden=false;
                self.nextBtn.hidden=false;
                self.headingLbl.alpha =1.0f;
                self.txtChapterDescription.alpha = 1.0f;
                
            } completion:^(BOOL finished) {
                
                if(finished){
                    
                }
            }];
            
        }
        if (self.currentConffessionId==0)
        {
            self.previousBtn.hidden=true;
        }
    }];
    


}
@end
