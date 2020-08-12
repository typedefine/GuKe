//
//  PatientBookReplyModel.h
//  GuKe
//
//  Created by 莹宝 on 2020/8/12.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "GJObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface PatientBookInfoStateModel : GJObject

@property (nonatomic, copy) NSString *isreply;//回复记录的状态    1已回复 0未回复
@property (nonatomic, copy) NSString *replyTime;//回复记录的回复时间

@end

NS_ASSUME_NONNULL_END
