//
//  ACTSModelViewController.m
//  DailyDevotional
//
//  Created by ketaki on 6/18/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "ACTSModelViewController.h"
#import "ACTSAcronymViewcontroller.h"

#import "database.h"
@interface ACTSModelViewController ()

@end

@implementation ACTSModelViewController

- (void)viewDidLoad {
     self.title = @"My Daily Devotion";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //database *db = [[database alloc] init];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)nextBtn:(id)sender
{
    ACTSAcronymViewcontroller *objACTSAcronymViewcontroller = (ACTSAcronymViewcontroller *) [self.storyboard instantiateViewControllerWithIdentifier:@"ACTSAcronymViewcontroller"];
    [self.navigationController pushViewController:objACTSAcronymViewcontroller animated:YES];
}
@end
