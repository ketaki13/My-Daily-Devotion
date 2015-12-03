//
//  PrayerToStChristopher.m
//  DailyDevotional
//
//  Created by ketaki on 6/22/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "PrayerToStChristopher.h"
#import "PrayerToStChristopherTableViewCell.h"
#import "constants.h"
#import "database.h"
#import "VersesDetailViewController.h"
@interface PrayerToStChristopher ()

@end

@implementation PrayerToStChristopher
#pragma mark-View
- (void)viewDidLoad
{
    self.minId=self.bookletId;
    self.christoperTbl.backgroundColor=[UIColor whiteColor];
    self.christoperTbl.backgroundView=nil;
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"My Daily Devotion";
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    NSLog(@"%@",self.arrChristPrayer);
    [self setNavigationBar];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setNavigationBar
{
    UIImage *backImg = [UIImage imageNamed:@"back arrow"];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = back;
}
-(void)back
{
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
//       self.christoperTbl.estimatedRowHeight =60;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.christoperTbl.rowHeight = UITableViewAutomaticDimension;
    [self.christoperTbl reloadData];
       [self setHeader];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-Table View Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.arrChristPrayer count];
}
-(void)setHeader
{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,50)];
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(10,10,headerView.frame.size.width-20,20)];
    title.textAlignment=NSTextAlignmentCenter;
    title.text=[NSString stringWithFormat:@"Prayer To %@",[[[booklet objectAtIndex:self.currentPrayerId-1]objectAtIndex:0] objectForKey:@"title"]];
    title.numberOfLines = 1;
    title.textColor=[UIColor blueColor];
    title.lineBreakMode = NSLineBreakByWordWrapping;
//    [title sizeToFit];
    title.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
      [headerView addSubview:title];
    self.christoperTbl.tableHeaderView=headerView;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrayerToStChristopherTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary  *dict=[self.arrChristPrayer objectAtIndex:indexPath.section];
    //NSArray *array=[dict objectForKey:@"strBookletDesc"];
    cell.discLbl.text=[dict objectForKey:@"strBookletDesc"];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.arrChristPrayer objectAtIndex:section] objectForKey:@"strBookletHeading"];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    PrayerToStChristopherTableViewCell *cell = (PrayerToStChristopherTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     NSDictionary  *dict=[self.arrChristPrayer objectAtIndex:indexPath.section];
    cell.discLbl.text=[dict objectForKey:@"strBookletDesc"];
     cell.discLbl.numberOfLines = 0;
   cell.discLbl.lineBreakMode = NSLineBreakByWordWrapping;
    [ cell.discLbl sizeToFit];
    if (IS_IOS7)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = cell.discLbl.lineBreakMode;
        
        CGRect rect = [cell.discLbl.text boundingRectWithSize:CGSizeMake(280, 2500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : cell.discLbl.font, NSParagraphStyleAttributeName : paragraphStyle} context:nil];
        
        return rect.size.height+10;
    }
    CGSize maximumLabelSize = CGSizeMake(280, 2500);
    CGSize expectedLabelSize = [ cell.discLbl.text sizeWithFont:cell.discLbl.font constrainedToSize:maximumLabelSize lineBreakMode: cell.discLbl.lineBreakMode];
    return expectedLabelSize.height+10;
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // calculate height of UILabel
    UILabel *lblSectionName = [[UILabel alloc] init];
    lblSectionName.text = [[self.arrChristPrayer objectAtIndex:section]objectForKey:@"strBookletHeading"];
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    lblSectionName.attributedText = [[NSAttributedString alloc] initWithString:[[self.arrChristPrayer objectAtIndex:section]objectForKey:@"strBookletHeading"] attributes:underlineAttribute];

    
    lblSectionName.font=[UIFont fontWithName:@"SegoeUISymbol" size:20.0f];
    lblSectionName.textColor = [UIColor lightGrayColor];
     lblSectionName.frame=CGRectMake(10, 10, self.view.frame.size.width-20, 20);
    lblSectionName.numberOfLines = 0;
    lblSectionName.lineBreakMode = NSLineBreakByWordWrapping;
    lblSectionName.backgroundColor = [UIColor grayColor];
    [lblSectionName sizeToFit];
    
    if (IS_IOS7)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lblSectionName.lineBreakMode;
        
        CGRect rect = [lblSectionName.text boundingRectWithSize:CGSizeMake(280, 2500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : lblSectionName.font, NSParagraphStyleAttributeName : paragraphStyle} context:nil];
        
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.christoperTbl.layer.frame.size.width, (rect.size.height+10))];
        [headerView addSubview:lblSectionName];
        
        return  headerView.frame.size.height;
        
    }
    CGSize maximumLabelSize = CGSizeMake(280, 2500);
    CGSize expectedLabelSize = [lblSectionName.text sizeWithFont:lblSectionName.font constrainedToSize:maximumLabelSize lineBreakMode:lblSectionName.lineBreakMode];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.christoperTbl.layer.frame.size.width, (expectedLabelSize.height+10))];
    [headerView addSubview:lblSectionName];
    return headerView.frame.size.height;}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // calculate height of UILabel
    UILabel *lblSectionName = [[UILabel alloc] init];
    lblSectionName.textColor = [UIColor blueColor];
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    lblSectionName.attributedText = [[NSAttributedString alloc] initWithString:[[self.arrChristPrayer objectAtIndex:section]objectForKey:@"strBookletHeading"] attributes:underlineAttribute];
    
    lblSectionName.font=[UIFont fontWithName:@"SegoeUISymbol" size:20.0f];
    lblSectionName.frame=CGRectMake(10, 10, self.view.frame.size.width-20, 20);
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
    if(self.bookletId<self.maxId)
    {
        self.nextbtn.hidden=false;
        self.bookletId++;
        [UIView animateWithDuration:0.3 animations:^
         {
             
             self.christoperTbl.alpha = 0.0f;
         }
                         completion:^(BOOL finished)
         {
             if(finished){
                 //do you job
                 
                 [self getNextData:[NSString stringWithFormat:@"%ld",(long)self.bookletId]];
                 [self setHeader];
                 [self.christoperTbl reloadData];
                 CGFloat oldTableViewHeight = self.christoperTbl.contentSize.height;
                 
                 // Reload your table view with your new messages
                 
                 // Put your scroll position to where it was before
                 CGFloat newTableViewHeight = self.christoperTbl.contentSize.height;
                 self.christoperTbl.contentOffset = CGPointMake(0, newTableViewHeight - oldTableViewHeight);

                 
                 [UIView animateWithDuration:0.3 animations:^{
                     self.previousbBrtn.hidden=false;
                     self.christoperTbl.alpha =  1.0f;
                     
                 } completion:^(BOOL finished) {
                     
                     if(finished){
                         
                     }
                 }];
                 
             }
             if (self.bookletId==self.maxId)
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
   
    if (self.bookletId>self.minId)
    {
         self.previousbBrtn.hidden=false;
        self.bookletId--;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.christoperTbl.alpha = 0.0f;
    } completion:^(BOOL finished) {
        
        if(finished){
            
            [self getNextData:[NSString stringWithFormat:@"%ld",(long)self.bookletId]];
            [self setHeader];
            [self.christoperTbl reloadData];
            CGFloat oldTableViewHeight = self.christoperTbl.contentSize.height;
            
            // Reload your table view with your new messages
            
            // Put your scroll position to where it was before
            CGFloat newTableViewHeight = self.christoperTbl.contentSize.height;
            self.christoperTbl.contentOffset = CGPointMake(0, newTableViewHeight - oldTableViewHeight);

            [UIView animateWithDuration:0.3 animations:^{
                self.nextbtn.hidden=false;
                self.christoperTbl.alpha =  1.0f;
                
            } completion:^(BOOL finished) {
                
                if(finished){
                    
                }
            }];
            
        }
        if (self.bookletId==self.minId)
        {
            self.previousbBrtn.hidden=true;
        }

    }];
    }
    else
    {
        self.previousbBrtn.hidden=true;
    }
}
- (IBAction)previous:(id)sender
{
    [self previousButton];
}

#pragma mark-Reload Data
-(NSArray *)getNextData:(NSString *)prayerBookletId
{
    
    self.arrChristPrayer=[[database getSharedInstance] fetchChristoperText:self.bookletprayerId prayerId:prayerBookletId];
    return self.arrChristPrayer;
}




@end
