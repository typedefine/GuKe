//
//  ManageRightPopupView.m
//

#import "ManageRightPopupView.h"
#import "ManageRightPopupCell.h"

@interface ManageRightPopupView ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *confirmButton;
@property(nonatomic, assign) CGFloat height;
@property (nonatomic, weak) id<ManageRightPopupViewDelegate> delegate;
@property(nonatomic, strong) NSArray<ManageRightPopupCellModel *> *cellModelList;
@property(nonatomic, assign) NSInteger selectedIndex;

@end

@implementation ManageRightPopupView
@synthesize isShow;

//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//    if (self = [super initWithCoder:coder]) {
//        [self setupSubviews];
//    }
//    return self;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        [self setupSubviews];
//    }
//    return self;
//}
//
//- (instancetype)init
//{
//    if (self = [super init]) {
//        [self setupSubviews];
//    }
//    return self;
//}

- (instancetype)initWithDelegate:(id<ManageRightPopupViewDelegate>)delegate;
{
    if (self = [super init]) {
        _delegate = delegate;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    self.selectedIndex = -1;
    self.cellModelList = [self.delegate performSelector:@selector(itemsForPopupView:) withObject:self]?:@[];
    
    self.height = IPHONE_X_SCALE(50) * self.cellModelList.count + IPHONE_X_SCALE(65) + SAFE_AREA_BOTTOM;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:70.0f/255];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.table];
    [self.contentView addSubview:self.confirmButton];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(self.height);
    }];
    
    CGFloat h = IPHONE_X_SCALE(40);
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-IPHONE_X_SCALE(7)+SAFE_AREA_BOTTOM);
        make.right.equalTo(self.contentView).offset(-IPHONE_X_SCALE(20));
        make.left.equalTo(self.contentView).offset(IPHONE_X_SCALE(20));
        make.height.mas_equalTo(IPHONE_X_SCALE(40));
    }];
    [self.confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _confirmButton.clipsToBounds = YES;
    _confirmButton.layer.cornerRadius = h/2.0;
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(IPHONE_X_SCALE(5));
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.confirmButton.mas_top).offset(-IPHONE_X_SCALE(10));
    }];
    
}

- (void)confirmButtonAction
{
    if (self.selectedIndex < 0) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(popupView:didSelectAtIndx:)]) {
        [self.delegate popupView:self didSelectAtIndx:self.selectedIndex];
    }
    [self diss];
}

- (void)diss
{
    [self removeFromSuperview];
    isShow = NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:self];
    if (p.y < ScreenHeight-self.height) {
        [self diss];
    }
}


- (void)show
{
    if (!self.delegate || isShow) return;
    isShow = YES;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    __weak UIWindow *w = window;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(w);
    }];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.table reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellModelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ManageRightPopupCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ManageRightPopupCell class])];
    ManageRightPopupCellModel *cm = self.cellModelList[indexPath.row];
    [cell configWithData:cm];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selected = indexPath.row == self.selectedIndex;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
}


- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.rowHeight = IPHONE_X_SCALE(50);
        [_table registerClass:[ManageRightPopupCell class] forCellReuseIdentifier:NSStringFromClass([ManageRightPopupCell class])];
        _table.tableFooterView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            if (@available(iOS 13.0, *)) {
                _table.automaticallyAdjustsScrollIndicatorInsets =  NO;
            }
        }else{
        }
    }
    return _table;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.backgroundColor = greenC;
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setTitle:@"确 定" forState:UIControlStateNormal];
    }
    return _confirmButton;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _height)];
        _contentView.backgroundColor = [UIColor whiteColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds
        byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(IPHONE_X_SCALE(16), IPHONE_X_SCALE(20))];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _contentView.bounds;
        maskLayer.path = maskPath.CGPath;
        _contentView.layer.mask = maskLayer;
    }
    return _contentView;
}

@end
