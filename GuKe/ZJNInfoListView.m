//
//  ZJNInfoListView.m
//  GuKe
//
//  Created by 朱佳男 on 2018/1/3.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "ZJNInfoListView.h"
#import "ZiXunlistModel.h"
#import "ZiXunDetailViewController.h"
#import "ZiXunTableViewCell.h"
#define KHeaderHeight lunboImgHeight+50+40
@interface ZJNInfoListView()<UITableViewDelegate,UITableViewDataSource>
{
//    NSString *searchText;//搜索关键词
    NSMutableArray *listArr;
    NSInteger page;
}

@end
@implementation ZJNInfoListView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _searchText = @"";
        page = 0;
        listArr = [NSMutableArray array];
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavBarHeight-TabbarHeight) style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;

        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        UIView *headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, KHeaderHeight)];
        headerV.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = headerV;
        __weak typeof(self) weakSelf = self;
        _tableView.mj_footer = [MJRefreshBackFooter
                                  footerWithRefreshingBlock:^{
            [weakSelf getDataFromServiceWithKeyStr:_searchText];
        }];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _searchText = @"";
            page = 0;
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(updateListWithState:)]) {
                [weakSelf.delegate updateListWithState:@"1"];
            }
            [weakSelf getDataFromServiceWithKeyStr:_searchText];
        }];
        [self addSubview:_tableView];
    }
    return self;
}
-(void)setModel:(ZiXunModel *)model{
    _model = model;
    [self getDataFromServiceWithKeyStr:_searchText];
}
-(void)setSearchText:(NSString *)searchText{
    _searchText = searchText;
    page = 0;
    [self getDataFromServiceWithKeyStr:_searchText];
}
-(void)getDataFromServiceWithKeyStr:(NSString *)keyStr{
    page ++;
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,informationlist];
    NSArray *keysArray = @[@"sessionid",@"page",@"typeId",@"title"];
    NSArray *valueArray = @[sessionIding,pageStr,_model.typeId,_searchText];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"%@ %@",_model.typeName,data);
        if (page == 1) {
            [listArr removeAllObjects];
        }
        NSString *retcode = data[@"retcode"];
        if ([retcode isEqualToString:@"0"] ) {
            NSArray *dicArr = data[@"data"];
            if (dicArr.count>0) {
                for ( NSDictionary * dic in data[@"data"] ) {
                    ZiXunlistModel * model = [ZiXunlistModel yy_modelWithDictionary:dic];
                    [listArr addObject:model];
                }
            }else{
                page>1?(page-=1):(page=1);
            }
        }else{
            page>1?(page-=1):(page=1);
        }
        [self.tableView reloadData];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateListWithState:)]) {
            [self.delegate updateListWithState:@"2"];
        }
    } failure:^(NSError *error) {
        page>1?(page-=1):(page=1);
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateListWithState:)]) {
            [self.delegate updateListWithState:@"2"];
        }
        NSLog(@"%@",error);
    }];
}
#pragma mark--UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  0.1 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellid = @"cellid1";
    ZiXunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ZiXunTableViewCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ZiXunlistModel *models  = listArr[indexPath.row];
    cell.model = models;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZiXunlistModel *models  = listArr[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToDetailInfoWithModel:)]) {
        [self.delegate pushToDetailInfoWithModel:models];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
