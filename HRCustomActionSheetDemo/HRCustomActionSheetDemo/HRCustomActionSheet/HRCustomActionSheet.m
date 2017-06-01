//
//  HRCustomActionSheet.m
//  HRCustomActionSheetDemo
//
//  Created by Zer0 on 2017/6/1.
//  Copyright © 2017年 Zer0. All rights reserved.
//

#import "HRCustomActionSheet.h"

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_height [UIScreen mainScreen].bounds.size.height
static const CGFloat kSpace = 10;     ///< 间隔
static const CGFloat kContentViewAlpha = 0.94;      ///< 内容透明度
static NSString* const kCellReuseIdentifier = @"HRCustomActionSheet";      ///< cell的复用身份字符串

@interface HRCustomActionSheet ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *_contentAttributes;        ///< 内容的样式字典
    NSDictionary *_cancelAttributes;     ///< 取消栏的样式字典
}
@property (nonatomic, strong) UIView *maskView;     ///< 蒙版视图
@property (nonatomic, strong) UITableView *tableView;       ///< 内容选择tableView
@property (nonatomic, strong) NSArray *optionContents;     ///< 操作选择栏字符串数组
@property (nonatomic,   copy) NSString *cancelText;
@property (nonatomic, strong) UIView *headView;     ///< 头部视图（定制title）


@property (nonatomic,   copy) void(^selectedBlock)(NSInteger index);  ///< 选择选项回调block
@property (nonatomic,   copy) void(^cancelBlock)();     ///< 取消选项回调block


@end

@implementation HRCustomActionSheet

#pragma mark - Publish API
+ (void)showCustomActionSheetInContainerView:(UIView *)containerView
                         titleAttributedText:(NSAttributedString *)attributedText
                           contentAttributes:(nullable NSDictionary<NSString *, id> *)contentAttributes
                            cancelAttributes:(nullable NSDictionary<NSString *, id> *)cancelAttributes
                              optionContents:(NSArray<NSString *> *)optionContents
                                  cancelText:(NSString *)cancelText
                               selectedBlock:(void(^)(NSInteger index))selectedBlock {
    
    HRCustomActionSheet *sheetView = [[HRCustomActionSheet alloc] initWithTitleAttributedStr:attributedText
                                                                           contentAttributes:contentAttributes
                                                                            cancelAttributes:cancelAttributes
                                                                              optionContents:optionContents
                                                                                  cancelText:cancelText
                                                                               selectedBlock:selectedBlock
                                                                                 cancelBlock:nil];
    [sheetView show];
    [containerView addSubview:sheetView];
    
}

+ (void)showCustomActionSheetWithTitleAttributedText:(NSAttributedString *)attributedText
                                   contentAttributes:(nullable NSDictionary<NSString *, id> *)contentAttributes
                                    cancelAttributes:(nullable NSDictionary<NSString *, id> *)cancelAttributes
                                      optionContents:(NSArray<NSString *> *)optionContents
                                          cancelText:(NSString *)cancelText
                                       selectedBlock:(void(^)(NSInteger index))selectedBlock {

    HRCustomActionSheet *sheetView = [[HRCustomActionSheet alloc] initWithTitleAttributedStr:attributedText
                                                                           contentAttributes:contentAttributes
                                                                            cancelAttributes:cancelAttributes
                                                                              optionContents:optionContents
                                                                                  cancelText:cancelText
                                                                               selectedBlock:selectedBlock
                                                                                 cancelBlock:nil];
    [sheetView show];
    [[UIApplication sharedApplication].delegate.window addSubview:sheetView];
}

+ (void)showDefaultCustomActionSheetWithTitle:(NSString *)title
                               optionContents:(NSArray<NSString *> *)optionContents
                                selectedBlock:(void(^)(NSInteger index))selectedBlock{

    NSAttributedString *attributedText = [self buildAttributedStringWithText:title font:[UIFont boldSystemFontOfSize:15.f] color:[UIColor orangeColor]];
    
    NSDictionary *contentAttributes = [self buildAttributedsWithFontSize:16.f color:[UIColor blueColor]];
    
    NSDictionary *cancelAttributes = [self buildAttributedsWithFontSize:15.f color:[UIColor grayColor]];
    
    HRCustomActionSheet *sheetView = [[HRCustomActionSheet alloc] initWithTitleAttributedStr:attributedText
                                                                           contentAttributes:contentAttributes
                                                                            cancelAttributes:cancelAttributes
                                                                              optionContents:optionContents
                                                                                  cancelText:@"取消"
                                                                               selectedBlock:selectedBlock
                                                                                 cancelBlock:nil];
    [sheetView show];
    [[UIApplication sharedApplication].delegate.window addSubview:sheetView];
    
}

#pragma mark ############### 参数定制 ###############
+ (NSAttributedString *)buildAttributedStringWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    return [[NSAttributedString alloc] initWithString:text attributes:[self buildAttributedsWithFont:font color:color]];
}

+ (NSDictionary *)buildAttributedsWithFont:(UIFont *)font color:(UIColor *)color {
    return @{NSFontAttributeName : font,NSForegroundColorAttributeName : color};
}

+ (NSDictionary *)buildAttributedsWithFontSize:(CGFloat)fontSize color:(UIColor *)color {
    return @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName : color};
}



#pragma mark - Initialize Methods
//- (instancetype)initWithTitleView:(UIView *)titleView
//                   optionContents:(NSArray<NSString *> *)optionContents
//                      cancelTitle:(NSString *)cancelTitle
//                    selectedBlock:(void(^)(NSInteger))selectedBlock
//                      cancelBlock:(void(^)())cancelBlock {
//    if (self = [super init]) {
//        _headView = titleView;
//        _headView.backgroundColor = [UIColor colorWithWhite:1 alpha:kContentViewAlpha];
//        _optionContents = optionContents;
//        _cancelText = cancelTitle;
//        _selectedBlock = selectedBlock;
//        _cancelBlock = cancelBlock;
//        [self creatUI];
//    }
//    return self;
//}

- (instancetype)initWithTitleAttributedStr:(NSAttributedString *)attributedText
                         contentAttributes:(nullable NSDictionary<NSString *, id> *)contentAttributes
                          cancelAttributes:(nullable NSDictionary<NSString *, id> *)cancelAttributes
                            optionContents:(NSArray <NSString *>*)optionContents
                                cancelText:(NSString *)cancelText
                             selectedBlock:(void(^)(NSInteger))selectedBlock
                               cancelBlock:(void(^)())cancelBlock {
    if (self = [super init]) {
        _headView = [self buildHeaderViewByTitleAttributedString:attributedText];
        _headView.backgroundColor = [UIColor colorWithWhite:1 alpha:kContentViewAlpha];
        _optionContents = optionContents;
        _contentAttributes = contentAttributes;
        _cancelAttributes = cancelAttributes;
        _cancelText = cancelText;
        _selectedBlock = selectedBlock;
        _cancelBlock = cancelBlock;
        [self creatUI];
    }
    return self;
}

//#pragma mark ############### System Methods ###############
//
////- (void)layoutSubviews {
////    [super layoutSubviews];
////    [self show];
////}

- (void)dealloc {
    NSLog(@"HRCustomActionSheet 释放了");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    [self dismiss];
}

#pragma mark ############### Getter ###############
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
        _maskView.userInteractionEnabled = YES;
    }
    return _maskView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = 10;
        _tableView.clipsToBounds = YES;
        _tableView.rowHeight = 57.f;
        _tableView.sectionFooterHeight = kSpace;
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = self.headView;
        _tableView.separatorInset = UIEdgeInsetsMake(0, -50, 0, 0);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    }
    return _tableView;
}

#pragma mark - Custom Methods

- (void)creatUI {
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.maskView];
    [self addSubview:self.tableView];
}

- (UIView *)buildHeaderViewByTitleAttributedString:(NSAttributedString *)attributedText {
    
    CGFloat width = kScreen_Width - 20;
    CGFloat height = 44.f;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = attributedText;
    [headView addSubview:titleLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, height-0.5 , width, .5)];
    line.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [headView addSubview:line];
    
    return headView;
}

- (void)show {
    _tableView.frame = CGRectMake(kSpace, kScreen_height, kScreen_Width - (kSpace * 2), _tableView.rowHeight * (_optionContents.count + 1) + _headView.bounds.size.height + (kSpace * 2));
    [UIView animateWithDuration:.5 animations:^{
        CGRect rect = _tableView.frame;
        rect.origin.y -= _tableView.bounds.size.height;
        _tableView.frame = rect;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:.5 animations:^{
        CGRect rect = _tableView.frame;
        rect.origin.y += _tableView.bounds.size.height;
        _tableView.frame = rect;
    } completion:^(BOOL finished) {
        _selectedBlock = nil;
        _cancelBlock = nil;
        [self removeFromSuperview];
    }];
}

#pragma mark - Delegate
#pragma mark ############### <UITableViewDelegate,UITableViewDataSource> ###############
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? _optionContents.count : 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:kContentViewAlpha];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = _optionContents[indexPath.row];
        if ([_contentAttributes objectForKey:NSForegroundColorAttributeName]) {
            cell.textLabel.textColor = _contentAttributes[NSForegroundColorAttributeName];
        }
        if ([_contentAttributes objectForKey:NSFontAttributeName]) {
            cell.textLabel.font = _contentAttributes[NSFontAttributeName];
        }
        if (indexPath.row == _optionContents.count - 1) {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:
                                      CGRectMake(0, 0, kScreen_Width - (kSpace * 2), tableView.rowHeight) byRoundingCorners:
                                      UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:
                                      CGSizeMake(10, 10)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
            maskLayer.frame = cell.contentView.bounds;
            maskLayer.path = maskPath.CGPath;
            cell.layer.mask = maskLayer;
        }
    } else {
        
        cell.textLabel.text = _cancelText;
        if ([_cancelAttributes objectForKey:NSForegroundColorAttributeName]) {
            cell.textLabel.textColor = _cancelAttributes[NSForegroundColorAttributeName];
        }
        if ([_cancelAttributes objectForKey:NSFontAttributeName]) {
            cell.textLabel.font = _cancelAttributes[NSFontAttributeName];
        }
        cell.layer.cornerRadius = 10;
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.selectedBlock) {
            self.selectedBlock(indexPath.row);
        }
    } else {
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }
    
    [self dismiss];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, kSpace)];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

@end
