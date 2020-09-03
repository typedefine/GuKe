//
//  PatientInfoController.h
//  GuKe
//
//  Created by 莹宝 on 2020/8/31.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PatientInfoController : UIViewController

@property (nonatomic, copy, nonnull) NSString *sessionid;
@property (nonatomic, copy, nonnull) NSString *hospnumId;
@property (nonatomic, copy) NSString *nickname;

@end

NS_ASSUME_NONNULL_END
