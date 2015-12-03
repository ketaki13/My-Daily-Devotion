//
//  prayerGuide.m
//  DailyDevotional
//
//  Created by ketaki on 6/22/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "prayerGuide.h"
#import "lordPrayerViewcontroller.h"
@interface prayerGuide ()

@end

@implementation prayerGuide

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title=@"My Daily Devotion";
    self.view.backgroundColor=[UIColor whiteColor];
    //self.navigationController.navigationBar.backItem.title = @"My Daily Devotion";
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
 
    [self setNavigationBar];
        // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    
  
}

-(void)viewDidAppear:(BOOL)animated
{
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)nextPage:(id)sender
{
    lordPrayerViewcontroller *objLordPrayer=(lordPrayerViewcontroller *)[self.storyboard instantiateViewControllerWithIdentifier:@"lordPrayerViewcontroller"];
    [self.navigationController pushViewController:objLordPrayer animated:YES];
}
@end
