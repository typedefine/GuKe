//
//  YshengChatViewController.m
//  GuKe
//
//  Created by yu on 2018/1/12.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "YshengChatViewController.h"
#import "yshengChatTableViewCell.h"
#import "WYYYIshengFriend.h"
#import "ChatViewController.h"//聊天页面
//#import "WYYMainGroupViewController.h"   //我的群组
#import "ZJNFindDoctorViewController.h"//找医生
#import "WYYeMenShiPinViewController.h"//热门视频
#import "WYYFMDBManager.h"
@interface YshengChatViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *chatTableview;
    NSMutableArray *titleArr;
    
    NSMutableArray *sectionTitlesArray;
    NSMutableArray *sortedArray;
    NSMutableArray *itemArray;
    WYYFMDBManager *_db;
    NSDate * comeDate;//进入模块的时间

}
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;
@end

@implementation YshengChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"医生好友";
    comeDate =[NSDate date];

    self.view.backgroundColor = [UIColor whiteColor];
    
    _db = [WYYFMDBManager shareWYYManager];
    
    
    
    //添加
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onClickedOKbtn)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    sectionTitlesArray = [NSMutableArray array];
    
    titleArr = [NSMutableArray array];
    [self makeAddTableview];
    [self makeData];
    // Do any additional setup after loading the view.
}
#pragma mark  导航栏右侧搜索按钮
- (void)onClickedOKbtn {
    ZJNFindDoctorViewController *zhao = [[ZJNFindDoctorViewController alloc]init];
    zhao.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:zhao animated:NO];
}
#pragma mark  好友医生列表
- (void)makeData{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,doctorhuanxinfreindlist];
    NSArray *keysArray = @[@"sessionId"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            NSArray *arays = [NSArray arrayWithArray:data[@"data"]];
            if (arays.count == 0) {
                
            }else{
                for (NSDictionary *dic in arays) {
                    WYYYIshengFriend *model = [WYYYIshengFriend yy_modelWithJSON:dic];
                    [_db addFriendListModel:model];
                    
                    [titleArr addObject:model];
                }
                [self sortDataArray:arays];
                [chatTableview reloadData];
            }
        }
        NSLog(@"好友医生列表%@",data);
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"好友医生列表%@",error);
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

#pragma mark add tableview
- (void)makeAddTableview{
    chatTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight)style:UITableViewStyleGrouped];
    
    chatTableview.delegate = self;
    chatTableview.dataSource = self;
    chatTableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    chatTableview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:chatTableview];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sectionTitlesArray.count; //+ 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) {
//        return 1;
//    }else{
//        return [[itemArray objectAtIndex:section - 1] count];
//    }
    
    return [[itemArray objectAtIndex:section] count];
        
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return sectionTitlesArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return 0.01;
//    }else{
        return 23;
//    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return nil;
//    }else{
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 23)];
        headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 23)];
        titleLab.text = sectionTitlesArray[section];
        titleLab.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:titleLab];
        

        return headerView;
        
//    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdter = @"cellId";
    yshengChatTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:cellIdter];
    if (!cellTwo) {
        cellTwo = [[[NSBundle mainBundle]loadNibNamed:@"yshengChatTableViewCell" owner:self options:nil] lastObject];
        cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    if (indexPath.section == 0) {
//        cellTwo.imgView.image = [UIImage imageNamed:@"医生好友_我的群组"];
//        cellTwo.nameLab.text = [NSString stringWithFormat:@"我的群组"];
//    }else{
        
        [cellTwo.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,itemArray[indexPath.section][indexPath.row][@"portrait"]]] placeholderImage:[UIImage imageNamed:@"doctorImage"]];
        cellTwo.imgView.layer.masksToBounds = YES;
        cellTwo.imgView.layer.cornerRadius = 18.5;
        cellTwo.nameLab.text = itemArray[indexPath.section][indexPath.row][@"name"];
//    }
    
    return cellTwo;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        WYYMainGroupViewController *group = [[WYYMainGroupViewController alloc]init];
//        group.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:group animated:NO];
//    }else{
        ChatViewController *chat = [[ChatViewController alloc]initWithConversationChatter:itemArray[indexPath.section - 1][indexPath.row][@"userId"] conversationType:EMConversationTypeChat];
        chat.doctorId = itemArray[indexPath.section][indexPath.row][@"doctorId"];
        chat.title = itemArray[indexPath.section][indexPath.row][@"name"];
        chat.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:chat animated:NO];
        
//    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)navigationShouldPopOnBackButton{
    
    [moduleDate ShareModuleDate].DouctFriendsLength =[[NSDate date]timeIntervalSinceDate:comeDate];
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
