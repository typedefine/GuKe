//
//  orderViewController.m
//  singdemo
//
//  Created by MYMAc on 2018/8/6.
//  Copyright © 2018年 ShangYu. All rights reserved.
//

#import "orderViewController.h"
#import "QJCOrderModel.h"
#import "QJCOrdercell.h"
#import "OrderDetailViewController.h"
@interface orderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong ,nonatomic) NSMutableArray  * dataArray;
@property (strong ,nonatomic) UITableView * tableView;
@end

@implementation orderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self addtableview];
    // Do any additional setup after loading the view.
}
-(void)addtableview{
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight -40 )];
    self.tableView.clipsToBounds = YES;
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0,  ScreenWidth, 0, 0);
    self.tableView.tableFooterView = [UIView new];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [self.view addSubview:self.tableView];
    
}
-(void)loadData{
    self.dataArray = [[NSMutableArray alloc]init];

    NSString *urlString = [NSString stringWithFormat:@"%@/app/order/list.json",requestUrl];
    NSArray *keysArray = @[@"sessionId",@"state"];
 
    NSArray *valueArray = @[sessionIding,self.statc];
 NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@" dic = %@ \ndata = %@",dic,data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            for (NSDictionary * datadic  in data[@"data"]) {
                QJCOrderListmodel * model =[QJCOrderListmodel yy_modelWithJSON:datadic];
//                model.list = [datadic objectForKey:data[@"data"][@"userList"]];
                [self.dataArray addObject:model ];
            }
          }
        [self.tableView reloadData];

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }  failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];

}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QJCOrderListmodel  *modle = self.dataArray[indexPath.row];

    QJCOrdercell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"QJCOrdercell" owner:self options:nil]lastObject];
    }
    cell.modle= modle;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.jumpAction = ^(NSString *orderId, BOOL pay) {
        
      MJWeakSelf
        OrderDetailViewController * detail =[[OrderDetailViewController alloc]init];
        detail.title = @"详情";

        detail.reloadBlock = ^{
            [weakSelf loadData];
        };
        NSString * urlStr ;
//       去支付
        if( [modle.state isEqualToString:@"1"]){
            if (pay) {
                urlStr =  [NSString stringWithFormat:@"%@/app/order/pay.json?orderNumber=%@&sessionId=%@",requestUrl,modle.orderNumber,sessionIding];

            }else{
                [self deleteOrderWithid:modle.orderNumber];
                
                return  ;
            }
            
            
        }else{
            //       赠送
            urlStr =  [NSString stringWithFormat:@"%@/app/order/give.json?orderNumber=%@&sessionId=%@",requestUrl,modle.orderNumber,sessionIding];
            
        }
        detail.urlStr = urlStr;
        
        [self.navigationController pushViewController:detail animated:YES];
        
    };
    return cell;
}
#pragma mark 删除订单
-(void)deleteOrderWithid:(NSString *)orderid{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/app/order/delOrderNumber.json",requestUrl];
    NSArray *keysArray = @[@"sessionId",@"orderNumber"];
    
    NSArray *valueArray = @[sessionIding,orderid];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@" dic = %@ \ndata = %@",dic,data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            [self showHint:@"删除成功！"];
            [self  loadData];
        }
        
    }  failure:^(NSError *error) {
        
    }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QJCOrderListmodel  *modle = self.dataArray[indexPath.row];
    if (modle.userList.count > 0){
        return 115 + modle.userList.count * 25;
    }
    else{
        return 115  ;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
     NSString * StrType =  _dataArray[indexPath.row];
  
    
    
    
}

#pragma mark - TableView 占位图

//- (UIImage *)xy_noDataViewImage {
//    return [UIImage imageNamed:@"note_list_no_data"];
//}

- (NSString *)xy_noDataViewMessage {
    return @"都用起来吧, 起飞~";
}

- (UIColor *)xy_noDataViewMessageColor {
    return [UIColor blackColor];
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

@end
