//
//  prayerViewController.m
//  DailyDevotional
//
//  Created by ketaki on 6/19/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "prayerViewController.h"
#import "prayerTableViewCell.h"
#import "constants.h"
#import "database.h"
@interface prayerViewController ()
{
 }
@end

@implementation prayerViewController
#pragma mark-View
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.prayerTbl.backgroundColor=[UIColor clearColor];
    self.prayerTbl.backgroundView=nil;
    if (self.currentPrayerId==1)
    {
         self.previousBtn.hidden=true;
    }
    if (self.currentPrayerId==self.arrAcronym.count)
    {
        self.nextbtn.hidden=true;
    }
   // self.prayerLine.text=self.prayerLineStr;
    [self setNavigationBar];
    [self setHeaderView];
     // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
//    self.prayerTbl.estimatedRowHeight =60;
//    self.prayerTbl.rowHeight = UITableViewAutomaticDimension;
//    [self.prayerTbl reloadData];
    
}
-(void)setNavigationBar
{
    UIImage *backImg = [UIImage imageNamed:@"back arrow"];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = back;
}
-(void)back
{
     [self.navigationController popViewControllerAnimated:YES];
}
-(void)setHeaderView
{
    self.title=[[[self.arrAcronym objectAtIndex:self.currentPrayerId-1] objectAtIndex:0]objectForKey:@"title"];
    UILabel *textAboveLineHeader=[[UILabel alloc]initWithFrame:CGRectMake(10,5,self.prayerTbl.layer.frame.size.width-20, 70)];
    if (self.currentPrayerId==1)
    {
        self.textAboveLineStr=Text_Above_Adoration;
    }
    if (self.currentPrayerId==2)
    {
        self.textAboveLineStr=Text_Above_Confession;
    }
    
    if (self.currentPrayerId==3)
    {
        self.textAboveLineStr=Text_Above_Thanksgiving;
    }
    if (self.currentPrayerId==4)
    {
        self.textAboveLineStr=Text_Above_Supplication;
    }
    textAboveLineHeader.text=self.textAboveLineStr;
    textAboveLineHeader.font=[UIFont fontWithName:@"SegoeUISymbol" size:18];
    textAboveLineHeader.numberOfLines = 0;
    textAboveLineHeader.lineBreakMode = NSLineBreakByWordWrapping;
    textAboveLineHeader.textColor=[UIColor blueColor];
    [textAboveLineHeader sizeToFit];
    
//    UILabel *PrayerLine=[[UILabel alloc]initWithFrame:CGRectMake(10,textAboveLineHeader.frame.size.height+10,self.prayerTbl.layer.frame.size.width-20, 50)];
//    PrayerLine.text=[[[self.arrAcronym objectAtIndex:self.currentPrayerId-1] objectAtIndex:0]objectForKey:@"title"];
//    PrayerLine.numberOfLines = 0;
//    PrayerLine.lineBreakMode = NSLineBreakByWordWrapping;
//    PrayerLine.textAlignment=NSTextAlignmentCenter;
//       CGSize size;
    CGSize sizeForPrayer;

    if (IS_IOS7)
    {
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineBreakMode = PrayerLine.lineBreakMode;
//        
//        CGRect rect = [PrayerLine.text boundingRectWithSize:CGSizeMake(280, 2500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : PrayerLine.font, NSParagraphStyleAttributeName : paragraphStyle} context:nil];
        
//        size= rect.size;
        
        NSMutableParagraphStyle *paragraphStyleforHeader = [[NSMutableParagraphStyle alloc] init];
        paragraphStyleforHeader.lineBreakMode = textAboveLineHeader.lineBreakMode;
        
        CGRect rectForHrader = [textAboveLineHeader.text boundingRectWithSize:CGSizeMake(280, 2500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : textAboveLineHeader.font, NSParagraphStyleAttributeName : paragraphStyleforHeader} context:nil];
        
        sizeForPrayer= rectForHrader.size;
    }
    CGSize maximumLabelSize = CGSizeMake(280, 2500);
//    size = [PrayerLine.text sizeWithFont:PrayerLine.font constrainedToSize:maximumLabelSize lineBreakMode:PrayerLine.lineBreakMode];
    
    sizeForPrayer = [textAboveLineHeader.text sizeWithFont:textAboveLineHeader.font constrainedToSize:maximumLabelSize lineBreakMode:textAboveLineHeader.lineBreakMode];
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.prayerTbl.layer.frame.size.width, (sizeForPrayer.height+10))];
    headerView.backgroundColor=[UIColor clearColor];
    [headerView addSubview:textAboveLineHeader];
//    [headerView addSubview:PrayerLine];
    self.prayerTbl.tableHeaderView = headerView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-Table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.prayerHeader count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary  *dict=[self.prayerHeader objectAtIndex:section];
    NSArray *array=[dict objectForKey:@"data"];
    return [array count];
}- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *cellIdentifier = @"cell";
    prayerTableViewCell *cell = (prayerTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary  *dict=[self.prayerHeader objectAtIndex:indexPath.section];
    NSArray *array=[dict objectForKey:@"data"];
    cell.descLbl.text=[array objectAtIndex:indexPath.row];
    cell.descLbl.font=[UIFont italicSystemFontOfSize:17.0f];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // calculate height of UILabel
    UILabel *lblSectionName = [[UILabel alloc]init];
     lblSectionName.frame=CGRectMake(10,5, self.view.frame.size.width-20, 20);
      lblSectionName.text =[[self.prayerHeader objectAtIndex:section] objectForKey:@"title"];
    lblSectionName.textColor = [UIColor blueColor];
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};

    lblSectionName.attributedText = [[NSAttributedString alloc] initWithString:[[self.prayerHeader objectAtIndex:section] objectForKey:@"title"]
                                                             attributes:underlineAttribute];
    
    lblSectionName.font=[UIFont fontWithName:@"SegoeUISymbol" size:20.0f];
    lblSectionName.numberOfLines = 0;
    lblSectionName.lineBreakMode = NSLineBreakByWordWrapping;
    //lblSectionName.backgroundColor = [UIColor grayColor];
    [lblSectionName sizeToFit];
    
    if (IS_IOS7)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lblSectionName.lineBreakMode;
        
        CGRect rect = [lblSectionName.text boundingRectWithSize:CGSizeMake(280, 2500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : lblSectionName.font, NSParagraphStyleAttributeName : paragraphStyle} context:nil];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.prayerTbl.layer.frame.size.width, (rect.size.height))];
        [headerView addSubview:lblSectionName];

        return  lblSectionName.frame.size.height+10;
        
    }
    CGSize maximumLabelSize = CGSizeMake(280, 2500);
    CGSize expectedLabelSize = [lblSectionName.text sizeWithFont:lblSectionName.font constrainedToSize:maximumLabelSize lineBreakMode:lblSectionName.lineBreakMode];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.prayerTbl.layer.frame.size.width, expectedLabelSize.height)];
    [headerView addSubview:lblSectionName];
    return lblSectionName.frame.size.height+10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // calculate height of UILabel
    UILabel *lblSectionName = [[UILabel alloc] init];
    lblSectionName.text =[[self.prayerHeader objectAtIndex:section] objectForKey:@"title"];
    lblSectionName.frame=CGRectMake(10, 5, self.view.frame.size.width-20, 20);
    lblSectionName.textColor = [UIColor blueColor];
    lblSectionName.numberOfLines = 0;
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};

    lblSectionName.attributedText = [[NSAttributedString alloc] initWithString:[[self.prayerHeader objectAtIndex:section] objectForKey:@"title"]
                                                                    attributes:underlineAttribute];
    
    lblSectionName.font=[UIFont fontWithName:@"SegoeUISymbol" size:20.0f];
    lblSectionName.lineBreakMode = NSLineBreakByWordWrapping;
       [lblSectionName sizeToFit];
    UIView *headerView = [[UIView alloc] init];
//    headerView.backgroundColor = [UIColor colorWithRed:55/255.0 green:70/255.0 blue:114/255.0 alpha:1.0];
    headerView.backgroundColor=[UIColor clearColor];
    [headerView addSubview:lblSectionName];
    
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    prayerTableViewCell *cell = (prayerTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary  *dict=[self.prayerHeader objectAtIndex:indexPath.section];
    NSArray *array=[dict objectForKey:@"data"];
    cell.descLbl.text=[array objectAtIndex:indexPath.row];
    cell.descLbl.numberOfLines = 0;
    cell.descLbl.lineBreakMode = NSLineBreakByWordWrapping;
    [ cell.descLbl sizeToFit];
    if (IS_IOS7)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = cell.descLbl.lineBreakMode;
        
        CGRect rect = [cell.descLbl.text boundingRectWithSize:CGSizeMake(280, 2500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : cell.descLbl.font, NSParagraphStyleAttributeName : paragraphStyle} context:nil];
        
        return rect.size.height+10;
    }
    CGSize maximumLabelSize = CGSizeMake(280, 2500);
    CGSize expectedLabelSize = [ cell.descLbl.text sizeWithFont:cell.descLbl.font constrainedToSize:maximumLabelSize lineBreakMode: cell.descLbl.lineBreakMode];
    return expectedLabelSize.height+10;
    
}

#pragma mark-Next button
-(void)nextButton
{
    if(self.currentPrayerId<self.arrAcronym.count)
    {
        
        self.currentPrayerId++;
        [UIView animateWithDuration:0.3 animations:^
         {
             
             self.prayerTbl.alpha = 0.0f;
         }
                         completion:^(BOOL finished)
         {
             
             if(finished){
                 //do you job
                 
                [self getNextData:[NSString stringWithFormat:@"%ld",(long)self.currentPrayerId]];
                 [self setHeaderView];
                 [self.prayerTbl reloadData];
                  CGFloat oldTableViewHeight = self.prayerTbl.contentSize.height;
                 CGFloat newTableViewHeight = self.prayerTbl.contentSize.height;
                 self.prayerTbl.contentOffset = CGPointMake(0, newTableViewHeight - oldTableViewHeight);
                 [UIView animateWithDuration:0.3 animations:^{
                     
                     self.prayerTbl.alpha =  1.0f;
                     self.previousBtn.hidden=false;
                     
                 } completion:^(BOOL finished) {
                     
                     if(finished){
                         
                     }
                 }];
                 
             }
             if (self.currentPrayerId==self.arrAcronym.count)
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
#pragma mark-Previous button
-(void)previousButton
{
    if(self.currentPrayerId<=1)
    {
        self.previousBtn.hidden=true;
        return;
    }
    
    self.currentPrayerId--;
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.prayerTbl.alpha = 0.0f;
    } completion:^(BOOL finished) {
        
        if(finished){
            
           [self getNextData:[NSString stringWithFormat:@"%ld",(long)self.currentPrayerId]];
            [self setHeaderView];
            [self.prayerTbl reloadData];
            CGFloat oldTableViewHeight = self.prayerTbl.contentSize.height;
            
            // Reload your table view with your new messages
            
            // Put your scroll position to where it was before
            CGFloat newTableViewHeight = self.prayerTbl.contentSize.height;
            self.prayerTbl.contentOffset = CGPointMake(0, newTableViewHeight - oldTableViewHeight);

            [UIView animateWithDuration:0.3 animations:^{
                
                self.prayerTbl.alpha =  1.0f;
                self.nextbtn.hidden=false;
                
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
- (IBAction)previous:(id)sender
{
    [self previousButton];
}
#pragma mark-Relaod data
-(NSArray *)getNextData:(NSString *)prayerId
{
    
    self.prayerHeader=[[database getSharedInstance]fnGetACTSDesc:prayerId];
    return self.prayerHeader;
}




@end
