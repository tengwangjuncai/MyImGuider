//
//  CarouselViewLayout.swift
//  ImGuider X
//
//  Created by llt on 2018/9/19.
//  Copyright © 2018年 imguider. All rights reserved.
//

import UIKit


enum CarouselAnim {
    case linear
    case rotary
    case carousel1
    case carousel2
    case carousel3
    case coverFlow
}


class CarouselViewLayout: UICollectionViewLayout {
    
    var interspaceParam:CGFloat = 0.65
    
    private var carouselAnim:CarouselAnim
    private var viewHeight:CGFloat = 0
    private var itemHeight:CGFloat = 0
    
    var scrollDirection:UICollectionView.ScrollDirection = .horizontal
    var itemSize:CGSize = CGSize.zero
    var visbleCount:Int = 0
    
    init(anim:CarouselAnim) {

        carouselAnim = anim
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        if visbleCount < 1 {
            visbleCount = 5
        }
        
        
        if carouselAnim == .carousel1 || carouselAnim == .carousel3 {
            
            interspaceParam = 0.3
        }
        
        if scrollDirection == .vertical {
            
            viewHeight = collectionView.frame.height
            itemHeight = self.itemSize.height

            if carouselAnim == .carousel3 {
                
                collectionView.contentInset = UIEdgeInsets(top: -(CGFloat(kScreenHeight) / 2 - CGFloat(kNavigationHeight) - itemHeight), left: 0, bottom: 0, right: 0)
                
            } else {
                
                collectionView.contentInset = UIEdgeInsets(top: (viewHeight - itemHeight) / 2, left: 0, bottom: (viewHeight - itemHeight) / 2, right: 0)
            }
            
            
        } else {
            
            viewHeight = collectionView.frame.width
            itemHeight = self.itemSize.width
            
            collectionView.contentInset = UIEdgeInsets(top: 0,left: (viewHeight - itemHeight) / 2, bottom: 0, right: (viewHeight - itemHeight) / 2)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        
        guard let collectionView = collectionView else { return CGSize.zero }
        
        let cellcount = collectionView.numberOfItems(inSection: 0)
        
        if scrollDirection == .vertical {
            
            var height = CGFloat(cellcount) * itemHeight
            
            if carouselAnim == .carousel3 {
                
                height = height + UIScreen.main.bounds.height / 2
            }
            
            return CGSize(width: collectionView.frame.width, height: height)
        }
        
        return CGSize(width: CGFloat(cellcount) * itemHeight, height: collectionView.frame.height)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let collectionView = collectionView else { return nil }
        
        let cellcount = collectionView.numberOfItems(inSection: 0)
        
        let centerY = (scrollDirection == .vertical ? collectionView.contentOffset.y : collectionView.contentOffset.x) + viewHeight / 2
        let index = Int(centerY / itemHeight)
        let count = (visbleCount - 1) / 2
        let minIndex = max(0, (index - count))
        let maxIndex = min((cellcount - 1), (index + count))

        if minIndex > maxIndex {
            return nil
        }
        
        var array:[UICollectionViewLayoutAttributes] = []
        
        for i in minIndex...maxIndex  {
            
            let indexpath = IndexPath(item: i, section: 0)
            if let attribus = layoutAttributesForItem(at: indexpath) {
                
                array.append(attribus)
            }
        }
        
        return array
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard let collectionView = collectionView else { return nil }
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.size = itemSize
        
        let cY = (scrollDirection == .vertical ? collectionView.contentOffset.y : collectionView.contentOffset.x) + viewHeight / 2
        
        let attributesY = itemHeight * CGFloat(indexPath.row) + itemHeight / 2
        attributes.zIndex = Int(-abs(attributesY - cY))
        let delta = cY - attributesY
        let ratio = -delta / (itemHeight * 2)
        let scale = 1 - abs(delta) / (itemHeight * 6) * cos(ratio * CGFloat.pi / 4)
        
        attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        
        var centerY = attributesY
        
        switch carouselAnim {
        case .rotary:
            
            attributes.transform = CGAffineTransform(rotationAngle: ratio * CGFloat.pi / 4)
            centerY = centerY + (sin(ratio * CGFloat.pi / 2) * itemHeight / 2)
        case .carousel1:
            
            centerY = cY + sin(ratio * CGFloat.pi / 2) * itemHeight * interspaceParam
            attributes.alpha = 1.3 - abs(sin(ratio * CGFloat.pi / 2))
        case .carousel2:
            
            centerY = cY + (sin(ratio * CGFloat.pi / 2) * itemHeight * interspaceParam)
            
            if delta > 0 && delta <= itemHeight / 2 {
                
                attributes.transform = CGAffineTransform.identity
                var rect = attributes.frame
                
                if scrollDirection == .vertical {
                    
                    rect.origin.x = collectionView.frame.width / 2 - itemSize.width * scale / 2
                    rect.origin.y = centerY - itemHeight * scale / 2
                    
                    rect.size.width = itemSize.width * scale
                    
                    let param = delta / (itemHeight / 2)
                    
                    rect.size.height = itemHeight * scale * (1 - param) + sin(0.25 * CGFloat.pi / 2) * itemHeight * interspaceParam * 2 * param
                } else {
                    
                    
                    rect.origin.x = centerY - itemHeight * scale / 2
                    rect.origin.y = collectionView.frame.height / 2 - itemSize.height * scale / 2
                    
                    rect.size.height = itemSize.height * scale
                    
                    let param = delta / (itemHeight / 2)
                    
                    rect.size.width = itemHeight * scale * (1 - param) + sin(0.25 * CGFloat.pi / 2) * itemHeight * interspaceParam * 2 * param
                }
                
                attributes.frame = rect
                return attributes
            }
            
        case .carousel3:
            
            attributes.zIndex = -indexPath.row
            
            if delta >= 0 {
                
                attributes.alpha = 1
                centerY = itemHeight * CGFloat(indexPath.row) + itemHeight / 2
                attributes.transform = CGAffineTransform.identity
            } else {
                
                attributes.alpha = scale
//                attributes.alpha = scale
                centerY = cY + (sin(ratio * CGFloat.pi / 2) * itemHeight * interspaceParam)
            }
            
            if scrollDirection == .vertical {
                
                centerY = centerY + UIScreen.main.bounds.height / 2 - itemHeight / 2 - CGFloat(kNavigationHeight) + 20
                
                attributes.alpha = 1.3 - sin(ratio * CGFloat.pi / 2)
            }
            
        case .coverFlow:
            
            var transform = CATransform3DIdentity
            transform.m34 = -1.0 / 400.0
            attributes.transform3D = CATransform3DRotate(transform, CGFloat.pi / 4, 1, 0, 0)
            
        default:
            
            break
        }
        
        if scrollDirection == .vertical {
            
            attributes.center = CGPoint(x: collectionView.frame.width / 2, y: centerY)
        } else {
            
            attributes.center = CGPoint(x: centerY, y: collectionView.frame.height / 2)
        }
        
        return attributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        var proposedContentOffset = proposedContentOffset
        
        let index = roundf(Float(((scrollDirection == .vertical ? proposedContentOffset.y : proposedContentOffset.x) + viewHeight / 2 - itemHeight / 2) / itemHeight))
        
        if scrollDirection == .vertical {
            
            proposedContentOffset.y = itemHeight * CGFloat(index) + itemHeight / 2 - viewHeight / 2
        } else {
            
            proposedContentOffset.x = itemHeight * CGFloat(index) + itemHeight / 2 - viewHeight / 2
        }
        
        return proposedContentOffset
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        guard let collectionView = collectionView else { return false }
        
        return !newBounds.equalTo(collectionView.bounds)
    }
    
}
