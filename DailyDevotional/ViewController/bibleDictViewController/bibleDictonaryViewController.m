//
//  bibleDictonaryViewController.m
//  DailyDevotional
//
//  Created by ketaki on 6/18/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "bibleDictonaryViewController.h"
#import "bibleDictonaryTableviewCell.h"
#import "constants.h"
#import "AppDelegate.h"
@interface bibleDictonaryViewController ()

@end

@implementation bibleDictonaryViewController
#pragma mark-view
- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"My Daily Devotion";
    self.tblView.backgroundColor=[UIColor clearColor];
    self.tblView.backgroundView=nil;

//    self.tblView.backgroundColor=[UIColor colorWithRed:55/255.0 green:70/255.0 blue:114/255.0 alpha:1.0f];
    [self setNavigationBar];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //self.activityIndicator.hidden=true;
    self.searchResult = [NSMutableArray arrayWithCapacity:[self.arrValue count]];
    [APP_Delegate showLoadingView:self.tblView];
}

-(void)viewDidAppear:(BOOL)animated
{

    dispatch_queue_t tableReload = dispatch_queue_create("tableReload", NULL);
    dispatch_async(tableReload, ^{
        self.tblView.dataSource=self;
        self.tblView.delegate=self;
          dispatch_async(dispatch_get_main_queue(), ^{
             [self.tblView reloadData];
              [APP_Delegate hideLoadingView:self.tblView];
              //disable
          });
    });
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.arrValue count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"cell";
    bibleDictonaryTableviewCell *cell = (bibleDictonaryTableviewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary  *dict=[self.arrValue objectAtIndex:indexPath.section];
    cell.lblValue.text=[dict objectForKey:@"desc"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"cell";
    bibleDictonaryTableviewCell *cell = (bibleDictonaryTableviewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary  *dict=[self.arrValue objectAtIndex:indexPath.section];
    cell.lblValue.text=[dict objectForKey:@"desc"];
    cell.lblValue.numberOfLines = 0;
    cell.lblValue.lineBreakMode = NSLineBreakByWordWrapping;
  if (IS_IOS7)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = cell.lblValue.lineBreakMode;
        
        CGRect rect = [cell.lblValue.text boundingRectWithSize:CGSizeMake(280,3500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : cell.lblValue.font, NSParagraphStyleAttributeName : paragraphStyle} context:nil];
        if (rect.size.height<50)
        {
            
            return 60;
        }
        else
        {
            return rect.size.height+50;
            
        }
    }
    CGSize maximumLabelSize = CGSizeMake(280, 3500);
    CGSize expectedLabelSize = [ cell.lblValue.text sizeWithFont:cell.lblValue.font constrainedToSize:maximumLabelSize lineBreakMode: cell.lblValue.lineBreakMode];
    if (expectedLabelSize.height<50) {
        return 60;
    }
    else
        
    {
        return expectedLabelSize.height+50;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // calculate height of UILabel
    UILabel *lblSectionName = [[UILabel alloc] init];
    lblSectionName.text = [[self.arrValue objectAtIndex:section] objectForKey:@"title"];
    lblSectionName.textColor = [UIColor lightGrayColor];
    lblSectionName.numberOfLines = 0;
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    
    lblSectionName.attributedText = [[NSAttributedString alloc] initWithString:[[self.arrValue objectAtIndex:section] objectForKey:@"title"]
                                                                    attributes:underlineAttribute];
    
    lblSectionName.font=[UIFont fontWithName:@"SegoeUISymbol" size:20.0f];
    lblSectionName.lineBreakMode = NSLineBreakByWordWrapping;
   // lblSectionName.backgroundColor = [UIColor grayColor];
    [lblSectionName sizeToFit];
    
    if (IS_IOS7)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lblSectionName.lineBreakMode;
        
        CGRect rect = [lblSectionName.text boundingRectWithSize:CGSizeMake(280, 2500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : lblSectionName.font, NSParagraphStyleAttributeName : paragraphStyle} context:nil];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.tblView.layer.frame.size.width, (rect.size.height+10))];
        [headerView addSubview:lblSectionName];
        
        return  headerView.frame.size.height;
    }
    CGSize maximumLabelSize = CGSizeMake(280, 2500);
    CGSize expectedLabelSize = [lblSectionName.text sizeWithFont:lblSectionName.font constrainedToSize:maximumLabelSize lineBreakMode:lblSectionName.lineBreakMode];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.tblView.layer.frame.size.width, (expectedLabelSize.height+10))];
    [headerView addSubview:lblSectionName];
    return headerView.frame.size.height;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // calculate height of UILabel
    UILabel *lblSectionName = [[UILabel alloc] init];
    lblSectionName.frame=CGRectMake(10, 5, self.view.frame.size.width-20, 20);
    lblSectionName.text =[[self.arrValue objectAtIndex:section] objectForKey:@"title"];
    lblSectionName.textColor = [UIColor blueColor];
    lblSectionName.numberOfLines = 0;
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    
    lblSectionName.attributedText = [[NSAttributedString alloc] initWithString:[[self.arrValue objectAtIndex:section] objectForKey:@"title"]
                                                                    attributes:underlineAttribute];
    
    lblSectionName.font=[UIFont fontWithName:@"SegoeUISymbol" size:20.0f];
    lblSectionName.lineBreakMode = NSLineBreakByWordWrapping;
    [lblSectionName sizeToFit];
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:lblSectionName];
    return headerView;
}
#pragma mark-Search bar delegate
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    NSLog(@"Searching");
}
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
//    [self.searchResult removeAllObjects];
//    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
//    
//    self.searchResult = [NSMutableArray arrayWithArray: [self.arrValue  filteredArrayUsingPredicate:resultPredicate]];
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}
@end
