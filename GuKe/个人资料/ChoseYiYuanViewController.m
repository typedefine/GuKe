//
//  ChoseYiYuanViewController.m
//  GuKe
//
//  Created by yu on 2017/8/3.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ChoseYiYuanViewController.h"
#import "QJCEdithospitalViewController.h"
@interface ChoseYiYuanViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UITableView *yishengTable;
    UITableView *tableviewOne;
    UITableView *tableviewTwo;
    UITableView *tableviewThree;
    UIView *heiseView;//黑色遮罩层
    UITextField *searchText;
    
    NSArray *arrayone;//类别
    NSArray *arrayTwo;//类型
    NSArray *arrayThree;//智能排序
    NSInteger number;//分页参数
    NSMutableArray *resourceArr;
    
    NSString *stringOne;//标注类别
    NSString *stringTwo;//标注类型
    NSString *stringThree;//标注只能排序
    
    NSString *provId;//省
    NSString *cityId;//市
    NSString *countyId;//县/区
    NSString *name;//名称
    NSString *YiYuanId;//医院id
    
    
    NSString *level;//省市区等级1省2市3区
    NSString *districtId;//省市区ID
    NSDictionary *yiyuanDic;
    
    
}
@property (nonatomic,strong)UIButton *selectedBtnOne;
@property (nonatomic,strong)UIButton *tableBtn;
@end

@implementation ChoseYiYuanViewController
- (instancetype)initWithStyle:(selectyiyuanStyle)style{
    self = [super init];
    if (self) {
        self.style = &(style);
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择医院";
    resourceArr = [NSMutableArray array];
    level = [NSString stringWithFormat:@"1"];
    districtId = [NSString stringWithFormat:@""];
    
    stringOne = [NSString stringWithFormat:@""];
    stringTwo = [NSString stringWithFormat:@""];
    stringThree = [NSString stringWithFormat:@""];
    
    provId = @"";
    cityId = @"";
    countyId = @"";
    name = @"";
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(onClickedOKNeedView)];
    rightBarItem.image =[UIImage imageNamed:@"就诊记录_添加"];
    
    
    
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self makeAddTopView];
    [self makeShengShiQU];
    [self makeChoseHospital];
    // Do any additional setup after loading the view from its nib.
}
- (void)onClickedOKNeedView{
//    if (yiyuanDic.count == 0) {
//        return;
//    }
//    self.returnYuan(yiyuanDic);
//    [self.navigationController popViewControllerAnimated:NO];
//
    QJCEdithospitalViewController * qjcVC  =[[QJCEdithospitalViewController alloc]init];
    qjcVC.MakeHospitalBlock = ^(NSString * _Nonnull hospital, NSString * _Nonnull department) {
        if (self.EditHospitalBlock) {
            self.EditHospitalBlock(hospital, department);

        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:NO];
        });

    };
    [self.navigationController pushViewController:qjcVC animated:YES];
    
    
}
#pragma mark 省市区
- (void)makeShengShiQU{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,districtlist];
    NSArray *keysArray = @[@"sessionid",@"level",@"districtId"];
    NSArray *valueArray = @[sessionIding,level,districtId];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"省市区%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            if ([level isEqualToString:@"1"]) {
                arrayone = [NSArray arrayWithArray:data[@"data"]];
            }else if ([level isEqualToString:@"2"]){
                arrayTwo = [NSArray arrayWithArray:data[@"data"]];
            }else if ([level isEqualToString:@"3"]){
                arrayThree = [NSArray arrayWithArray:data[@"data"]];
            }
        }else{
            
        }
            
        if ([level isEqualToString:@"1"]) {
            [tableviewOne reloadData];
        }else if ([level isEqualToString:@"2"]){
            [tableviewTwo reloadData];
        }else if ([level isEqualToString:@"3"]){
            [tableviewThree reloadData];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"省市区%@",error);
    }];
}
#pragma mark 医院信息
- (void)makeChoseHospital{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,hospitallist];
    NSArray *keysArray = @[@"provId",@"cityId",@"countyId",@"name"];
    NSArray *valueArray = @[provId,cityId,countyId,name];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];

    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"医院信息%@",data);
        [resourceArr removeAllObjects];
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            [resourceArr addObjectsFromArray:data[@"data"]];
        }else{
            
        }
        if(resourceArr.count == 0){
            UILabel *titleLabss = [[UILabel alloc]initWithFrame:CGRectMake(20, 11,ScreenWidth - 200, 100)];
            titleLabss.numberOfLines = 0 ;
            titleLabss.textAlignment = NSTextAlignmentCenter;
            titleLabss.centerY = self.view.centerY - 80;
            titleLabss.centerX = self.view.centerX;
            [titleLabss setValue:@(20) forKey:@"lineSpacing"];

            titleLabss.text = @"暂无满足条件医院信息，你可以在右上角进行添加医院和科室";
            titleLabss.tag =  509;
            titleLabss.font = [UIFont systemFontOfSize:16];
            titleLabss.textColor = detailTextColor;
            [self.view  addSubview:titleLabss];
        }else{
            UIView * titleLabss =[self.view viewWithTag:509];
            [titleLabss removeFromSuperview];
        }
        [yishengTable reloadData];
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"医院信息%@",error);
    }];
}
#pragma mark 添加顶部搜索框
- (void)makeAddTopView{
    //搜索框
    UIView *viewBack = [[UIView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 80, 30)];
    viewBack.backgroundColor = SetColor(0xeae9e9);
    viewBack.layer.masksToBounds = YES;
    viewBack.layer.cornerRadius = 15;
    [self.view addSubview:viewBack];
    
    UIImageView *images = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
    images.image = [UIImage imageNamed:@"搜索-搜索"];
    [viewBack addSubview:images];
    
    searchText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(images.frame) + 5, 0, 200, 30)];
    searchText.delegate = self;
    searchText.textColor = SetColor(0xb3b3b3);
    searchText.font = Font12;
    searchText.placeholder = @"搜医院信息";
    [viewBack addSubview:searchText];
    
    
    UIButton *labelsa = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 70,10 , 70, 30)];
    labelsa.titleLabel.font = Font12;
    [labelsa setTitle:@"搜索" forState:normal];
    [labelsa setTitleColor:titColor forState:normal];
    [labelsa addTarget:self action:@selector(didSouSuoButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:labelsa];
    
    //
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, 1)];
    lineView.backgroundColor = SetColor(0xf0f0f0);
    [self.view addSubview:lineView];
    
    //
    NSArray *titleaRR = [NSArray arrayWithObjects:@"省",@"市",@"区", nil];
    for (int a= 0; a < 3; a ++) {
        UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(0 + ScreenWidth/3* a, 51, ScreenWidth/3, 50)];
        btns.titleLabel.font = [UIFont systemFontOfSize:16];
        [btns setTitle:[NSString stringWithFormat:@"%@",titleaRR[a]] forState:normal];
        [btns setTitleColor:SetColor(0x1a1a1a) forState:normal];
        [btns setTitleColor:SetColor(0x06a27b) forState:UIControlStateSelected];
        [btns setImage:[UIImage imageNamed:@"三角-选择"] forState:normal];
        [btns setImage:[UIImage imageNamed:@"三角_当前"] forState:UIControlStateSelected];
        [btns addTarget:self action:@selector(didButton:) forControlEvents:UIControlEventTouchUpInside];
        btns.tag = a + 20;
        btns.titleLabel.font = Font14;
        btns.imageEdgeInsets = UIEdgeInsetsMake(0, 80, 0, 0);
        btns.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
        [self.view addSubview:btns];
    }
    
    UIView *views = [[UIView alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, 10)];
    views.backgroundColor = SetColor(0xf0f0f0);
    [self.view addSubview:views];
    
    yishengTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 110, ScreenWidth, ScreenHeight - 64 - 110)];
    yishengTable.delegate = self;
    yishengTable.dataSource = self;
    yishengTable.backgroundColor = SetColor(0xf0f0f0);
    yishengTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:yishengTable];
    
    //heiseView
    heiseView = [[UIView alloc]initWithFrame:CGRectMake(0,100, ScreenWidth, ScreenHeight)];
    heiseView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view  addSubview:heiseView];
    heiseView.hidden = YES;
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didViewBlockView)];
    [heiseView addGestureRecognizer:tapGesture];
    
    tableviewOne = [[UITableView alloc]initWithFrame:CGRectMake(0,100, ScreenWidth, 44* 4)];
    tableviewOne.delegate = self;
    tableviewOne.dataSource = self;
    
    tableviewOne.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tableviewOne];
    tableviewOne.hidden = YES;
    
    tableviewTwo = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, 44* 4)];
    tableviewTwo.delegate = self;
    tableviewTwo.dataSource = self;
    tableviewTwo.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tableviewTwo];
    tableviewTwo.hidden = YES;
    
    tableviewThree = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, 44 * 4)];
    tableviewThree.delegate = self;
    tableviewThree.dataSource = self;
    tableviewThree.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tableviewThree];
    tableviewThree.hidden = YES;
    
}
#pragma mark textfield delegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    heiseView.hidden = YES;
    tableviewOne.hidden = YES;
    tableviewTwo.hidden = YES;
    tableviewThree.hidden = YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    name = [NSString stringWithFormat:@"%@",textField.text];
}
#pragma mark 黑色遮罩层点击事件
- (void)didViewBlockView{
    heiseView.hidden =YES;
    tableviewOne.hidden = YES;
    tableviewTwo.hidden = YES;
    tableviewThree.hidden = YES;
    
}
#pragma mark 顶部三个按钮点击事件
- (void)didButton:(UIButton *)sender{
    sender.selected =! sender.selected;
    heiseView.hidden = NO;
    [searchText resignFirstResponder];
    
    //
    if (sender != _selectedBtnOne) {
        self.selectedBtnOne.selected = NO;
        sender.selected = YES;
        self.selectedBtnOne = sender;
    }else{
        self.selectedBtnOne.selected = YES;
    }
    
    if (sender.tag == 20) {
        tableviewOne.hidden = NO;
        tableviewTwo.hidden = YES;
        tableviewThree.hidden = YES;
    }else if (sender.tag == 21){
        tableviewOne.hidden = YES;
        tableviewTwo.hidden = NO;
        tableviewThree.hidden = YES;
    }else{
        tableviewOne.hidden = YES;
        tableviewTwo.hidden = YES;
        tableviewThree.hidden = NO;
    }
}
#pragma mark 搜索框按钮点击事件
- (void)didSouSuoButton{
    [searchText resignFirstResponder];
    [self makeChoseHospital];
    
}

#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView ==tableviewOne) {
        return arrayone.count;
    }else if (tableView == tableviewTwo){
        return arrayTwo.count;
    }else if (tableView == tableviewThree){
        return arrayThree.count;
    }else{
        return resourceArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == yishengTable) {
        return 44;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == yishengTable) {
        static NSString *cellOn= @"cellOne";
        UITableViewCell *cella = [tableView cellForRowAtIndexPath:indexPath];
        if (!cella) {
            cella = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellOn]
            ;
            cella.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UILabel *titleLabss = [[UILabel alloc]initWithFrame:CGRectMake(20, 11,ScreenWidth - 80, 20)];
        titleLabss.text = [NSString stringWithFormat:@"%@",resourceArr[indexPath.row][@"hospitalName"]];
        titleLabss.font = [UIFont systemFontOfSize:16];
        titleLabss.textColor = titColor;
        [cella.contentView addSubview:titleLabss];
        
//        UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 54, 0, 44, 44)];
//        [btns setImage:[UIImage imageNamed:@"选医院_未"] forState:normal];
//        [btns setImage:[UIImage imageNamed:@"选医院"] forState:UIControlStateSelected];
//        [btns addTarget:self action:@selector(didtableviewButton:) forControlEvents:UIControlEventTouchUpInside];
//        btns.tag = 10 + indexPath.row;
//        [cella.contentView addSubview:btns];
        
        return cella;
    }else if (tableView == tableviewOne){
        static NSString *cellOne= @"cellOne";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellOne];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UIImageView *imageOne = [[UIImageView alloc]initWithFrame:CGRectMake(20, 14, 20, 16)];
        imageOne.image = [UIImage imageNamed:@"TICK"];
        [cell.contentView addSubview:imageOne];
        imageOne.tag = indexPath.row + 10;
        imageOne.hidden = YES;
        
        UILabel *styleOneLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 12, 200, 20)];
        styleOneLab.text = [NSString stringWithFormat:@"%@",arrayone[indexPath.row][@"districtName"]];
        
        styleOneLab.tag = indexPath.row + 10;
        styleOneLab.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:styleOneLab];
        
        if (imageOne.tag == [stringOne intValue]) {
            imageOne.hidden = NO;
            styleOneLab.textColor = greenC;
        }else{
            imageOne.hidden = YES;
            styleOneLab.textColor = titColor;
        }
        
        return cell;
        
    }else if (tableView == tableviewTwo){
        static NSString *cellTwo= @"cellTwo";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTwo];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UIImageView *imageTwo = [[UIImageView alloc]initWithFrame:CGRectMake(20, 14, 20, 16)];
        imageTwo.tag = indexPath.row + 200;
        
        imageTwo.image = [UIImage imageNamed:@"TICK"];
        [cell.contentView addSubview:imageTwo];
        imageTwo.hidden = YES;
        
        
        UILabel *styleTwoLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 12, 200, 20)];
        styleTwoLab.text = [NSString stringWithFormat:@"%@",arrayTwo[indexPath.row][@"districtName"]];
        styleTwoLab.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:styleTwoLab];
        
        
        if (imageTwo.tag == [stringTwo intValue]) {
            imageTwo.hidden = NO;
            styleTwoLab.textColor = greenC;
        }else{
            imageTwo.hidden = YES;
            styleTwoLab.textColor = titColor;
        }
        
        return cell;
        
    }else{
        static NSString *cellThree= @"cellThree";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellThree];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UIImageView *imageThree = [[UIImageView alloc]initWithFrame:CGRectMake(20, 14, 20, 16)];
        imageThree.tag = indexPath.row + 300;
        imageThree.image = [UIImage imageNamed:@"TICK"];
        [cell.contentView addSubview:imageThree];
        imageThree.hidden = YES;
        
        UILabel *styleThreeLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 12, 200, 20)];
        styleThreeLab.text = [NSString stringWithFormat:@"%@",arrayThree[indexPath.row][@"districtName"]];
        styleThreeLab.highlightedTextColor = [UIColor orangeColor];
        styleThreeLab.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:styleThreeLab];
        
        if (imageThree.tag == [stringThree intValue]) {
            imageThree.hidden = NO;
            styleThreeLab.textColor = greenC;
        }else{
            imageThree.hidden = YES;
            styleThreeLab.textColor = titColor;
        }
        
        return cell;
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    heiseView.hidden = YES;
    if (tableView == yishengTable) {
        YiYuanId = resourceArr[indexPath.row][@"hospitalId"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:YiYuanId forKey:@"YiYuanId"];
        [defaults synchronize];
        yiyuanDic = resourceArr[indexPath.row];
        
        if (yiyuanDic.count == 0) {
            return;
        }
        self.returnYuan(yiyuanDic);
        [self.navigationController popViewControllerAnimated:NO];
        
        
    }else if (tableView == tableviewOne){
        stringOne = [NSString stringWithFormat:@"%ld",indexPath.row + 10];
        tableviewOne.hidden = YES;
        provId = [NSString stringWithFormat:@"%@",arrayone[indexPath.row][@"districtId"]];
        districtId = [NSString stringWithFormat:@"%@",arrayone[indexPath.row][@"districtId"]];
        level = [NSString stringWithFormat:@"2"];
        
        NSString *names = [NSString stringWithFormat:@"%@",arrayone[indexPath.row][@"districtName"]];
        if (names.length > 3) {
            names = [names substringToIndex:3];
            names = [NSString stringWithFormat:@"%@...",names];
        }
        UIButton *btns = (UIButton *)[self.view viewWithTag:20];
        UIButton *cityBtn = (UIButton *)[self.view viewWithTag:21];
        UIButton *areaBtn = (UIButton *)[self.view viewWithTag:22];
        [btns setTitle:names forState:normal];
        [cityBtn setTitle:@"市" forState:normal];
        [areaBtn setTitle:@"区" forState:normal];
        [self makeShengShiQU];
        [self makeChoseHospital];
        [tableviewOne reloadData];
    }else if (tableView == tableviewTwo){
        stringTwo = [NSString stringWithFormat:@"%ld",indexPath.row + 200];
        tableviewTwo.hidden = YES;
        cityId = [NSString stringWithFormat:@"%@",arrayTwo[indexPath.row][@"districtId"]];
        districtId = [NSString stringWithFormat:@"%@",arrayTwo[indexPath.row][@"districtId"]];
        level = [NSString stringWithFormat:@"3"];
        
        NSString *names = [NSString stringWithFormat:@"%@",arrayTwo[indexPath.row][@"districtName"]];
        if (names.length > 3) {
            names = [names substringToIndex:3];
            names = [NSString stringWithFormat:@"%@...",names];
        }
        UIButton *btns = (UIButton *)[self.view viewWithTag:21];
        [btns setTitle:names forState:normal];
        
        UIButton *areaBtn = (UIButton *)[self.view viewWithTag:22];
        [areaBtn setTitle:@"区" forState:normal];
        [self makeShengShiQU];
        [self makeChoseHospital];
        [tableviewTwo reloadData];
    }else{
        stringThree = [NSString stringWithFormat:@"%ld",indexPath.row + 300];
        tableviewThree.hidden = YES;
        countyId = [NSString stringWithFormat:@"%@",arrayThree[indexPath.row][@"districtId"]];
        districtId = [NSString stringWithFormat:@"%@",arrayThree[indexPath.row][@"districtId"]];
        
        NSString *names = [NSString stringWithFormat:@"%@",arrayThree[indexPath.row][@"districtName"]];
        if (names.length > 3) {
            names = [names substringToIndex:3];
            names = [NSString stringWithFormat:@"%@...",names];
        }
        UIButton *btns = (UIButton *)[self.view viewWithTag:22];
        [btns setTitle:names forState:normal];
        [self makeChoseHospital];
        [tableviewThree reloadData];
    }
    
}
//- (void)didtableviewButton:(UIButton *)sender{
//    sender.selected =! sender.selected;
//
//    if (sender != _tableBtn) {
//        _tableBtn.selected = NO;
//        sender.selected = YES;
//        _tableBtn = sender;
//    }else{
//        _tableBtn.selected = YES;
//    }
//    YiYuanId = resourceArr[sender.tag - 10][@"hospitalId"];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:YiYuanId forKey:@"YiYuanId"];
//    [defaults synchronize];
//    yiyuanDic = resourceArr[sender.tag - 10];
//
//}
- (void)returnYiYUan:(returnYiYuan)block{
    self.returnYuan = block;
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
