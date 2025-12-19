//
//  LSRootCollectionView.m
//  LSProjectTool
//
//  Created by Alex Yang on 2018/2/1.
//  Copyright © 2018年 Link-Start. All rights reserved.
//
//
// zIndex这个属性调整collectionview中的层级关系，cell是0，要想装饰视图在cell底部，就要把装饰视图的zindex调整到小于0
// zIndex 这个属性可以在自定义卡片的时候 让中间的cell处于视图的最前面

/**
 https://www.jianshu.com/p/c54f52a1e72a
 
 UICollectionViewFlowLayout: 确定网格视图的布局

 上下左右的间距: sectionInset(left, top, bottom, right)
 每一个Cell的大小: itemSize(width, height)
 横向Cell之间的间距: minimumInteritemSpacing，左右item之间的距离
 纵向Cell之间的间距: minimumLineSpacing，上下item之间的距离

 */



//上下左右的间距: sectionInset(left, top, bottom, right)
//每一个Cell的大小: itemSize(width, height)
//横向Cell之间的间距: minimumInteritemSpacing，左右item之间的距离
//纵向Cell之间的间距: minimumLineSpacing，上下item之间的距离






#import "LSRootCollectionView.h"

@interface LSRootCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *ls_collectionView;

@end

@implementation LSRootCollectionView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 刷新
- (void)headerRereshing {
    
}

- (void)footerRereshing {
    
}

#pragma mark - 通过遵守UICollectionViewDelegateFlowLayout实现代理方法来布局（非固定情况则需要通过数据源方法）
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
// 上下item之间的距离
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
// 左右item之间的距离
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;


#pragma mark - 数据源方法
////设置分区数（必须实现）
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}
////设置每个分区的item个数
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return 5;
//}
////设置返回每个item的属性必须实现）
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//
////    // 去掉 刷新collection的时候的隐式动画
////    [UIView animateWithDuration:0 animations:^{
////        [UIView performWithoutAnimation:^{
////            [self.collectionView reloadData];
////        }];
////    } completion:^(BOOL finished) {
////
////    }];
////    // 去掉 刷新collection的 row 的时候的隐式动画
////    [UIView animateWithDuration:0 animations:^{
////        [collectionView performBatchUpdates:^{
////            [self.cardCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:indexPath.item inSection:0]]];
////        } completion:^(BOOL finished) {
////        }];
////    }];
//
//
//}
////对头视图或者尾视图进行设置
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//MemberInfoDetailsBottomConsumerDetailsHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMemberInfoDetailsBottomConsumerDetailsHeadViewId forIndexPath:indexPath];
//}
//是否允许移动Item
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0){
    return YES;
}
//移动Item时触发的方法
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath NS_AVAILABLE_IOS(9_0); {
}
//是否允许某个Item的高亮，返回NO，则不能进入高亮状态
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath; {
    return YES;
}
//当item高亮时触发的方法
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath; {
}
//结束高亮状态时触发的方法
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath; {
}
//是否可以选中某个Item，返回NO，则不能选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath; {
    return YES;
}
//是否可以取消选中某个Item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath; {
    return YES;
}
//已经选中某个item时触发的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath; {
}
//取消选中某个Item时触发的方法
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath; {
}
//将要加载某个Item时调用的方法
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0); {
}
//将要加载头尾视图时调用的方法
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0); {
}
//已经展示某个Item时触发的方法
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath; {
}
//已经展示某个头尾视图时触发的方法
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath; {
}
//这个方法设置是否展示长按菜单
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath; {
    return YES;
}

//这个方法用于设置要展示的菜单选项
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender; {
    return YES;
}

//这个方法用于实现点击菜单按钮后的触发方法,通过测试，只有copy，cut和paste三个方法可以使用
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender; {
    //通过下面的方式可以将点击按钮的方法名打印出来：
    NSLog(@"%@",NSStringFromSelector(action));
}

//collectionView进行重新布局时调用的方法
//- (nonnull UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout; {
//
//}




#pragma mark -  https://www.jianshu.com/p/c53ba3a36fe8
// UICollectionView 的 拖放(dragDelegate&dropDelegate)


// UICollectionView 支持拖放操作，该API处理所显示的 Items 。为了支持拖动，定义一个 UICollectionViewDragDelegate 拖动委托对象，并将其分配给集合视图的 dragDelegate 属性。要处理掉落，定义一个 UICollectionViewDropDelegate 协议的对象，并将其分配给集合视图的 dropDelegate 属性。

一、从集合视图中拖动 Items

集合视图管理大多数与拖动相关的交互，但是您需要指定要拖动哪些项。当拖动手势发生时，集合视图创建一个拖动会话并调用您的拖动委托对象的 collectionView:itemsForBeginningDragSession:atIndexPath: 方法。如果从该方法返回一个非空数组，则集合视图将开始拖动指定的项。当不允许用户从指定索引路径中拖动项时，返回空数组。

注意：
使用 UICollectionViewDragDelegate 协议的其他方法来管理其他与拖动相关的交互。例如，可以自定义正在拖动的项目的外观，并允许用户将项目添加到当前拖动会话中。
在实现collectionView:itemsForBeginningDragSession:atIndexPath方法时，请执行以下操作:

创建一个或多个 NSItemProvider 对象。使用项提供程序来表示集合视图项的数据。
将每个项目提供程序对象包装在 UIDragItem 对象中。
3.考虑为每个拖动项的 localObject 属性赋值。这个步骤是可选的，但是在同一个应用程序中拖放内容会更快。

4.从方法返回拖动项。

使用提供的索引路径来确定要拖动的项。如果项目是当前选定项目集合的一部分，则集合视图将自动拖动所有选定项目。如果项目不是当前选择的一部分，则集合视图将其添加到拖动操作中。

有关初始化拖动的更多信息，请参见UICollectionViewDragDelegate

二、接收放置的内容

当内容被拖到它的边界内时，集合视图会咨询它的拖放委托，以确定它是否可以接收被拖放的数据。最初，集合视图只调用拖放委托的 collectionView:canHandleDropSession: 方法，以确定是否可以将指定的数据合并到数据源中。如果可以合并数据，则集合视图会开始调用其他方法来确定数据可以放在哪里。

当用户的手指移动时，集合视图会跟踪潜在的放置位置，并通过调用每次更改的委托 collectionView:dropSessionDidUpdate:withDestinationIndexPath: 方法来通知您的代理。实现此方法是可选的，但推荐使用，因为它允许集合视图显示关于如何合并拖动项目的视觉反馈。在您的实现中，创建一个 UICollectionViewDropProposal 对象，其中包含有关如何响应指定索引路径上的放置的信息。例如，您可能希望将内容作为新 item 插入到数据源中，或者将数据添加到指定索引路径处的现有 item 中。因为该方法被频繁调用，所以要尽可能快地返回您的建议。如果不实现此方法，则集合视图不会提供有关如何处理放置的视觉反馈。

在 collectionView:performDropWithCoordinator: 方法的实现中，请执行以下操作：

1、对所提供的放置协调器对象中的 items 属性进行迭代。

2、对于每个项目，确定要如何处理其内容：

2.1、如果 item 的 sourceIndexPath 包含一个值，则该 item 起源于集合视图。使用批处理更新将 item 从当前位置删除，并将其插入到新的索引路径。
2.2、如果设置了拖动项的 localObject 属性，则该 item 来自应用程序中的其他位置，因此必须插入 item 或更新现有 item 。
2.3、如果没有其他可用的选项，在拖拽 item 的 itemProvider 属性中使用 NSItemProvider 来异步获取数据并插入或更新 item。
3、更新数据源，并在集合视图中插入或移动必要的项。

对于已经在应用程序本地的 items，通常可以直接更新集合视图的数据源和界面。例如，您可以使用批处理更新来删除然后插入来自集合视图的 item。完成后，调用放置协调器的 dropItem:toItemAtIndexPath: 方法，将拖动的内容插入到集合视图中。

对于必须使用 NSItemProvider 对象检索的数据，请在集合视图中插入占位符，直到能够检索实际数据为止。只有在向集合视图中插入新 item 时，才需要插入占位符。占位符在集合视图中充当临时 item，在实际数据可用之前显示您想要显示的默认内容。例如，您可以提供一个占位符单元格，其中包含一个文本字段，说明当前正在加载内容。

要在集合视图中插入占位符，请执行以下操作:

1、调用提供的 UICollectionViewDropCoordinator 对象的 dropItem:toPlaceholder: 方法将占位符单元格插入到集合视图中。

2、开始从 NSItemProvider 对象异步加载数据。

当 NSItemProvider 对象返回实际数据时，提交插入并将占位符单元格替换为最终单元格。具体来说，调用创建占位符后收到的上下文对象的 commitInsertionWithDataSourceUpdates: 方法。在传递给该方法的块中，更新模型对象和集合视图的数据源。当此方法返回时，集合视图将自动删除占位符并插入最终项，从而使更新后的数据反映在新项中。

在删除协调器的 destinationIndexPath 属性指定的位置插入占位符。

三、UICollectionViewDragDelegate

在用于从集合视图中初始化拖动的对象中实现此协议。该协议唯一需要的方法是 collectionView:itemsForBeginningDragSession:atIndexPath: 方法，但是您可以根据需要实现其他方法来定制集合视图的拖动行为。

将自定义委托对象分配给集合视图的 dragDelegate 属性。

API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos)
@protocol UICollectionViewDragDelegate <NSObject>
//必须实现的方法
@required
//提供 items 以 开始 与 给定 indexPath 关联的拖动。
//如果返回 空数组，则 不会开始拖动会话。
//提供要拖动的初始 items（如果有）。
// session ：当前拖动会话对象。
// indexPath 要拖动的item的索引路径。
//UIDragItem 对象数组，其中包含要拖动的项的详细信息。
//返回空数组以防止拖动项。

//注意：
//必须实现此方法才能从集合视图中拖动项。
//在实现中，为指定 indexPath 处的项创建一个或多个 UIDragItem 对象。
//通常，您只返回一个拖动 item，但是如果指定的项有 子item 或者
//没有一个或多个关联 item 就不能拖动，那么也要包含这些 items。

//当在集合视图的边界内开始新的拖动时，集合视图调用此方法 一次或多次。
//具体来说，
//如果用户从选定项开始拖动，则集合视图会为所选item中的 每个项 调用 此方法一次。
//如果用户从未选中的item开始拖动，则集合视图仅为该项调用该方法一次。
- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView
    itemsForBeginningDragSession:(id<UIDragSession>)session
          atIndexPath:(NSIndexPath *)indexPath;

//以下是可实现方法，非必须
@optional
//注意：
//添加 item 手势，响应请求将 item 添加到现有拖动会话中。
//如果需要，您可以使用提供的点(在集合视图的坐标空间中)进行额外的命中测试。
//如果没有实现，或者返回一个空数组，
//则在拖动中将不会添加任何项，手势将被正常处理。

//将指定 item 添加到现有拖动会话中。
//session：当前拖动会话对象。
//indexPath：要添加到拖动中的 item 的索引路径。
//point：用户触摸的点。该点位于集合视图的坐标空间中。
//返回 UIDragItem对象数组 ：其中包含要添加到当前拖动会话的 item。
//返回空数组以防止将 item 添加到拖动会话。

//注意：当您希望允许用户向一个在活动状态的拖动会话中添加 item 时，请实现此方法。
//如果你不实现这个方法，在集合视图中的点击 可以触发 items 的选择，或其他行为。
//但是，当拖动会话处于在活动状态并且发生点击时，集合视图将会调用此方法，
//以便您有机会将基础 item 添加到拖动会话中。
//在您的实现中，为指定的 indexPath 的 item 创建一个或多个 UIDragItem 对象。
//通常，您只返回一个拖动项，
//但是如果指定的item有子item或者没有一个或多个关联item就不能拖动，
//那么也要包含这些item。
- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView
  itemsForAddingToDragSession:(id<UIDragSession>)session
    atIndexPath:(NSIndexPath *)indexPath
         point:(CGPoint)point;
#pragma mark --------- 跟踪拖动会话 ----------
//通知您即将开始对集合视图进行拖动会话。
//在拖动的位置发生变化之前调用。
- (void)collectionView:(UICollectionView *)collectionView
       dragSessionWillBegin:(id<UIDragSession>)session;
//通知您集合视图的拖动会话已结束。
- (void)collectionView:(UICollectionView *)collectionView
        dragSessionDidEnd:(id<UIDragSession>)session;

#pragma mark --------- 提供自定义预览 ----------
//返回 有关如何在拖动期间在指定位置显示项目 的自定义信息。
// 拖动参数，指示在拖动过程中如何显示单元格的内容。
// - (nullable UIDragPreviewParameters *)collectionView:(UICollectionView *)collectionView
    dragPreviewParametersForItemAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark --------- 控制拖动会话 ----------
//该值确定是否允许拖动会话进行移动操作。
//如果没有实现，这将默认为YES。
- (BOOL)collectionView:(UICollectionView *)collectionView
     dragSessionAllowsMoveOperation:(id<UIDragSession>)session;

//返回一个布尔值，用于确定拖放会话的源应用程序和目标应用程序是否必须相同。
- (BOOL)collectionView:(UICollectionView *)collectionView
  dragSessionIsRestrictedToDraggingApplication:(id<UIDragSession>)session;

@end
四、UICollectionViewDropDelegate

在用于将删除的数据合并到集合视图中的对象中实现此协议。
这个协议唯一需要的方法是collectionView:performDropWithCoordinator: method，但是，您可以根据需要实现其他方法来自定义集合视图的删除行为。将自定义委托对象分配给集合视图的dropDelegate属性。

API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos)
@protocol UICollectionViewDropDelegate <NSObject>

@required
#pragma mark --------- 合并被拖放的item ----------
// 告诉您的代理将放置数据合并到集合视图中。
// collectionView 接收投递的集合视图。
// coordinator  处理拖放时要使用的协调器对象。
// 使用此对象可以将自定义行为与集合视图的默认行为相协调。
//使用此方法接受删除的内容并将其集成到集合视图中。在您的实现中，
//遍历协调器对象(coordinator)的items属性并从每个UIDragItem中获取数据。
//将数据合并到集合视图的数据源中，并通过插入任何所需的项来更新集合视图本身。
//合并项目时，
//请使用协调器对象的方法设置从拖动项目的预览到集合视图中相应项目的转换动画。
//对于立即合并的项，可以使用dropItem:toTarget:
//或dropItem:toPItemAtIndexPath:方法来执行动画。
- (void)collectionView:(UICollectionView *)collectionView
  performDropWithCoordinator:(id<UICollectionViewDropCoordinator>)coordinator;


@optional

#pragma mark --------- 声明支持处理掉落 ----------
//询问dropDelegate,集合视图是否可以接受具有指定类型数据的删除。
//如果集合视图可以接受拖放的数据，则为YES;
//如果不能，则为NO,将不再调用此drop会话的委派方法。
//如果没有实现此方法，默认值为YES。
- (BOOL)collectionView:(UICollectionView *)collectionView
     canHandleDropSession:(id<UIDropSession>)session;

#pragma mark --------- 跟踪拖动移动 ----------
//告诉你的委托被拖动的数据在集合视图上的位置发生了变化。//如果内容被放置在指定位置，如何处理该内容的建议。
//destinationIndexPath 将要删除内容的索引路径。

//当用户拖放内容时，集合视图会反复调用此方法，
//以确定如果拖放发生在指定位置，您将如何处理。集合视图根据您的建议向用户提供可视反馈。
//在这个方法的实现中，创建一个UICollectionViewDropProposal对象，
//并用它来传达你的意图。因为当用户在表视图上拖拽时，这个方法会被反复调用，
//所以您的实现应该尽可能快地返回。
- (UICollectionViewDropProposal *)collectionView:(UICollectionView *)collectionView
   dropSessionDidUpdate:(id<UIDropSession>)session
    withDestinationIndexPath:(nullable NSIndexPath *)destinationIndexPath;

//当拖动的内容进入集合视图的边界矩形时通知你。
//当被拖动的内容进入其边界矩形时，集合视图调用此方法。
//直到拖动的内容退出集合视图的边界(触发
//对collectionView:dropSessionDidExit:方法的调用)并再次进入，
//才会再次调用该方法。
//使用此方法执行与跟踪集合视图上拖动的内容相关的任何一次性设置。
- (void)collectionView:(UICollectionView *)collectionView
    dropSessionDidEnter:(id<UIDropSession>)session;

//当拖动的内容退出集合视图的边界矩形时通知你。
//当被拖动的内容退出指定集合视图的边界矩形时，
//UIKit调用这个方法。直到拖动的内容进入集合视图的边界(触发对
//collectionView:dropSessionDidEnter:方法的调用)并再次退出，
//才会再次调用该方法。使用此方法可以清除在
//collectionView:dropSessionDidEnter:方法中配置的任何状态信息。
- (void)collectionView:(UICollectionView *)collectionView
   dropSessionDidExit:(id<UIDropSession>)session;

//当拖动操作结束时通知您。
//集合视图在某一点上的拖动结束时调用此方法。
//使用它可以清除 用于处理 拖动的任何状态信息。
//无论数据是否已实际放到集合视图中，都会调用此方法。
- (void)collectionView:(UICollectionView *)collectionView
   dropSessionDidEnd:(id<UIDropSession>)session;

#pragma mark --------- 提供自定义预览 ------------
//返回有关如何在拖放过程中 在指定位置 显示项目的自定义信息。
//使用此方法可以在放置过程中自定义项目的外观。
//如果没有实现此方法，或者实现了它并返回nil，
//则集合视图将使用单元格的可见边界来创建预览。
//注意：
//允许自定义用于要删除的项目的预览。
//如果未实现或返回nil，则整个单元格将用于预览。
//当通过[UICollectionViewDropCoordinator dropItem:toItemAtIndexPath:]
//设置放置动画时，将根据需要 调用此项（若要自定义占位符放置，
//请参阅 UICollectionViewDropPlaceholder.previewParametersProvider）
- (nullable UIDragPreviewParameters *)collectionView:(UICollectionView *)collectionView
  dropPreviewParametersForItemAtIndexPath:(NSIndexPath *)indexPath;

@end





// ------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - collectionView 使用 scrollToItemAtIndexPath 方法，滚动不到 headView的位置,只能滚动到具体的item的顶部
// [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionTop animated:YES]; // 只能滚动到 dui
// 上面的代码会将UICollectionView中第index个section的第0个item所对应的区域滚动到顶部。
// 但是，如果有headView，不会滚动到当前headView的顶部,只会滚动到index的第0个item的顶部

// 改成下面这个方法，可以滚动到 当前headView的顶部，亲测有效， 2024.03.25 -------------
//UICollectionViewLayoutAttributes *attributes = [_collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
//CGRect rect = attributes.frame;
//[_collectionView setContentOffset:CGPointMake(_collectionView.frame.origin.x, rect.origin.y - “header的高度”) animated:YES];

// ------------------------------------------------------------------------------------------------------------------------------------
UICollectionViewLayoutAttributes *attributes = [self.cityCollectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
CGRect rect = attributes.frame;
CGFloat headView_h = 0;
if (section == 0) {
    headView_h = 0;
} else {
    headView_h = 35;
}
[self.cityCollectionView setContentOffset:CGPointMake(self.cityCollectionView.frame.origin.x, rect.origin.y - headView_h) animated:YES];
// ------------------------------------------------------------------------------------------------------------------------------------




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (UICollectionView *)ls_collectionView {
    if (!_ls_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滑动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //设置分区的EdgeInset 偏移量
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 10, 10);

        
//        // 1.设置列间距
//        layout.minimumInteritemSpacing = 1;
//        // 2.设置行间距
//        layout.minimumLineSpacing = 1;
//        // 3.设置每个item的大小
//        layout.itemSize = CGSizeMake(50, 50);
//        // 4.设置Item的估计大小,用于动态设置item的大小，结合自动布局（self-sizing-cell）
//        layout.estimatedItemSize = CGSizeMake(320, 60);
//        // 5.设置布局方向
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        // 6.设置头视图尺寸大小
//        layout.headerReferenceSize = CGSizeMake(50, 50);
//        // 7.设置尾视图尺寸大小
//        layout.footerReferenceSize = CGSizeMake(50, 50);
//        // 8.设置分区(组)的EdgeInset（四边距）
//        layout.sectionInset = UIEdgeInsetsMake(10, 20, 30, 40);
//        // 9.10.设置分区的头视图和尾视图是否始终固定在屏幕上边和下边
//        layout.sectionFootersPinToVisibleBounds = YES; // 设置 headView 悬浮
//        layout.sectionHeadersPinToVisibleBounds = YES; // 设置 footView 悬浮

        
        
        //通过一个布局策略layout来创建一个collectionView
        _ls_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kLS_ScreenWidth , kLS_ScreenHeight - kLS_TopHeight - kLS_TabBarHeight) collectionViewLayout:flowLayout];
        //设置代理
//        _ls_collectionView.delegate = self;
//        _ls_collectionView.dataSource = self;
        //设置Cell多选
        _ls_collectionView.allowsMultipleSelection = YES;
        //设置collection的背景色
        _ls_collectionView.backgroundColor = [UIColor whiteColor];
        _ls_collectionView.scrollsToTop = YES;
        
#ifdef __IPHONE_11_0
        if (@available(iOS 13.0, *)) {
            _ls_collectionView.automaticallyAdjustsScrollIndicatorInsets = false;
        } else
        if (@available(iOS 11.0, *)) {
            _ls_collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            _ls_collectionView.automaticallyAdjustsScrollIndicatorInsets = NO;
        }
        if(kDevice_Is_iPhoneX && CGRectGetHeight(self.view.frame) == kLS_ScreenHeight - kLS_TopHeight){
            _ls_collectionView.contentInset = UIEdgeInsetsMake(0, 0, kLS_iPhoneX_Home_Indicator_Height, 0);
            _ls_collectionView.scrollIndicatorInsets = _ls_collectionView.contentInset;
        }
#endif
        
        //        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        //        header.automaticallyChangeAlpha = YES;
        //        header.lastUpdatedTimeLabel.hidden = YES;
        //        header.stateLabel.hidden = YES;
        //        _ls_collectionView.mj_header = header;
        
        //底部刷新
        //        _ls_collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];

        [self.view addSubview:_ls_collectionView];
    }
    return _ls_collectionView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
