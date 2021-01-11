//
//  AddMembersController.m
//  GuKe
//
//  Created by yb on 2021/1/12.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "AddMembersController.h"
#import "WYYChoseGroupNumberTableViewCell.h"

@interface AddMembersController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UITableView *qunliaoTableview;
    UITextField *searchText;
    NSMutableArray *sectionTitlesArray;
    NSMutableArray *sortedArray;
    NSMutableArray *itemArray;
    
    NSMutableArray *numberArr;
    
    NSString * numberUserid;
}
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;
@end

@implementation AddMembersController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加成员";
    
    if (self.action == InviteMembersActionByAddingGroup) {
        numberUserid  = @"userId";
    }else{
        numberUserid  = @"userid";
        
    }
    

    self.view.backgroundColor = [UIColor whiteColor];
    sectionTitlesArray = [NSMutableArray array];
    numberArr = [NSMutableArray array];
    
    if (self.action == InviteMembersActionByAddingGroup) {
        if (self.GroupNumberArr.count == 0) {
            
        }else{
            [numberArr addObjectsFromArray:self.GroupNumberArr];
        }
    }
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onOKNeedView)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self makeaddtableview];
    [self makedata];
    // Do any additional setup after loading the view.
}
#pragma mark确定按钮
- (void)onOKNeedView{
    
    if (self.backgroupnumber) {
        self.backgroupnumber(numberArr);
    }
    
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark add tableview
-(void)makeaddtableview{
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
    searchText.placeholder = @"请输入医生姓名进行搜索";
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
    
    if (IS_IPGONE_X) {
        qunliaoTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 51, ScreenWidth, ScreenHeight - 51 - 86)];
    }else{
        qunliaoTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 51, ScreenWidth, ScreenHeight - 51 - 64)];
    }
    
    [self.view addSubview:qunliaoTableview];
    qunliaoTableview.delegate = self;
    qunliaoTableview.dataSource = self;
    qunliaoTableview.tableFooterView = [[UIView alloc]init];
}
- (void)didSouSuoButton{

    if (searchText.text.length == 0) {
        return;
    }else{
        [qunliaoTableview reloadData];
        [self makedata];
    }
    
}
- (void)makedata{
    NSString *searchStr;
    if (searchText.text.length == 0) {
        searchStr = @"";
    }else{
        searchStr = searchText.text;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,doctorhuanxindoctorlist];
    NSArray *keysArray = @[@"sessionId",@"name"];
    NSArray *valueArray = @[sessionIding,searchStr];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            NSArray *arrays = [NSArray arrayWithArray:data[@"data"]];
            if (arrays.count == 0) {
                
            }else{
                [self sortDataArray: arrays];
                [qunliaoTableview reloadData];
            }
        }
        NSLog(@"群成员%@",data);
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"群成员%@",error);
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
#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sectionTitlesArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[itemArray objectAtIndex:section] count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 23;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 23)];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 23)];
    titleLab.text = sectionTitlesArray[section];
    titleLab.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:titleLab];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdter = @"cellId";
    WYYChoseGroupNumberTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:cellIdter];
    if (!cellTwo) {
        cellTwo = [[[NSBundle mainBundle]loadNibNamed:@"WYYChoseGroupNumberTableViewCell" owner:self options:nil] lastObject];
        cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cellTwo.nameLab.text = itemArray[indexPath.section][indexPath.row][@"name"];
    [cellTwo.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,itemArray[indexPath.section][indexPath.row][@"portrait"]]] placeholderImage:[UIImage imageNamed:@"头像"]];
    [cellTwo.choseBtn setImage:[UIImage imageNamed:@"ѡҽԺ_δ"] forState:normal];
    [cellTwo.choseBtn setImage:[UIImage imageNamed:@"ѡҽԺ"] forState:UIControlStateSelected];
    cellTwo.choseBtn.tag =indexPath.row;
    [cellTwo.choseBtn addTarget:self action:@selector(addNumber:) forControlEvents:UIControlEventTouchUpInside];
   
 
    NSString *groupNumberID = [NSString stringWithFormat:@"%@",itemArray[indexPath.section][indexPath.row][@"userId"]];
    NSString *numberID;
    cellTwo.choseBtn.selected = NO;

    for (int a = 0; a < self.GroupNumberArr.count; a ++ ) {
        numberID = [NSString stringWithFormat:@"%@",self.GroupNumberArr[a][numberUserid]];
       
        NSLog(@"groupNumberID = %@  numberID = %@  \n",groupNumberID,numberID);
        
        if ([numberID isEqualToString:@"(null)"]||(numberID.length == 0)) {
            numberID = [NSString stringWithFormat:@"%@",self.GroupNumberArr[a][numberUserid]];
        }
        if ([groupNumberID isEqualToString:numberID]) {
            //[cellTwo.choseBtn setImage:[UIImage imageNamed:@"ѡҽԺ"] forState:normal];
            cellTwo.choseBtn.selected = YES;
        }
        
//        if (addGroup == 1) {
//            if ([groupNumberID isEqualToString:numberID]) {
//                //[cellTwo.choseBtn setImage:[UIImage imageNamed:@"ѡҽԺ"] forState:normal];
//                cellTwo.choseBtn.selected = YES;
//                cellTwo.choseBtn.enabled = NO;
//
//            }
//        }else{
        
       
//        }
        
        
    }
    return cellTwo;
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return sectionTitlesArray;
}
- (void)addNumber:(UIButton *)sender{
    sender.selected =! sender.selected;
    NSIndexPath *indes = [qunliaoTableview indexPathForCell:(UITableViewCell *)[[sender superview]superview]];
    if (sender.selected == YES) {
        [numberArr addObject:itemArray[indes.section][indes.row]];
    }else{
        [numberArr removeObject:itemArray[indes.section][indes.row]];
    }
    
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
