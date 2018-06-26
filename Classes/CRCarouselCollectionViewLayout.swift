//
//  CarouselCollectionViewLayout.swift
//  CRCollectionLayouts
//
//  Created by chola on 6/18/18.
//  Copyright © 2018 chola. All rights reserved.
//

import UIKit

@IBDesignable @objcMembers
open class CRCarouselCollectionViewLayout: CRInfiniteCollectionViewLayout {

    public var scalingOffset: CGFloat = 200
    

    public var minimumScaleFactor: CGFloat = 0.10
    
    //MARK: - Utility properties
    
    override var canInfiniteScroll: Bool { return false }
    
    //MARK: Preparation

    open override func prepare() {
        super.prepare()
        //Nothing special here, but it is best practice to override this method anyway
    }
    
    //MARK: Layouting and attributes generators

    private func configureAttributes(for attributes: UICollectionViewLayoutAttributes) {
        guard let collection = collectionView else { return }
        let contentOffset = collection.contentOffset
        let size = collection.bounds.size
        
        let visibleRect = CGRect(x: contentOffset.x, y: contentOffset.y, width: size.width, height: size.height)
        let visibleCenterX = visibleRect.midX
        
        let distanceFromCenter = visibleCenterX - attributes.center.x
        let absDistanceFromCenter = min(abs(distanceFromCenter), scalingOffset)
        let scale = absDistanceFromCenter * (minimumScaleFactor - 1) / scalingOffset + 1
        
        attributes.alpha = scale
        
        
        
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        //All we have to do at this point is to apply the scale factor to the attributes we already have.
        for attribute in attributes where attribute.representedElementCategory == .cell {
            configureAttributes(for: attribute)
        }
        return attributes
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attribute = super.layoutAttributesForItem(at: indexPath) else { return nil }
        configureAttributes(for: attribute)
        return attribute
    }
}
