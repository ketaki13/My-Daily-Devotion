//
//  scriptureGuideDetailView.m
//  DailyDevotional
//
//  Created by ketaki on 6/25/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "scriptureGuideDetailView.h"
#import "constants.h"
#import "scriputerGuideTableViewcell.h"
#import "database.h"
#import "scripturePrayerVC.h"
@implementation scriptureGuideDetailView
-(void)viewDidLoad
{
    self.arrScriputreGuide =scriptureGuide;
    NSLog(@"%@",self.arrScriputreGuide);
    self.scriputreTbl.layer.borderWidth=1.0;
    self.scriputreTbl.layer.borderColor=[[UIColor blackColor] CGColor];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.title=@"My Daily Devotion";
  
    [self setNavigationBar];

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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    return [self.arrScriputreGuide count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    scriputerGuideTableViewcell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.scriputreLbl.text=[[[self.arrScriputreGuide objectAtIndex:indexPath.row] objectAtIndex:0]objectForKey:@"title"];;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    scripturePrayerVC *objscripturePrayerV=(scripturePrayerVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"scripturePrayerVC"];
     objscripturePrayerV.currentPrayerId=indexPath.row+1;
    objscripturePrayerV.arrScriputreGuide=self.arrScriputreGuide;
    NSMutableArray *arrPrayer=[[database getSharedInstance]fetchSacripturePrayer:[[[self.arrScriputreGuide objectAtIndex:indexPath.row] objectAtIndex:1]objectForKey:@"id"]];
    objscripturePrayerV.arrPrayer=arrPrayer;
    if (indexPath.row==0)
    {
        objscripturePrayerV.textAboveLineStr=Text_Above_Scripture_1;
        objscripturePrayerV.prayerLineStr=[[[self.arrScriputreGuide objectAtIndex:indexPath.row] objectAtIndex:0]objectForKey:@"title"];
    }
    else if(indexPath.row==1)
    {
        objscripturePrayerV.textAboveLineStr=Text_Above_Scripture_2;
        objscripturePrayerV.prayerLineStr=[[[self.arrScriputreGuide objectAtIndex:indexPath.row] objectAtIndex:0]objectForKey:@"title"];
    }
    else if(indexPath.row==2)
    {
        objscripturePrayerV.textAboveLineStr=Text_Above_Scripture_3;
        objscripturePrayerV.prayerLineStr=[[[self.arrScriputreGuide objectAtIndex:indexPath.row] objectAtIndex:0]objectForKey:@"title"];
    }
    else if(indexPath.row==3)
    {
        objscripturePrayerV.textAboveLineStr=Text_Above_Scripture_4;
        objscripturePrayerV.prayerLineStr=[[[self.arrScriputreGuide objectAtIndex:indexPath.row] objectAtIndex:0]objectForKey:@"title"];
    }
    else if(indexPath.row==4)
    {
        objscripturePrayerV.textAboveLineStr=Text_Above_Scripture_5;
        objscripturePrayerV.prayerLineStr=[[[self.arrScriputreGuide objectAtIndex:indexPath.row] objectAtIndex:0]objectForKey:@"title"];
    }
    [self.navigationController pushViewController:objscripturePrayerV animated:YES];
}
@end
