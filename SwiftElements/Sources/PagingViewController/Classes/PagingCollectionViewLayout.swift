//
//  PagingCollectionViewLayout.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/6.
//

import UIKit

// https://developer.apple.com/documentation/uikit/uicollectionviewlayout

open class PagingCollectionViewLayout: UICollectionViewLayout {

	public var state: PagingState = .empty

  public var options = PagingOptions() {
    didSet {
      optionsChanged(oldValue: oldValue)
    }
  }

	private let indicatorKind: String = "indicator"
	public private(set) var indicatorLayoutAttributes: PagingIndicatorLayoutAttributes?
	open var indicatorClass: PagingIndicatorView.Type {
		set { options.indicatorClass = newValue }
		get { return options.indicatorClass }
	}
  
  private let borderKind: String = "border"
  public private(set) var borderLayoutAttributes: PagingBorderLayoutAttributes?
  open var borderClass: PagingBorderView.Type {
    set { options.borderClass = newValue }
    get { return options.borderClass }
  }

	public private(set) var layoutAttributes: [IndexPath: PagingCellLayoutAttributes] = [:]

	private var contentSize: CGSize = .zero
  public private(set) var contentInsets: UIEdgeInsets = .zero
	open override var collectionViewContentSize: CGSize {
		return contentSize
	}

	public var visibleItems: PagingItems = PagingItems(items: [])

  internal var sizeCache: PagingItemSizeCache?
  
  private var invalidateKind: PagingInvalidateKind = .nothing

  private var range: Range<Int> {
    return 0..<view.numberOfItems(inSection: 0)
  }

	private var view: UICollectionView {
		return collectionView!
	}

	override init() {
		super.init()
		configure()
	}

	required public init?(coder: NSCoder) {
		super.init(coder: coder)
		configure()
	}

	open override func prepare() {
		super.prepare()
    
    switch invalidateKind {
    case .everything:
      layoutAttributes = [:]
      indicatorLayoutAttributes = nil
      borderLayoutAttributes = nil
      createCellLayoutAttributes()
      createDecorationLayoutAttributes()
    case .size:
      layoutAttributes = [:]
      createCellLayoutAttributes()
    case .nothing:
      break
    }

    updateIndicatorLayoutAttributes()
    updateBorderLayoutAttributes()
    
    invalidateKind = .nothing
	}

  open override func invalidateLayout() {
    super.invalidateLayout()
    invalidateKind = .everything
  }

  open override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
    super.invalidateLayout(with: context)
    invalidateKind = PagingInvalidateKind(from: context)
  }

  open override func shouldInvalidateLayout(
		forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
		withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes
	) -> Bool {
		return false
  }

  open override func invalidationContext(
    forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
    withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes
  ) -> UICollectionViewLayoutInvalidationContext {
    let context = PagingInvalidationContext()
    context.invalidateSizes = true
    return context
  }

	open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		guard let attrs = self.layoutAttributes[indexPath] else {
			return nil
		}

    attrs.progress = progressForCellLayoutAttributes(at: attrs.indexPath)
		return attrs
	}

  open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var layoutAttributes: [UICollectionViewLayoutAttributes] = Array(self.layoutAttributes.values)
    for each in layoutAttributes {
      if let attrs = each as? PagingCellLayoutAttributes {
				attrs.progress = progressForCellLayoutAttributes(at: attrs.indexPath)
      }
    }

    let indexPath = IndexPath(item: 0, section: 0 )
    if let attrs = layoutAttributesForDecorationView(ofKind: indicatorKind, at: indexPath) {
      layoutAttributes.append(attrs)
    }
    
    if let attrs = layoutAttributesForDecorationView(ofKind: borderKind, at: indexPath) {
      layoutAttributes.append(attrs)
    }

    return layoutAttributes
  }

	open override func layoutAttributesForDecorationView(
		ofKind elementKind: String,
		at indexPath: IndexPath
	) -> UICollectionViewLayoutAttributes? {
		switch elementKind {
		case indicatorKind:
			return indicatorLayoutAttributes
    case borderKind:
      return borderLayoutAttributes
		default:
			return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
		}
	}
}

private extension PagingCollectionViewLayout {
  func createCellLayoutAttributes() {
		guard let sizeCache = sizeCache else {
			return
		}

    var layoutAttributes: [IndexPath: PagingCellLayoutAttributes] = [:]

    var previousFrame: CGRect = .zero
    for index in range {
      let indexPath = IndexPath(item: index, section: 0)
			let attributes = PagingCellLayoutAttributes(forCellWith: indexPath)

      let x = previousFrame.maxX
      let y = previousFrame.minY

			if sizeCache.implementedSizeDelegate {
				let item = visibleItems.item(for: indexPath)
				let width = sizeCache.widthForItem(item)
				// TODO: caculate width
				if let selectedItem = state.currentItem, selectedItem.isEqual(to: item) {

				} else if let destinationItem = state.destinationItem, destinationItem.isEqual(to: item) {

				}

				attributes.frame = CGRect(x: x, y: y, width: width, height: options.itemSize.height)
			} else {
				switch options.itemSize {
				case let .fixed(width, height):
					attributes.frame = CGRect(x: x, y: y, width: width, height: height)
				case let .selfSizing(estimatedWidth, height):
					attributes.frame = CGRect(x: x, y: y, width: estimatedWidth, height: height)
				}
			}

			layoutAttributes[indexPath] = attributes
      previousFrame = attributes.frame
    }

		contentSize = CGSize(width: previousFrame.maxX, height: view.bounds.height)

		self.layoutAttributes = layoutAttributes
  }

	func createDecorationLayoutAttributes() {
		if case .visible = options.indicatorOptions,
       indicatorLayoutAttributes == nil {
			indicatorLayoutAttributes = PagingIndicatorLayoutAttributes(
				forDecorationViewOfKind: indicatorKind,
				with: IndexPath(item: 0, section: 0)
			)
		}
    
    if case .visible = options.borderOptions,
       borderLayoutAttributes == nil {
      borderLayoutAttributes = PagingBorderLayoutAttributes(
        forDecorationViewOfKind: borderKind,
        with: IndexPath(item: 0, section: 0)
      )
    }
	}
  
  func updateIndicatorLayoutAttributes() {
    guard let attrs = indicatorLayoutAttributes else {
      return
    }

    attrs.configure(with: options)

    if let fromItem = state.currentItem {
      if let currentIndexPath = visibleItems.indexPath(for: fromItem),
          let upcomingInexPath = upcomingIndexPath(for: currentIndexPath) {
        let from = PagingItemLayout(frame: indicatorFrame(for: currentIndexPath))
        let to = PagingItemLayout(frame: indicatorFrame(for: upcomingInexPath))
        let progress = abs(state.progress)
        attrs.update(from: from, to: to, progress: progress)
      }
    }
  }
  
  func updateBorderLayoutAttributes() {
    guard let attrs = borderLayoutAttributes else {
      return
    }

    attrs.configure(with: options)
    attrs.update(from: view.bounds, contentSize: contentSize)
  }
}

private extension PagingCollectionViewLayout {
  func upcomingIndexPath(for indexPath: IndexPath) -> IndexPath? {
		if let toItem = state.destinationItem,
			 let upcomingIndexPath = visibleItems.indexPath(for: toItem) {
			return upcomingIndexPath
    }

		if indexPath.item == (0..<view.numberOfSections).lowerBound {
			return IndexPath(item: indexPath.item + 1, section: 0)
		}

		if indexPath.item == (0..<view.numberOfSections).upperBound {
			return IndexPath(item: indexPath.item - 1, section: 0)
		}

    return indexPath
  }
  
  func optionsChanged(oldValue: PagingOptions) {
    var shouldInvalidateLayout = false
    
    if oldValue.indicatorClass != options.indicatorClass {
      shouldInvalidateLayout = true
      registerIndicatorClass()
    }
    
    if oldValue.borderClass != options.borderClass {
      shouldInvalidateLayout = true
      registerBorderClass()
    }
    
    if shouldInvalidateLayout {
      invalidateLayout()
    }
  }

	func indicatorFrame(for indexPath: IndexPath) -> CGRect {
		guard let attributes = self.layoutAttributes[indexPath] else {
			return .zero
		}

		return attributes.frame
	}
  
  func configure() {
    registerIndicatorClass()
    registerBorderClass()
  }
  
  func registerIndicatorClass() {
    register(indicatorClass.self, forDecorationViewOfKind: indicatorKind)
  }
  
  func registerBorderClass() {
    register(borderClass.self, forDecorationViewOfKind: borderKind)
  }

  func progressForCellLayoutAttributes(at indexPath: IndexPath) -> CGFloat {
    guard let _ = state.currentItem else {
      return 0
    }

    return 0
  }
}
