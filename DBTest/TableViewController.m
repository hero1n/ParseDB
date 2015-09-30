//
//  ViewController.m
//  DBTest
//
//  Created by Jaewon on 2015. 8. 25..
//  Copyright (c) 2015년 App:ple Pi. All rights reserved.
//

#import "TableViewController.h"
#import "DetailViewController.h"
#import <Parse/Parse.h>

@interface TableViewController (){
    PFObject *data;
    PFQuery *query;
    NSMutableArray *allDatas;
}

@end

@implementation TableViewController

- (void)viewDidLoad {
    [self performSelector:@selector(getObjects)];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(getObjects)
                  forControlEvents:UIControlEventValueChanged];
}

-(void)getObjects{
    //    데이터 저장
    data = [PFObject objectWithClassName:@"data"];
    //    data[@"testCol"] = @"testRow";
    //    [data saveInBackground];
    
    query = [PFQuery queryWithClassName:@"data"];
    // 모든 오브젝트 가져오기 ( limit : 100개 ) setLimit: 으로 설정가능
    // setSkip: 으로 몇번째까지 스킵하고 가져올지 설정가능
    // setSkip:100 -> 100 ~ 199
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects,NSError *error){
        if (!error) {
            allDatas = [[NSMutableArray alloc] initWithArray:objects];
            NSLog(@"%@",objects);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
     [self.refreshControl endRefreshing];
}

-(void)addRow{
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    data[@"testCol"] = @"testRowWithButton";
    [data saveInBackground];
    [self getObjects];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allDatas.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *detailViewController = [storyBoard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier];
    }
    
    PFObject *myObject = [allDatas objectAtIndex:indexPath.row];
//    NSLog(@"%@",myObject);
    NSString *objectId = [myObject objectId];
    NSLog(@"%@ %d",objectId,__LINE__);
    cell.detailTextLabel.text = [[NSString alloc]initWithFormat:@"ObjectID : %@",objectId];
    NSString *string = [[allDatas objectAtIndex:indexPath.row] objectForKey:@"testCol"];

    NSLog(@"%@",string);
    cell.textLabel.text = [string stringByAppendingFormat:@" %d",indexPath.row + 1];
//    NSLog(@"%@",[[allDatas objectAtIndex:indexPath.row]objectForKey:@"createdAt"]);
//    cell.detailTextLabel.text = [[allDatas objectAtIndex:indexPath.row] objectForKey:@"createdAt"];
    return cell;
}
@end
