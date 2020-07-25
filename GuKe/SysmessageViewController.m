//
//  SysmessageViewController.m
//  GuKe
//
//  Created by MYMAc on 2019/3/19.
//  Copyright © 2019年 shangyukeji. All rights reserved.
//

#import "SysmessageViewController.h"
#import "SysMessageTewCell.h"
#import "MessageModels.h"
@interface SysmessageViewController (){
    NSInteger  page ;
 
    
}

@end

@implementation SysmessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1 ;
    dataArray =[[NSMutableArray alloc]init];

    [self makeUI];
    [self getDataFromService];
    // Do any additional setup after loading the view.
}
- (void)getDataFromService{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,messageList];
    NSArray *keysArray = @[@"sessionId",@"page"];
    NSArray *valueArray = @[sessionIding,[NSString stringWithFormat:@"%ld",(long)page]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
         NSLog(@"%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            if (page ==1) {
                [dataArray removeAllObjects];
             }
            for(NSDictionary * dic in data[@"data"]){
                MessageModels *model =[MessageModels yy_modelWithJSON:dic];
                [dataArray addObject:model];
            }
          
        }
     
        [_TV reloadData];
        [_TV.mj_footer endRefreshing];
        [_TV.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [_TV.mj_footer endRefreshing];
        [_TV.mj_header endRefreshing];
        [self hideHud];
        NSLog(@"%@",error);
    }];
}

-(void)makeUI{
    self.title =@"系统消息";
    _TV =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -NavBarHeight) style:UITableViewStylePlain];
    _TV.estimatedRowHeight = 88;
    _TV.rowHeight =  UITableViewAutomaticDimension;
    _TV.delegate = self ;
    _TV.dataSource = self;
    [self.view addSubview:_TV];
    _TV.tableFooterView =[UIView alloc];
    _TV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page =1;
        [self getDataFromService];
    }];
    _TV.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        page++;
        [self getDataFromService];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SysMessageTewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SysMessageTewCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = dataArray[indexPath.row];
    return cell;
}
 /*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
