import PocketCastsDataModel
import UIKit

class PodcastGridCellLarge: UICollectionViewCell {
    @IBOutlet var podcastImage: PodcastImageView!
    @IBOutlet var podcastName: ThemeableLabel!

    @IBOutlet var unplayedSashView: UnplayedSashOverlayView!
    @IBOutlet var supporterHeart: PodcastHeartView!

    private var podcastUuid: String?
    private var badgeType = BadgeType.off

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        NotificationCenter.default.addObserver(self, selector: #selector(podcastColorsLoaded(_:)), name: Constants.Notifications.podcastColorsDownloaded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(podcastImageCacheCleared), name: Constants.Notifications.podcastImageReCacheRequired, object: nil)
    }

    func populateFrom(podcast: Podcast, badgeType: BadgeType, libraryType: LibraryType) {
        self.badgeType = badgeType
        podcastUuid = podcast.uuid

        setImage()
        setColors(podcast: podcast)

        podcastName.accessibilityLabel = podcast.title

        unplayedSashView.populateFrom(podcast: podcast, badgeType: badgeType, libraryType: libraryType)

        supporterHeart.isHidden = !podcast.isPaid
        if podcast.isPaid {
            supporterHeart.setPodcastColor(podcast: podcast)
        }
    }

    @objc private func podcastImageCacheCleared() {
        setImage()
    }

    @objc private func podcastColorsLoaded(_ notification: Notification) {
        guard let uuidLoaded = notification.object as? String else { return }

        if uuidLoaded == podcastUuid, let podcast = DataManager.sharedManager.findPodcast(uuid: uuidLoaded) {
            setColors(podcast: podcast)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        podcastUuid = nil
    }

    private func setImage() {
        guard let podcastUuid = podcastUuid else { return }

        podcastImage.setPodcast(uuid: podcastUuid, size: .grid)
    }

    private func setColors(podcast: Podcast) {
        podcastName.text = podcast.title
        podcastName.textColor = ThemeColor.primaryText01()
        podcastName.font = UIFont.systemFont(ofSize: 19, weight: .semibold)

        let bgColor = ColorManager.backgroundColorForPodcast(podcast)
        backgroundColor = bgColor
        podcastName.backgroundColor = bgColor

        backgroundColor = nil
        podcastName.backgroundColor = nil

        if podcast.isPaid {
            supporterHeart.setPodcastColor(podcast: podcast)
        }
    }
}
