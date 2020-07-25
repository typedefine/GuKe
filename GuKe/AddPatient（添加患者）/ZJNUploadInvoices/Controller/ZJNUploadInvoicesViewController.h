//
//  ZJNUploadInvoicesViewController.h
//  GuKe
//
//  Created by 朱佳男 on 2017/10/9.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJNAddPatientRequestModel.h"
typedef enum {
    UploadInvoicesFromAddPatient = 0,//添加患者
    UploadInvoicesFromAddFollow_UP,//添加患者随访记录
    UploadInvoicesFromChangePatient,
    UploadInvoicesFromChangeFollow_UP,
    UploadInvoicesFromChangePatientImage
}UploadInvoicesType;
@interface ZJNUploadInvoicesViewController : UIViewController
@property (nonatomic ,assign)UploadInvoicesType type;
@property (nonatomic ,strong)NSMutableDictionary *fInfoDic;//添加随访记录基本信息字典
@property (nonatomic ,strong)ZJNAddPatientRequestModel *infoModel;
@property (nonatomic ,strong)NSArray *hyArr;
@property (nonatomic ,strong)NSArray *xgArr;
@property (nonatomic ,strong)NSArray *twArr;
@property (nonatomic ,strong)NSArray *videoArr;
@property (nonatomic ,strong)NSString *checkID;//随访主键id
@property (nonatomic ,strong) void(^reloadDataBlock)();
-(instancetype)initWithUploadInvoicesType:(UploadInvoicesType)type;


@end
