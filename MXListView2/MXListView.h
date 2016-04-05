//
//  MXListView.h
//  MXListView2
//
//  Created by IOS_HMX on 16/4/5.
//  Copyright © 2016年 humingxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MXListViewDelegate;
@protocol MXListViewDataSource;

typedef NS_ENUM(NSInteger, MXListViewSelectionStyle) {
    MXListViewSelectionStyleNone,
    MXListViewSelectionStyleGray,
};

@interface MXListView : UIView<UIAppearance>

@property(nonatomic, assign)id<MXListViewDataSource>dataSource;
@property(nonatomic, assign)id<MXListViewDelegate>delegate;
@property(nonatomic, assign)CGFloat columnWidth;
@property(nonatomic, assign)CGFloat rowHeight;
@property(nonatomic, strong)UIColor *backgroundColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong)UIColor *separatorColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, assign)MXListViewSelectionStyle selectionStyle;
@property(nonatomic, strong)UIColor *selectionColor;
@property(nonatomic, readonly)UIScrollView *contentScrollView;
- (void)reloadData ;
- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation ;
@end
@protocol MXListViewDelegate <NSObject>

@optional
- (void)listView:(MXListView *)listView didSelectedRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)listView:(MXListView *)listView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)listView:(MXListView *)listView widthForCulumnAtIndex:(NSInteger)index;
- (CGFloat)listView:(MXListView *)listView heightForHeaderInSection:(NSInteger)section;
- (UIView *)listView:(MXListView *)listView reuseViewForHeader:(UIView *)reuseView inSection:(NSInteger)section inColumn:(NSInteger)inColumn;


//以下两个方法未实现
- (UIView *)listView:(MXListView *)listView viewForFooterInSection:(NSInteger)section;
- (CGFloat)listView:(MXListView *)listView heightForFooterInSection:(NSInteger)section;

@end

@protocol MXListViewDataSource <NSObject>

@required
- (NSInteger)listView:(MXListView *)listView numberOfRowsInSection:(NSInteger)section;
- (NSInteger)numberOfColumnsEachRowInListView:(MXListView *)listView ;
- (UIView *)listView:(MXListView *)listView reuseView:(UIView *)reuseView indexPath:(NSIndexPath *)indexPath inColumn:(NSInteger)inColumn;

@optional
- (NSInteger)numberOfSectionsInListView:(MXListView *)listView;


//以下两个方法未实现
- (NSString *)listView:(MXListView *)listView titleForHeaderInSection:(NSInteger)section;
- (NSString *)listView:(MXListView *)listView titleForFooterInSection:(NSInteger)section;

@end