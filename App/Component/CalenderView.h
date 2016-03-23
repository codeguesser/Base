//
//  CalenderView.h
//  base
//
//  Created by wsg on 16/3/18.
//  Copyright © 2016年 wsg. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, CVState) {
    CVStateSilent  = 0,
    CVStateWorkday   = 1 << 0, // 00001
    CVStateToday    = 1 << 1, // 00010
    CVStateMarked    = 1 << 2, // 00100
    CVStateOuttimed    = 1 << 3, // 00100
};

/*!
 @brief 日期Entity
 */
@interface CVDayEntity:Entity
/*!
 @brief 日期
 */
@property(nonatomic,assign)BOOL isValiable;
@property(nonatomic,strong)NSDate *date;
@property(nonatomic,assign)CVState state;
@property(nonatomic,strong)void (^changeAction)();
@end
/*!
 @brief 日期中日的控件
 */
@interface CVButton:UIView{
    /*!
     @brief 那个文字
     */
    UILabel *_titleLabel;
    /*!
     @brief 那个背景
     */
    UIView *_backgroundView;
    /*!
     @brief 那个点
     */
    UIView *_dotView;
}
/*!
 @brief 根据日期生成所需的按钮
 
 @param day 日期
 
 @return
 */
+(CVButton *)defaultButtonWithDay:(CVDayEntity * )day;
/*!
 @brief 按钮被触发是事件
 */
@property(nonatomic,strong)void(^clickAction)();
/*!
 @brief 状态，选中的背景的，改变颜色的，标记的
 */
@property(nonatomic,assign)CVDayEntity * day;
@end
@interface CalenderView : UIView
/*!
 @brief 切换月事件，传回切换的月份
 */
@property(nonatomic,strong)void(^changeMonthAction)(NSDate *month);
/*!
 @brief 目标日期发生变动，返回变动之后的日期及其状态
 */
@property(nonatomic,strong)void(^changeSelectDateAction)(CVDayEntity *day);
/*!
 @brief 原始数据，所有的日期，在选择区域里，就是黑名单，非选择区域里就是白名单
 */
@property(nonatomic,strong)NSMutableIndexSet *dataSource;
/*!
 @brief 改变了日期的信息
 */
@property(nonatomic,strong)NSMutableDictionary *outtimeRange;
/*!
 @brief 初始化的月份，默认为当前月
 */
@property(nonatomic,strong)NSDate *month;
/*!
 @brief 选中的那一天
 */
@property(nonatomic,strong)NSDate *selectedDay;
/*!
 @brief 工作日
 */
@property(nonatomic,assign)NSArray *workingDays;
//
///*!
// @brief 更新单个按钮的状态，需要在当前日历处理
// 
// @param tag 目标时间的tag
// 
// @return 默认为空，找到按钮则返回这个按钮的状态
// */
//-(CVDayEntity *)updateMarkStatusWithTag:(NSUInteger)tag;
/*!
 @brief 反转按钮的工作状态，默认为空
 
 @param tag 工作的日期，也就是tag  请输入20150102
 */
-(CVDayEntity *)reverseMarkStatusWithTag:(NSUInteger)tag;

/*!
 @brief 更新日历里的修改了时间段的状态
 
 @param str   新的时间段
 @param tag   目标时间，也就是tag 如20150102
 @param compr 要比较的目标时间
 
 @return 是否获修改成功了
 */
-(BOOL)updateoutTimeWith:(NSString *)str targetTime:(NSUInteger)tag standardTime:(NSString *)compr;
@end
