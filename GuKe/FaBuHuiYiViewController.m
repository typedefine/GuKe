//
//  FaBuHuiYiViewController.m
//  GuKe
//
//  Created by yu on 2017/8/18.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "FaBuHuiYiViewController.h"
#import "HuiYiChoseView.h"
#import "PhotoChoseView.h"
#import "ZYQAssetPickerController.h"
#import "MWPhotoBrowser.h"
#import "TZImagePickerController.h"
@interface FaBuHuiYiViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HuiYiViewDelegate,ChoseViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,MWPhotoBrowserDelegate,TZImagePickerControllerDelegate>{
    UITableView *fabuTableview;
    
    NSString *meetingName;//会议标题
    NSString *beginTime;//开始时间
    NSString *speakerUser;//主讲人
    NSString *site;//会议地点
    NSString *image;//会议图片
    NSString *content;//新闻描述
    
    
    UITextField *filedone;
    UITextField *filedTwo;
    UITextField *filedThree;
    UITextView *contentText;
    
    
    
    UIView *_backWindowView;
    UIImagePickerController *imgPicker;//拍照
    
    NSMutableArray *imgArr;//存放照片的数组
    
    UILabel *plaerLab;//群公告下面输入框的占位符

    MWPhotoBrowser *browser;
}
@property (nonatomic,strong)HuiYiChoseView *DatePick;
@property (nonatomic,strong)PhotoChoseView *ChoseView;
@end

@implementation FaBuHuiYiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布会议";
    meetingName = @"";
    beginTime = @"";
    speakerUser = @"";
    site = @"";
    content = @"";

    imgArr = [NSMutableArray array];
    [self makeAddTableview];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark add table
- (void)makeAddTableview{
    fabuTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 50) style:UITableViewStyleGrouped];
    fabuTableview.delegate = self;
//    fabuTableview.scrollEnabled = NO;
    fabuTableview.dataSource = self;
    fabuTableview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:fabuTableview];
    
    UIButton *tijiaoBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, ScreenHeight - 64 - 60, ScreenWidth - 20, 44)];
    tijiaoBtn.backgroundColor = greenC;
    [tijiaoBtn setTitle:@"提交" forState:normal];
    tijiaoBtn.layer.masksToBounds = YES;
    [tijiaoBtn setTitleColor:[UIColor whiteColor] forState:normal];
    tijiaoBtn.layer.cornerRadius = 20;
    tijiaoBtn.titleLabel.font = Font15;
    [tijiaoBtn addTarget:self action:@selector(didTijiaoButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tijiaoBtn];
}

#pragma mark 提交
- (void)didTijiaoButton{
    if (imgArr.count> 0) {
        NSMutableArray *imageStringArr = [NSMutableArray array];
        for (int i = 0; i <imgArr.count; i ++) {
            NSData *data = UIImageJPEGRepresentation([Utile fixOrientation:imgArr[i]], proportion);
            NSString *imageString = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            [imageStringArr addObject:imageString];
        }
        NSString *path = [imageStringArr componentsJoinedByString:@","];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,uploadimageUpload];
        NSArray *keysArray = @[@"fromFile"];
        NSArray *valueArray = @[path];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
        [self showHudInView:self.view hint:nil];
        [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
            NSLog(@"图片上传%@",data);
            NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
            if ([retcode isEqualToString:@"0"]) {
                NSArray *array = [NSArray arrayWithArray:data[@"data"]];
                NSString *pathss = [array componentsJoinedByString:@","];
                [self makeTiJiaodata:pathss];
                
            }else{
                [self hideHud];
                [self showHint:@"提交失败请重试"];
            }
            
        } failure:^(NSError *error) {
            [self hideHud];
            NSLog(@"图片上传%@",error);
        }];
    }else{
        NSString *pathing = [NSString stringWithFormat:@""];
        [self makeTiJiaodata:pathing];
    }
}
- (void)makeTiJiaodata:(NSString *)paths{
    
    //start
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,meetingsave];
    NSArray *keysArray = @[@"sessionid",@"meetingName",@"beginTime",@"image",@"speakerUser",@"site",@"content"];
    NSArray *valueArray = @[sessionIding,meetingName,beginTime,paths,speakerUser,site,content];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"发布会议%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            [self.navigationController popViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshHuiYiList" object:nil];
        }else{
            
        }
        [self showHint:data[@"message"]];
        [self hideHud];
    } failure:^(NSError *error) {
        [self showHint:@"提交失败！"];
        [self hideHud];
        NSLog(@"发布会议%@",error);
    }];
    //end

}
#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else{
        
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 4) {
            return 80;
        }else{
            return 44;
        }
        
    }else{
        if ((imgArr.count + 1)%4 == 0) {
            return ((ScreenWidth - 60)/4 + 20) * (imgArr.count + 1)/4 + 15;
        }else{
            return ((ScreenWidth - 60)/4 + 20) * ((imgArr.count + 1)/4 + 1)+ 15;
        }
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
        UIView *heardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        
        UIImageView * greenImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 2, 16)];
        greenImg.image = [UIImage imageNamed:@"矩形-6"];
        [heardView addSubview:greenImg];
        UILabel *titlLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(greenImg.frame)+ 10, 12, 100, 20)];
        titlLab.text = [NSString stringWithFormat:@"上传照片"];
        titlLab.font = Font14;
        titlLab.textColor = SetColor(0x1a1a1a);
        [heardView addSubview:titlLab];
        
        CGRect whiteRect = [titlLab boundingRectWithInitSize:titlLab.frame.size];
        titlLab.frame  = CGRectMake(CGRectGetMaxX(greenImg.frame)+ 10, 12,whiteRect.size.width, 20);
        
        if (section == 1 ) {
            UIImageView *images = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titlLab.frame) + 5, 15, 18, 16)];
            images.image = [UIImage imageNamed:@"上传图片123"];
            [heardView addSubview:images];
        }

        return heardView;

    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellThree= @"cellThree";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellThree];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        NSArray *titArr = [NSArray arrayWithObjects:@"标题",@"主讲人",@"时间",@"地址",@"新闻描述", nil];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",titArr[indexPath.row]];
        cell.textLabel.font = Font14;
        cell.textLabel.textColor = SetColor(0x1a1a1a);
        if (indexPath.row == 0) {
            filedone = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth - 200, 0, 190, 40)];
            filedone.textColor = detailTextColor;
            filedone.font = Font14;
            filedone.placeholder = @"请输入您的会议标题";
            [filedone setValue:detailTextColor forKeyPath:@"_placeholderLabel.textColor"];
            
            filedone.delegate = self;
            filedone.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:filedone];
            
            if ([Utile stringIsNil:meetingName]) {
                
            }else{
                filedone.text = meetingName;
            }
        }else if (indexPath.row == 1){
            filedTwo = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth - 200, 0, 190, 40)];
            filedTwo.textColor = detailTextColor;
            filedTwo.font = Font14;
            filedTwo.placeholder = @"请输入主讲人姓名";
            
            [filedTwo setValue:detailTextColor forKeyPath:@"_placeholderLabel.textColor"];
            
            filedTwo.delegate = self;
            filedTwo.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:filedTwo];
            
            if ([Utile stringIsNil:speakerUser]) {
                
            }else{
                filedTwo.text = speakerUser;
            }
        }else if(indexPath.row == 2){
            UILabel *labTwo = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 200, 0, 190, 40)];
            labTwo.textColor = detailTextColor;
            labTwo.textAlignment = NSTextAlignmentRight;
            labTwo.font = Font14;
            [cell.contentView addSubview:labTwo];
            
            if ([Utile stringIsNil:beginTime]) {
                labTwo.text = @"请输入会议时间";
                
            }else{
                
                labTwo.text = beginTime;
            }
        }else if(indexPath.row == 3){
            filedThree = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth - 200, 0, 190, 40)];
            filedThree.textColor = detailTextColor;
            filedThree.font = Font14;
            filedThree.placeholder = @"请输入会议地点";
            [filedThree setValue:detailTextColor forKeyPath:@"_placeholderLabel.textColor"];
            
            filedThree.delegate = self;
            filedThree.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:filedThree];
            
            if ([Utile stringIsNil:site]) {
                
            }else{
                filedThree.text = site;
            }

        }else{
            
            contentText = [[UITextView alloc]initWithFrame:CGRectMake(120, 10, ScreenWidth - 130, 60)];
            contentText.textColor = detailTextColor;
            contentText.font = Font14;
            contentText.delegate = self;
            contentText.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:contentText];
            
            plaerLab = [[UILabel alloc]init];
            plaerLab.textColor = [UIColor grayColor];
            plaerLab.frame = CGRectMake(0, 10, ScreenWidth - 130, 20);
            plaerLab.font = [UIFont systemFontOfSize:14];
            plaerLab.textAlignment = NSTextAlignmentRight;
            plaerLab.backgroundColor = [UIColor clearColor];
            [contentText addSubview:plaerLab];
            
            if ([Utile stringIsNil:content]) {
                plaerLab.text = [NSString stringWithFormat:@"请输入新闻描述"];
            }else{
               // plaerLab.text = [NSString stringWithFormat:@"请输入新闻描述"];
                contentText.text = content;
            }
        }
    }else{
        for (int a = 0; a < imgArr.count + 1; a ++) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(12 + ((ScreenWidth - 60)/4 + 12)*(a %4), 12 + ((ScreenWidth - 60)/4 + 12)*(a/4), (ScreenWidth - 60)/4, (ScreenWidth - 60)/4)];
            img.layer.masksToBounds = YES;
            img.layer.cornerRadius = 2;
            img.clipsToBounds = YES;
            img.contentMode = UIViewContentModeScaleAspectFill;
            [cell.contentView addSubview:img];
            
            UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(12 + (ScreenWidth - 60)/4 +  ((ScreenWidth - 60)/4 + 12)*(a %4) - 10, 2 + ((ScreenWidth - 60)/4 + 12)*(a/4), 20, 20)];
            deleteBtn.tag = 10 + a;
            img.tag = 20+a;
            [deleteBtn addTarget:self action:@selector(didDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:deleteBtn];
            
            if (a == imgArr.count) {
                deleteBtn.hidden = YES;
                img.image = [UIImage imageNamed:@"上传图片"];
                [Utile addClickEvent:self action:@selector(previewImageViewButtonClick:) owner:img];
            }else{
                [deleteBtn setBackgroundImage:[UIImage imageNamed:@"删"] forState:normal];
                img.image = imgArr[a];
                [Utile addClickEvent:self action:@selector(showImage:) owner:img];
            }
        }

    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            [filedone resignFirstResponder];
            [filedTwo resignFirstResponder];
            [self didTimeButton];
        }
    }
}
#pragma mark 添加 图片按钮
-(void)previewImageViewButtonClick:(UIGestureRecognizer *)recognizer{
    NSLog(@"******");
    [self makeChosePhoto];
}
#pragma mark 图片上面的删除按钮点击事件
- (void)didDeleteButton:(UIButton *)sender{
    [imgArr removeObjectAtIndex:sender.tag- 10];
    [fabuTableview reloadData];
    
    NSLog(@"%ld",(long)sender.tag);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    UITableViewCell *cell = (UITableViewCell *)[textField superview].superview;
    NSIndexPath *indexpath = [fabuTableview indexPathForCell:cell];
    if (indexpath.section == 0) {
        if (indexpath.row == 0) {
            meetingName = textField.text;
        }else if (indexpath.row == 1){
            speakerUser = textField.text;
        }else if (indexpath.row == 3){
            site = textField.text;
        }
    }else if (indexpath.section == 1){
    }
}


#pragma mark textview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    plaerLab.text = @"";
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@""]) {
        plaerLab.text = @"请输入新闻描述";
        textView.textColor =[UIColor grayColor];
    }else{
        plaerLab.text = @"";
        content = textView.text;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [contentText resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
#pragma mark 开始时间
- (void)didTimeButton{
    if(_DatePick==nil){
        _backWindowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight)];
        _backWindowView.backgroundColor = [UIColor blackColor];
        _backWindowView.alpha = 0.5;
        
        
        [self.view addSubview:_backWindowView];
        _DatePick = [HuiYiChoseView datePickerChoseView];
        _DatePick.delegate = self;
        _DatePick.frame= CGRectMake(0, ScreenHeight - 64, ScreenWidth, 184);
        [self.view addSubview:_DatePick];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _DatePick.frame = CGRectMake(0, ScreenHeight-184 - 64, ScreenWidth, 184);
        } completion:^(BOOL finished) {
        }];
        
    }else{
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_backWindowView removeFromSuperview];
            _backWindowView = nil;
            _DatePick.frame = CGRectMake(0, ScreenHeight - 64, ScreenWidth, 184);
        } completion:^(BOOL finished) {
            [_DatePick removeFromSuperview];
            _DatePick = nil;
        }];
    }
    
}
- (void)getViewcancel{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _DatePick.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 184);
    } completion:^(BOOL finished) {
        [self.DatePick removeFromSuperview];
        self.DatePick = nil;
    }];
    
}
- (void)getSelectViewDate:(NSString *)date{
    beginTime = [NSString stringWithFormat:@"%@", date];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _DatePick.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 184);
    } completion:^(BOOL finished) {
        [self.DatePick removeFromSuperview];
        self.DatePick = nil;
    }];
    
    [fabuTableview reloadData];
}
#pragma mark  选择照片
- (void)makeChosePhoto{
    if(_ChoseView==nil){
        _backWindowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight)];
        _backWindowView.backgroundColor = [UIColor blackColor];
        _backWindowView.alpha = 0.5;
        [self.view addSubview:_backWindowView];
        _ChoseView = [PhotoChoseView makeAddButton];
        _ChoseView.delegate = self;
        _ChoseView.frame= CGRectMake(0, ScreenHeight - 64, ScreenWidth, 160);
        [self.view addSubview:_ChoseView];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _ChoseView.frame = CGRectMake(0, ScreenHeight-184 - 64, ScreenWidth, 184);
        } completion:^(BOOL finished) {
        }];
        
    }else{
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_backWindowView removeFromSuperview];
            _backWindowView = nil;
            _ChoseView.frame = CGRectMake(0, ScreenHeight - 64, ScreenWidth, 160);
        } completion:^(BOOL finished) {
            [self.ChoseView removeFromSuperview];
            self.ChoseView = nil;
        }];
    }
    
}
#pragma 头像 从系统相册选择按钮
- (void)makeSelectBtnOne{
    
    TZImagePickerController *tzController = [[TZImagePickerController alloc]initWithMaxImagesCount:16-imgArr.count delegate:self];
    tzController.allowPreview = YES;
    tzController.allowPickingVideo = NO;
    tzController.allowPickingGif = NO;
    tzController.allowPickingOriginalPhoto = NO;
    [tzController setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [imgArr addObjectsFromArray:photos];
        [fabuTableview reloadData];
    }];
    
    [self presentViewController:tzController animated:NO completion:^{
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_backWindowView removeFromSuperview];
            _backWindowView = nil;
            _ChoseView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 160);
        } completion:^(BOOL finished) {
            [_ChoseView removeFromSuperview];
            _ChoseView = nil;
        }];
    }];
}

#pragma 头像 拍照按钮
- (void)makeSelectBtnTwo{
    if (!imgPicker) {
        imgPicker = [[UIImagePickerController alloc]init];
    }
    imgPicker.delegate = self;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imgPicker animated:YES completion:^{
        
    }];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _ChoseView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 160);
    } completion:^(BOOL finished) {
        [self.ChoseView removeFromSuperview];
        self.ChoseView = nil;
    }];
    
}
#pragma 头像 取消按钮
- (void)makeSelectBtnThree{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _ChoseView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 160);
    } completion:^(BOOL finished) {
        [self.ChoseView removeFromSuperview];
        self.ChoseView = nil;
    }];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *imgage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [imgArr addObject:imgage];
    
    [fabuTableview reloadData];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)picker{
    NSLog(@"到达上限");
}
#pragma mark--预览图片
-(void)showImage:(UIGestureRecognizer *)recognizer{
    UIImageView *imageView = (UIImageView *)recognizer.view;
    browser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    browser.hidesBottomBarWhenPushed = YES;
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill = NO;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:imageView.tag-20];
    [self.navigationController pushViewController:browser animated:NO];
}
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return imgArr.count;
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
 
    NSString * photimageStr  =[NSString stringWithFormat:@"%@",imgArr[index]];
    if ([photimageStr containsString:imgPath]) {
    }else{
        photimageStr = [NSString stringWithFormat:@"%@%@",imgPath,photimageStr];
    }
    MWPhoto *photot = [MWPhoto photoWithURL:[NSURL URLWithString:photimageStr]];

    return photot;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
