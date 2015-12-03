//
//  lordPrayerViewcontroller.m
//  DailyDevotional
//
//  Created by ketaki on 6/22/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "lordPrayerViewcontroller.h"
#import "LordPrayerCell.h"
#import "LordPrayerDetailViewController.h"
#import "constants.h"
#import "database.h"
@interface lordPrayerViewcontroller ()

@end

@implementation lordPrayerViewcontroller
@synthesize arrPrayer;
- (void)viewDidLoad {
    arrPrayer=LordPrayer;
    self.prayerTbl.layer.borderWidth=1.0;
    [self setNavigationBar];
    self.prayerTbl.layer.borderColor=[[UIColor blackColor] CGColor];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.headingColor= [[NSArray alloc]initWithObjects:[UIColor colorWithRed:58.0/255.0 green:68.0/     255.0 blue:113.0/255.0 alpha:1.0],
                                 [UIColor colorWithRed:94.0/255.0 green:28.0/255.0 blue:171.0/255.0 alpha:1.0],
                                 [UIColor colorWithRed:31.0/255.0 green:100./255.0 blue:153.0/255.0 alpha:1.0],
                                 [UIColor colorWithRed:132.0/255.0 green:106./255.0 blue:3.0/255.0 alpha:1.0],
                                 [UIColor colorWithRed:58.0/255.0 green:68.0/255.0 blue:113.0/255.0 alpha:1.0],
                                [UIColor colorWithRed:132.0/255.0 green:106./255.0 blue:3.0/255.0 alpha:1.0],
                                [UIColor colorWithRed:31.0/255.0 green:100./255.0 blue:153.0/255.0 alpha:1.0],
                                [UIColor colorWithRed:58.0/255.0 green:68.0/255.0 blue:113.0/255.0 alpha:1.0],
                        nil];
    

    [self setHeader];
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
     [self.navigationController popViewControllerAnimated:YES];}
-(void)setHeader
{
     UILabel *header=[[UILabel alloc]initWithFrame:CGRectMake(1,0,self.prayerTbl.layer.frame.size.width, 50)];
    header.text=@"The Lord’s Prayer\n(Matthew 6:9–13 and Luke 11:2–4)";
    header.numberOfLines = 0;
    header.lineBreakMode = NSLineBreakByWordWrapping;
  
    header.textAlignment=NSTextAlignmentCenter;
    header.font=[UIFont fontWithName:@"SegoeUISymbol" size:20];
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.prayerTbl.layer.frame.size.width, (header.frame.size.height+30))];
    [headerView addSubview:header];
    self.prayerTbl.tableHeaderView = headerView;
}
//-(void)viewDidAppear:(BOOL)animated
//{
//    self.prayerTbl.estimatedRowHeight =60;
//    self.prayerTbl.rowHeight = UITableViewAutomaticDimension;
//    //[self.prayerTbl reloadData];
//    
//}
-(void)viewWillAppear:(BOOL)animated
{
     self.title=@"My Daily Devotion";
    }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrPrayer.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LordPrayerCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.prayerLbl.text=[[[arrPrayer objectAtIndex:indexPath.row] objectAtIndex:0]objectForKey:@"title"];
    cell.prayerLbl.textColor=[self.headingColor objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LordPrayerDetailViewController *objLordPrayer=(LordPrayerDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"LordPrayerDetailViewController"];
    
    NSMutableArray * arrPrayerLine=[[database getSharedInstance] fnLordPrayerDesc:[[[arrPrayer objectAtIndex:indexPath.row] objectAtIndex:1]objectForKey:@"id"]];
    objLordPrayer.titleText=[[[arrPrayer objectAtIndex:indexPath.row] objectAtIndex:0]objectForKey:@"title"];
    objLordPrayer.textColor=[self.headingColor objectAtIndex:indexPath.row];
    objLordPrayer.arrPrayer=self.arrPrayer;
    objLordPrayer.currentPrayerId=indexPath.row+1;
    objLordPrayer.arrPrayerLineStr=arrPrayerLine;
    
       [self.navigationController pushViewController:objLordPrayer animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


@end
