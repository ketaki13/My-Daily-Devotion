//
//  ACTSAcronymViewcontroller.m
//  DailyDevotional
//
//  Created by ketaki on 6/19/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "ACTSAcronymViewcontroller.h"
#import "ACTSacronamyTableViewCell.h"
#import "prayerViewController.h"
#import "database.h"
#import "constants.h"
@interface ACTSAcronymViewcontroller (){

    database *db;
}

@end

@implementation ACTSAcronymViewcontroller
@synthesize arrPrayer;
- (void)viewDidLoad {
    
    db = [[database alloc] init];

   self.title = @"My Daily Devotion";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.arrAcronym=[[NSArray alloc]initWithObjects:@"Adoration",@"Confession",@"Thanksgiving",@"Supplication",nil];
    NSLog(@"%@",ACTS);
 self.arrAcronym =ACTS;
    NSLog(@"%@",[self.arrAcronym objectAtIndex:0]);
    NSLog(@"%@",self.arrAcronym);
    self.acronymTbl.layer.borderWidth=1.0;
    self.acronymTbl.layer.borderColor=[[UIColor blackColor] CGColor];
    [self setNavigationBar];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
     [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.arrAcronym count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACTSacronamyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.headingLbl.text=[[[self.arrAcronym objectAtIndex:indexPath.row] objectAtIndex:0]objectForKey:@"title"];
    cell.headingLbl.font=[UIFont fontWithName:@"SegoeUISymbol" size:18];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    prayerViewController *objPrayerViewController=(prayerViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"prayerViewController"];
    objPrayerViewController.currentPrayerId=indexPath.row+1;
    objPrayerViewController.arrAcronym=self.arrAcronym;
    NSMutableArray *arr=[[database getSharedInstance]fnGetACTSDesc:[NSString stringWithFormat:@"%ld",(long)indexPath.row+1]];
    objPrayerViewController.prayerHeader=arr;
    [self.navigationController pushViewController:objPrayerViewController animated:YES];
}

@end
