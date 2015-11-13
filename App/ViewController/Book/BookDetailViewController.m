//
//  BookDetailViewController.m
//  base
//
//  Created by wsg on 15/9/8.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "BookDetailViewController.h"
#import "Part.h"
#import "Prefrence.h"
#import "BookMarkViewController.h"
@interface BookDetailViewController (){
    __weak IBOutlet UILabel *_contentLabel;
    __weak IBOutlet UIToolbar *_toolBar;
}

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self crackBookToParts];
    
    
    
//    [Prefrence saveLastPageWith:100];
//    [Prefrence saveLastPageNumberWith:0];
    
    
    
    self.countStart = [Prefrence lastPageNumber];
    self.currentPage = [Prefrence lastPage];
    NSArray *arr = [self getBookPartsFromLocal];
    self.part = arr[self.currentPage];
    self.title = self.part.title;
    NSUInteger countOfWords = [self maxNumberToContantText:[self.part.content substringFromIndex:self.countStart] isGoNext:YES];
    NSString *text = [self.part.content substringWithRange:NSMakeRange(self.countStart, countOfWords)];
    _contentLabel.text = text;
    
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changePage:)];
    swip.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swip];
    UISwipeGestureRecognizer *swip1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changePage:)];
    swip1.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swip1];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePage:)];
    [self.view addGestureRecognizer:tap];
    
    
    if ([[NSDate date] hour]>=0&&[[NSDate date] hour]<6) {
        _contentLabel.backgroundColor = [UIColor blackColor];
        _contentLabel.textColor = [UIColor darkGrayColor];
        
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"color_black"] forBarMetrics:UIBarMetricsDefault];
        [_toolBar setBackgroundImage:[UIImage imageNamed:@"color_black"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        for (UIBarButtonItem *item in _toolBar.items) {
            item.tintColor = [UIColor grayColor];
        }
    }else{
        _contentLabel.backgroundColor = [UIColor whiteColor];
        _contentLabel.textColor = [UIColor blackColor];
        
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [_toolBar setBackgroundImage:nil forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setTintColor:[UIColor greenColor]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)crackBookToParts{
    NSUInteger indexOfBook = 0;
    NSMutableString *str = [NSMutableString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"372" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *arr = [NSMutableArray new];
    {
        PartEntity *pe = [PartEntity new];
        pe.pid = @(indexOfBook);
        pe.title = @"书名";
        pe.content = [@"" mutableCopy];
        [arr addObject:pe];
    }
    
    NSArray *lines = [str componentsSeparatedByString:@"\n"];
    for (NSString *s in lines) {
        if ([s rangeOfString:@"^第.*卷.*第.*章.*$" options:NSRegularExpressionSearch].length>0) {
            indexOfBook++;
            PartEntity *pe = [PartEntity new];
            pe.pid = @(indexOfBook);
            pe.title = s;
            pe.content = [NSMutableString new];
            [arr addObject:pe];
        }else{
            PartEntity *pe = [arr lastObject];
            [pe.content appendString:s];
            [pe.content appendString:@"\n"];
        }
    }
    [self saveToDatabaseWithArr:arr];
}
-(void)saveToDatabaseWithArr:(NSArray *)arr{
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        for (PartEntity *pe in arr) {
            Part *p = [Part MR_createEntityInContext:localContext];
            p.pid = pe.pid;
            p.title = pe.title;
            p.content = pe.content;
        }
    }];
}
-(NSArray *)getBookPartsFromLocal{
    NSArray *sourceArr = [Part MR_findAllSortedBy:@"pid" ascending:YES];
    NSMutableArray *arr = [NSMutableArray new];
    for (Part *p in sourceArr) {
        PartEntity *pe = [PartEntity new];
        pe.pid = p.pid;
        NSRegularExpression * rex = [NSRegularExpression regularExpressionWithPattern:@"第.*卷.* 第(.*)$" options:NSRegularExpressionCaseInsensitive error:nil];
        [rex enumerateMatchesInString:p.title options:0 range:NSMakeRange(0, p.title.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSRange range = [result rangeAtIndex:1];
            if (range.location != NSNotFound) {
                NSString *s1 = [p.title substringWithRange:range];
                pe.title = s1;
            }
        }];
        pe.content = [p.content copy];
        [arr addObject:pe];
    }
    return arr;
}
-(NSUInteger)maxNumberToContantText:(NSString *)str isGoNext:(BOOL)isGoNext{
    UIFont *font = _contentLabel.font;
    NSUInteger lastLength = 0;
    for (int i=10; i<str.length; i++) {
        NSString *targetStr = isGoNext?[str substringToIndex:i]:[str substringFromIndex:str.length-i];
        CGSize size = [targetStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil].size;
        if (size.height<SCREEN_HEIGHT-64-44) {
            lastLength = i;
        }else{
            break;
        }
    }
    return lastLength;
}
-(void)changePage:(UISwipeGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:sender.view];
    
    if (([sender isMemberOfClass:[UISwipeGestureRecognizer class]]&&sender.direction==UISwipeGestureRecognizerDirectionLeft)||point.x>sender.view.frame.size.width/2.0f) {
        self.countStart = self.countStart+_contentLabel.text.length;
        if (_contentLabel.text.length==0) {
            self.currentPage ++;
            NSArray *arr = [self getBookPartsFromLocal];
            self.part = arr[self.currentPage];
            self.countStart = 0;
            self.title = self.part.title;
        }
        NSUInteger countOfWords = [self maxNumberToContantText:[self.part.content substringFromIndex:self.countStart] isGoNext:YES];
        NSString *text = [self.part.content substringWithRange:NSMakeRange(self.countStart, countOfWords)];
        _contentLabel.text = text;
    }else if (([sender isMemberOfClass:[UISwipeGestureRecognizer class]]&&sender.direction==UISwipeGestureRecognizerDirectionRight)||point.x<sender.view.frame.size.width/2.0f){
        NSUInteger countOfWords = [self maxNumberToContantText:[self.part.content substringToIndex:self.countStart] isGoNext:YES];
        if (countOfWords==0) {
            self.currentPage --;
            NSArray *arr = [self getBookPartsFromLocal];
            self.part = arr[self.currentPage];
            countOfWords = [self maxNumberToContantText:self.part.content isGoNext:NO];
            self.title = self.part.title;
            self.countStart = self.part.content.length;
        }
        self.countStart = self.countStart - countOfWords;
        NSString *text = [self.part.content substringWithRange:NSMakeRange(self.countStart, countOfWords)];
        _contentLabel.text = text;
    }
    
    [Prefrence saveLastPageWith:self.currentPage];
    [Prefrence saveLastPageNumberWith:self.countStart];
    if ([[NSDate date] hour]>=0&&[[NSDate date] hour]<6) {
        _contentLabel.backgroundColor = [UIColor blackColor];
        _contentLabel.textColor = [UIColor darkGrayColor];
    }else{
        _contentLabel.backgroundColor = [UIColor whiteColor];
        _contentLabel.textColor = [UIColor blackColor];
    }
    self.view.backgroundColor = _contentLabel.textColor;
}
- (IBAction)bookMark:(UIBarButtonItem *)sender {
    BookMarkViewController *vc = [[BookMarkViewController alloc]initWithNibName:@"BookMarkViewController" bundle:nil];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self transformViewControllerWithMethod:ITransformMethodPresent fromController:self targetController:nvc];
}
- (IBAction)addMark:(UIBarButtonItem *)sender {
    
}

- (IBAction)category:(UIBarButtonItem *)sender {
    
}





@end
