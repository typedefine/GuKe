//
//  WoDeHuanZheViewController.m
//  GuKe
//
//  Created by yu on 2017/8/7.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "WoDeHuanZheViewController.h"
#import "WoDeHuanZheTableViewCell.h"
#import "ZJNPatientBasicInfoViewController.h"
#import "ShuHouSUFangViewController.h"
#import "ZJNDatePickerView.h"
#import "HuanZheListModel.h"
#import "ZhhuanChangViewController.h"
@interface WoDeHuanZheViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZJNDatePickerDelegate>{
    UITableView *huanZheTable;
    UITextField *searchText;
    NSString *StrSearch;
    NSString *StringOne;
    NSString *StringTwo;
    
    UITableView *tableviewOne;
    
    UIView *heiseView;//黑色遮罩层
    UIView *_backWindowView;
    
    NSInteger number;//分页参数
    NSMutableArray *resourceArr;
    
    NSString *stringOne;//标注类别
    NSString *stringTwo;//标注类型
    NSString *inTime;
    
    NSMutableArray *Arrone;//关节
    NSMutableArray *ArrTwo;//时间
    CGRect heightRect;

    NSInteger page;//请求患者列表分页
    UILabel * numberLB ; // 显示返回的条数，
    
    NSMutableArray * selectGuanjieDic;//帅选的关节
}
@property (nonatomic,strong)ZJNDatePickerView *datePicker;
@property (nonatomic,strong)UIButton *selectedBtnOne;
@end

@implementation WoDeHuanZheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"患者病例";
    selectGuanjieDic =[[NSMutableArray alloc]init];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"就诊记录_添加"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickedOKNeedView)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didaddPatient) name:@"notificationAddHuanZhe" object:nil];
    resourceArr = [NSMutableArray array];
    Arrone = [NSMutableArray array];
    ArrTwo = [NSMutableArray array];
    
    StrSearch = [NSString stringWithFormat:@""];
    stringOne = [NSString stringWithFormat:@""];
    stringTwo = [NSString stringWithFormat:@""];
    inTime = [NSString stringWithFormat:@""];
    page = 0;
    [self makeTableView];
    [self makeData];
    [self makeGuanjie];
    // Do any additional setup after loading the view from its nib.
}
- (void)didaddPatient{
    page = 0;
    [self makeData];
}
- (void)onClickedOKNeedView{
//    HuanZheInfoViewController *info = [[HuanZheInfoViewController alloc]init];
//    info.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:info animated:NO];
    ZJNPatientBasicInfoViewController *info = [[ZJNPatientBasicInfoViewController alloc]init];
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:NO];
}
#pragma mark  关节名称
- (void)makeGuanjie{
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,jointslist];
//    [ZJNRequestManager postWithUrlString:urlString parameters:nil success:^(id data) {
//        NSLog(@"关节名称%@",data);
//        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
//        if ([retcode isEqualToString:@"0"]) {
//            NSArray *array = [NSArray arrayWithArray:data[@"data"]];
//            if (array.count > 0) {
//                [Arrone addObjectsFromArray:array];
//
//                if (array.count > 4) {
//                    tableviewOne.frame = CGRectMake(0, 100, ScreenWidth, 44*4);
//                }else{
//                    tableviewOne.frame = CGRectMake(0, 100, ScreenWidth, 44*array.count);
//                }
//                [tableviewOne reloadData];
//            }
//        }else{
//            [self showHint:data[@"messages"]];
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"关节名称%@",error);
//    }];

}
#pragma mark  请求数据患者列表
- (void)makeData{
    page++;
    NSMutableArray * SeleUidArray =[[NSMutableArray alloc]init];
    for (NSDictionary *SelectDic in selectGuanjieDic) {
        [SeleUidArray addObject:SelectDic[@"uid"]];
    }
    stringOne = [ SeleUidArray componentsJoinedByString:@","];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,patientpatient_list];
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    NSArray *keysArray = @[@"doctorid",@"sessionid",@"jointid",@"time",@"patientname",@"page"];
    NSArray *valueArray = @[UserId,sessionIding,stringOne,inTime,StrSearch,pageStr];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"患者列表%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            NSArray *array = [NSArray arrayWithArray:data[@"data"]];
            if (page == 1) {
                [resourceArr removeAllObjects];
            }
            if (array.count > 0) {
                
                [resourceArr addObjectsFromArray:array];
                
            }else{
                
                if (resourceArr.count == 0) {
                    [self showHint:@"暂无数据"];
                }else{
                    [self showHint:@"暂无更多数据"];
                }
            }
        }else{
            page --;
            [self showHint:data[@"message"]];
        }
        numberLB.text =[NSString stringWithFormat:@"共有%@条数据",[NSString changeNullString: [NSString stringWithFormat:@"%@",data[@"count"]]]];

        [huanZheTable.mj_header endRefreshing];
        [huanZheTable.mj_footer endRefreshing];
        [huanZheTable reloadData];
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"患者列表%@",error);
    }];
}
#pragma mark add tableview
- (void)makeTableView{
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
    searchText.placeholder = @"搜患者信息";
    searchText.font = Font12;
    [viewBack addSubview:searchText];
    
    
    UIButton *labelsa = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 70,10 , 70, 30)];
    labelsa.titleLabel.font = Font14;
    [labelsa setTitle:@"搜索" forState:normal];
    [labelsa setTitleColor:titColor forState:normal];
    [labelsa addTarget:self action:@selector(didSouSuoButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:labelsa];
    
    //
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, 1)];
    lineView.backgroundColor = SetColor(0xf0f0f0);
    [self.view addSubview:lineView];
    
    //
    NSArray *titleaRR = [NSArray arrayWithObjects:@"全部",@"关节",@"时间", nil];
    for (int a= 0; a < 3; a ++) {
        UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(0 + ScreenWidth/3* a, 51, ScreenWidth/3, 50)];
        btns.titleLabel.font = Font14;
        [btns setTitle:[NSString stringWithFormat:@"%@",titleaRR[a]] forState:normal];
        [btns setTitleColor:SetColor(0x1a1a1a) forState:normal];
        
        if (a == 0) {
            btns.selected = YES;
            self.selectedBtnOne = btns;
        }else{
            [btns setImage:[UIImage imageNamed:@"三角-选择"] forState:normal];
            [btns setImage:[UIImage imageNamed:@"三角_当前"] forState:UIControlStateSelected];
            [btns setTitleColor:SetColor(0x06a27b) forState:UIControlStateSelected];
        }
        [btns addTarget:self action:@selector(didButton:) forControlEvents:UIControlEventTouchUpInside];
        btns.tag = a + 20;
        btns.imageEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0);
        btns.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
        [self.view addSubview:btns];
        
    }
    
    UIView *views = [[UIView alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, 10)];
    views.backgroundColor = SetColor(0xf0f0f0);
    [self.view addSubview:views];

    huanZheTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 110, ScreenWidth, ScreenHeight - 64 - 110)];
    huanZheTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 0;
        [self makeData];
    }];
    
    huanZheTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self makeData];
    }];
    huanZheTable.delegate = self;
    huanZheTable.dataSource = self;
    huanZheTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:huanZheTable];
//    HeaderView 显示返回数据的条数
    [self maketableHeaderView];
    
    //heiseView
    heiseView = [[UIView alloc]initWithFrame:CGRectMake(0,100, ScreenWidth, ScreenHeight)];
    heiseView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view  addSubview:heiseView];
    heiseView.hidden = YES;
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didViewBlockView)];
    [heiseView addGestureRecognizer:tapGesture];
    
//    tableviewOne = [[UITableView alloc]initWithFrame:CGRectMake(0,100, ScreenWidth, 44* 4)];
//    tableviewOne.delegate = self;
//    tableviewOne.dataSource = self;
//    tableviewOne.tableFooterView = [[UIView alloc]init];
//    [self.view addSubview:tableviewOne];
//    tableviewOne.hidden = YES;
    
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
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    heiseView.hidden = YES;
    tableviewOne.hidden = YES;
    StrSearch = textField.text;
}
#pragma mark 黑色遮罩层点击事件
- (void)didViewBlockView{
    self.selectedBtnOne.selected = NO;
    heiseView.hidden = YES;
    tableviewOne.hidden = YES;
}
#pragma mark 顶部三个按钮点击事件
- (void)didButton:(UIButton *)sender{
    
    if (sender.tag == 20) {
        
        stringOne = @"";
        [selectGuanjieDic removeAllObjects];

        inTime = @"";
        StrSearch = @"";
        searchText.text = @"";

        page = 0;
        [self makeData];
        
    }else{
        if (sender.selected) {
            sender.selected = NO;
            heiseView.hidden = YES;
            tableviewOne.hidden = YES;
            
        }else{
            self.selectedBtnOne.selected = NO;
            sender.selected = YES;
            if (sender.tag == 21) {
                heiseView.hidden = NO;
                tableviewOne.hidden = NO;
                [self makeSelectGuanjie];
            }else if (sender.tag == 22){
                [self didTimeButton];
                heiseView.hidden = YES;
                tableviewOne.hidden = YES;
            }
        }
        self.selectedBtnOne = sender;
    }
    
    [searchText resignFirstResponder];
}

#pragma mark 搜索框按钮点击事件
- (void)didSouSuoButton{
    heiseView.hidden =YES;
    tableviewOne.hidden = YES;
    [searchText resignFirstResponder];
    page = 0;
//    [resourceArr removeAllObjects];
    [self makeData];
}
#pragma  mark 选关节
-(void)makeSelectGuanjie{
    ZhhuanChangViewController *zhuan = [[ZhhuanChangViewController alloc]init];
    zhuan.typeStr = @"1";
    zhuan.returnZhuan = ^(NSMutableArray *arr){
       
        self.selectedBtnOne.selected = NO;
//         stringOne = [NSString stringWithFormat:@"%@",Arrone[indexPath.row][@"uid"]];
        selectGuanjieDic = arr;
        tableviewOne.hidden = YES;
        heiseView.hidden = YES;
        page = 0;
        [self makeData];
        [tableviewOne reloadData];//
    };
    zhuan.selectArray = selectGuanjieDic;
    zhuan.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:zhuan animated:NO];
    

}
#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == huanZheTable) {
        return resourceArr.count;
    }else{
        return Arrone.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == huanZheTable) {
        return 103;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == huanZheTable) {
        static NSString *cellIdter = @"cellId";
        WoDeHuanZheTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:cellIdter];
        if (!cellTwo) {
            cellTwo = [[[NSBundle mainBundle]loadNibNamed:@"WoDeHuanZheTableViewCell" owner:self options:nil] lastObject];
            cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSDictionary *dic = resourceArr[indexPath.row];
        HuanZheListModel *listModel = [HuanZheListModel yy_modelWithDictionary:dic];
        
        
        if ([listModel.gender isEqualToString:@"1"]) {
            cellTwo.nameLab.text = [NSString stringWithFormat:@"%@   男   %@岁",listModel.patientName,listModel.age];
            [cellTwo.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",listModel.portrait]] placeholderImage:[UIImage imageNamed:@"nan"]];
        }else{
            cellTwo.nameLab.text = [NSString stringWithFormat:@"%@   女   %@岁",listModel.patientName,listModel.age];
            [cellTwo.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",listModel.portrait]] placeholderImage:[UIImage imageNamed:@"nv"]];
        }
        
        cellTwo.zhuyuanhaoLab.text = [NSString stringWithFormat:@"住院号:%@   主治医师:%@",listModel.hospNum,listModel.doctorName];
        cellTwo.zhenduanLab.text = [NSString stringWithFormat:@"诊断情况:%@",listModel.diagnosis];
        
        cellTwo.zheLiaoLab.text = [NSString stringWithFormat:@"诊疗时间:%@",listModel.intime];

        cellTwo.anniuBtn.tag = indexPath.row;
        [cellTwo.anniuBtn addTarget:self action:@selector(didChatButton:) forControlEvents:UIControlEventTouchUpInside];
        return cellTwo;
        
    }else{
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
        styleOneLab.text = [NSString stringWithFormat:@"%@",Arrone[indexPath.row][@"jointsName"]];
        styleOneLab.tag = indexPath.row + 10;
        styleOneLab.font = Font14;
        [cell.contentView addSubview:styleOneLab];
        
        if (imageOne.tag == [StringOne intValue]+ 10) {
            imageOne.hidden = NO;
            styleOneLab.textColor = greenC;
        }else{
            imageOne.hidden = YES;
            styleOneLab.textColor = titColor;
        }
        
        return cell;
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == huanZheTable) {
        NSString *strings = resourceArr[indexPath.row][@"hospnumId"];
        NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
        [defau setObject:strings forKey:@"hospitalnumbar"];
        [defau synchronize];
        ShuHouSUFangViewController *shu = [[ShuHouSUFangViewController alloc]initWithDictionary:resourceArr[indexPath.row]];
        shu.numbers = 0;
         shu.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:shu animated:NO];
        
    }else{
        
        self.selectedBtnOne.selected = NO;
        StringOne = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        stringOne = [NSString stringWithFormat:@"%@",Arrone[indexPath.row][@"uid"]];
        tableviewOne.hidden = YES;
        heiseView.hidden = YES;
        page = 0;
        [self makeData];
        [tableviewOne reloadData];
    }
}
#pragma mark 聊天
- (void)didChatButton:(UIButton *)sender{
    
    
  //  NSString *userStr = [NSString stringWithFormat:@"%@",resourceArr[sender.tag][@""]];
    
}
#pragma mark 医生好友列表 --是否是好友
- (void)makeFriend:(NSString *)stringId{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,doctorfriends_is];
    NSArray *keysArray = @[@"sessionid",@"friendid"];
    NSArray *valueArray = @[sessionIding,stringId];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"医生好友列表 --是否是好友%@",data);
    } failure:^(NSError *error) {
        NSLog(@"医生好友列表 --是否是好友%@",error);
    }];

}

#pragma mark 开始时间
- (void)didTimeButton{

    if(_datePicker==nil){
        _backWindowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight)];
        _backWindowView.backgroundColor = [UIColor blackColor];
        _backWindowView.alpha = 0.5;
        
        [Utile addClickEvent:self action:@selector(getCenterDatePicker) owner:_backWindowView];
        [self.view addSubview:_backWindowView];
        _datePicker = [[ZJNDatePickerView alloc]init];
        _datePicker.frame= CGRectMake(0, ScreenHeight - 64, ScreenWidth, 184);
        _datePicker.delegate = self;
        [self.view addSubview:_datePicker];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _datePicker.frame = CGRectMake(0, ScreenHeight-184 - 64, ScreenWidth, 184);
        } completion:^(BOOL finished) {
        }];
        
    }else{
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_backWindowView removeFromSuperview];
            _backWindowView = nil;
            _datePicker.frame = CGRectMake(0, ScreenHeight - 64, ScreenWidth, 184);
        } completion:^(BOOL finished) {
            [_datePicker removeFromSuperview];
            _datePicker = nil;
        }];
    }
}

#pragma mark--ZJNDatePickerDelegate
-(void)getCenterDatePicker{
    UIButton *button = (UIButton *)[self.view viewWithTag:22];
    button.selected = NO;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _datePicker.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 184);
    } completion:^(BOOL finished) {
        [self.datePicker removeFromSuperview];
        self.datePicker = nil;
    }];
}
-(void)getSelectedDate:(NSString *)selectedDate{
    UIButton *button = (UIButton *)[self.view viewWithTag:22];
    button.selected = NO;
    inTime = [NSString stringWithFormat:@"%@", selectedDate];
    //    [button setTitle:inTime forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _datePicker.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 184);
    } completion:^(BOOL finished) {
        [self.datePicker removeFromSuperview];
        self.datePicker = nil;
    }];
    page = 0;
    //    [resourceArr removeAllObjects];
    [self makeData];
}
#pragma mark  添加headerView
-(void)maketableHeaderView{
    UIView * headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];

    numberLB  =[[UILabel alloc]initWithFrame:CGRectMake(30, 5, ScreenWidth -  80, 35)];
    numberLB.textColor =  [UIColor colorWithHex:666666];
    numberLB.font =[UIFont systemFontOfSize:13];
    numberLB.text =[NSString stringWithFormat:@""];
    [headerView addSubview:numberLB];
    huanZheTable.tableHeaderView  = headerView;
    
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
