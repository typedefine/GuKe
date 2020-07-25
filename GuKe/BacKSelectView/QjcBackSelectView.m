//
//  QjcBackSelectView.m
//  GuKe
//
//  Created by MYMAc on 2018/5/11.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "QjcBackSelectView.h"
#import "QjcBackSelectCell.h"
@implementation QjcBackSelectView{
   
    UITableView * _TV;
    
}

-(void)setDataArray:(NSArray *)DataArray{
    if (_DataArray == nil) {
        UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapWithSelectView:) ];
        tap.delegate = self;
        [self addGestureRecognizer:tap];

        _DataArray =[[NSArray alloc]init];
        _TV =[[UITableView alloc]initWithFrame:CGRectMake(self.width/2, self.height/2,self.width/2, self.height/2) style:UITableViewStylePlain];
        _TV.delegate = self;
        _TV.dataSource = self;
        [self addSubview:_TV];
    }
    _DataArray = DataArray;
}


-(void)tapWithSelectView:(UITapGestureRecognizer *)tap{
    self.hidden = !self.hidden;
    
}
//#pragma mark-手势代理，解决和tableview点击发生的冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableView"] ||[NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }//否则手势存在
    return YES;
}

 -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QjcBackSelectCell * cell =[tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil){
        cell =[[[NSBundle mainBundle]loadNibNamed:@"QjcBackSelectCell" owner:self options:nil] lastObject];
    }
    cell.Title.text = [self.DataArray[indexPath.row] objectForKey:@"roomName"];
    cell.time.text = [NSString stringWithFormat:@"直播时间：%@",[self.DataArray[indexPath.row] objectForKey:@"roomTime"]];
     if ([[NSString stringWithFormat:@"%@",[self.DataArray[indexPath.row] objectForKey:@"liveState"]] isEqualToString:@"0"]){
//         未开启
         cell.PlayingView.hidden = YES;
     }else{
//         直播中
         cell.PlayingView.hidden = NO;

     }
     
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.DataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(selectItemWithIndex:)]) {
        [self.delegate selectItemWithIndex:indexPath.row];
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */



@end
