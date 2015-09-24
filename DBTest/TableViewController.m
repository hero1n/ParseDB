//
//  ViewController.m
//  DBTest
//
//  Created by Jaewon on 2015. 8. 25..
//  Copyright (c) 2015년 App:ple Pi. All rights reserved.
//

#import "TableViewController.h"
#import <Parse/Parse.h>

@interface TableViewController (){
    PFObject *data;
    PFQuery *query;
    NSMutableArray *allDatas;
}

@end

@implementation TableViewController

- (void)viewDidLoad {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"추가" style:UIBarButtonItemStylePlain target:self action:@selector(addRow)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
//    데이터 저장
    data = [PFObject objectWithClassName:@"data"];
//    data[@"testCol"] = @"testRow";
//    [data saveInBackground];
    
    allDatas = [NSMutableArray array];
    query = [PFQuery queryWithClassName:@"data"];
    // 모든 오브젝트 가져오기 ( limit : 100개 ) setLimit: 으로 설정가능
    // setSkip: 으로 몇번째까지 스킵하고 가져올지 설정가능
    // setSkip:100 -> 100 ~ 199
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects,NSError *error){
        if (!error) {
            [allDatas addObjectsFromArray:objects];
            NSLog(@"%@",objects);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)addRow{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    data[@"testCol"] = @"testRowWithButton";
    [data saveInBackground];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allDatas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier];
    }
    PFObject *myObject = [allDatas objectAtIndex:indexPath.row];
    NSLog(@"%@",myObject);
    NSString *objectId = [myObject objectId];
    NSLog(@"%@ %d",objectId,__LINE__);
//    cell.detailTextLabel.text = myObject.createdAt;
    NSString *string = [[allDatas objectAtIndex:indexPath.row] objectForKey:@"testCol"];

    NSLog(@"%@",string);
    cell.textLabel.text = [string stringByAppendingFormat:@" %d",indexPath.row + 1];
//    NSLog(@"%@",[[allDatas objectAtIndex:indexPath.row]objectForKey:@"createdAt"]);
//    cell.detailTextLabel.text = [[allDatas objectAtIndex:indexPath.row] objectForKey:@"createdAt"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    return cell;
}
@end
