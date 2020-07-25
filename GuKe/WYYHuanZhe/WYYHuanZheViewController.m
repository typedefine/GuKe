//
//  WYYHuanZheViewController.m
//  GuKe
//
//  Created by yu on 2018/1/29.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYHuanZheViewController.h"//
#import "WYYHuanZheListTableViewCell.h"
#import "ChatViewController.h"
#import "WYYYIshengFriend.h"
#import "WYYFMDBManager.h"

@interface WYYHuanZheViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    UITextField *searchText;
    UITableView *huanzheTableview;
    
    NSMutableArray *sectionTitlesArray;
    NSMutableArray *sortedArray;
    NSMutableArray *itemArray;
    
    NSMutableArray *numberArr;
    
    WYYFMDBManager *managers;
}

@end

@implementation WYYHuanZheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的患者";
    self.view.backgroundColor = [UIColor whiteColor];
    sectionTitlesArray = [NSMutableArray array];
    numberArr = [NSMutableArray array];
    managers = [WYYFMDBManager shareWYYManager];
    
    [self makeAddTableview];
    [self makeHuanZheList];
    
    
    // Do any additional setup after loading the view.
}
- (void)makeAddTableview{
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
    
    huanzheTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, ScreenHeight - 50)];
    huanzheTableview.delegate = self;
    huanzheTableview.dataSource = self;
    huanzheTableview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:huanzheTableview];
}
#pragma mark 搜索按钮
- (void)didSouSuoButton{
    [searchText resignFirstResponder];
    [self makeHuanZheList];
}
#pragma mark 患者列表
- (void)makeHuanZheList{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,doctorhuanxinpatientlist];
    NSArray *keysArray = @[@"sessionId",@"patientname"];
    NSArray *valueArray = @[sessionIding,searchText.text];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
        NSLog(@"患者列表%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            NSArray *arrays = [NSArray arrayWithArray:data[@"data"]];
            if (arrays.count == 0) {
                
            }else{
                
                for (NSDictionary *dicar in arrays) {
                    WYYYIshengFriend *model = [WYYYIshengFriend yy_modelWithJSON:dicar];
                    [managers addFriendListModel:model];
                }
                
                [self sortDataArray:arrays];
                [huanzheTableview reloadData];
            }
        }
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"患者列表%@",error);
    }];
    
    
}
- (NSMutableArray *)sortDataArray:(NSArray *)dataArray{
    
    if (dataArray.count == 0) {
        [sectionTitlesArray removeAllObjects];
        itemArray = [NSMutableArray array];
        return sortedArray;
    }
    itemArray = [NSMutableArray array];
    
    UILocalizedIndexedCollation *indexCollection = [UILocalizedIndexedCollation currentCollation];
    [sectionTitlesArray removeAllObjects];
    [sectionTitlesArray addObjectsFromArray:[indexCollection sectionTitles]];
    
    NSInteger highSection = [sectionTitlesArray count];
    sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i ++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    
    
    for (NSDictionary *dicat in dataArray) {
        NSString *realString = [NSString stringWithFormat:@"%@",[dicat objectForKey:@"name"]];
        NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:realString];
        NSInteger section = [indexCollection sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:dicat];
        
    }
    
    for (int i = 0; i < [sortedArray count]; i ++) {
        NSArray *array =[[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(NSString *nameOne,NSString *nameTwo) {
            
            NSMutableArray *arraystr = sortedArray[i];
            
            NSString *firstLetter1;
            NSString *firstLetter2;
            for (NSDictionary *dicae in arraystr) {
                nameOne = [NSString stringWithFormat:@"%@",[dicae objectForKey:@"name"]];
                firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:nameOne];
                firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
                
                
                nameTwo = [NSString stringWithFormat:@"%@",[dicae objectForKey:@"name"]];
                firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:nameTwo];
                firstLetter2 = [[firstLetter2 substringToIndex:1]uppercaseString];
                
            }
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
            
        }];
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    NSMutableArray *tempSectionTitles = [NSMutableArray array];
    for (int i = 0; i < sortedArray.count; i ++) {
        NSArray *array = sortedArray[i];
        if (array.count > 0) {
            [itemArray addObject:array];
            [tempSectionTitles addObject:[sectionTitlesArray objectAtIndex:i]];
        }
    }
    [sectionTitlesArray removeAllObjects];
    [sectionTitlesArray addObjectsFromArray:tempSectionTitles];
    return itemArray;
    
    
}
#pragma mark tabelview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[itemArray objectAtIndex:section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sectionTitlesArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 22)];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 22)];
    titleLab.text = sectionTitlesArray[section];
    titleLab.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:titleLab];
    return headerView;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return sectionTitlesArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdone = @"cellIdo";
    WYYHuanZheListTableViewCell *cellOne = [tableView dequeueReusableCellWithIdentifier:cellIdone];
    if (!cellOne) {
        cellOne = [[[NSBundle mainBundle]loadNibNamed:@"WYYHuanZheListTableViewCell" owner:self options:nil] lastObject];
        cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cellOne.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,itemArray[indexPath.section][indexPath.row][@"portrait"]]] placeholderImage:[UIImage imageNamed:@"头像"]];
    NSString *genderStr = [NSString stringWithFormat:@"%@",itemArray[indexPath.section][indexPath.row][@"gender"]];
    if ([genderStr isEqualToString:@"0"]) {
        cellOne.nameLab.text = [NSString stringWithFormat:@"%@  女  %@岁",itemArray[indexPath.section][indexPath.row][@"name"],itemArray[indexPath.section][indexPath.row][@"age"]];
    }else{
        cellOne.nameLab.text = [NSString stringWithFormat:@"%@  男  %@岁",itemArray[indexPath.section][indexPath.row][@"name"],itemArray[indexPath.section][indexPath.row][@"age"]];
    }
    
    
    return cellOne;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *listDic = itemArray[indexPath.section][indexPath.row];
    ChatViewController *chatview = [[ChatViewController alloc]initWithConversationChatter:[listDic objectForKey:@"userId"] conversationType:EMConversationTypeChat];
    chatview.chatStyle = @"1";
    chatview.title = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"name"]];
    chatview.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatview animated:NO];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
