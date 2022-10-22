import PocketCastsDataModel
import UIKit

class FolderGridCell: UICollectionViewCell {
    @IBOutlet var folderPreview: FolderPreviewView!

    @IBOutlet var unplayedSashView: UnplayedSashOverlayView!

    func populateFrom(folder: Folder, badgeType: BadgeType, libraryType: LibraryType) {
        folderPreview.populateFrom(folder: folder, withoutFolderName: true)

        unplayedSashView.populateFrom(folder: folder, badgeType: badgeType, libraryType: libraryType)
    }
}
