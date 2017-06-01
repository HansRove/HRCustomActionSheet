//
//  HRCustomActionSheet.h
//  HRCustomActionSheetDemo
//
//  Created by Zer0 on 2017/6/1.
//  Copyright © 2017年 Zer0. All rights reserved.
//


// github: https://github.com/HansRove/HRCustomActionSheetDemo


//TODO: 未来可以定制titleView样式，甚至cell内容样式


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HRCustomActionSheet : UIView

#pragma mark ############### 类展示方法 ###############
/**
 * 展示一个默认的ActionSheet (展示在containerView)
 * containerView：需要展示在哪个容器视图中
 * titleAttributedText： 富文本标题
 * contentAttributes： 内容Attributes 字典
 * cancelAttributes： 取消Attributes 字典
 * optionContents: 操作栏的显示字符串数组
 * cancelText： 取消text定制  也可以不叫“取消”
 * selectedBlock： 选择操作栏回调（对应optionsArr）
 */
+ (void)showCustomActionSheetInContainerView:(UIView *)containerView
                         titleAttributedText:(NSAttributedString *)attributedText
                           contentAttributes:(nullable NSDictionary<NSString *, id> *)contentAttributes
                            cancelAttributes:(nullable NSDictionary<NSString *, id> *)cancelAttributes
                                     optionContents:(NSArray<NSString *> *)optionContents
                                  cancelText:(NSString *)cancelText
                               selectedBlock:(void(^)(NSInteger index))selectedBlock;
/**
 * 展示一个默认的ActionSheet (展示在window)
 * titleAttributedText： 富文本标题
 * contentAttributes： 内容Attributes 字典
 * cancelAttributes： 取消Attributes 字典
 * optionContents: 操作栏的显示字符串数组
 * cancelText： 取消text定制  也可以不叫“取消”
 * selectedBlock： 选择操作栏回调（对应optionsArr)
 */
+ (void)showCustomActionSheetWithTitleAttributedText:(NSAttributedString *)attributedText
                                   contentAttributes:(nullable NSDictionary<NSString *, id> *)contentAttributes
                                    cancelAttributes:(nullable NSDictionary<NSString *, id> *)cancelAttributes
                                      optionContents:(NSArray<NSString *> *)optionContents
                                          cancelText:(NSString *)cancelText
                                       selectedBlock:(void(^)(NSInteger index))selectedBlock;

/**
 * 展示一个默认的ActionSheet (展示在window)，内部定义了你需要的attributes, 可以修改定制成你公司的需要
 * title： tipsTitle
 * optionContents: 操作栏的显示字符串数组
 * selectedBlock： 选择操作栏回调（对应options）
 */
+ (void)showDefaultCustomActionSheetWithTitle:(NSString *)title
                               optionContents:(NSArray<NSString *> *)optionContents
                                selectedBlock:(void(^)(NSInteger index))selectedBlock;

#pragma mark - 定制上面参数方法
/**
    * 根据字体，颜色配置参数attributedText
    * font：字体
    * color： 字体颜色
 */
+ (NSAttributedString *)buildAttributedStringWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color;
/**
 * 根据字体大小，颜色配置参数Attributes
 * font：字体
 * color： 字体颜色
 */
+ (NSDictionary *)buildAttributedsWithFont:(UIFont *)font color:(UIColor *)color;

/**
 * 根据字体大小，颜色配置参数Attributes
 * fontSize：字体大小 (默认使用系统字体： 定制字体【加粗，斜体】用上一个方法)
 * color： 字体颜色
 */
+ (NSDictionary *)buildAttributedsWithFontSize:(CGFloat)fontSize color:(UIColor *)color;



@end

NS_ASSUME_NONNULL_END
