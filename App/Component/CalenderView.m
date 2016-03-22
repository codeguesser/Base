//
//  CalenderView.m
//  base
//
//  Created by wsg on 16/3/18.
//  Copyright © 2016年 wsg. All rights reserved.
//

#import "CalenderView.h"
#define kCVButtonHeight 55.0f
@implementation CVButton

+(CVButton *)defaultButtonWithDay:(CVDayEntity * )day{
    CVButton *cvbt = [[CVButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    cvbt.day = day;
    return cvbt;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //crate background view
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2-15, 10, 30, 30)];
        _backgroundView.layer.masksToBounds = YES;
        _backgroundView.layer.cornerRadius = 15;
        _backgroundView.backgroundColor = [UIColor colorWithWhite:214.0/255 alpha:1];
        [self addSubview:_backgroundView];
        
        //create text
        _titleLabel = [[UILabel alloc]initWithFrame:_backgroundView.frame];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"0";
        [self addSubview:_titleLabel];
        
        //create mark
        _dotView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2-2, _backgroundView.frame.size.height+_backgroundView.frame.origin.y+3, 4, 4)];
        _dotView.backgroundColor = [UIColor colorWithWhite:214.0/255 alpha:1];
        _dotView.layer.masksToBounds = YES;
        _dotView.layer.cornerRadius = 2;
        [self addSubview:_dotView];
        
        //create clickaction
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAction)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}
-(void)touchAction{
    if (self.clickAction) {
        self.clickAction();
    };
}
/*!
 @brief 根据状态更新状态界面
 */
-(void)updateSubView{
    self.hidden = !self.day.isValiable;
    _titleLabel.text = [NSString stringWithFormat:@"%ld",(long)self.day.date.day];
    _backgroundView.backgroundColor = self.day.state & CVStateWorkday?[UIColor colorWithWhite:214.0/255 alpha:1]:[UIColor clearColor];
    if(self.day.state & CVStateMarked)_backgroundView.backgroundColor = [UIColor colorWithRed:39.0/255 green:211.0/255 blue: 144.0/255 alpha:1];
    
    _titleLabel.textColor = self.day.state & CVStateToday?[UIColor redColor]:self.day.state & CVStateWorkday||self.day.state & CVStateMarked?[UIColor whiteColor]:[UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:12.0f];
//    _dotView.hidden = !(self.day.state & CVStateMarked);
    _dotView.hidden = YES;
    if (self.superview) {
        NSDate *date = [self.day.date dateAtStartOfDay];
        NSDate *firstDate = [date dateByAddingDays:-date.day+1];
        NSUInteger offset = firstDate.weekday-2;
        float width = self.superview.frame.size.width/7;
        NSUInteger idx = (self.day.date.day+offset)%7;
        NSUInteger week = (self.day.date.day+offset)/7;
        
        self.frame = CGRectMake(0, 0, width, kCVButtonHeight);
        self.center = CGPointMake(width*idx + width/2, kCVButtonHeight*week+kCVButtonHeight/2);
        _backgroundView.frame = CGRectMake(self.frame.size.width/2-15, 10, 30, 30);
        _titleLabel.frame = _backgroundView.frame;
        _dotView.frame = CGRectMake(self.frame.size.width/2-2, _backgroundView.frame.size.height+_backgroundView.frame.origin.y+3, 4, 4);
    }
}
-(void)setDay:(CVDayEntity *)day{
    _day = day;
}
@end
@implementation CVDayEntity
-(void)setDate:(NSDate *)date{
    _date = date;
    if (self.changeAction) {
        self.changeAction();
    }
}
-(void)setState:(CVState)state{
    _state = state;
    if (self.changeAction) {
        self.changeAction();
    }
}
-(void)setIsValiable:(BOOL)isValiable{
    _isValiable = isValiable;
    if (self.changeAction) {
        self.changeAction();
    }
}
@end
#define kCalenderViewScrollPage 2
@interface CalenderView()<UIScrollViewDelegate>{
    //头部view
    UIView *_headerContentView;     //头部View
    UILabel *_headerMonthLabel;     //头部的月label
    UIButton *_headerGobackButton;  //返回上个月的按钮
    UIButton *_headerGoaheadButton; //走去下一个月的按钮
    
    //中间的不可变的星期
    UIView *_weekView;              //星期视图
    
    //主要的日期view
    UIScrollView *_mainScrollView;  //主视图，用于发起滚动
    NSMutableArray * _mainCachedDayButtons;//缓存的按钮
    NSMutableArray * _mainDisplayDayViews;//缓存的视图
    
    //额外数据处理
    NSMutableArray * _currentDataSource;//当前的数据集，防止对象消失
    NSArray *_weekDays;
}
@end
@implementation CalenderView
#pragma mark - public Init methods
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self Init];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self Init];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self Init];
        });
    }
    return self;
}

/*!
 @brief 公用初始化方法
 */
-(void)Init{
    _currentDataSource = [[NSMutableArray alloc] init];
    _mainCachedDayButtons = [NSMutableArray new];
    _mainDisplayDayViews = [NSMutableArray new];
    self.month = [NSDate date];
    self.selectedDay = [self firstDayOfMonth:[NSDate date]];
    _weekDays = @[@(NO),@(NO),@(YES),@(YES),@(YES),@(YES),@(NO)];
    self.workingDays = _weekDays;
    self.dataSource = [NSMutableIndexSet new];//第一个是黑名单，第二个是白名单
    
    
    
    
    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
    NSMutableArray *arr2 = [[NSMutableArray alloc]init];
    NSMutableArray *arr3 = [[NSMutableArray alloc]init];
    NSDate *date = [self.month dateAtStartOfDay];
    NSDate *firstDate = [date dateByAddingDays:-date.day+1];
    
    
    
    for (int i=0; i<31; i++) {
        CVDayEntity *e1 = [CVDayEntity new];
        e1.date = [firstDate dateByAddingDays:i];
        e1.state = CVStateSilent;
        [arr1 addObject:[CVButton defaultButtonWithDay:e1]];
        [_currentDataSource addObject:e1];
        
        CVDayEntity *e2 = [CVDayEntity new];
        e2.date = [firstDate dateByAddingDays:i];
        e2.state = CVStateSilent;
        [arr2 addObject:[CVButton defaultButtonWithDay:e2]];
        [_currentDataSource addObject:e2];
        
        
        CVDayEntity *e3 = [CVDayEntity new];
        e3.date = [firstDate dateByAddingDays:i];
        e3.state = CVStateSilent;
        [arr3 addObject:[CVButton defaultButtonWithDay:e3]];
        [_currentDataSource addObject:e3];
    }
    [_mainCachedDayButtons addObject:[arr1 copy]];
    [_mainCachedDayButtons addObject:[arr2 copy]];
    [_mainCachedDayButtons addObject:[arr3 copy]];
    self.backgroundColor = [UIColor colorWithWhite:247.0/255 alpha:1];
    [self setupHeader];
    [self setupWeekView];
    [self setupScrolledDate];
}
#pragma mark - pravite methods ----- 界面及其事件
/*!
 @brief 设置空间头部，文字的月份切换
 */
-(void)setupHeader{
    //头view
    _headerContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    [self addSubview:_headerContentView];
    
    //年月
    _headerMonthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _headerContentView.frame.size.width, _headerContentView.frame.size.height)];
    _headerMonthLabel.textColor = [UIColor colorWithRed:39.0/255 green:211.0/255 blue: 144.0/255 alpha:1];
    _headerMonthLabel.text = [NSString stringWithFormat:@"%ld年%ld月",(long)self.month.year,(long)self.month.month];
    _headerMonthLabel.textAlignment = NSTextAlignmentCenter;
    [_headerContentView addSubview:_headerMonthLabel];
    
    //前一个月按钮
    _headerGobackButton = [[UIButton alloc]initWithFrame:CGRectMake((_headerContentView.frame.size.height-33)/2, (_headerContentView.frame.size.height-33)/2, 33, 33)];
    _headerGobackButton.backgroundColor = [UIColor colorWithWhite:214.0/255 alpha:1];
    [_headerGobackButton setTitle:@"<" forState:0];
    [_headerGobackButton setTitleColor:[UIColor colorWithRed:39.0/255 green:211.0/255 blue: 144.0/255 alpha:1] forState:0];
    _headerGobackButton.layer.masksToBounds = YES;
    _headerGobackButton.layer.cornerRadius = 33/2.0;
    [self addSubview:_headerGobackButton];
    
    //下一个月按钮
    _headerGoaheadButton = [[UIButton alloc]initWithFrame:CGRectMake(_headerContentView.frame.size.width-(_headerContentView.frame.size.height-33)/2-33, (_headerContentView.frame.size.height-33)/2, 33, 33)];
    _headerGoaheadButton.backgroundColor = [UIColor colorWithWhite:214.0/255 alpha:1];
    [_headerGoaheadButton setTitle:@">" forState:0];
    [_headerGoaheadButton setTitleColor:[UIColor colorWithRed:39.0/255 green:211.0/255 blue: 144.0/255 alpha:1] forState:0];
    _headerGoaheadButton.layer.masksToBounds = YES;
    _headerGoaheadButton.layer.cornerRadius = 33/2.0;
    [self addSubview:_headerGoaheadButton];
    
}
-(void)setupWeekView{
    _weekView = [[UIView alloc]initWithFrame:CGRectMake(0, _headerContentView.frame.origin.y+_headerContentView.frame.size.height, self.frame.size.width, 30)];
    [self addSubview:_weekView];
    [@[@"日",@"一",@"二",@"三",@"四",@"五",@"六"] enumerateObjectsUsingBlock:^(NSString *tip, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text  = tip;
        label.textColor = [UIColor lightGrayColor];
        [_weekView addSubview:label];
        float width = _weekView.frame.size.width/7;
        label.center = CGPointMake(width*idx + width/2, _weekView.frame.size.height/2);
    }];
}
/*!
 @brief 设置滚动的日期部分，包括里面的日期按钮，包括，不动的星期部分
 */
-(void)setupScrolledDate{
    
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _weekView.frame.origin.y+_weekView.frame.size.height, self.frame.size.width, self.frame.size.height-(_weekView.frame.origin.y+_weekView.frame.size.height))];
    _mainScrollView.delegate = self;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.contentSize = CGSizeMake(_mainScrollView.frame.size.width*(kCalenderViewScrollPage*2+1), _mainScrollView.frame.size.height);
    _mainScrollView.contentOffset = CGPointMake(kCalenderViewScrollPage*_mainScrollView.frame.size.width, 0);
    NSDate *date = [self.month dateAtStartOfDay];
    NSDate *firstDate = [date dateByAddingDays:-date.day+1];
    NSUInteger offset = firstDate.weekday-2;
    for (int i=0; i<(offset+31)/7; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kCVButtonHeight*(i+1)+_mainScrollView.frame.origin.y, _mainScrollView.frame.size.width, 1)];
        view.backgroundColor = [UIColor colorWithWhite:214.0 alpha:1];
        [self addSubview:view];
    }
    
    [self addSubview:_mainScrollView];
    [self addReusedView];
}
-(void)addReusedView{
    //日期需要在这里得到初始化
    [_mainCachedDayButtons enumerateObjectsUsingBlock:^(NSArray * buttons, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(_mainScrollView.frame.size.width*(idx+kCalenderViewScrollPage-1), 0, _mainScrollView.frame.size.width, _mainScrollView.frame.size.height)];
        [self updateCalenderWithMonth:[self monthByAddingMonth:idx-1 withMonth:self.month] objects:buttons superview:v];
        [_mainScrollView addSubview:v];
        [_mainDisplayDayViews addObject:v];
    }];
}
/*!
 @brief 前往下一个月
 */
-(void)goNextMonth{
    
}
/*!
 @brief 去之前的一个月
 */
-(void)goPreviousMonth{
    
}
/*!
 @brief 滚动到的月份
 
 @param mounth 滚动到的月份
 */
-(void)scrolledToMonth:(NSDate *)mounth{
    
}
-(void)resetAllScrollViews{
    CGPoint p = _mainScrollView.contentOffset;
    if (p.x/_mainScrollView.frame.size.width-kCalenderViewScrollPage<0) {
        
        if (self.changeMonthAction) {
            self.changeMonthAction(self.month);
        }
        self.month = [self previousMonthOfDate:self.month];
        //小于0是指现在滚动到前一个页面，这个时候需要将最后一个视图转移到最前面去，同时所有的view都重置坐标
        _mainScrollView.contentOffset = CGPointMake(_mainScrollView.frame.size.width*kCalenderViewScrollPage, 0);
        [_mainDisplayDayViews insertObject:[_mainDisplayDayViews lastObject] atIndex:0];
        [_mainDisplayDayViews removeLastObject];
        
        [_mainCachedDayButtons insertObject:[_mainCachedDayButtons lastObject] atIndex:0];
        [_mainCachedDayButtons removeLastObject];
        [self updateCalenderWithMonth:[self monthByAddingMonth:-1 withMonth:self.month] objects:_mainCachedDayButtons.firstObject superview:nil];
    }else if (p.x/_mainScrollView.frame.size.width-kCalenderViewScrollPage > 0){
        
        if (self.changeMonthAction) {
            self.changeMonthAction(self.month);
        }
        //大于0是指现在滚动到后一个页面，这个时候需要将最后一个视图转移到最后面去，同时所有的view都重置坐标
        _mainScrollView.contentOffset = CGPointMake(_mainScrollView.frame.size.width*kCalenderViewScrollPage, 0);
        self.month = [self nextMonthOfDate:self.month];
        [_mainDisplayDayViews addObject:[_mainDisplayDayViews firstObject]];
        [_mainDisplayDayViews removeObjectAtIndex:0];
        
        [_mainCachedDayButtons addObject:[_mainCachedDayButtons firstObject]];
        [_mainCachedDayButtons removeObjectAtIndex:0];
        [self updateCalenderWithMonth:[self monthByAddingMonth:1 withMonth:self.month] objects:_mainCachedDayButtons.lastObject superview:nil];
    }
    [_mainDisplayDayViews enumerateObjectsUsingBlock:^(UIView * contentView, NSUInteger idx, BOOL * _Nonnull stop) {
        contentView.frame = CGRectMake(_mainScrollView.frame.size.width*(idx+kCalenderViewScrollPage-1), 0, _mainScrollView.frame.size.width, _mainScrollView.frame.size.height);
    }];
    
    //更新头部信息
    _headerMonthLabel.text = [NSString stringWithFormat:@"%ld年%ld月",(long)self.month.year,(long)self.month.month];
    
    [self changeCurrentSelectedDayFromDiffrentMonth];
}
-(void)changeCurrentSelectedDayFromDiffrentMonth{
    //更新选中的按钮
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CVDayEntity *date;
        [_mainCachedDayButtons[1] enumerateObjectsUsingBlock:^(CVButton * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.day.state & CVStateMarked) {
                if (obj.day.date.day != self.selectedDay.day) {
                    obj.day.state = [self setObject:obj.day.state forKey:CVStateMarked value:NO];
                    [obj updateSubView];
                }else{
                    date = obj.day;
                    self.selectedDay = date.date;
                }
            }else{
                if (obj.day.date.day == self.selectedDay.day) {
                    obj.day.state = [self setObject:obj.day.state forKey:CVStateMarked value:YES];
                    [obj updateSubView];
                    date = obj.day;
                    self.selectedDay = date.date;
                }
            }
        }];
        
        
        if (self.changeSelectDateAction) {
            self.changeSelectDateAction(date);
        }
    });
}
-(void)updateCalenderWithMonth:(NSDate *)theMonth objects:(NSArray *)objects superview:(UIView *)v{
    NSDate * firstDayOfMouth = [self firstDayOfMonth:theMonth];
    NSInteger countOfMonth = [self countOfMonth:theMonth];
    
    _headerGobackButton.hidden = [[self monthByAddingMonth:-1 withMonth:self.month] isEarlierThanDate:[self firstDayOfMonth:[NSDate date]]];
    
    [objects enumerateObjectsUsingBlock:^(CVButton *b, NSUInteger idx2, BOOL * _Nonnull stop) {
        if (v) {
            [v addSubview:b];
        }
        if (idx2<countOfMonth) {
            b.day.date = [firstDayOfMouth dateByAddingDays:idx2];
            b.day.state = [self setObject:b.day.state forKey:CVStateMarked value:b.day.date.day == self.selectedDay.day];
            b.day.state = [self setObject:b.day.state forKey:CVStateWorkday value:[self isWorkingDay:b.day.date]];
            b.day.state = [self setObject:b.day.state forKey:CVStateToday value:b.day.date.day==[NSDate date].day&&b.day.date.month==[NSDate date].month&&b.day.date.year==[NSDate date].year];
        }
        b.day.isValiable = idx2<countOfMonth;
        __weak CVDayEntity * weak_date = b.day;
        b.clickAction = ^{
            self.selectedDay = weak_date.date;
            [self updateCalenderWithMonth:theMonth objects:objects superview:nil];
            if (self.changeSelectDateAction) {
                self.changeSelectDateAction(weak_date);
            }
        };
        [b updateSubView];
    }];
}
-(CVDayEntity *)updateStatusWithTag:(NSUInteger)tag{
    if (_mainCachedDayButtons&&_mainCachedDayButtons.count>1&&[_mainCachedDayButtons[1] count]==31) {
        CVButton *b = _mainCachedDayButtons[1][tag%100-1];
        b.day.state = [self setObject:b.day.state forKey:CVStateWorkday value:[self isWorkingDay:b.day.date]];
        [b updateSubView];
        return b.day;
    }
    return nil;
}
-(CVState)setObject:(CVState)object forKey:(CVState)key value:(BOOL)value{
    if (value) {
        //被选中
        if(!(object&key)){
            object |= key;
        }
    }else{
        //取消选中
        if(object&key){
            object &= ~key;
        }
    }
    return object;
}
-(BOOL)isWorkingDay:(NSDate *)day{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:day];
    if ([self.workingDays[components.weekday-1] boolValue]) {
        //选中的工作日
        return ![self.dataSource containsIndex:day.year*10000+day.month*100+day.day];
    }else{
        return [self.dataSource containsIndex:day.year*10000+day.month*100+day.day];
    }
}
#pragma mark - day methods
-(NSDate *)firstDayOfMonth:(NSDate *)date{
    return [[NSDateFormatter dateFormatterWithFormat:@"yyyy-MM"] dateFromString:[NSString stringWithFormat:@"%lu-%lu",(unsigned long)date.year,(unsigned long)date.month]];
}
-(NSDate *)lastDayOfMonth:(NSDate *)date{
    NSDate *nextMounth = [self nextMonthOfDate:date];
    return [nextMounth dateByAddingDays:-1];
}
-(NSInteger)countOfMonth:(NSDate *)date{
    return [self lastDayOfMonth:date].day;
}
-(NSDate *)previousMonthOfDate:(NSDate *)day{
    return [self monthByAddingMonth:-1 withMonth:day];
}
-(NSDate *)nextMonthOfDate:(NSDate *)day{
    return [self monthByAddingMonth:1 withMonth:day];
}
-(NSDate *)monthByAddingMonth:(NSInteger)count withMonth:(NSDate *)day{
    NSUInteger mouth = day.month;
    NSUInteger year = day.year;
    year = year+count/12;
    NSInteger remainder = count%12;
    if (remainder+mouth>12) {
        year += 1;
        mouth = (remainder+mouth)%12;
    }else if (remainder+mouth<1){
        year -= 1;
        mouth = (remainder+mouth)%12;
    }else{
        mouth = remainder+mouth;
    }
    if (mouth==0) {
        mouth = 12;
    }
    return [[NSDateFormatter dateFormatterWithFormat:@"yyyy-MM"] dateFromString:[NSString stringWithFormat:@"%lu-%lu",(unsigned long)year,(unsigned long)mouth]];
}
#pragma mark - delegate for scrollview methods
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //再次抓取时的事件，抓取时，是否有动画
    if (scrollView.isDecelerating) {
        [self resetAllScrollViews];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //减速结束，意味着动画结束，也是更改的时候
    [self resetAllScrollViews];
}
#pragma mark - public methods

@end
