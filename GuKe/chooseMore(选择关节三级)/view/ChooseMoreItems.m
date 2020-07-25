//
//  ChooseMoreItems.m
//  ScreeningMoreTag
//
//  Created by 韩新辉 on 2017/12/24.
//  Copyright © 2017年 韩新辉. All rights reserved.
//

#import "ChooseMoreItems.h"
#import "SDAutoLayout.h"
#import "ChooseAreasBase.h"
#import "ChooseModelChildren.h"

#import "Details.h"
#import "MJExtension.h"
#import "DetailsTableViewCell.h"


static NSString *DETAIL_IDENTIF = @"cellThree";

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@interface ChooseMoreItems ()<UITableViewDelegate,UITableViewDataSource>{
    
    /** tableView高度 */
    CGFloat tableViewHeight;
    
    
    NSInteger FirstSelectRow;
    NSInteger SecondSelectRow;

    

}

@property (nonatomic ,strong) UITableView * firsttableView;
@property (nonatomic ,strong) UITableView * sectiondtableView;
@property (nonatomic ,strong) UITableView * threetableView;

@property (nonatomic, strong) NSMutableArray *baseArray;/**<总的数据*/
@property (nonatomic, strong) NSMutableArray *baseFirstArray;/**<第一个tab数据*/
@property (nonatomic, strong) NSMutableArray *baseSecondArray;/**<第二个tab数据区域*/
 @property (nonatomic, strong) NSMutableArray *baseThirdArray;/**<第三个tab区域数据*/


@property (nonatomic, copy) NSString *selectSubStr;


@end



@implementation ChooseMoreItems

-(instancetype)init{
    self = [super init];
    if (self) {
         self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.67];
        tableViewHeight = [UIScreen mainScreen].bounds.size.height * 0.7 ;
        FirstSelectRow =  0;
        SecondSelectRow =  0;
    }
        return self;
}
#pragma mark - UITableViewDataSource&&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.firsttableView) {
        return self.baseFirstArray.count;
    }
    else if (tableView == self.sectiondtableView) {
             return self.baseSecondArray.count;
        
    }
    else  {
             return self.baseThirdArray.count;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.firsttableView) {
        static NSString *identifier = @"lefCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        ChooseModelChildren *baseChildren = [self.baseFirstArray objectAtIndex:indexPath.row];
        cell.textLabel.text = baseChildren.jointsName;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor blackColor];
        [cell setBackgroundColor:[UIColor whiteColor]];
        if(indexPath.row == FirstSelectRow){
            cell.textLabel.textColor =  [UIColor colorWithHex:0x06a27b];
         }
        return cell;
    }
    else if (tableView == self.sectiondtableView) {
        static NSString *centerIdentifier = @"centerCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:centerIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:centerIdentifier];
        }
        [cell setBackgroundColor:[UIColor lightGrayColor]];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor blackColor];
//        cell.textLabel.highlightedTextColor = [UIColor orangeColor];
        ChooseModelChildren *vcitem = self.baseSecondArray[indexPath.row];
    
        cell.textLabel.text = vcitem.jointsName;
        if(indexPath.row == SecondSelectRow){
            cell.textLabel.textColor = [UIColor colorWithHex:0x06a27b];
        }
       
        return cell;
    }
    else if (tableView == self.threetableView) {
        DetailsTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:DETAIL_IDENTIF];
        if (!cell) {
            cell = [[DetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DETAIL_IDENTIF];
        }
             Details *vcitem = self.baseThirdArray[indexPath.row];
            for (Details *vc in self.selectedModelArray) {
                if ([vc.uid isEqualToString:vcitem.uid]) {
//                    NSLog(@"vc.text %@---vcitem.text%@",vc.text, vcitem.text);
                    vcitem.flag = YES;
                }
            }
            cell.detailsModel = vcitem;
        
        return cell;
    }
    return [[UITableViewCell alloc]init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击了第一个tableview对应更新第二个tabview的cell个数
    if (tableView == self.firsttableView ) {
        FirstSelectRow = indexPath.row;
        SecondSelectRow = 0;

        ChooseModelChildren *model = self.baseFirstArray[indexPath.row];
        self.baseSecondArray = [ChooseModelChildren mj_objectArrayWithKeyValuesArray:model.children];
 
        ChooseModelChildren *threemodel = self.baseSecondArray[0];
         NSArray *arrayDetail = threemodel.children;
        [self.baseThirdArray removeAllObjects];
        for (int jk = 0; jk<arrayDetail.count; jk++) {
            NSDictionary *dic = arrayDetail[jk];
            Details *dv = [[Details alloc] init];
            dv.jointsName = dic[@"jointsName"];
            dv.uid = [NSString stringWithFormat:@"%@",dic[@"uid"]];
            dv.flag = NO;
            [self.baseThirdArray addObject:dv];
        }
        
        self.firsttableView.sd_layout.widthIs(SCREEN_WIDTH*0.21);
        self.sectiondtableView.sd_layout.widthIs(SCREEN_WIDTH*0.33);
        [self.firsttableView reloadData];
        [self.sectiondtableView reloadData];
        [self.threetableView reloadData];

        
    }
    
    if (tableView == self.sectiondtableView ) {
        SecondSelectRow = indexPath.row;
             [self.baseThirdArray removeAllObjects];
             ChooseModelChildren *dic = self.baseSecondArray[indexPath.row];
             NSArray *arrayDetail = dic.children;
            for (int jk = 0; jk<arrayDetail.count; jk++) {
                NSDictionary *dic = arrayDetail[jk];
                Details *dv = [[Details alloc] init];
                dv.jointsName = dic[@"jointsName"];
                dv.flag = NO;
                dv.uid = [NSString stringWithFormat:@"%@",dic[@"uid"]];

                [self.baseThirdArray addObject:dv];
            }
 
        self.firsttableView.sd_layout.widthIs(SCREEN_WIDTH*0.21);
        self.sectiondtableView.sd_layout.widthIs(SCREEN_WIDTH*0.33);
        [self.sectiondtableView reloadData];
        [self.threetableView reloadData];
    }
    
    if (tableView == self.threetableView) {
        
             Details *model =self.baseThirdArray[indexPath.row];
        [self updateSelectedItemListWithItem:model and:model.jointsName];
    }
    
}

#pragma mark - 处理第三级数据是否点击
- (void)updateSelectedItemListWithItem:(Details*)model  and:(NSString*)seleString{
    NSLog(@"seleString---->%@",seleString);
    model.flag = !model.flag;
          if (model.flag) {//选中
            [self.selectedModelArray addObject:model];
         } else {//取消
            NSMutableArray * tempArray = self.selectedModelArray;
            [tempArray mutableCopy];
            for (int i=0; i<tempArray.count; i++) {
                Details * tempModel = tempArray[i];
                if ([tempModel.uid isEqualToString:model.uid]) {
                    [tempArray removeObject:tempModel];
                     break;
                }
            }
            self.selectedModelArray = tempArray;
         }
//        NSLog(@"-----%@---------------->%@",self.selectedModelArray,);
    if(self.didSelectItem){
        self.didSelectItem(self.selectedModelArray);
    }
    [self.threetableView reloadData];
}

#pragma mark - 点击了背景
-(void)picDetail:(UITapGestureRecognizer *)tap{
  
    if (self.didRemoveFromSuperViewHandle) {
        self.didRemoveFromSuperViewHandle();
    }
}
-(void)makeViewWithData:(NSArray *)dataArray AndSelectArray:(NSArray *)SeletArray{
    
    for (NSDictionary * dic  in SeletArray) {
         Details *dv = [[Details alloc] init];
        dv.jointsName = dic[@"jointsName"];
        dv.uid = [NSString stringWithFormat:@"%@",dic[@"uid"]];
        dv.flag = YES;
        [self.selectedModelArray addObject:dv];
        
    }
    
     //        NSDictionary *childrenDic = arr[0];
    //        NSArray *childrenArr = childrenDic[@"children"];
    for (int i = 0 ; i<dataArray.count; i++) {
        NSDictionary *dic = dataArray[i];
        ChooseAreasBase *baseDic = [ChooseAreasBase mj_objectWithKeyValues:dic];
        [self.baseArray  addObject:baseDic];
    }
    
    NSLog(@"dic %@",self.baseArray);
    //        处理一级数据
    for (int j = 0; j<self.baseArray.count; j++) {
        NSDictionary *dic = self.baseArray[j];
        ChooseModelChildren *baseChildren = [ChooseModelChildren  mj_objectWithKeyValues:dic];
        [self.baseFirstArray addObject:baseChildren];
        
    }
    //        [self.baseFirstArray removeObjectAtIndex:2];// 移除"附近"数据
    
    //二级数据
    NSDictionary *seconDic = self.baseFirstArray[0];
    ChooseModelChildren *baseChildren = [ChooseModelChildren  mj_objectWithKeyValues:seconDic];
    self.baseSecondArray = [ChooseModelChildren mj_objectArrayWithKeyValuesArray:baseChildren.children];
    //    三级数据
    ChooseModelChildren *ThirdChildren = self.baseSecondArray[0];
    
//    self.baseSecondArray = [ChooseModelChildren mj_objectArrayWithKeyValuesArray:baseChildren.children];
    
    
    [self.baseThirdArray removeAllObjects];
    for (int jk = 0; jk<ThirdChildren.children.count; jk++) {
        NSDictionary *dic = ThirdChildren.children[jk];
        Details *dv = [[Details alloc] init];
        dv.jointsName = dic[@"jointsName"];
        dv.uid = [NSString stringWithFormat:@"%@",dic[@"uid"]];
        dv.flag = NO;
        [self.baseThirdArray addObject:dv];
    }

    
    self.firsttableView = [[UITableView alloc] init];
    self.firsttableView.delegate = self;
    self.firsttableView.dataSource = self;
    self.firsttableView.estimatedSectionHeaderHeight = 0;
    self.firsttableView.estimatedSectionFooterHeight = 0;
    self.firsttableView.estimatedRowHeight = 0;
    self.firsttableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview: self.firsttableView];
    self.firsttableView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).widthIs(SCREEN_WIDTH*0.21).heightIs(tableViewHeight);
    
    self.sectiondtableView = [[UITableView alloc] init];
    self.sectiondtableView.delegate = self;
    self.sectiondtableView.dataSource = self;
    self.sectiondtableView.estimatedSectionHeaderHeight = 0;
    self.sectiondtableView.estimatedSectionFooterHeight = 0;
    self.sectiondtableView.estimatedRowHeight = 0;
    self.sectiondtableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview: self.sectiondtableView];
    self.sectiondtableView.sd_layout.leftSpaceToView(self.firsttableView, 0).topSpaceToView(self, 0).widthIs(SCREEN_WIDTH*0.33).heightIs(tableViewHeight);
    
    self.threetableView = [[UITableView alloc] init];
    self.threetableView.delegate = self;
    self.threetableView.dataSource = self;
    self.threetableView.estimatedSectionHeaderHeight = 0;
    self.threetableView.estimatedSectionFooterHeight = 0;
    self.threetableView.estimatedRowHeight = 0;
    self.threetableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview: self.threetableView];
    self.threetableView.sd_layout.leftSpaceToView(self.sectiondtableView, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(tableViewHeight);
    
    //底部view
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, tableViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - tableViewHeight)];
    bottomLineView.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.35];
    
    [self addSubview:bottomLineView];
    UITapGestureRecognizer *tapThePicImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picDetail:)];
    [bottomLineView addGestureRecognizer:tapThePicImageView];
    
}
#pragma mark da数据
- (NSMutableArray *)baseArray {
    if (_baseArray == nil) {
        _baseArray = [NSMutableArray array];
     }

    return _baseArray;
}
#pragma mark 一级初始数据
- (NSMutableArray *)baseFirstArray {
    if (_baseFirstArray == nil) {
        _baseFirstArray = [NSMutableArray array];
    }
    return _baseFirstArray;
}
#pragma mark 二级初始数据
- (NSMutableArray *)baseSecondArray {
    if (_baseSecondArray == nil) {
        _baseSecondArray = [NSMutableArray array];
    }
    return _baseSecondArray;
}

#pragma mark 三级初始数据
- (NSMutableArray *)baseThirdArray {
    if (_baseThirdArray == nil) {
        _baseThirdArray = [NSMutableArray array];
    }
    return _baseThirdArray;
}
#pragma mark 选中的区域
 /**选中的model*/
- (NSMutableArray *)selectedModelArray {
    if (_selectedModelArray == nil) {
        _selectedModelArray = [NSMutableArray array];
    }
    return _selectedModelArray;
}

 @end
