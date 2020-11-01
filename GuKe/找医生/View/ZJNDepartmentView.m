//
//  ZJNDepartmentView.m
//  MrBone_PatientProject
//
//  Created by 朱佳男 on 2018/1/22.
//  Copyright © 2018年 ShangYuKeJi. All rights reserved.
//

#import "ZJNDepartmentView.h"
#import "ZJNSelectHospODeptTableViewCell.h"

@interface ZJNDepartmentView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) NSString *hospitalId;
@property (nonatomic ,strong)NSMutableArray *deptArr;
@property (nonatomic ,strong)UITableView *tableView;

@end
@implementation ZJNDepartmentView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
        [self addSubview:self.tableView];
    }
    return self;
}
-(void)loadDataWithHospitalId:(NSNumber *)hospitalId completion:(void (^)())completion
{
    if (!hospitalId.isValidObjectValue || (self.hospitalId.isValidObjectValue && [self.hospitalId intValue] == [hospitalId intValue])) {
        completion();
        return;
    }
    self.hospitalId = hospitalId.stringValue;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",requestUrl,url_hospital_department];
    NSDictionary *dic = @{@"sessionId":sessionIding, @"hospitalId":self.hospitalId};
   
    [ZJNRequestManager postWithUrlString:urlStr parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        completion();
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"] || [retcode isEqualToString:@"0"]) {
            self.deptArr = [NSMutableArray arrayWithArray:data[@"data"]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        completion();
    }];
    
    [self.tableView reloadData];
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 360) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}
#pragma mark--UITableViewDelegate,UITableViewDataSource
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _deptArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    ZJNSelectHospODeptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZJNSelectHospODeptTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = _deptArr[indexPath.row];
    cell.contentLabel.text = dic[@"deptName"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _deptArr[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(zjnDeptViewSelectedDepartmentWithID:)]) {
        [self.delegate zjnDeptViewSelectedDepartmentWithID:dic[@"deptId"]];
    }
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (point.y > _tableView.frame.size.height) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(zjnDeptViewCanceled)]) {
            [self.delegate zjnDeptViewCanceled];
        }
        if (self.hidden) {
            return [super hitTest:point withEvent:event];
        }else{
            self.hidden = YES;
            return _tableView;
        }
    }
    return [super hitTest:point withEvent:event];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
