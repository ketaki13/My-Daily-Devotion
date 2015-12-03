//
//  scripturePrayerVC.m
//  DailyDevotional
//
//  Created by ketaki on 6/25/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "scripturePrayerVC.h"
#import "scriputreTableViewCell.h"
#import "constants.h"
#import "database.h"
@implementation scripturePrayerVC
#pragma mark-View
-(void)viewDidLoad
{
    self.scriptureTbl.backgroundColor=[UIColor whiteColor];
    self.scriptureTbl.backgroundView=nil;
    if (self.currentPrayerId==1)
    {
        self.previousBtn.hidden=true;
    }
    if (self.currentPrayerId==self.arrScriputreGuide.count)
    {
        self.nextbtn.hidden=true;
    }
    self.scriptureTbl.layer.borderWidth=1.0;
    self.scriptureTbl.layer.borderColor=[[UIColor blackColor] CGColor];
      [self setNavigationBar];
self.title=@"My Daily Devotion";
    [self setHeaderView];
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
#pragma mark-Set Header View
-(void)setHeaderView
{
    if (self.currentPrayerId==1)
    {
        self.textAboveLineStr=Text_Above_Scripture_1;
    }
    if (self.currentPrayerId==2)
    {
        self.textAboveLineStr=Text_Above_Scripture_2;
    }
    
    if (self.currentPrayerId==3)
    {
        self.textAboveLineStr=Text_Above_Scripture_3;
    }
    if (self.currentPrayerId==4)
    {
        self.textAboveLineStr=Text_Above_Scripture_4;
    }
    if (self.currentPrayerId==5)
    {
        self.textAboveLineStr=Text_Above_Scripture_5;
    }
    [self setHeader];
 }
-(void)setHeader
{
     UILabel *textAboveLineHeader=[[UILabel alloc]initWithFrame:CGRectMake(10,5,self.praylerTbl.layer.frame.size.width-20, 50)];
    textAboveLineHeader.textColor=[UIColor blueColor];
    textAboveLineHeader.text=self.textAboveLineStr;
    textAboveLineHeader.numberOfLines = 0;
    textAboveLineHeader.lineBreakMode = NSLineBreakByWordWrapping;
    [textAboveLineHeader sizeToFit];
    CGSize sizeForPrayer;
    if (IS_IOS7)
    {
        NSMutableParagraphStyle *paragraphStyleforHeader = [[NSMutableParagraphStyle alloc] init];
        paragraphStyleforHeader.lineBreakMode = textAboveLineHeader.lineBreakMode;
        
        CGRect rectForHrader = [textAboveLineHeader.text boundingRectWithSize:CGSizeMake(280, 2500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : textAboveLineHeader.font, NSParagraphStyleAttributeName : paragraphStyleforHeader} context:nil];
        
        sizeForPrayer= rectForHrader.size;
    }
   CGSize maximumLabelSize = CGSizeMake(280, 2500);
    sizeForPrayer = [textAboveLineHeader.text sizeWithFont:textAboveLineHeader.font constrainedToSize:maximumLabelSize lineBreakMode:textAboveLineHeader.lineBreakMode];
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.scriptureTbl.layer.frame.size.width, (sizeForPrayer.height+10))];
    [headerView addSubview:textAboveLineHeader];
    self.praylerTbl.tableHeaderView = headerView;
    
}
#pragma mark-tablew view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.arrPrayer count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    scriputreTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.prayerDesc.text=[self.arrPrayer objectAtIndex:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    UILabel *lblSectionName = [[UILabel alloc] init];
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    lblSectionName.attributedText = [[NSAttributedString alloc] initWithString:[[[self.arrScriputreGuide objectAtIndex:self.currentPrayerId-1]objectAtIndex:0]objectForKey:@"title"] attributes:underlineAttribute];
       lblSectionName.font=[UIFont fontWithName:@"SegoeUISymbol" size:20.0f];
    lblSectionName.textColor = [UIColor lightGrayColor];
    lblSectionName.numberOfLines = 0;
     lblSectionName.frame=CGRectMake(10, 5, self.view.frame.size.width-20, 20);
    lblSectionName.lineBreakMode = NSLineBreakByWordWrapping;
    lblSectionName.backgroundColor = [UIColor grayColor];
    [lblSectionName sizeToFit];
    if (IS_IOS7)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lblSectionName.lineBreakMode;
        
        CGRect rect = [lblSectionName.text boundingRectWithSize:CGSizeMake(280, 2500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : lblSectionName.font, NSParagraphStyleAttributeName : paragraphStyle} context:nil];
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.scriptureTbl.layer.frame.size.width, (rect.size.height+10))];
        [headerView addSubview:lblSectionName];
        return  headerView.frame.size.height;
    }
    CGSize maximumLabelSize = CGSizeMake(280, 2500);
    CGSize expectedLabelSize = [lblSectionName.text sizeWithFont:lblSectionName.font constrainedToSize:maximumLabelSize lineBreakMode:lblSectionName.lineBreakMode];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.scriptureTbl.layer.frame.size.width, (expectedLabelSize.height+10))];
    [headerView addSubview:lblSectionName];
    return headerView.frame.size.height;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lblSectionName = [[UILabel alloc] init];
     lblSectionName.frame=CGRectMake(10, 5, self.view.frame.size.width-20, 20);
    lblSectionName.textColor = [UIColor blueColor];
    lblSectionName.numberOfLines = 0;
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    lblSectionName.attributedText = [[NSAttributedString alloc] initWithString:[[[self.arrScriputreGuide objectAtIndex:self.currentPrayerId-1]objectAtIndex:0]objectForKey:@"title"] attributes:underlineAttribute];
      lblSectionName.font=[UIFont fontWithName:@"SegoeUISymbol" size:20.0f];
    lblSectionName.lineBreakMode = NSLineBreakByWordWrapping;
    [lblSectionName sizeToFit];
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:lblSectionName];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    scriputreTableViewCell *cell = (scriputreTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      cell.prayerDesc.text=[self.arrPrayer objectAtIndex:indexPath.row];
    cell.prayerDesc.numberOfLines = 0;
    cell.prayerDesc.lineBreakMode = NSLineBreakByWordWrapping;
    [ cell.prayerDesc sizeToFit];
    if (IS_IOS7)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = cell.prayerDesc.lineBreakMode;
        CGRect rect = [cell.prayerDesc.text boundingRectWithSize:CGSizeMake(280, 2500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : cell.prayerDesc.font, NSParagraphStyleAttributeName :paragraphStyle} context:nil];
        return rect.size.height+10;
    }
    CGSize maximumLabelSize = CGSizeMake(280, 2500);
    CGSize expectedLabelSize = [ cell.prayerDesc.text sizeWithFont:cell.prayerDesc.font constrainedToSize:maximumLabelSize lineBreakMode: cell.prayerDesc.lineBreakMode];
    return expectedLabelSize.height+10;
    
}
#pragma mark-Next Button

-(void)nextButton
{
    if(self.currentPrayerId<self.arrScriputreGuide.count)
    {
         self.nextbtn.hidden=false;
        self.currentPrayerId++;
        [UIView animateWithDuration:0.3 animations:^
         {
        self.praylerTbl.alpha = 0.0f;
         }
        completion:^(BOOL finished)
         {
             
             if(finished){
                [self getNextData:[NSString stringWithFormat:@"%ld",(long)self.currentPrayerId]];
                 [self setHeaderView];
                 [self.praylerTbl reloadData];
                 
                 
                 [UIView animateWithDuration:0.3 animations:^{
                     self.previousBtn.hidden=false;
                     self.praylerTbl.alpha =  1.0f;
                     
                 } completion:^(BOOL finished) {
                     
                     if(finished){
                         
                     }
                 }];
                 
             }
             if (self.currentPrayerId==self.arrScriputreGuide.count)
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
- (IBAction)next:(id)sender
{
    [self nextButton];
}

#pragma mark-Previous Button
-(void)previousButton
{
    if(self.currentPrayerId<=1)
    {
        self.previousBtn.hidden=true;
        return;
    }
    else
    {
    self.currentPrayerId--;
    self.previousBtn.hidden=false;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.praylerTbl.alpha = 0.0f;
    } completion:^(BOOL finished) {
        
        if(finished){
            
            [self getNextData:[NSString stringWithFormat:@"%ld",(long)self.currentPrayerId]];
            [self setHeaderView];
            [self.praylerTbl reloadData];
            
            [UIView animateWithDuration:0.3 animations:^{
                self.nextbtn.hidden=false;
                self.praylerTbl.alpha =  1.0f;
                
            } completion:^(BOOL finished) {
                
                if(finished){
                    
                }
            }];
            
        }
        if (self.currentPrayerId==1)
        {
            self.previousBtn.hidden=true;
        }
    }];
    }
    
}
- (IBAction)previous:(id)sender
{
    [self previousButton];
}
#pragma Mark-Reload Data
-(NSArray *)getNextData:(NSString *)prayerId
{
    self.arrPrayer=[[database getSharedInstance] fetchSacripturePrayer:prayerId];
    return self.arrPrayer;
}
@end
