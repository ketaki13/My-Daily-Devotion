//
//  guideToConfession.m
//  DailyDevotional
//
//  Created by ketaki on 6/18/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "guideToConfession.h"
#import "confessionTableViewCell.h"
#import "guideToConfessDetailView.h"
#import "database.h"
@interface guideToConfession ()

@end

@implementation guideToConfession

- (void)viewDidLoad {
    self.title = @"My Daily Devotion";

    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    database *db = [[database alloc] init];
    self.confesTitleArr=[[NSArray alloc]initWithObjects:@"Introduction",@"Confession & 10 Commandments",@"Stages (1st Stage)",@"Stages (2nd Stage)",@"Stages (3rd Stage)",@"Conclusion",nil];
    
    self.confessionArr=[[NSArray alloc]initWithArray:[db fetchGuideToConfession]];
    [self setNavigationBar];
    [super viewDidLoad];
    self.confessionTbl.layer.borderWidth=1.0;
    self.confessionTbl.layer.borderColor=[[UIColor blackColor] CGColor];
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
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.confessionArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    confessionTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.headingLbl.text=[self.confesTitleArr objectAtIndex:indexPath.row];
    cell.headingLbl.numberOfLines = 0;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    guideToConfessDetailView *objguideToConfessDetailView = (guideToConfessDetailView *) [self.storyboard instantiateViewControllerWithIdentifier:@"guideToConfessDetailView"];
    objguideToConfessDetailView.heading=[[self.confessionArr objectAtIndex:indexPath.row] valueForKey:@"chapterName"];
    objguideToConfessDetailView.chapterdescription=[[self.confessionArr objectAtIndex:indexPath.row] valueForKey:@"Desc"];
    objguideToConfessDetailView.currentConffessionId = indexPath.row;
    objguideToConfessDetailView.confessionArr = self.confessionArr;
    
    [self.navigationController pushViewController:objguideToConfessDetailView animated:YES];
}
@end
