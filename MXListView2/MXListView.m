//
//  MXListView.m
//  MXListView2
//
//  Created by IOS_HMX on 16/4/5.
//  Copyright © 2016年 humingxing. All rights reserved.
//

#import "MXListView.h"


static const NSInteger kSubViewTags = 1000;
static const CGFloat kRowHeightDefault = 44.;
static const CGFloat kColumnWidthDefault = 88.;

static inline CGFloat GetWidth(CGRect frame);
static inline CGFloat GetHeight(CGRect frame);

CGFloat GetWidth(CGRect frame){
    return CGRectGetWidth(frame);
}
CGFloat GetHeight(CGRect frame){
    return CGRectGetHeight(frame);
}

@interface MXListViewCell : UITableViewCell
@property(nonatomic, strong)NSIndexPath *indexPath;
@end
@implementation MXListViewCell



@end
@interface MXListView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIScrollView *scrollView;

@end
@implementation MXListView
-(void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}
#pragma mark - initialize
-(instancetype)init
{
    return [self initWithFrame:CGRectZero];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat height = GetHeight(self.frame);
    CGFloat width = GetWidth(self.frame);
    self.scrollView.frame = CGRectMake(0, 0, width, height);
    self.scrollView.contentSize = CGSizeMake([self scrollViewContentSize], height);
    self.tableView.frame = CGRectMake(0, 0, [self scrollViewContentSize], height);
    [self.tableView reloadData];
    
}
-(void)initialize
{
    self.rowHeight = kRowHeightDefault;
    self.columnWidth = kColumnWidthDefault;
    self.selectionStyle = MXListViewSelectionStyleGray;
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.tableView];
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator =
    self.tableView.showsHorizontalScrollIndicator  =
    self.tableView.showsVerticalScrollIndicator    = NO;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        self.tableView.layoutMargins = UIEdgeInsetsZero;
    }
    
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(listView:didSelectedRowAtIndexPath:)]) {
        [self.delegate listView:self didSelectedRowAtIndexPath:indexPath];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(listView:heightForRowAtIndexPath:)]) {
        return [self.delegate listView:self heightForRowAtIndexPath:indexPath];
    }
    return self.rowHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(listView:heightForHeaderInSection:)]) {
        return [self.delegate listView:self heightForHeaderInSection:section];
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(listView:reuseViewForHeader:inSection:inColumn:)]) {
        static NSString *headerId = @"headerId";
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
        if (!headerView) {
            headerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:headerId];
            headerView.backgroundView = [[UIView alloc]init];
            headerView.backgroundView.backgroundColor =
            headerView.contentView.backgroundColor    = [UIColor clearColor];
        }
        
        NSInteger numberOfColumn = [self.dataSource numberOfColumnsEachRowInListView:self];
        CGFloat x=0;
        for (int column=0; column<numberOfColumn; column++) {
            UIView *view = [headerView.contentView viewWithTag:kSubViewTags+column];
            view = [self.delegate listView:self reuseViewForHeader:view inSection:section inColumn:column];
            view.tag = kSubViewTags + column;
            view.frame = CGRectMake(x, 0, [self columnWidthInColumn:column], [self.delegate listView:self heightForHeaderInSection:section]);
            x += [self columnWidthInColumn:column];
            if (!view.superview) {
                [headerView.contentView addSubview:view];
            }
        }
        [headerView.contentView bringSubviewToFront:[headerView.contentView viewWithTag:kSubViewTags]];
        return headerView;
        
    }
    return nil;
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInListView:)]) {
        return [self.dataSource numberOfSectionsInListView:self];
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource listView:self numberOfRowsInSection:section];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellIdentifier";
    MXListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MXListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.contentView.backgroundColor  =
        cell.backgroundColor              = [UIColor clearColor];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        if (self.selectionStyle == MXListViewSelectionStyleNone) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else
        {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        if (self.selectionColor) {
            UIView *view = [[UIView alloc]init];
            view.backgroundColor = self.selectionColor;
            cell.selectedBackgroundView = view;
        }
        
    }
    cell.indexPath = indexPath;
    NSInteger numberOfColumns = [self.dataSource numberOfColumnsEachRowInListView:self];
    if (numberOfColumns >1) {
        
        CGFloat x=0;
        for (int column=0; column<numberOfColumns; column++) {
            UIView *view = [cell.contentView viewWithTag:kSubViewTags+column];
            view = [self.dataSource listView:self reuseView:view indexPath:indexPath inColumn:column];
            view.tag = kSubViewTags+column;
            view.frame = CGRectMake(x, 0, [self columnWidthInColumn:column], [self rowHeightAtIndexPath:indexPath]);
            x+= [self columnWidthInColumn:column];
#pragma 优化
            if (!view.superview) {
                [cell.contentView addSubview:view];
            }
            
            
        }
        [cell.contentView bringSubviewToFront:[cell.contentView viewWithTag:kSubViewTags]];
    }
    return cell;
}
#pragma mark - public
-(void)reloadData
{
    [self.tableView reloadData];
}
-(void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self.tableView reloadSections:sections withRowAnimation:animation];
}
-(void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}
#pragma mark - private
/**
 *  当所有的column的宽度加起来小于listView 的宽度时,给每一个column一个额外的宽度，使之等于listView 的宽度
 */
-(CGFloat)fixedSpace
{
    CGFloat space = 0.0;
    CGFloat total = 0.0;
    NSInteger numberOfColumns = [self.dataSource numberOfColumnsEachRowInListView:self];
    for (int column=0; column<numberOfColumns; column++) {
        total += [self.delegate respondsToSelector:@selector(listView:widthForCulumnAtIndex:)]?[self.delegate listView:self widthForCulumnAtIndex:column]:self.columnWidth;
    }
#pragma 优化
    if (total < GetWidth(self.frame)) {
        space = (GetWidth(self.frame)-total)/numberOfColumns;
    }
    return space;
}
-(CGFloat)columnWidthInColumn:(NSInteger)inColumn
{
    if ([self.delegate respondsToSelector:@selector(listView:widthForCulumnAtIndex:)]) {
        return [self fixedSpace] + [self.delegate listView:self widthForCulumnAtIndex:inColumn];
    }else
        return [self fixedSpace] + self.columnWidth;
}
-(CGFloat)rowHeightAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(listView:heightForRowAtIndexPath:)]) {
        return [self.delegate listView:self heightForRowAtIndexPath:indexPath];
    }else
        return self.rowHeight;
}
-(CGFloat)scrollViewContentSize
{
    CGFloat total = 0.0;
    NSInteger numberOfColumns = [self.dataSource numberOfColumnsEachRowInListView:self];
    for (int column=0; column<numberOfColumns; column++) {
        total += [self columnWidthInColumn:column];
    }
    return total;
}
#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"])
    {
        NSArray *visibleCells = [self.tableView visibleCells];
        NSMutableSet *sectionSet = [[NSMutableSet alloc]init];
        for (MXListViewCell *cell in visibleCells) {
            [sectionSet addObject:@(cell.indexPath.section)];
            UIView *fixedView = [cell.contentView viewWithTag:kSubViewTags];
            if (fixedView) {
                CGRect frame = fixedView.frame;
                frame.origin.x = self.scrollView.contentOffset.x;
                fixedView.frame = frame;
            }
        }
        for (NSNumber *section in sectionSet) {
            UITableViewHeaderFooterView *headerView = [self.tableView headerViewForSection:[section integerValue]];
            UIView *fixedView = [headerView viewWithTag:kSubViewTags];
            if (fixedView) {
                CGRect frame = fixedView.frame;
                frame.origin.x = self.scrollView.contentOffset.x;
                fixedView.frame = frame;
            }
        }
        UIView *refreshHeaderView = [self.tableView valueForKey:@"mj_header"];
        UIView *refreshFooterView = [self.tableView valueForKey:@"mj_footer"];
        if (!refreshFooterView) {
            refreshFooterView = [self.tableView valueForKey:@"footer"];
        }
        if (!refreshHeaderView) {
            refreshHeaderView = [self.tableView valueForKey:@"header"];
        }
        if (refreshHeaderView) {
            CGRect frame = refreshHeaderView.frame;
            frame.origin.x = self.scrollView.contentOffset.x;
            frame.size.width = GetWidth(self.frame);
            refreshHeaderView.frame = frame;
        }
        if (refreshFooterView) {
            CGRect frame = refreshFooterView.frame;
            frame.size.width = GetWidth(self.frame);
            frame.origin.x = self.scrollView.contentOffset.x;
            refreshFooterView.frame = frame;
        }

    }
}
#pragma mark - getter setter
-(UIScrollView *)contentScrollView
{
    return self.tableView;
}
-(void)setRowHeight:(CGFloat)rowHeight
{
    _rowHeight = rowHeight;
}
-(void)setColumnWidth:(CGFloat)columnWidth
{
    _columnWidth = columnWidth;
}
-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.tableView.backgroundColor  =  backgroundColor;
}
-(void)setSeparatorColor:(UIColor *)separatorColor
{
    _separatorColor = separatorColor;
    self.tableView.separatorColor = separatorColor;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    }
    return _scrollView;
}
@end
