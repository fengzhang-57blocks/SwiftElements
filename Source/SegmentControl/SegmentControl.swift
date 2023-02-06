//
//  SegmentControl.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

public class SegmentControl: UIView {

	public var layout: SegmentControl.Layout = SegmentControl.Layout() {
		didSet {
			collectionView.reloadData()
		}
	}

  public var alignment: SegmentControlAlignment = .centered

  public var style: SegmentControlStyle = .indicator

	public weak var dataSource: SegmentControlDataSource?
	public weak var delegate: SegmentControlDelegate?

	public private(set) var collectionView: UICollectionView!

	private var selectedSegment: Segment?

  private(set) public var segments: [Segment]
	public required init(segments: [Segment] = []) {
		self.segments = segments
		super.init(frame: .zero)

		selectedSegment = segments.filter({
			$0.isSelected
		}).first

		setupSubviews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupSubviews() {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal

		collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

		collectionView.showsVerticalScrollIndicator = false
		collectionView.showsHorizontalScrollIndicator = false

		collectionView.register(SegmentControlOvalCell.self, forCellWithReuseIdentifier: "oval")
		collectionView.register(SegmentControlIndicatorCell.self, forCellWithReuseIdentifier: "indicator")

		collectionView.dataSource = self
		collectionView.delegate = self

		collectionView.bounces = true

		addSubview(collectionView)
	}

	public override func layoutSubviews() {
		super.layoutSubviews()

		switch alignment {
		case .centered:
			var cellSpacings: CGFloat = 0
			if segments.count > 0 {
				cellSpacings = CGFloat(segments.count - 1) * layout.itemSpacing
			}

			let contentWidth = segments.reduce(0) {
				layout.contentInsets.horizontal +
				$0 +
				$1.title.boundingRectSize(bounds.size).width
			} + cellSpacings
      let realWidth = CGFloat.minimum(contentWidth, bounds.width)
      if realWidth.isEqual(to: bounds.width) {
				print(-half(contentWidth - realWidth))
        collectionView.contentOffset.x = half(contentWidth - realWidth)
      }

      collectionView.frame.size = CGSize(width: realWidth, height: bounds.height)
		case .tiled, .equalization:
			collectionView.frame.size = bounds.size
		}

		collectionView.center = CGPoint(x: half(bounds.width), y: half(bounds.height))
    
    // Recalculate cell size incase of device orientation change.
    collectionView.reloadData()
	}
  
	public func reload(with segments: [Segment]) {
		self.segments = segments

		selectedSegment = segments.filter({
			$0.isSelected
		}).first

    reloadData()
	}

	public func reloadData() {
		collectionView.reloadData()
		DispatchQueue.main.asyncAfter(deadline: .now()) {
			if let selectedSegment = self.selectedSegment,
				 let index = self.segments.firstIndex(of: selectedSegment) {
				let indexPath = IndexPath(item: index, section: 0)
				self.collectionView.selectItem(
					at: indexPath,
					animated: true,
					scrollPosition: .centeredHorizontally
				)
				self.handleSelectSegment(selectedSegment, at: indexPath)
			}
		}
	}
  
  public func scrollTo(index: Int, animated: Bool) {
    guard index < segments.count else {
      return
    }
    
    collectionView(collectionView, didSelectItemAt: IndexPath(item: index, section: 0))
  }
}

extension SegmentControl: UICollectionViewDataSource {
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let dataSource = dataSource {
      return dataSource.numberOfItems(in: self)
    }

		return segments.count
	}

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let dataSource = dataSource {
      return dataSource.segmentControl(self, cellForItemAt: indexPath.item)
    }

		var identifier = "oval"
		if style == .indicator {
			identifier = "indicator"
		}
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! SegmentControlCell
    if let segment = dataSource?.segmentControl(self, segmentAt: indexPath.item) {
      cell.configure(segment, layout: layout)
    } else {
      cell.configure(segments[indexPath.item], layout: layout)
    }

		return cell
	}
}

extension SegmentControl: UICollectionViewDelegateFlowLayout {
	public func collectionView
	(_ collectionView: UICollectionView,
	 layout collectionViewLayout: UICollectionViewLayout,
	 sizeForItemAt indexPath: IndexPath) -> CGSize {
		if let size = delegate?.segmentControl(self, layout: collectionViewLayout, sizeForItemAt: indexPath.item),
				!size.equalTo(.zero) {
      return size
    }

    switch alignment {
		case .tiled, .centered:
			return CGSize(
				width: segments[indexPath.item].title.boundingRectSize(bounds.size).width + layout.contentInsets.horizontal,
				height: bounds.height
			)
    case .equalization:
      return CGSize(
				width: (
					bounds.width - CGFloat(segments.count - 1) * layout.itemSpacing
				) / CGFloat(segments.count),
				height: bounds.height
			)
    }
	}

	public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
			if let spacing = delegate?.minimumInteritemSpacingForSegmentControl(self, layout: collectionViewLayout),
					!spacing.isEqual(to: .zero) {
        return spacing
      }

      return layout.itemSpacing
	}

	public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      if let spacing = delegate?.minimumInteritemSpacingForSegmentControl(self, layout: collectionViewLayout),
				 !spacing.isEqual(to: .zero) {
        return spacing
      }

      return layout.itemSpacing
	}

	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let segment = segments[indexPath.item]

		if let selectedSegment = selectedSegment,
			 selectedSegment.isEqual(to: segment),
				!layout.isRepeatTouchEnabled {
			return
		}

		selectedSegment = segment
		segments = segments.map { s in
      var nexts = s
      nexts.isSelected = segment.title.isEqual(to: s.title)
      return nexts
    }

    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    collectionView.reloadData()

    handleSelectSegment(segment, at: indexPath)
	}
}

private extension SegmentControl {
	func handleSelectSegment(_ segment: Segment, at indexPath: IndexPath) {
		if let actionHandler = segment.handler {
			actionHandler(segment)
		} else if let delegate = delegate {
			delegate.segmentControl(self, didSelect: segment, at: indexPath.item)
		}
	}
}
