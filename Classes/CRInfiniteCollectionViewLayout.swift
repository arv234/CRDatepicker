//
//  CRInfiniteCollectionViewLayout.swift
//  CRCollectionLayouts
//
//  Created by chola on 6/18/18.
//  Copyright © 2018 chola. All rights reserved.
//

import UIKit

@IBDesignable @objcMembers
open class CRInfiniteCollectionViewLayout: CRSnapToCenterCollectionViewLayout {
    //MARK: - Inspectable properties
    
    ///Enable and disable the snap to center behavior inherited by this layout supr class.
    @IBInspectable public var snapToCenter: Bool = true {
        didSet { invalidateLayout() }
    }

    //MARK: - Utility properties

    ///This property signals that the current set of items in the collection can actually be displayed as infinite layout.
    internal var canInfiniteScroll: Bool {

        guard let cycleSize = cycleSize else { return false }
        return cycleSize.width > (collectionView?.bounds.size.width ?? 0) * 2.0
    }
    
    //MARK: - Cached properties

    ///This property determines the offset from where we wil start our collection to allow the user to scroll on both sides since the beginning.
    private var cycleStart: CGFloat = 0
    
    ///This property represent the size of each set of items in the data source.
    private var cycleSize: CGSize?
    
    //MARK: - Layout implementation
    //MARK: Preparation

    override open var collectionViewContentSize: CGSize {
        let size = super.collectionViewContentSize
        guard canInfiniteScroll, let cycleSize = cycleSize else { return size }

        return CGSize(width: cycleSize.width * 20000, height: size.height)
    }
    
    open override func prepare() {
        super.prepare()
        
        guard let collection = collectionView else { return }
        //Since we want to give the illusion of infinite scrolling the scroll indicator must be disabled as they would not make sense in 
        //terms of ux.
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        
        let sections = collection.dataSource?.numberOfSections?(in: collection) ?? 0
        guard sections < 2 else {
            fatalError("\(self) is a collection View Layout that just supports one section")
        }
        
        if itemCount == nil {
            itemCount = collection.dataSource?.collectionView(collection, numberOfItemsInSection: 0) ?? 0
        }
        
        guard let itemCount = itemCount, cycleSize == nil else { return }
        
        let width = (itemSize.width + interitemSpacing) * CGFloat(itemCount)
        let height = itemSize.height
        
        cycleSize = CGSize(width: width, height: height)

        guard canInfiniteScroll else {
            if !snapToCenter {
                sectionInsetLeft = minimumSectionInsetLeft
                sectionInsetRight = minimumSectionInsetRight
            }
            return
        }
        
        cycleStart = cycleSize!.width * 10000
    
        let currentInFocusXOffset = cycleStart + collection.contentOffset.x - sectionInsetLeft
        
        let proposedOffset = CGPoint(x: currentInFocusXOffset, y: -collection.contentInset.top)
        collection.contentOffset = proposedOffset
    }
    
    //MARK: Layouting and attributes generators

    private func frameForCycle(at index: Int) -> CGRect {
        guard let cycleSize = cycleSize else { return .zero }
        let x = cycleStart + cycleSize.width * CGFloat(index)
        return CGRect(x: x, y: 0, width: cycleSize.width, height: cycleSize.height)
    }
    
    override internal func items(in rect: CGRect) -> [(index:IndexPath, frame: CGRect)] {
        guard canInfiniteScroll else { return super.items(in: rect) }
        guard let cycleSize = cycleSize, cycleSize.width != 0,
            let itemCount = itemCount, itemCount > 0 else { return [] }
        
        let iFirstCycle = Int(floor((rect.origin.x - cycleStart) / cycleSize.width))
        let iLastCycle = Int(floor((rect.maxX - cycleStart) / cycleSize.width))
        
        var indexPaths = [(index:IndexPath, frame: CGRect)]()
        
        var currentX = rect.origin.x
        
        //For each cycle we determine now which are the currently visible items.
        for i in iFirstCycle...iLastCycle {
            let cycleFrame = frameForCycle(at: i)
            
            //TODO: Maybe super can be used
            let relativInitialX = currentX - cycleFrame.origin.x
            let relativeFinalX = min(cycleFrame.maxX, rect.maxX) - cycleFrame.origin.x
            
            let firstIndex = Int(floor(relativInitialX/(itemSize.width + interitemSpacing)))
            let lastIndex = min(Int(floor(relativeFinalX/(itemSize.width + interitemSpacing))), itemCount-1)
            
            for j in firstIndex...lastIndex {
                let x = cycleFrame.origin.x + (itemSize.width + interitemSpacing) * CGFloat(j)
                let y = sectionInsetTop + (headerHeight ?? 0)
                
                indexPaths.append((
                    IndexPath(item: j, section: 0),
                    CGRect(origin: CGPoint(x: x, y: y), size: itemSize)
                ))
            }
            
            currentX = min(cycleFrame.maxX, rect.maxX)
        }
        
        return indexPaths
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard canInfiniteScroll else { return super.layoutAttributesForElements(in: rect) }
        var attributes = [UICollectionViewLayoutAttributes]()
        
        for item in items(in: collectionView?.bounds ?? rect) {
            let attribute = UICollectionViewLayoutAttributes(forCellWith: item.index)
            attribute.frame = item.frame
            
            attributes.append(attribute)
        }
        
        attributes.append(contentsOf: attributesForHeaderAndFooter())
        return attributes
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard canInfiniteScroll,
            let cycleSize = cycleSize,
            let collection = collectionView else { return super.layoutAttributesForItem(at: indexPath) }
        
        let currentRect = CGRect(origin: collection.contentOffset, size: collection.bounds.size)
        
        let itemsOnScreen = items(in: currentRect)
        var frame: CGRect!
        
        //If the item is visible, we will return the frame for that item
        if let item = itemsOnScreen.first(where: { $0.index == indexPath })  {
            frame = item.frame
        } else {
            
            let iLastCycle = Int(floor((currentRect.maxX - cycleStart) / cycleSize.width))
            let cycleFrame = frameForCycle(at: iLastCycle)
            
            let x = cycleFrame.origin.x + (itemSize.width + interitemSpacing) * CGFloat(indexPath.item)
            let y = sectionInsetTop
            
            frame = CGRect(origin: CGPoint(x: x, y: y), size: itemSize)
        }
        
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attribute.frame = frame
        
        return attribute
    }
    
    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard snapToCenter else { return proposedContentOffset }
        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
    }

    //MARK: Invalidation

    open override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        if context.invalidateEverything || context.invalidateDataSourceCounts || context.contentSizeAdjustment != .zero {
            cycleSize = nil
        }
        
        super.invalidateLayout(with: context)
    }
}
