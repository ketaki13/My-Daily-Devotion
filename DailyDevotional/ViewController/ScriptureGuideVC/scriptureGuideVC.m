//
//  scriptureGuideVC.m
//  DailyDevotional
//
//  Created by ketaki on 6/25/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "scriptureGuideVC.h"
#import "scriptureGuideDetailView.h"
@implementation scriptureGuideVC
-(void)viewDidLoad
{
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
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
}
- (IBAction)nextPage:(id)sender
{
    scriptureGuideDetailView *objScriputreDetail=(scriptureGuideDetailView *)[self.storyboard instantiateViewControllerWithIdentifier:@"scriptureGuideDetailView"];
     [self.navigationController pushViewController:objScriputreDetail animated:YES];
}
@end
