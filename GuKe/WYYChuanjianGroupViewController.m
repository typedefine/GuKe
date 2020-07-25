//
//  WYYChuanjianGroupViewController.m
//  GuKe
//
//  Created by yu on 2018/1/15.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYChuanjianGroupViewController.h"
#import "WYYGroupOneTableViewCell.h"
#import "WYYGroupTwoTableViewCell.h"
#import "WYYGroupThreeTableViewCell.h"
#import "WYYChoseGroupNumberViewController.h"
@interface WYYChuanjianGroupViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UITextViewDelegate>{
    UITableView *groupTableview;
    NSMutableArray *personArr;//群成员
    NSString *imgUrle;//群头像
    NSString *GroupNameStr;//群名字
    NSString *groupContent;//群描述
    
}
@property (nonatomic,strong)UITextField *nameText;
@property (nonatomic,strong)UILabel *placeLab;//
@property (nonatomic,strong)UITextView *groupTextview;//
@property (nonatomic, strong) UIImagePickerController *imagePickController;//选择图像
@property(nonatomic,strong)NSString *imageString;//个人头像 上传数据用的
@property (nonatomic,strong)UIImage *photoImg;// 个人头像  页面展示用的
@end

@implementation WYYChuanjianGroupViewController
- (UIImagePickerController *)imagePickController {
    if (!_imagePickController) {
        _imagePickController = [[UIImagePickerController alloc] init];
        
        _imagePickController.delegate = self;
        _imagePickController.allowsEditing = YES;
    }
    return _imagePickController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建团队";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    personArr = [NSMutableArray array];
    [self maktableview];
    // Do any additional setup after loading the view.
}
#pragma mark add tableview
- (void)maktableview{
    if (IS_IPGONE_X) {
        groupTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 86)style:UITableViewStyleGrouped];
    }else{
        groupTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)style:UITableViewStyleGrouped];
    }
    
    [self.view addSubview:groupTableview];
    groupTableview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    groupTableview.delegate = self;
    groupTableview.dataSource = self;
    groupTableview.tableFooterView = [[UIView alloc]init];
}
#pragma mark  建群
- (void)makeData{
    
    NSMutableArray *arrays = [NSMutableArray array];
    for (int a = 0; a < personArr.count ; a ++ ) {
        [arrays addObject:personArr[a][@"userId"]];
    }
    NSString  *groupNmuber = [arrays componentsJoinedByString:@","];
    if (groupContent.length == 0) {
        [self showHint:@"请填写群组描述！"];
        return;
    }else if (GroupNameStr.length == 0) {
        [self showHint:@"请填写群组名称！"];
        return;
    }else if(arrays.count == 0){
        [self showHint:@"请选择群成员！"];
        return;
        
    }else if ([NSString changeNullString:self.imageString].length ==0  ){
        [self showHint:@"请选择群图片"];
        return;
        
    }
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,chatgroupsadd];
    NSArray *keysArray = @[@"sessionId",@"groupname",@"desc",@"groupportrait",@"members"];
    NSArray *valueArray = @[sessionIding,GroupNameStr,groupContent,self.imageString,groupNmuber];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
        NSLog(@"建群%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshGroupList" object:nil];
        }else{
            [self showHint:data[@"message"]];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"建群%@",error);
    }];
}
#pragma mark tableview deleagte
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return 44;
    }else if (indexPath.row == 2){
        return 80;
    }else if(indexPath.row == 3){
        return 121;
    }else{
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (personArr.count == 0) {
        return 110;
    }else if (personArr.count%6 == 0) {
        return 80 * (personArr.count + 1)/6 + 30;
    }else{
        return 80 * ((personArr.count + 1)/6 + 1) + 30;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 80 * (personArr.count + 1)/6 + 30)];
    whiteView.backgroundColor = [UIColor whiteColor];
    if (personArr.count == 0) {
        whiteView.frame = CGRectMake(0, 0, ScreenWidth, 110);
    }else if (personArr.count%6 == 0) {
        whiteView.frame = CGRectMake(0, 0, ScreenWidth, 80 * (personArr.count + 1)/6 + 30);
    }else{
        whiteView.frame = CGRectMake(0, 0, ScreenWidth, 80 * ((personArr.count + 1)/6 + 1) + 30);
    }
    UILabel *labesl = [[UILabel alloc]initWithFrame:CGRectMake(10, 13, 200, 14)];
    labesl.tag = 100;
    labesl.font = [UIFont systemFontOfSize:14];
    labesl.textColor = SetColor(0x1A1A1A);
    labesl.text = [NSString stringWithFormat:@"多人聊天成员（%ld人）",personArr.count];
    [whiteView addSubview:labesl];
    
    for (int a = 0; a < personArr.count + 1 ; a ++) {
        UIImageView *images = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth/6 - 43)/2 + ScreenWidth/6* (a%6), 30 + 70 * (a/6), 43, 43)];
        images.tag = a;
        [whiteView addSubview:images];
        UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0+ a * ScreenWidth/6, CGRectGetMaxY(images.frame)+ 5 +  70 * (a/6), ScreenWidth/6, 20)];
        nameLab.textColor = greenC;
        nameLab.tag = a;
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.font = [UIFont systemFontOfSize:12];
        [whiteView addSubview:nameLab];
        if (a == personArr.count) {
            images.image = [UIImage imageNamed:@"添加图片"];
            [Utile addClickEvent:self action:@selector(didAddGroupNumber) owner:images];
            nameLab.text = @"邀请";
        }else{
            [images sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,personArr[a][@"portrait"]]] placeholderImage:[UIImage imageNamed:@"头像"]];
            nameLab.text = [NSString stringWithFormat:@"%@",personArr[a][@"name"]];
        }
        
    }
    
    
    return whiteView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(10, 150, ScreenWidth - 20, 44)];
    btns.backgroundColor = greenC;
    [btns setTitle:@"创建群组" forState:normal];
    [btns setTitleColor:[UIColor whiteColor] forState:normal];
    [backView addSubview:btns];
    btns.layer.masksToBounds = YES;
    btns.layer.cornerRadius = 22;
    [btns addTarget:self action:@selector(makeData) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btns];
    
    return backView;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"ImageOnRightCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return cell;
        
    }else if (indexPath.row == 1) {
            static NSString *cellIdone = @"cellIdone";
            WYYGroupOneTableViewCell *cellOne = [tableView dequeueReusableCellWithIdentifier:cellIdone];
            if (!cellOne) {
                cellOne = [[[NSBundle mainBundle]loadNibNamed:@"WYYGroupOneTableViewCell" owner:self options:nil] lastObject];
                cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cellOne.groupNameText.delegate = self;
        self.nameText = cellOne.groupNameText;
    
        if (GroupNameStr.length == 0) {
            
        }else{
            self.nameText.text = GroupNameStr;
        }
        self.nameText.delegate = self;
            return cellOne;
        }else if (indexPath.row == 2){
            static NSString *cellIdter = @"cellId";
            WYYGroupTwoTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:cellIdter];
            if (!cellTwo) {
                cellTwo = [[[NSBundle mainBundle]loadNibNamed:@"WYYGroupTwoTableViewCell" owner:self options:nil] lastObject];
                cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cellTwo.textViewS.delegate = self;
            self.groupTextview = cellTwo.textViewS;
            
            self.groupTextview.delegate = self;
            self.groupTextview.returnKeyType = UIReturnKeyDone;
            self.placeLab = cellTwo.plearLab;
            if (groupContent.length == 0) {
                
            }else{
                self.groupTextview.text = groupContent;
                self.placeLab.hidden = YES;
            }
            return cellTwo;
        }else{
            static NSString *cellIdter = @"cellId";
            WYYGroupThreeTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:cellIdter];
            if (!cellTwo) {
                cellTwo = [[[NSBundle mainBundle]loadNibNamed:@"WYYGroupThreeTableViewCell" owner:self options:nil] lastObject];
                cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cellTwo.GroupImg.layer.masksToBounds = YES;
            cellTwo.GroupImg.layer.cornerRadius = 22.5;
            if (imgUrle.length == 0) {
                
            }else{
                cellTwo.GroupImg.image = self.photoImg;
            }
            
            return cellTwo;
        }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
    }else if (indexPath.row == 1){
        
    }else if(indexPath.row == 2){
        
    }else{
        [self chosePhoto];
    }
}
#pragma mark  图像
- (void)chosePhoto{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更改头像" message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"拍照");
        
        [weakSelf addPicEventWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    
    UIAlertAction *pictureAction = [UIAlertAction actionWithTitle:@"从图库选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"图库");
        
        [weakSelf addPicEventWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    
    [alert addAction:photoAction];
    [alert addAction:pictureAction];
    [alert addAction:cancelAction];
    //弹出提示框；
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark -- 调用系统相机
// 调用相机
- (void) addPicEventWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    // 先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    self.imagePickController.sourceType = sourceType;
    
    [self presentViewController:self.imagePickController animated:YES completion:^{
        
    }];
}
// delegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    
    [self performSelector:@selector(saveImage:)
               withObject:image
               afterDelay:0.5];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
// 照片处理
- (void)saveImage:(UIImage *)image {
    self.photoImg = image;
    [groupTableview reloadData];
    NSData *data = UIImageJPEGRepresentation(image, proportion);
    imgUrle = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    //上传图片
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,uploadimageUpload];
    NSArray *keysArray = @[@"fromFile"];
    NSArray *valueArray = @[imgUrle];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            NSArray *arrays = [NSArray arrayWithArray:data[@"data"]];
            self.imageString = [arrays componentsJoinedByString:@","];
        }else{
            
        }
    
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    GroupNameStr = textField.text;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    GroupNameStr = textField.text;
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if(textView.text.length == 0){
        self.placeLab.text = @"";
        self.placeLab.hidden = YES;
    }else{
        
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        
    }else{
        groupContent = self.groupTextview.text;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.groupTextview resignFirstResponder];
        
        groupContent = self.groupTextview.text;
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
#pragma mark 添加群成员
- (void)didAddGroupNumber{
    WYYChoseGroupNumberViewController *group = [[WYYChoseGroupNumberViewController alloc]init];
    group.hidesBottomBarWhenPushed = YES;
    group.GroupNumberArr = personArr;
    group.backgroupnumber = ^(NSMutableArray *groupDic) {
        NSLog(@"%@",groupDic);
        [personArr removeAllObjects];
        [personArr addObjectsFromArray:groupDic];
        [groupTableview reloadData];
    };
    [self.navigationController pushViewController:group animated:NO];
    
    
    
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
