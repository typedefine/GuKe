//
//  ZJNMRSharesTableViewCell.m
//  MrBone_PatientProject
//
//  Created by 朱佳男 on 2018/1/20.
//  Copyright © 2018年 ShangYuKeJi. All rights reserved.
//

#import "ZJNMRSharesTableViewCell.h"
#import "ZJNMRSharesCollectionViewCell.h"
static NSString *cellid = @"cellID";
@interface ZJNMRSharesTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *showDataArr;
}
@property (nonatomic ,assign)ZJNMRSharesTableViewCellType type;
@end
@implementation ZJNMRSharesTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(ZJNMRSharesTableViewCellType)type{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _type = type;
        showDataArr = [NSMutableArray array];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((ScreenWidth-70)/6.0, (ScreenWidth-70)/6.0+30);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0) collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerNib:[UINib nibWithNibName:@"ZJNMRSharesCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellid];
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self);
        }];
    }
    return self;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_type == 0) {
        return showDataArr.count;
    }else{
        return showDataArr.count+1;
    }
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJNMRSharesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    
    if (_type == 0) {
        NSDictionary *dic = showDataArr[indexPath.row];
        NSString *imagePathStr = dic[@"portrait"];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,imagePathStr]] placeholderImage:[UIImage imageNamed:@"default_img"]];
        cell.nameLabel.text = dic[@"doctorName"];
        cell.deleteImageView.hidden = YES;
    }else{
        if (indexPath.row<showDataArr.count) {
            NSDictionary *dic = showDataArr[indexPath.row];
            NSString *imagePathStr = dic[@"portrait"];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,imagePathStr]] placeholderImage:[UIImage imageNamed:@"default_img"]];
            cell.nameLabel.text = dic[@"doctorName"];
            cell.deleteImageView.hidden = NO;
        }else{
            cell.imageView.image = [UIImage imageNamed:@"添加icon"];
            cell.nameLabel.text = nil;
            cell.deleteImageView.hidden = YES;
        }
    }

    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_type == 1) {
        if (indexPath.row<showDataArr.count) {
            [showDataArr removeObjectAtIndex:indexPath.row];
            [collectionView reloadData];
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteSharesDoctorWithArray:)]) {
                [self.delegate deleteSharesDoctorWithArray:showDataArr];
            }
        }else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(zjnMRSharesTableViewaddSharesDoctor)]) {
                [self.delegate zjnMRSharesTableViewaddSharesDoctor];
            }
        }
    }
}
-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [showDataArr removeAllObjects];
    [showDataArr addObjectsFromArray:_dataArray];
    [self.collectionView reloadData];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
