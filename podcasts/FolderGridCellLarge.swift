import PocketCastsDataModel
import UIKit

class FolderGridCellLarge: UICollectionViewCell {
    @IBOutlet var folderPreview: FolderPreviewView!
    @IBOutlet var folderName: ThemeableLabel!

    @IBOutlet var unplayedSashView: UnplayedSashOverlayView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func populateFrom(folder: Folder, badgeType: BadgeType, libraryType: LibraryType) {
        folderPreview.populateFrom(folder: folder, withoutFolderName: true)

        unplayedSashView.populateFrom(folder: folder, badgeType: badgeType, libraryType: libraryType)

        folderName.text = folder.name
        folderName.textColor = ThemeColor.primaryText01()
        folderName.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
    }
}
