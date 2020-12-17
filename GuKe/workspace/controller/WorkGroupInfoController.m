//
//  WorkGroupInfoController.m
//  GuKe
//
//  Created by yb on 2020/12/13.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkGroupInfoController.h"
#import "GroupMembersView.h"
#import "WorkGroupInfoPageModel.h"

@interface WorkGroupInfoController ()<GroupMembersViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UITextView *nameView;
@property (nonatomic, strong) UITextView *desView;
@property (nonatomic, strong) GroupMembersView *membersView;
@property (nonatomic, strong) WorkGroupInfoPageModel *pageModel;

@end

@implementation WorkGroupInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"工作组介绍";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubViews];
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
//    [self loadData];
}

- (void)setupSubViews
{
    self.scrollView.frame = self.view.bounds;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.topView];
    [self.topView addSubview:self.nameView];
    [self.topView addSubview:self.desView];
    
    [self.scrollView addSubview:self.middleView];
    [self.middleView addSubview:self.membersView];
        
    [self setDisplayViewColor:defaultBlankTextColor];
    
    CGRect f = CGRectMake(20, 10, ScreenWidth-40, 30);
    self.nameView.frame = f;
    
    f.origin.y += f.size.height + 15;
    f.size.height = 40;
    self.desView.frame = f;
    
    self.topView.frame = CGRectMake(0, 0, ScreenWidth, f.size.height + f.origin.y + 70);
    
    f.origin.y += f.size.height + 25;
    f.size.height = IPHONE_Y_SCALE(167);
    self.middleView.frame = f;
    self.membersView.frame = CGRectMake(18, IPHONE_Y_SCALE(15), f.size.width-36, f.size.height-IPHONE_Y_SCALE(30));
    
}

- (void)setDisplayViewColor:(UIColor *)color
{
    self.nameView.backgroundColor = color;
    self.desView.backgroundColor = color;
}

- (void)loadData
{
    [self.pageModel configareWithData:nil];
    [self setDisplayViewColor:[UIColor clearColor]];
    self.nameView.text  = self.pageModel.name;
    
    CGRect f = self.desView.frame;
    f.size.height = [Tools sizeOfText:self.pageModel.des andMaxSize:CGSizeMake(f.size.width, CGFLOAT_MAX) andFont:self.desView.font].height + 15;
    self.desView.frame = f;
    self.desView.text = self.pageModel.des;
    
    self.topView.frame = CGRectMake(0, 0, ScreenWidth, f.size.height + f.origin.y + 70);
    
    f.origin.y += f.size.height + 25;
    f.size = self.middleView.frame.size;
    self.middleView.frame = f;
//    [self.membersView configureWithTarget:self action:@selector(viewMembersAction:) members:self.pageModel.members];
    [self.membersView reloadData];
}


- (NSString *)titleInMemberView:(GroupMembersView *)membersView
{
    return @"工作组成员";
}

-(CGSize)itemSizeInMemberView:(GroupMembersView *)membersView
{
    return CGSizeMake(IPHONE_X_SCALE(35), IPHONE_X_SCALE(35));
}

- (CGFloat)minimumLineSpacingInMemberView:(GroupMembersView *)membersView
{
    return IPHONE_Y_SCALE(19);
}

- (CGFloat)minimumInteritemSpacingInMemberView:(GroupMembersView *)membersView
{
    return IPHONE_X_SCALE(18);
}

- (NSArray<UserInfoModel *> *)membersInView:(GroupMembersView *)membersView
{
    return self.pageModel.members;
}

- (void)memberView:(GroupMembersView *)membersView didSelectAtIndex:(NSInteger)index
{
    
}

//- (void)viewMembersAction:(NSString *)memberId
//{
//    if ([memberId isEqualToString:@"all"]) {
//        NSLog(@"查看全部医生");
//
//    }else{
//        NSLog(@"查看医生%@",memberId);
//    }
//}



- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = SetColor(0xEDF1F4);
        _scrollView.bounces = YES;
    }
    return _scrollView;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = greenC;
    }
    return _topView;
}

- (UIView *)middleView
{
    if (!_middleView) {
        _middleView = [[UIView alloc] init];
        _middleView.backgroundColor = [UIColor whiteColor];
        _middleView.clipsToBounds = YES;
        _middleView.layer.cornerRadius = 5.0f;
    }
    return _middleView;
}


- (UITextView *)nameView
{
    if (!_nameView) {
        _nameView = [[UITextView alloc] init];
        _nameView.textColor = [UIColor whiteColor];
        _nameView.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    }
    return _nameView;
}

- (UITextView *)desView
{
    if (!_desView) {
        _desView = [[UITextView alloc] init];
        _desView.textColor = [UIColor whiteColor];
        _desView.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    }
    return _desView;
}

- (GroupMembersView *)membersView
{
    if (!_membersView) {
        _membersView = [[GroupMembersView alloc] init];//WithFrame:CGRectMake(20, 20, ScreenWidth-40, IPHONE_Y_SCALE(130))
        _membersView.delegate = self;
    }
    return _membersView;
}

- (WorkGroupInfoPageModel *)pageModel
{
    if (!_pageModel) {
        _pageModel = [[WorkGroupInfoPageModel alloc] init];
//        _pageModel.name = self.name;
    }
    return _pageModel;
}


@end
