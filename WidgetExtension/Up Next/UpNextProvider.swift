import Foundation
import WidgetKit

struct UpNextProvider: TimelineProvider {
    typealias Entry = UpNextEntry

    func placeholder(in context: Context) -> UpNextEntry {
        let widgetData = WidgetData.shared
        widgetData.reload()

        return upNextEntry(data: widgetData, imageCountToCache: context.family.imageCount)
    }

    func getSnapshot(in context: Context, completion: @escaping (UpNextEntry) -> Void) {
        let widgetData = WidgetData.shared
        widgetData.reload()

        completion(upNextEntry(data: widgetData, imageCountToCache: context.family.imageCount))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let widgetData = WidgetData.shared
        widgetData.reload()

        let entry = upNextEntry(data: widgetData, imageCountToCache: context.family.imageCount)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    private func upNextEntry(data: WidgetData, imageCountToCache: Int = 0) -> UpNextEntry {
        var episodes: [WidgetEpisode] = []

        if let nowPlayingEpisode = data.nowPlayingEpisode {
            episodes.append(nowPlayingEpisode)
        }

        if let upNextEpisodes = data.upNextEpisodes, upNextEpisodes.count > 0 {
            episodes.append(contentsOf: upNextEpisodes.filter { newEpisode in
                !episodes.contains { episode in
                    episode.episodeUuid == newEpisode.episodeUuid
                }
            })
        }

        if let topFilterEpisodes = data.topFilterEpisodes, topFilterEpisodes.count > 0 {
            episodes.append(contentsOf: topFilterEpisodes.filter { newEpisode in
                !episodes.contains { episode in
                    episode.episodeUuid == newEpisode.episodeUuid
                }
            })
        }

        if episodes.count > 0, imageCountToCache > 0 {
            for episode in episodes.prefix(imageCountToCache) {
                episode.loadImageData()
            }

            return UpNextEntry(date: Date(), episodes: episodes, filterName: data.topFilterName, isPlaying: data.isPlaying, upNextEpisodesCount: episodes.count)
        }

        return UpNextEntry(date: Date(), episodes: nil, filterName: data.topFilterName, isPlaying: data.isPlaying, upNextEpisodesCount: 0)
    }
}

private extension WidgetFamily {
    var imageCount: Int {
        switch self {
        case .systemSmall:
            return 1
        case .systemMedium:
            return 2
        case .systemLarge:
            return 5
        default:
            return 5 // we don't support this size, but added to make switch exhaustive
        }
    }
}
