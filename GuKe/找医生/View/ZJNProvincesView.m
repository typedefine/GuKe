//
//  ZJNProvincesView.m
//  MrBone_PatientProject
//
//  Created by 朱佳男 on 2018/1/22.
//  Copyright © 2018年 ShangYuKeJi. All rights reserved.
//

#import "ZJNProvincesView.h"
#import "ZJNSelectHospODeptTableViewCell.h"
@interface ZJNProvincesView()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *proviceStr;
    NSString *cityStr;
    NSString *areaStr;
}
@property (nonatomic ,strong)UITableView *provinceTableView;
@property (nonatomic ,strong)UITableView *cityTableView;
@property (nonatomic ,strong)UITableView *areaTableView;

@property (nonatomic ,strong)NSMutableArray *provinceArr;
@property (nonatomic ,strong)NSMutableArray *cityArr;
@property (nonatomic ,strong)NSMutableArray *areaArr;

@property (nonatomic ,strong)NSIndexPath *provinceIndexP;
@property (nonatomic ,strong)NSIndexPath *cityIndexP;
//@property (nonatomic ,strong)NSIndexPath *areaIndexP;
@end
@implementation ZJNProvincesView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
        
        _provinceArr = [NSMutableArray array];
        _cityArr     = [NSMutableArray array];
        _areaArr     = [NSMutableArray array];
        
        proviceStr   = @"";
        cityStr      = @"";
        areaStr      = @"";
        [self addSubview:self.provinceTableView];
        [self addSubview:self.cityTableView];
        [self addSubview:self.areaTableView];
        [self loadData];
    }
    return self;
}


- (void)loadData
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"Provinces.plist"];
    NSData *provincesData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *provincesDic = [NSKeyedUnarchiver unarchiveObjectWithData:provincesData];
    if (provincesDic) {
        NSArray *proviceArr = provincesDic[@"data"];
        [_provinceArr addObjectsFromArray:proviceArr];
        NSArray *cityArr = proviceArr[0][@"city"];
        [_cityArr addObjectsFromArray:cityArr];
        NSArray *areaArr = cityArr[0][@"county"];
        [_areaArr addObjectsFromArray:areaArr];
    }else{
        [self getDataFromService];
    }
}


-(void)getDataFromService{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",requestUrl,url_provice_city_county];//userpatienthuanxinlist
    NSDictionary *dic = @{@"sessionId":sessionIding};
    [ZJNRequestManager postWithUrlString:urlStr parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            NSData *provincesData = [NSKeyedArchiver archivedDataWithRootObject:data];
            [self localProvincesInfoWithData:provincesData];
            [_provinceArr removeAllObjects];
            [_cityArr removeAllObjects];
            [_areaArr removeAllObjects];
            NSArray *proviceArr = data[@"data"];
            [_provinceArr addObjectsFromArray:proviceArr];
            
            NSArray *cityArr;
            if (_provinceIndexP) {
                cityArr = proviceArr[_provinceIndexP.row][@"city"];
            }else{
                cityArr = proviceArr[0][@"city"];
            }
            [_cityArr addObjectsFromArray:cityArr];
            
            NSArray *areaArr;
            if (_cityIndexP) {
                areaArr = cityArr[_cityIndexP.row][@"county"];
            }else{
                areaArr = cityArr[0][@"county"];
            }
            
            [_areaArr addObjectsFromArray:areaArr];
            [_provinceTableView reloadData];
            [_cityTableView reloadData];
            [_areaTableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


-(void)localProvincesInfoWithData:(NSData *)data{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"Provinces.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        [fileManager removeItemAtPath:filePath error:&error];
        if (!error) {
            [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        }else{
            NSLog(@"更新省市区信息失败");
        }
    }else{
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    BOOL isSuccess = [data writeToFile:filePath atomically:YES];
    if (isSuccess) {
        NSLog(@"存储省市区信息成功");
    }else{
        NSLog(@"存储省市区信息失败");
    }

}
-(UITableView *)provinceTableView{
    if (!_provinceTableView) {
        _provinceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/3.0, 360) style:UITableViewStylePlain];
        _provinceTableView.delegate = self;
        _provinceTableView.dataSource = self;
        _provinceTableView.showsVerticalScrollIndicator = NO;
        if ([_provinceTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_provinceTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_provinceTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_provinceTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _provinceTableView;
}
-(UITableView *)cityTableView{
    if (!_cityTableView) {
        _cityTableView = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth/3.0, 0, ScreenWidth/3.0, 360) style:UITableViewStylePlain];
        _cityTableView.delegate = self;
        _cityTableView.dataSource = self;
        _cityTableView.showsVerticalScrollIndicator = NO;
        if ([_cityTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_cityTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_cityTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_cityTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _cityTableView;
}
-(UITableView *)areaTableView{
    if (!_areaTableView) {
        _areaTableView = [[UITableView alloc]initWithFrame:CGRectMake(2*(ScreenWidth/3.0), 0, ScreenWidth/3.0, 360) style:UITableViewStylePlain];
        _areaTableView.delegate = self;
        _areaTableView.dataSource = self;
        _areaTableView.showsVerticalScrollIndicator = NO;
        if ([_areaTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_areaTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_areaTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_areaTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _areaTableView;
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
    if (tableView == _provinceTableView) {
        return _provinceArr.count;
    }else if (tableView == _cityTableView){
        return _cityArr.count;
    }else{
        return _areaArr.count;
    }
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
    if (tableView == _provinceTableView) {
        NSDictionary *dic = _provinceArr[indexPath.row];
        cell.contentLabel.text = dic[@"provinceName"];
        if ([proviceStr isEqualToString:dic[@"provinceName"]]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        
    }else if (tableView == _cityTableView){
        NSDictionary *dic = _cityArr[indexPath.row];
        cell.contentLabel.text = dic[@"cityName"];
        if ([cityStr isEqualToString:dic[@"cityName"]]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }else{
        NSDictionary *dic = _areaArr[indexPath.row];
        cell.contentLabel.text = dic[@"countyName"];
        if ([areaStr isEqualToString:dic[@"countyName"]]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _provinceTableView) {
        _provinceIndexP = indexPath;
        NSDictionary *dic = _provinceArr[indexPath.row];
        proviceStr = dic[@"provinceName"];
        cityStr = @"";
        areaStr = @"";
        [_cityArr removeAllObjects];
        [_areaArr removeAllObjects];
        NSArray *cityArr = dic[@"city"];
        [_cityArr addObjectsFromArray:cityArr];
        
        NSArray *areaArr = cityArr[0][@"county"];
        [_areaArr addObjectsFromArray:areaArr];
        
        [_cityTableView reloadData];
        [_areaTableView reloadData];
        
    }else if (tableView == _cityTableView){
        _cityIndexP = indexPath;
        NSDictionary *dic = _cityArr[indexPath.row];
        cityStr = dic[@"cityName"];
        areaStr = @"";
        [_areaArr removeAllObjects];
        
        NSArray *areaArr = dic[@"county"];
        [_areaArr addObjectsFromArray:areaArr];
        [_areaTableView reloadData];
    }else{
        NSDictionary *dic = _areaArr[indexPath.row];
        areaStr = dic[@"countyName"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(provincesViewSearchDoctorWithArea:code:)]) {
            [self.delegate provincesViewSearchDoctorWithArea:areaStr code:dic[@"countyId"]];
        }
    }
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (point.y > _provinceTableView.frame.size.height) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(provincesViewCanceled)]) {
            [self.delegate provincesViewCanceled];
        }
//        if (self.hidden) {
//            return [super hitTest:point withEvent:event];
//        }else{
            self.hidden = YES;
            return _provinceTableView;
//        }
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
