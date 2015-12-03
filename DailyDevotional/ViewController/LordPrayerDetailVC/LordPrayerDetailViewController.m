//
//  LordPrayerDetailViewController.m
//  DailyDevotional
//
//  Created by ketaki on 6/22/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "LordPrayerDetailViewController.h"
#import "LordPrayerDetailCellTableViewCell.h"
#import "constants.h"
#import "database.h"
@interface LordPrayerDetailViewController ()

@end

@implementation LordPrayerDetailViewController
#pragma mark-View
- (void)viewDidLoad {
    self.view.backgroundColor=[UIColor whiteColor];
    self.lordPrayerTbl.backgroundColor=[UIColor whiteColor];
    self.lordPrayerTbl.backgroundView=nil;
    if (self.currentPrayerId==1)
    {
         self.previous.hidden=true;
    }
    if (self.currentPrayerId==self.arrPrayer.count)
    {
        self.nextbtn.hidden=true;
    }
    self.lordPrayerTbl.layer.borderWidth=1.0;
   
    self.lordPrayerTbl.layer.borderColor=[[UIColor blackColor] CGColor];
     [self setHeaderView];
    [self setNavBar];
    [super viewDidLoad];
}
-(void)setNavBar
{
     
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.translucent=NO;
    UIImage *backImg = [UIImage imageNamed:@"back arrow"];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = back;


}

-(void)back
{
     [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
}
#pragma mark-Header View
-(void)setHeaderView
{
    self.title=@"My Daily Devotion";

      if (self.currentPrayerId==1)
    {
        self.textAboveLineStr=Text_Above_LordPrayer_1;
    }
    if (self.currentPrayerId==2)
    {
        self.textAboveLineStr=Text_Above_LordPrayer_2;
    }

    if (self.currentPrayerId==3)
    {
        self.textAboveLineStr=Text_Above_LordPrayer_3;
    }
    if (self.currentPrayerId==4)
    {
        self.textAboveLineStr=Text_Above_LordPrayer_4;
    }
    if (self.currentPrayerId==5)
    {
        self.textAboveLineStr=Text_Above_LordPrayer_5;
    }
    if (self.currentPrayerId==6)
    {
        self.textAboveLineStr=Text_Above_LordPrayer_6;
    }
    if (self.currentPrayerId==7)
    {
        self.textAboveLineStr=Text_Above_LordPrayer_7;
    }
    if (self.currentPrayerId==8)
    {
        self.textAboveLineStr=Text_Above_LordPrayer_8;
    }
    self.lordPrayerTbl.tableHeaderView = [self setHeaderLbl];
    
    
}
-(UIView *)setHeaderLbl
{
    UILabel *textAboveLineHeader=[[UILabel alloc]initWithFrame:CGRectMake(10,5,self.lordPrayerTbl.layer.frame.size.width-20, 50)];
    
    textAboveLineHeader.text=self.textAboveLineStr;
    textAboveLineHeader.textColor=[UIColor blueColor];
    textAboveLineHeader.numberOfLines = 0;
    textAboveLineHeader.lineBreakMode = NSLineBreakByWordWrapping;
    [textAboveLineHeader sizeToFit];
    
    
    
    UILabel *PrayerLine=[[UILabel alloc]initWithFrame:CGRectMake(10,90,self.lordPrayerTbl.layer.frame.size.width-20, 100)];
    PrayerLine.text=[[[self.arrPrayer objectAtIndex:self.currentPrayerId-1] objectAtIndex:0]objectForKey:@"title"];
    PrayerLine.numberOfLines = 0;
    PrayerLine.lineBreakMode = NSLineBreakByWordWrapping;
    PrayerLine.textAlignment=NSTextAlignmentLeft;
    PrayerLine.textColor=[UIColor blueColor];
    //[PrayerLine sizeToFit];
    CGSize size;
    
    CGSize sizeForPrayer;
    
    if (IS_IOS7)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = PrayerLine.lineBreakMode;
        
        CGRect rect = [PrayerLine.text boundingRectWithSize:CGSizeMake(280, 2500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : PrayerLine.font, NSParagraphStyleAttributeName : paragraphStyle} context:nil];
        
        size= rect.size;
        
        NSMutableParagraphStyle *paragraphStyleforHeader = [[NSMutableParagraphStyle alloc] init];
        paragraphStyleforHeader.lineBreakMode = textAboveLineHeader.lineBreakMode;
        
        CGRect rectForHrader = [textAboveLineHeader.text boundingRectWithSize:CGSizeMake(280, 2500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : textAboveLineHeader.font, NSParagraphStyleAttributeName : paragraphStyleforHeader} context:nil];
        
        sizeForPrayer= rectForHrader.size;
    }
    CGSize maximumLabelSize = CGSizeMake(280, 2500);
    size = [PrayerLine.text sizeWithFont:PrayerLine.font constrainedToSize:maximumLabelSize lineBreakMode:PrayerLine.lineBreakMode];
    
    sizeForPrayer = [textAboveLineHeader.text sizeWithFont:textAboveLineHeader.font constrainedToSize:maximumLabelSize lineBreakMode:textAboveLineHeader.lineBreakMode];
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.lordPrayerTbl.layer.frame.size.width, (sizeForPrayer.height+size.height+30))];
    
    [headerView addSubview:textAboveLineHeader];
    [headerView addSubview:PrayerLine];
    return headerView;
    

}
#pragma mark-table View delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.arrPrayerLineStr count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary  *dict=[self.arrPrayerLineStr objectAtIndex:section];
    NSArray *array=[dict objectForKey:@"data"];
    return [array count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    LordPrayerDetailCellTableViewCell *cell = (LordPrayerDetailCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary  *dict=[self.arrPrayerLineStr objectAtIndex:indexPath.section];
    NSArray *array=[dict objectForKey:@"data"];
    cell.lbl.text=[array objectAtIndex:indexPath.row];
    cell.lbl.font=[UIFont italicSystemFontOfSize:17.0f];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    LordPrayerDetailCellTableViewCell *cell = (LordPrayerDetailCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary  *dict=[self.arrPrayerLineStr objectAtIndex:indexPath.section];
    NSArray *array=[dict objectForKey:@"data"];
    cell.lbl.text=[array objectAtIndex:indexPath.row];
    cell.lbl.numberOfLines = 0;
    cell.lbl.lineBreakMode = NSLineBreakByWordWrapping;
    [ cell.lbl sizeToFit];
    if (IS_IOS7)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = cell.lbl.lineBreakMode;
        
        CGRect rect = [cell.lbl.text boundingRectWithSize:CGSizeMake(280, 2500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : cell.lbl.font, NSParagraphStyleAttributeName : paragraphStyle} context:nil];
        
        return rect.size.height+10;
    }
    CGSize maximumLabelSize = CGSizeMake(280, 2500);
    CGSize expectedLabelSize = [ cell.lbl.text sizeWithFont:cell.lbl.font constrainedToSize:maximumLabelSize lineBreakMode: cell.lbl.lineBreakMode];
    return expectedLabelSize.height+10;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // calculate height of UILabel
    UILabel *lblSectionName = [[UILabel alloc] init];
    lblSectionName.text = [[self.arrPrayerLineStr objectAtIndex:section] objectForKey:@"title"];
    lblSectionName.frame=CGRectMake(10,5, self.view.frame.size.width-20, 20);
    lblSectionName.textColor = [UIColor lightGrayColor];
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    lblSectionName.attributedText = [[NSAttributedString alloc] initWithString:[[self.arrPrayerLineStr objectAtIndex:section]objectForKey:@"title"] attributes:underlineAttribute];
    
    lblSectionName.font=[UIFont fontWithName:@"SegoeUISymbol" size:20.0f];

    lblSectionName.numberOfLines = 0;
    lblSectionName.lineBreakMode = NSLineBreakByWordWrapping;
    [lblSectionName sizeToFit];
  
    if (IS_IOS7)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lblSectionName.lineBreakMode;
        
        CGRect rect = [lblSectionName.text boundingRectWithSize:CGSizeMake(280, 2500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : lblSectionName.font, NSParagraphStyleAttributeName : paragraphStyle} context:nil];
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.lordPrayerTbl.layer.frame.size.width, (rect.size.height+20))];
        [headerView addSubview:lblSectionName];
        
        return  headerView.frame.size.height;


    }
    CGSize maximumLabelSize = CGSizeMake(280, 2500);
    CGSize expectedLabelSize = [lblSectionName.text sizeWithFont:lblSectionName.font constrainedToSize:maximumLabelSize lineBreakMode:lblSectionName.lineBreakMode];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.lordPrayerTbl.layer.frame.size.width, (expectedLabelSize.height))];
    [headerView addSubview:lblSectionName];
    return headerView.frame.size.height;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // calculate height of UILabel
    UILabel *lblSectionName = [[UILabel alloc] init];
    lblSectionName.textColor = [UIColor blueColor];
      lblSectionName.frame=CGRectMake(10,20, self.view.frame.size.width-20, 20);
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    lblSectionName.attributedText = [[NSAttributedString alloc] initWithString:[[self.arrPrayerLineStr objectAtIndex:section]objectForKey:@"title"] attributes:underlineAttribute];
    
    lblSectionName.font=[UIFont fontWithName:@"SegoeUISymbol" size:20.0f];
   
    lblSectionName.numberOfLines = 0;
    lblSectionName.lineBreakMode = NSLineBreakByWordWrapping;
    [lblSectionName sizeToFit];
    UIView *headerView = [[UIView alloc] init];
//    headerView.backgroundColor = [UIColor colorWithRed:55/255.0 green:70/255.0 blue:114/255.0 alpha:1.0];
    
    [headerView addSubview:lblSectionName];
    
    return headerView;

}
#pragma mark-Next Button
-(void)nextButton
{
    if(self.currentPrayerId<self.arrPrayer.count)
    {
        self.nextbtn.hidden=false;
        
        self.currentPrayerId++;
        [UIView animateWithDuration:0.3 animations:^
        {
            
            self.lordPrayerTbl.alpha = 0.0f;
        }
        completion:^(BOOL finished)
        {
            
            if(finished){
                //do you job
             
                [self getNextData:[NSString stringWithFormat:@"%ld",(long)self.currentPrayerId]];
                [self setHeaderView];
                  [self.lordPrayerTbl reloadData];
               // Save the contentSize of your table view before reloading it
                 CGFloat oldTableViewHeight = self.lordPrayerTbl.contentSize.height;
                 
                 // Reload your table view with your new messages
                 
                 // Put your scroll position to where it was before
                 CGFloat newTableViewHeight = self.lordPrayerTbl.contentSize.height;
                 self.lordPrayerTbl.contentOffset = CGPointMake(0, newTableViewHeight - oldTableViewHeight);

                    [UIView animateWithDuration:0.3 animations:^{
                        self.previous.hidden=false;

                    self.lordPrayerTbl.alpha =  1.0f;
                    
                } completion:^(BOOL finished) {
                    
                    if(finished){
                        
                    }
                }];
                
            }
            if (self.currentPrayerId==self.arrPrayer.count)
            {
                self.nextbtn.hidden=true;
            }
        }];
        
        
    }
    else
    {
                self.nextbtn.hidden=true;
    }
    
}
#pragma mark-previous Button
-(void)previousButton
{
    if(self.currentPrayerId<=1)
    {
        self.previous.hidden=true;
        return;
    }
    
    
    self.currentPrayerId--;
    
    self.previous.hidden=false;
    
    [UIView animateWithDuration:0.3 animations:^{
        
       self.lordPrayerTbl.alpha = 0.0f;
    } completion:^(BOOL finished) {
        
        if(finished){
            
            [self getNextData:[NSString stringWithFormat:@"%ld",(long)self.currentPrayerId]];
            [self setHeaderView];
            [self.lordPrayerTbl reloadData];
            // Save the contentSize of your table view before reloading it
            CGFloat oldTableViewHeight = self.lordPrayerTbl.contentSize.height;
            
            // Reload your table view with your new messages
            
            // Put your scroll position to where it was before
            CGFloat newTableViewHeight = self.lordPrayerTbl.contentSize.height;
            self.lordPrayerTbl.contentOffset = CGPointMake(0, newTableViewHeight - oldTableViewHeight);
            
            [UIView animateWithDuration:0.3 animations:^{
                self.nextbtn.hidden=false;

                self.lordPrayerTbl.alpha =  1.0f;
                
            } completion:^(BOOL finished) {
                
                if(finished){
                    
                }
            }];
            
        }
        if (self.currentPrayerId==1)
        {
            self.previous.hidden=true;
        }
    }];
    
}

-(NSArray *)getNextData:(NSString *)prayerId
{
   self.arrPrayerLineStr=[[database getSharedInstance] fnLordPrayerDesc:prayerId];
    return self.arrPrayerLineStr;
}


- (IBAction)next:(id)sender
{
    [self nextButton];
}

- (IBAction)previous:(id)sender
{
    [self previousButton];
}
@end
