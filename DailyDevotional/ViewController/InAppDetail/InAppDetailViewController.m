//
//  InAppDetailViewController.m
//  DailyDevotional
//
//  Created by webwerks on 6/17/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "InAppDetailViewController.h"
#import "DictCollectionViewCell.h"
#import "bibleDictonaryViewController.h"
#import "constants.h"
#import "database.h"
#import "VersesDetailViewController.h"
@interface InAppDetailViewController ()

@end

@implementation InAppDetailViewController
@synthesize  arrAlphabet;
#pragma mark-View
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"My Daily Devotion";
    [self setNavigationBar];
    self.titleOfCategeory.text = [self.screenData valueForKey:@"title"];
    // Do any additional setup after loading the view.//My Daily Devotion
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
#pragma mark-Collection view Delgate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrAlphabet.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DictCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
     cell.alphaLbl.text=[[[arrAlphabet objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"title"];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
      NSMutableArray *arrDict=[[database getSharedInstance]fetchDictonary:[NSString stringWithFormat:@"%ld",(long)indexPath.row+1]];
    if ([arrDict count]>1)
    {
        bibleDictonaryViewController *objbibleDictonaryViewController = (bibleDictonaryViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"bibleDictonaryViewController"];
        objbibleDictonaryViewController.arrValue=arrDict;
        objbibleDictonaryViewController.key=[arrAlphabet objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:objbibleDictonaryViewController animated:YES];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"No Data Available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }

}
   
@end
