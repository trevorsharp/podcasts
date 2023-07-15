import Combine
import PocketCastsDataModel

protocol BookmarkListRouter: AnyObject {
    func bookmarkPlay(_ bookmark: Bookmark)
    func bookmarkEdit(_ bookmark: Bookmark)
}

class BookmarkListViewModel: MultiSelectListViewModel<Bookmark> {
    weak var router: BookmarkListRouter?

    private let bookmarkManager: BookmarkManager
    private var cancellables = Set<AnyCancellable>()

    weak var episode: BaseEpisode? = nil {
        didSet {
            reload()
        }
    }

    init(bookmarkManager: BookmarkManager) {
        self.bookmarkManager = bookmarkManager
        super.init()

        addListeners()
    }

    func reload() {
        items = episode.map { bookmarkManager.bookmarks(for: $0) } ?? []
    }

    /// Reload a single item from the list
    func refresh(bookmark: Bookmark) {
        guard let index = items.firstIndex(of: bookmark) else { return }

        items.replaceSubrange(index...index, with: [bookmark])
    }

    private func addListeners() {
        bookmarkManager.onBookmarkCreated
            .filter { [weak self] episode, _ in
                self?.episode?.uuid == episode.uuid
            }
            .sink { [weak self] _, _ in
                self?.reload()
            }
            .store(in: &cancellables)
    }

    // MARK: - View Methods

    func bookmarkPlayTapped(_ bookmark: Bookmark) {
        router?.bookmarkPlay(bookmark)
    }

    func editSelectedBookmarks() {
        guard let bookmark = selectedItems.first else { return }

        router?.bookmarkEdit(bookmark)
    }

    func deleteSelectedBookmarks() {
        guard numberOfSelectedItems > 0 else { return }

        let items = Array(selectedItems)

        confirmDeletion { [weak self] in
            self?.actuallyDelete(items)
        }
    }
}

private extension BookmarkListViewModel {
    func confirmDeletion(_ delete: @escaping () -> Void) {
        guard let controller = SceneHelper.rootViewController() else { return }

        let alert = UIAlertController(title: L10n.bookmarkDeleteWarningTitle,
                                      message: L10n.bookmarkDeleteWarningBody,
                                      preferredStyle: .alert)

        alert.addAction(.init(title: L10n.cancel, style: .cancel))
        alert.addAction(.init(title: L10n.delete, style: .destructive, handler: { _ in
            delete()
        }))

        controller.present(alert, animated: true, completion: nil)
    }

    func actuallyDelete(_ items: [Bookmark]) {
        Task {
            guard await bookmarkManager.remove(items) else {
                return
            }

            reload()
        }
    }
}
