//
//  DuiBiViewController.m
//  GuKe
//
//  Created by yu on 2017/8/14.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "DuiBiViewController.h"

#import <MediaPlayer/MediaPlayer.h>
#import "MWPhotoBrowser.h"
@interface DuiBiViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,MWPhotoBrowserDelegate>{
    UITableView *duibiTable;
    NSMutableArray *imgHuaYanArr;
    NSMutableArray *imgXGuangArr;
    NSMutableArray *imgTiWeiArr;
    NSMutableArray *shipinArr;
    NSDictionary *infoDic;
    NSDictionary *dicaOne;
    NSDictionary *dicaTwo;
    
    NSMutableArray *publicArr;//图片数组
    MPMoviePlayerViewController *moviePlayerController;
    
    NSArray *PhotoImageArr;
    NSArray *VideoPathArr;
    
    NSMutableArray *fourArr;
    NSMutableArray *fourArrimg;
    
}

@end

@implementation DuiBiViewController

- (void)viewDidLoad {
    [super viewDidLoad];//患者跟踪对比
    self.title = @"患者跟踪对比";
    
    // 1.把返回文字的标题设置为空字符串(A和B都是UIViewController)
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    publicArr = [NSMutableArray array];
    imgHuaYanArr = [NSMutableArray array];
    imgXGuangArr = [NSMutableArray array];
    imgTiWeiArr = [NSMutableArray array];
    shipinArr = [NSMutableArray array];
    
    [self makeAddTableview];
    [self makeDuiBiData];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 我的患者--随访记录 --对比内容
- (void)makeDuiBiData{
    NSString *hopitals = [[NSUserDefaults standardUserDefaults] objectForKey:@"hospitalnumbar"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,patientpatient_compare];
    NSArray *keysArray = @[@"sessionid",@"fristid",@"twoid",@"hospumid"];
    NSArray *valueArray = @[sessionIding,self.strOne,self.strTwo,hopitals];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"对比内容%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            infoDic = [NSDictionary dictionaryWithDictionary:data[@"data"][@"info"]];
            dicaOne = [NSDictionary dictionaryWithDictionary:data[@"data"][@"frist"]];
            dicaTwo = [NSDictionary dictionaryWithDictionary:data[@"data"][@"two"]];
            [imgHuaYanArr addObjectsFromArray:dicaOne[@"hyimages"]];
            [imgXGuangArr addObjectsFromArray:dicaOne[@"ximages"]];
            [imgTiWeiArr addObjectsFromArray:dicaOne[@"twimages"]];
            
            [shipinArr addObjectsFromArray:dicaOne[@"videos"]];
            
            NSArray *publicOneAae = [NSArray arrayWithArray:dicaOne[@"videos"]];
            
            fourArr = [NSMutableArray array];
            for (NSDictionary *disafa in publicOneAae) {
                NSString *pathss = [NSString stringWithFormat:@"%@%@",imgPath,[disafa objectForKey:@"path"]];
                NSURL * url = [NSURL URLWithString:pathss];
                UIImage * imageing = [Utile imageWithMediaURL:url];
                [fourArr addObject:imageing];
            }
            
            [publicArr addObjectsFromArray:imgHuaYanArr];
            [imgXGuangArr addObjectsFromArray:dicaTwo[@"ximages"]];
            [imgHuaYanArr addObjectsFromArray:dicaTwo[@"hyimages"]];
            [imgTiWeiArr addObjectsFromArray:dicaTwo[@"twimages"]];
            [shipinArr addObjectsFromArray:dicaTwo[@"videos"]];
            
            NSArray *publicOneAs = [NSArray arrayWithArray:dicaTwo[@"videos"]];
            fourArrimg = [NSMutableArray array];
            for (NSDictionary *disafa in publicOneAs) {
                NSString *pathss = [NSString stringWithFormat:@"%@%@",imgPath,[disafa objectForKey:@"path"]];
                NSURL * url = [NSURL URLWithString:pathss];
                UIImage * imageing = [Utile imageWithMediaURL:url];
                [fourArrimg addObject:imageing];
            }

        }
        
        [duibiTable reloadData];
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"对比内容%@",error);
    }];

}
#pragma mark add tableview
- (void)makeAddTableview{
    duibiTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)style:UITableViewStyleGrouped];
    duibiTable.delegate = self;
    duibiTable.dataSource = self;
    duibiTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:duibiTable];
}
#pragma mark tableview delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
        UIView *heardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        
        UIImageView * greenImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 2, 16)];
        greenImg.image = [UIImage imageNamed:@"矩形-6"];
        [heardView addSubview:greenImg];
        NSArray *arrays = [NSArray arrayWithObjects:@"化验单",@"X光",@"体位照",@"步态小视频", nil];
        UILabel *titlLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(greenImg.frame)+ 10, 12, 100, 20)];
        titlLab.text = [NSString stringWithFormat:@"%@",arrays[section-1]];
        titlLab.font = Font14;
        titlLab.textColor = SetColor(0x1a1a1a);
        [heardView addSubview:titlLab];
        return heardView;

        
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else{
        return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 70;
    }else{
        return 190+190;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellTwo= @"cellTwo";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTwo];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        NSString *genderStr = [NSString stringWithFormat:@"%@",infoDic[@"gender"]];
        NSString *gender;
        if ([genderStr isEqualToString:@"1"]) {
            gender = @"男";
        }else if ([genderStr isEqualToString:@"0"]){
            gender = @"女";
        }else{
            gender = @"";
        }
        
        UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 20)];
        nameLab.font = Font14;
        nameLab.textColor = titColor;
        nameLab.text = [NSString stringWithFormat:@"患者信息：%@    %@    %@岁",[NSString changeNullString:infoDic[@"patientName"]],gender,[NSString changeNullString:[NSString stringWithFormat:@"%@",infoDic[@"age"]]]];
        [cell.contentView addSubview:nameLab];
        
        UILabel *numLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 200, 20)];
        numLab.text = [NSString stringWithFormat:@"住院号：%@",[NSString changeNullString:infoDic[@"hospNum"]]];
        numLab.font = Font14;
        numLab.textColor = titColor;
        [cell.contentView addSubview:numLab];
    }else if(indexPath.section == 1){
        UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 30)];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.backgroundColor = greenC;
//        timeLab.font = Font14;
        timeLab.text = [NSString stringWithFormat:@"%@图片",[NSString changeNullString:dicaOne[@"time"]]];
        timeLab.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:timeLab];
        
        UIScrollView *scrollOne = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 40, ScreenWidth - 20, 140)];
        scrollOne.delegate = self;
        [cell.contentView addSubview:scrollOne];
        NSArray *publicOneArr = [NSArray arrayWithArray:dicaOne[@"hyimages"]];
        for (int a = 0; a < publicOneArr.count; a ++ ) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0 +((ScreenWidth - 20)/2 + 2)* a ,0, (ScreenWidth - 20)/2, 140)];
            [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,publicOneArr[a][@"path"]]] placeholderImage:[UIImage imageNamed:@"default_img"]];
            img.tag = a;
            [Utile addClickEvent:self action:@selector(showImageView:) owner:img];
            img.clipsToBounds = YES;
            img.contentMode = UIViewContentModeScaleAspectFill;
            [scrollOne addSubview:img];
        }
        scrollOne.contentSize = CGSizeMake(((ScreenWidth - 20)/2 + 2)* publicOneArr.count,0);
        scrollOne.pagingEnabled = YES;

        UILabel *timeTwoLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 +180,ScreenWidth - 20, 30)];
        timeTwoLab.textAlignment = NSTextAlignmentCenter;
        timeTwoLab.backgroundColor = greenC;
        timeTwoLab.text = [NSString stringWithFormat:@"%@图片",[NSString changeNullString:dicaTwo[@"time"]]];
        timeTwoLab.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:timeTwoLab];
        
        UIScrollView *scrolTwo = [[UIScrollView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(timeTwoLab.frame), ScreenWidth - 20, 140)];
        scrolTwo.delegate = self;
        [cell.contentView addSubview:scrolTwo];
        NSArray *publicTwoArr = [NSArray arrayWithArray:dicaTwo[@"hyimages"]];
        for (int a = 0; a < publicTwoArr.count; a ++) {
            UIImageView *imgTwo = [[UIImageView alloc]initWithFrame:CGRectMake( 0 + ((ScreenWidth - 20)/2 + 2)* a, 0, (ScreenWidth - 20)/2, 140)];
            [imgTwo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,publicTwoArr[a][@"path"]]] placeholderImage:[UIImage imageNamed:@"default_img"]];
            imgTwo.tag = a;
            [Utile addClickEvent:self action:@selector(showImageTwoView:) owner:imgTwo];
            imgTwo.clipsToBounds = YES;
            imgTwo.contentMode = UIViewContentModeScaleAspectFill;
            [scrolTwo addSubview:imgTwo];
        }
        scrolTwo.contentSize = CGSizeMake(((ScreenWidth - 20)/2 + 2)*publicTwoArr.count,0);
        scrolTwo.pagingEnabled = YES;

    }else if (indexPath.section == 2){
        UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 30)];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.backgroundColor = greenC;
        timeLab.text = [NSString stringWithFormat:@"%@图片",[NSString changeNullString:dicaOne[@"time"]]];
        timeLab.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:timeLab];
        
        UIScrollView *scrollOne = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 40, ScreenWidth - 20, 140)];
        scrollOne.delegate = self;
        [cell.contentView addSubview:scrollOne];
        NSArray *publicOneAa = [NSArray arrayWithArray:dicaOne[@"ximages"]];
        for (int a = 0; a < publicOneAa.count; a ++ ) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0 +((ScreenWidth - 20)/2 + 2)* a ,0, (ScreenWidth - 20)/2, 140)];
            [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,publicOneAa[a][@"path"]]] placeholderImage:[UIImage imageNamed:@"default_img"]];
            img.tag = a;
            [Utile addClickEvent:self action:@selector(showImageView:) owner:img];
            img.clipsToBounds = YES;
            img.contentMode = UIViewContentModeScaleAspectFill;
            [scrollOne addSubview:img];
        }
        scrollOne.contentSize = CGSizeMake(((ScreenWidth - 20)/2 + 2)* publicOneAa.count,0);
        scrollOne.pagingEnabled = YES;
        
        UILabel *timeTwoLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 +180,ScreenWidth - 20, 30)];
        timeTwoLab.textAlignment = NSTextAlignmentCenter;
        timeTwoLab.backgroundColor = greenC;
        timeTwoLab.text = [NSString stringWithFormat:@"%@图片",[NSString changeNullString:dicaTwo[@"time"]]];
        timeTwoLab.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:timeTwoLab];
        
        
        UIScrollView *scrolTwo = [[UIScrollView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(timeTwoLab.frame), ScreenWidth - 20, 140)];
        scrolTwo.delegate = self;
        [cell.contentView addSubview:scrolTwo];
        NSArray *publicOneAb = [NSArray arrayWithArray:dicaTwo[@"ximages"]];
        for (int a = 0; a < publicOneAb.count; a ++) {
            UIImageView *imgTwo = [[UIImageView alloc]initWithFrame:CGRectMake( 0 + ((ScreenWidth - 20)/2 + 2)* a, 0, (ScreenWidth - 20)/2, 140)];
            [imgTwo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,publicOneAb[a][@"path"]]] placeholderImage:[UIImage imageNamed:@"default_img"]];
            imgTwo.tag = a;
            [Utile addClickEvent:self action:@selector(showImageTwoView:) owner:imgTwo];

            imgTwo.clipsToBounds = YES;
            imgTwo.contentMode = UIViewContentModeScaleAspectFill;
            [scrolTwo addSubview:imgTwo];
        }
        scrolTwo.contentSize = CGSizeMake(((ScreenWidth - 20)/2 + 2)*publicOneAb.count,0);
        scrolTwo.pagingEnabled = YES;

    }else if (indexPath.section == 3){
        UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 30)];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.backgroundColor = greenC;
        timeLab.text = [NSString stringWithFormat:@"%@图片",[NSString changeNullString:dicaOne[@"time"]]];
        timeLab.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:timeLab];
        
        UIScrollView *scrollOne = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 40, ScreenWidth - 20, 140)];
        scrollOne.delegate = self;
        [cell.contentView addSubview:scrollOne];
        
        NSArray *publicOneAae = [NSArray arrayWithArray:dicaOne[@"twimages"]];
        for (int a = 0; a < publicOneAae.count; a ++ ) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0 +((ScreenWidth - 20)/2 + 2)* a ,0, (ScreenWidth - 20)/2, 140)];
            [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,publicOneAae[a][@"path"]]] placeholderImage:[UIImage imageNamed:@"default_img"]];
            img.tag = a;
            [Utile addClickEvent:self action:@selector(showImageView:) owner:img];
            
            img.clipsToBounds = YES;
            img.contentMode = UIViewContentModeScaleAspectFill;
            [scrollOne addSubview:img];
        }
        scrollOne.contentSize = CGSizeMake(((ScreenWidth - 20)/2 + 2)* publicOneAae.count,0);
        scrollOne.pagingEnabled = YES;
        
        UILabel *timeTwoLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 +180,ScreenWidth - 20, 30)];
        timeTwoLab.textAlignment = NSTextAlignmentCenter;
        timeTwoLab.backgroundColor = greenC;
        timeTwoLab.text = [NSString stringWithFormat:@"%@图片",[NSString changeNullString:dicaTwo[@"time"]]];
        timeTwoLab.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:timeTwoLab];
        
        
        UIScrollView *scrolTwo = [[UIScrollView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(timeTwoLab.frame), ScreenWidth - 20, 140)];
        scrolTwo.delegate = self;
        [cell.contentView addSubview:scrolTwo];
        
        NSArray *publicOneAs = [NSArray arrayWithArray:dicaTwo[@"twimages"]];
        for (int a = 0; a < publicOneAs.count; a ++) {
            UIImageView *imgTwo = [[UIImageView alloc]initWithFrame:CGRectMake( 0 + ((ScreenWidth - 20)/2 + 2)* a, 0, (ScreenWidth - 20)/2, 140)];
            [imgTwo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,publicOneAs[a][@"path"]]] placeholderImage:[UIImage imageNamed:@"default_img"]];
            imgTwo.tag = a;
            [Utile addClickEvent:self action:@selector(showImageTwoView:) owner:imgTwo];

            imgTwo.clipsToBounds = YES;
            imgTwo.contentMode = UIViewContentModeScaleAspectFill;
            [scrolTwo addSubview:imgTwo];
        }
        scrolTwo.contentSize = CGSizeMake(((ScreenWidth - 20)/2 + 2)*publicOneAs.count,0);
        scrolTwo.pagingEnabled = YES;

    }else{
        UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 30)];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.backgroundColor = greenC;
        timeLab.text = [NSString stringWithFormat:@"%@图片",[NSString changeNullString:dicaOne[@"time"]]];
        timeLab.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:timeLab];
        
        UIScrollView *scrollOne = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 40, ScreenWidth - 20, 140)];
        scrollOne.delegate = self;
        [cell.contentView addSubview:scrollOne];
        
        for (int a = 0; a < fourArr.count; a ++ ) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0 +((ScreenWidth - 20)/2 + 2)* a ,0, (ScreenWidth - 20)/2, 140)];
            img.image = fourArr[a];
            img.tag = a;
            [Utile addClickEvent:self action:@selector(showImageView:) owner:img];
            
            img.clipsToBounds = YES;
            img.contentMode = UIViewContentModeScaleAspectFill;
            [scrollOne addSubview:img];
        }
        scrollOne.contentSize = CGSizeMake(((ScreenWidth - 20)/2 + 2)* fourArr.count,0);
        scrollOne.pagingEnabled = YES;
        
        UILabel *timeTwoLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 +180,ScreenWidth - 20, 30)];
        timeTwoLab.textAlignment = NSTextAlignmentCenter;
        timeTwoLab.backgroundColor = greenC;
        timeTwoLab.text = [NSString stringWithFormat:@"%@图片",[NSString changeNullString:dicaTwo[@"time"]]];
        timeTwoLab.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:timeTwoLab];
        
        
        UIScrollView *scrolTwo = [[UIScrollView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(timeTwoLab.frame), ScreenWidth - 20, 140)];
        scrolTwo.delegate = self;
        [cell.contentView addSubview:scrolTwo];
        
        for (int a = 0; a < fourArrimg.count; a ++) {
            UIImageView *imgTwo = [[UIImageView alloc]initWithFrame:CGRectMake( 0 + ((ScreenWidth - 20)/2 + 2)* a, 0, (ScreenWidth - 20)/2, 140)];
            imgTwo.image = fourArrimg[a];
            imgTwo.tag = a;
            [Utile addClickEvent:self action:@selector(showImageTwoView:) owner:imgTwo];

            imgTwo.clipsToBounds = YES;
            imgTwo.contentMode = UIViewContentModeScaleAspectFill;
            [scrolTwo addSubview:imgTwo];
        }
        scrolTwo.contentSize = CGSizeMake(((ScreenWidth - 20)/2 + 2)*fourArrimg.count,0);
        scrolTwo.pagingEnabled = YES;

    }
    return cell;
}

-(void)showImageView:(UIGestureRecognizer *)recognizer{
    UIImageView *imag = (UIImageView *)recognizer.view;
    
    UITableViewCell *cell = (UITableViewCell *)[imag superview].superview.superview;
    NSIndexPath *indexpath = [duibiTable indexPathForCell:cell];
    
    if (indexpath.section == 4) {
        PhotoImageArr = [NSArray arrayWithArray:[dicaOne objectForKey:@"videos"]];
        
        NSString *localPath = [NSString stringWithFormat:@"%@%@",imgPath,PhotoImageArr[imag.tag][@"path"]];
        NSURL *videoURL = [NSURL URLWithString:localPath];
        moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
        [moviePlayerController.moviePlayer prepareToPlay];
       // moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        [self presentViewController:moviePlayerController animated:NO completion:nil];

    }else{
        if (indexpath.section == 1) {
            PhotoImageArr = [NSArray arrayWithArray:[dicaOne objectForKey:@"hyimages"]];
        }else if (indexpath.section == 2){
            PhotoImageArr = [NSArray arrayWithArray:[dicaOne objectForKey:@"ximages"]];
        }else if(indexpath.section == 3){
            PhotoImageArr = [NSArray arrayWithArray:[dicaOne objectForKey:@"twimages"]];
        }
        
        MWPhotoBrowser *brower = [[MWPhotoBrowser alloc]initWithDelegate:self];
        brower.displayActionButton = NO;
        brower.displayNavArrows = NO;
        brower.displaySelectionButtons = NO;
        brower.zoomPhotosToFill = NO;
        brower.enableSwipeToDismiss = YES;
        [brower setCurrentPhotoIndex:imag.tag];
        [self.navigationController pushViewController:brower animated:NO];
    }

}
- (void)showImageTwoView:(UIGestureRecognizer *)recognizer{
    UIImageView *imag = (UIImageView *)recognizer.view;
    
    UITableViewCell *cell = (UITableViewCell *)[imag superview].superview.superview;
    NSIndexPath *indexpath = [duibiTable indexPathForCell:cell];
    
    if (indexpath.section == 4) {
        PhotoImageArr = [NSArray arrayWithArray:[dicaTwo objectForKey:@"videos"]];
        NSString *localPath = [NSString stringWithFormat:@"%@%@",imgPath,PhotoImageArr[imag.tag][@"path"]];
        NSURL *videoURL = [NSURL URLWithString:localPath];
        moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
        [moviePlayerController.moviePlayer prepareToPlay];
       // moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        [self presentViewController:moviePlayerController animated:NO completion:^{
            
        }];
    }else{
        if (indexpath.section == 1) {
            PhotoImageArr = [NSArray arrayWithArray:[dicaTwo objectForKey:@"hyimages"]];
        }else if (indexpath.section == 2){
            PhotoImageArr = [NSArray arrayWithArray:[dicaTwo objectForKey:@"ximages"]];
        }else if(indexpath.section == 3){
            PhotoImageArr = [NSArray arrayWithArray:[dicaTwo objectForKey:@"twimages"]];
        }
        
        
        MWPhotoBrowser *brower = [[MWPhotoBrowser alloc]initWithDelegate:self];
        brower.displayActionButton = NO;
        brower.displayNavArrows = NO;
        brower.displaySelectionButtons = NO;
        brower.zoomPhotosToFill = NO;
        brower.enableSwipeToDismiss = YES;
        [brower setCurrentPhotoIndex:imag.tag];
        [self.navigationController pushViewController:brower animated:NO];
    }

}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return PhotoImageArr.count;
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
 
    NSString * photimageStr  =[NSString stringWithFormat:@"%@",PhotoImageArr[index][@"path"]];
    if ([photimageStr containsString:imgPath]) {
    }else{
        photimageStr = [NSString stringWithFormat:@"%@%@",imgPath,photimageStr];
    }
    
    photimageStr = [photimageStr stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"imgs"];

    MWPhoto *photot  = [MWPhoto photoWithURL:[NSURL URLWithString:photimageStr]];
    
    return photot;
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
