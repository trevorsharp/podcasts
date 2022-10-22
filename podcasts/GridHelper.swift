import Foundation

class GridHelper {
    var gridSpacing: CGFloat = 20
    var defaultTargetWidth: CGFloat = 180

    var listSpacing: CGFloat = 2
    var targetListWidth: CGFloat = 400

    private static let bigDevicePortraitWidth: CGFloat = 600
    private static let bigDeviceLandscapeWidth: CGFloat = 900

    private static let moveScale: CGFloat = 1.05
    private static let moveAlpha: CGFloat = 0.8

    private lazy var cellSizeFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.roundingMode = .down

        return formatter
    }()

    private var movingIndexPath: IndexPath?

    // MARK: - UICollectionView layout

    func configureLayout(collectionView: UICollectionView) {
        guard let flowLayout = collectionView.collectionViewLayout as? ReorderableFlowLayout else { return }

        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.growScale = GridHelper.moveScale
        flowLayout.alphaOnPickup = GridHelper.moveAlpha
        flowLayout.growOffset = 0

        let gridType = Settings.libraryType()

        if gridType == .list {
            flowLayout.sectionInset = UIEdgeInsets(top: listSpacing, left: listSpacing, bottom: listSpacing, right: listSpacing)
        } else {
            flowLayout.sectionInset = UIEdgeInsets(top: gridSpacing + 5, left: gridSpacing, bottom: gridSpacing + 5, right: gridSpacing)
        }

        flowLayout.minimumLineSpacing = gridType == .list ? listSpacing : gridSpacing
        flowLayout.minimumInteritemSpacing = gridType == .list ? listSpacing : gridSpacing
    }

    func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath, itemCount: Int) -> CGSize {
        let gridType = Settings.libraryType()
        let viewWidth = collectionView.bounds.width
        let viewHeight = collectionView.bounds.height

        // CUSTOM LOGIC STARTS HERE

        if gridType == .list {
            let targetWidth = targetListWidth

            var numberOfColumns: CGFloat = 1

            while viewWidth - ((numberOfColumns + 1) * (targetWidth + listSpacing) + listSpacing) > 0 && numberOfColumns < 3 {
                numberOfColumns += 1
            }

            let calculatedWidth = (viewWidth - (numberOfColumns + 1) * listSpacing) / numberOfColumns

            return CGSize(width: floor(calculatedWidth), height: 92)
        }

        let targetWidth = defaultTargetWidth * (gridType == .fourByFour ? 0.66 : 1)

        var numberOfColumns: CGFloat = gridType == .fourByFour ? 3 : 2

        while viewWidth - ((numberOfColumns + 1) * (targetWidth + gridSpacing) + gridSpacing) > 0 && numberOfColumns < 10 {
            numberOfColumns += 1
        }

        let calculatedWidth = (viewWidth - (numberOfColumns + 1) * gridSpacing) / numberOfColumns
        let heightMultiplier = gridType == .threeByThree ? 1.2 : 1

        return CGSize(width: floor(calculatedWidth), height: floor(calculatedWidth * heightMultiplier))

        // CUSTOM LOGIC ENDS HERE

        if gridType == .list {
            return CGSize(width: viewWidth, height: 65)
        }

        var divideBy: CGFloat
        if viewWidth > viewHeight {
            if viewWidth > GridHelper.bigDeviceLandscapeWidth {
                divideBy = gridType == .threeByThree ? 10 : 14
            } else {
                divideBy = gridType == .threeByThree ? 5 : 7
            }
        } else {
            if viewWidth > GridHelper.bigDevicePortraitWidth {
                divideBy = gridType == .threeByThree ? 6 : 8
            } else {
                divideBy = gridType == .threeByThree ? 3 : 4
            }
        }

        let roundedSizeStr = cellSizeFormatter.string(from: NSNumber(value: Double(viewWidth / divideBy)))
        let roundedSize = roundedSizeStr?.toDouble() ?? 0
        // if there aren't enough podcasts to fill the first row, don't do anything weird
        if viewWidth > CGFloat(Double(itemCount) * roundedSize) {
            return CGSize(width: roundedSize, height: roundedSize)
        }

        let flooredSize = floor(viewWidth / divideBy)
        let pixelsRemaining = Int(viewWidth - (flooredSize * divideBy))
        // if we don't need to add extra pixels to make things sit snugly together, then don't
        if pixelsRemaining == 0 {
            return CGSize(width: flooredSize, height: flooredSize)
        }

        // if we get here then the screen is not divisible in an even amount, we'll need to add more pixels
        let row = floor(CGFloat(indexPath.row) / divideBy) + 1
        let column = indexPath.row - Int((row - 1) * divideBy)

        if pixelsRemaining > column {
            return CGSize(width: flooredSize + 1, height: flooredSize)
        }

        return CGSize(width: flooredSize, height: flooredSize)
    }

    // MARK: - Drag and Drop

    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer, from collectionView: UICollectionView, isList: Bool, containerView: UIView) {
        var location = gesture.location(in: collectionView)
        movingIndexPath = collectionView.indexPathForItem(at: location)

        if gesture.state == .began {
            if let movingIndexPath = movingIndexPath {
                collectionView.beginInteractiveMovementForItem(at: movingIndexPath)
                animatePickingUpCell(pickedUpCell(collectionView: collectionView))
            }
        } else if gesture.state == .changed {
            if isList {
//                location = CGPoint(x: containerView.bounds.width / 2, y: location.y)
            }
            collectionView.updateInteractiveMovementTargetPosition(location)
        } else if gesture.state == .ended {
            collectionView.endInteractiveMovement()
            animatePuttingDownCell(pickedUpCell(collectionView: collectionView))
        } else {
            collectionView.cancelInteractiveMovement()
            animatePuttingDownCell(pickedUpCell(collectionView: collectionView))
        }
    }

    private func pickedUpCell(collectionView: UICollectionView) -> UICollectionViewCell? {
        guard let path = movingIndexPath else { return nil }

        return collectionView.cellForItem(at: path)
    }

    private func animatePickingUpCell(_ cell: UICollectionViewCell?) {
        guard let cell = cell else { return }

        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            cell.alpha = GridHelper.moveAlpha
            cell.transform = CGAffineTransform(scaleX: GridHelper.moveScale, y: GridHelper.moveScale)
        }, completion: nil)
    }

    private func animatePuttingDownCell(_ cell: UICollectionViewCell?) {
        guard let cell = cell else { return }

        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            cell.alpha = 1
            cell.transform = .identity
        }, completion: nil)
    }
}
