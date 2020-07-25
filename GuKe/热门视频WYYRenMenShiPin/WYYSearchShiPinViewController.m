//
//  WYYSearchShiPinViewController.m
//  GuKe
//
//  Created by MYMAc on 2019/2/15.
//  Copyright © 2019年 shangyukeji. All rights reserved.
//

#import "WYYSearchShiPinViewController.h"
#import "WYYShiPinModel.h"
#import "WYYShiPinTableViewCell.h"
#import "WYYShiPinDetailViewController.h"//视频详情

@interface WYYSearchShiPinViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    NSMutableArray *orderArr;
     NSMutableArray * moreArray; // 头部右侧显示或隐藏
    UIView * search ;// 搜索框view;
    UITextField * searchField ; // 搜索内容
    NSInteger page ;
    NSDate * comeDate;//进入模块的时间

}


@end

@implementation WYYSearchShiPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title  = @"搜索";
     page = 1;
    comeDate =[NSDate date];

    orderArr = [NSMutableArray array];
    [self makeSearchView];
    
    [self makeAddTableview];
    [self getDataFromService];
//    [searchField becomeFirstResponder];
    // Do any additional setup after loading the view.
}
- (void)makeAddTableview{
    if (IS_IPGONE_X) {
        self.orderTable = [[UITableView alloc]initWithFrame:CGRectMake(0, search.bottom, ScreenWidth, ScreenHeight - 88 - search.height) style:UITableViewStylePlain];
    }else{
        self.orderTable = [[UITableView alloc]initWithFrame:CGRectMake(0, search.bottom, ScreenWidth, ScreenHeight - NavBarHeight- search.height) style:UITableViewStylePlain];
    }
    
    
    //    _tableView.showsVerticalScrollIndicator = NO;
    self.orderTable.showsHorizontalScrollIndicator = NO;
    self.orderTable.delegate = self;
    self.orderTable.dataSource = self;
    self.orderTable.mj_footer  =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page ++;

        [self getDataFromService];
    }];
    self.orderTable.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self getDataFromService];
    }];
    self.orderTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.orderTable];
    
}
- (void)getDataFromService{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,pubvideoSearchlist];
    NSArray *keysArray = @[@"sessionId",@"videoName",@"page"];
    NSArray *valueArray = @[sessionIding ,searchField.text,[NSString stringWithFormat:@"%ld",(long)page]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];

        if (page ==1) {
            [orderArr removeAllObjects];
         }
      
         NSLog(@"%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            [orderArr addObjectsFromArray:data[@"data"]];
            
            [self.orderTable reloadData];
        }
        [self.orderTable.mj_header endRefreshing];
        [self.orderTable.mj_footer  endRefreshing];
    } failure:^(NSError *error) {
        [self.orderTable.mj_header endRefreshing];
        [self.orderTable.mj_footer  endRefreshing];
        [self hideHud];
        NSLog(@"%@",error);
    }];
}
#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  orderArr.count;
//    return  1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arrays = [NSArray arrayWithArray:orderArr[section][@"list"]];
    return arrays.count;

//    if ([moreArray[section] isEqualToString:@"更多" ] && arrays.count >2) {
//        return 2;
//    }else{
//        return arrays.count;
//
//    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return  43;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if ([moreArray[section] isEqualToString:@"更多"] && [[NSArray arrayWithArray:orderArr[section][@"list"]] count] > 2) {
//        return 43;
//
//    }else{
//        return 0.01;
//    }
//}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 43)];
//
//
//
//    if ([moreArray[section] isEqualToString:@"更多"] && [[NSArray arrayWithArray:orderArr[section][@"list"]] count] > 2) {
//
//        UILabel * numbreLB=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 43)];
//        numbreLB.textColor = titColor;
//        numbreLB.font =[UIFont systemFontOfSize:14];
//        numbreLB.text =[NSString stringWithFormat:@"余下%ld篇",[[NSArray arrayWithArray:orderArr[section][@"list"]] count] -2];
//        [headView addSubview:numbreLB];
//
//        UIView *linview =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
//        linview.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
//        [headView  addSubview:linview];
//
//        UIImageView * image =[[UIImageView alloc]init];
//        image.frame = CGRectMake(ScreenWidth - 60, 14, 15, 15);
//        image.image =[UIImage imageNamed:@"下拉"];
//        [headView addSubview:image];
//        UIButton * morebtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        morebtn.frame = CGRectMake(0, 0, ScreenWidth, 43);
//        [morebtn setTitle:@"" forState:UIControlStateNormal];
//        [morebtn setTitleColor:detailTextColor forState:UIControlStateNormal];
//        [morebtn addTarget:self action:@selector(moreBtnACtion:) forControlEvents:UIControlEventTouchUpInside];
//        morebtn.tag = section +30;
//        morebtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [headView addSubview:morebtn];
//
//    }else{
//        headView.frame = CGRectMake(0, 0, 1, 1);
//    }
//    headView.backgroundColor =  [UIColor whiteColor];
//    return  headView;
//
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 43)];
    headView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 2, 20)];
    lineView.backgroundColor = greenC;
    [headView addSubview:lineView];
    NSDictionary *orderDic = [NSDictionary dictionaryWithDictionary:orderArr[section]];
    UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+ 10, 10, 200, 20)];
    [headView addSubview:labels];
    labels.text = [NSString stringWithFormat:@"%@",[orderDic objectForKey:@"videoTypeName"]];
    labels.font = [UIFont systemFontOfSize:14];
    labels.textColor = SetColor(0x1A1A1A);
    
    
    
    return headView;
}
//-(void)moreBtnACtion:(UIButton *)sender{
//
//    [moreArray replaceObjectAtIndex:sender.tag - 30 withObject:@""];
//
//    [_orderTable reloadData];
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 143;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellid = @"cellid1";
    WYYShiPinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"WYYShiPinTableViewCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arrays = [NSArray arrayWithArray:orderArr[indexPath.section][@"list"]];
    NSDictionary *orderDic = [NSDictionary dictionaryWithDictionary:arrays[indexPath.row]];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,[orderDic objectForKey:@"videoImages"]]] placeholderImage:[UIImage imageNamed:@"default_img"]];
    cell.doctorName.text = [NSString stringWithFormat:@"%@",[orderDic objectForKey:@"videoName"]];
    [Utile setUILabel:cell.doctorName data:nil setData:[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"videoName"]] color:SetColor(0x1A1A1A) font:14 underLine:NO];
    
    //    cell.detailLab.text = [NSString stringWithFormat:@"%@",[orderDic objectForKey:@"videoContent"]];
    cell.detailLab.text = [NSString stringWithFormat:@"%@\n%@",[orderDic objectForKey:@"videoSpeaker"], [NSString changeNullString:[orderDic objectForKey:@"videoUnit"]]];
    
    cell.timeLab.text = [NSString stringWithFormat:@"%@",[orderDic objectForKey:@"createTime"]];
    
    cell.numLab.text = [NSString stringWithFormat:@"%@",[orderDic objectForKey:@"videoCount"]];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arrays = [NSArray arrayWithArray:orderArr[indexPath.section][@"list"]];
    NSDictionary *orderDic = [NSDictionary dictionaryWithDictionary:arrays[indexPath.row]];
    WYYShiPinDetailViewController *detail = [[WYYShiPinDetailViewController alloc]init];
    detail.videoId = [NSString stringWithFormat:@"%@",[orderDic objectForKey:@"videoId"]];
    detail.CanSaveDate = NO ;
    detail.titleStr = [NSString stringWithFormat:@"%@",[orderDic objectForKey:@"videoName"]];
    detail.contentStr = [NSString stringWithFormat:@"%@",[orderDic objectForKey:@"videoContent"]];
    detail.iconImagePath = [NSString stringWithFormat:@"%@",[orderDic objectForKey:@"videoImages"]];
    detail.videoShou = [NSString stringWithFormat:@"%@",[orderDic objectForKey:@"videoShou"]];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)makeSearchView{
    search =[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    UIView  * searchbacnview =[[UIView alloc]initWithFrame:CGRectMake(10, 5, ScreenWidth-60, 30)];
    searchbacnview.backgroundColor =[UIColor colorWithHex:0xf5f5f5];
    searchbacnview.layer.masksToBounds = YES;
    searchbacnview.layer.cornerRadius = 10;
    
    UIImageView *searchImage =[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 16, 16)];
    searchImage.image =[UIImage imageNamed:@"搜索-搜索"];
    [searchbacnview addSubview:searchImage];
    
    searchField =[[UITextField alloc]initWithFrame:CGRectMake(30, 0, searchbacnview.width - 30, 30)];
    searchField.font =[UIFont systemFontOfSize:15];
    searchField.textColor= titColor;
    searchField.delegate= self;
    [searchbacnview addSubview:searchField];
    
    UIButton * searchbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchbtn.frame = CGRectMake(ScreenWidth - 50, 0, 50, 43);
    [searchbtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchbtn setTitleColor:detailTextColor forState:UIControlStateNormal];
    [searchbtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    searchbtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [search addSubview:searchbtn];
  
    [search addSubview:searchbacnview];
    [self.view addSubview:search];
    
}
-(void)searchAction{
    [searchField endEditing:YES];
    [self getDataFromService];

}
-(void)textFieldDidEndEditing:(UITextField *)textField{
}

-(BOOL)navigationShouldPopOnBackButton{
    
    [moduleDate ShareModuleDate].MeetingLength =[[NSDate date]timeIntervalSinceDate:comeDate];
    return  YES ;
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
