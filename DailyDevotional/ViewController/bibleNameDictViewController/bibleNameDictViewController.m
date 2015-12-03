//
//  bibleNameDictViewController.m
//  DailyDevotional
//
//  Created by ketaki on 6/18/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "bibleNameDictViewController.h"
#import "bibleNameCollectionViewCell.h"
#import "bibleDictonaryViewController.h"
#import "constants.h"
#import "database.h"
@interface bibleNameDictViewController ()

@end

@implementation bibleNameDictViewController
@synthesize arrAlphabet;
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self setNavigationBar];
    self.title = @"My Daily Devotion";
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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrAlphabet.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    bibleNameCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.alphaName.text=[[[arrAlphabet objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"title"];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arrNameDict=[[database getSharedInstance]fetchNameDictonary:[NSString stringWithFormat:@"%ld",(long)indexPath.row+1]];
    if ([arrNameDict count]>1)
    {
        bibleDictonaryViewController *objbibleDictonaryViewController = (bibleDictonaryViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"bibleDictonaryViewController"];
        objbibleDictonaryViewController.key=[arrAlphabet objectAtIndex:indexPath.row];
        objbibleDictonaryViewController.arrValue=arrNameDict;
    
        [self.navigationController pushViewController:objbibleDictonaryViewController animated:YES];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"No Data Availble" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

}
    

@end
