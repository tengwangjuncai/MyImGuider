//
//  FocusViewLayout.swift
//  MyImGuider
//
//  Created by 王鹏宇 on 2018/9/10.
//  Copyright © 2018年 王鹏宇. All rights reserved.
//

import UIKit

class FocusViewLayout: UICollectionViewLayout {

    // default  The collapsed height
    // this property must be smaller than focusedHeight
    @IBInspectable open var standardHeight: CGFloat = 100
    
    // The expanded height
    // this property must be greater than standardHeight
    @IBInspectable open var focusedHeight: CGFloat = kScreenWidth/16 * 9
    
    // Drag Offset is the amount the user needs to scroll before
    //the featured cell changes
    @IBInspectable open var dragOffset: CGFloat = (kScreenWidth/16 * 9) - 100
    
    internal var cached = [UICollectionViewLayoutAttributes]()
    
    
    // Return the size of all the content in the collection view
    override open var collectionViewContentSize: CGSize {
        
        let contentHeight = CGFloat(numberOfItems) * dragOffset + (height - dragOffset)
        return CGSize(width: width, height: contentHeight)
    }
    
    // Return true so that the layout is continuously invalidated as the user scrolls
    
    //返回true，以便在用户滚动时连续无效布局
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        return true
    }
    
    // Return the content offset of the nearest cell which achieves the nice snapping effect,
    // similar to a paged UIScrollView
    
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let proposedItemIndex = round(proposedContentOffset.y / dragOffset)
        let nearestPageOffset = proposedItemIndex * dragOffset
        
        // Smooth scrolling when user release the touch to focoused cell
        return CGPoint(x: 0, y: nearestPageOffset)
    }
    
    // Return all attributes in the cache whose frame intersects with the rect passed to the method
    // 返回缓存中的所有属性，其框架与传递给方法的rect相交
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return cached.filter{ attributes in
          
            return attributes.frame.intersects(rect)
        }
    }
    // Perform whatever calculations are needed to determine the position of the cells and views in the layout
    
    //执行所需的任何计算以确定布局中单元格和视图的位置
    override open func prepare() {
    
        cached = [UICollectionViewLayoutAttributes]()
        
        // last rect will be used to calculate frames past the first one.  We initialize it to a non junk 0 value
        
        
        // last rect将用于计算第一个之后的帧。我们将它初始化为非空 0值
        var frame = CGRect()
        var y: CGFloat = 0
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // Important because each cell has to slide over the top of the previous one
            //重要，因为每个单元格必须滑过前一个单元格的顶部
            attributes.zIndex = item
            
            // Initially set the height of the cell to the standard height
            var height = standardHeight
            
            // The featured cell

            if indexPath.item == currentFocusedItemIndex {
                
                y = yOffset - standardHeight * nextItemPercentageOffset
                height = focusedHeight
            }else if indexPath.item == (currentFocusedItemIndex + 1) && indexPath.item != numberOfItems{
                
                // The cell directly below the featured cell, which grows as the user scrolls
                
                //特色单元格正下方的单元格，随着用户滚动而增长
                
                let maxY = y + standardHeight
                height = standardHeight + max((focusedHeight - standardHeight) * nextItemPercentageOffset,0)
                y = maxY - height
                
            }else {
                y = frame.origin.y + frame.size.height
            }
            
            frame = CGRect(x: 0, y: y, width: width, height: height)
            attributes.frame = frame
            cached.append(attributes)
            y = frame.maxY
        }
    }
    
    // Returns the layout attributes for the item at the specified index path.
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return cached[indexPath.item]
    }
}


extension  UICollectionViewLayout {
    
    var numberOfItems: Int {
        return collectionView?.numberOfItems(inSection: 0) ?? 0
    }
    
    var width: CGFloat {
        return collectionView?.frame.width ?? 0
    }
    
    var height: CGFloat {
        return collectionView?.frame.height ?? 0
    }
    
    var yOffset: CGFloat {
        return collectionView?.contentOffset.y ?? 0
    }
}

extension FocusViewLayout {
    
    // Returns the item index of the currently featured cell
    var currentFocusedItemIndex: Int {
        return max(0, Int(yOffset / dragOffset))
    }
    
    var nextItemPercentageOffset: CGFloat {
        return (yOffset / dragOffset) - CGFloat(currentFocusedItemIndex)
    }
    
}
