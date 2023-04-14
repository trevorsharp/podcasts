import Foundation
import SwiftUI

struct UpNextLargeWidgetView: View {
    @State var episodes: [WidgetEpisode]
    @State var filterName: String?
    @State var isPlaying: Bool

    var body: some View {
        LargeFilterView(episodes: $episodes, filterName: $filterName)
    }
}

struct LargeUpNextWidgetView: View {
    @Binding var episodes: [WidgetEpisode]
    @Binding var isPlaying: Bool

    var body: some View {
        ZStack {
            if let firstEpisode = episodes.first {
                GeometryReader { geometry in
                    VStack(alignment: .leading, spacing: 0) {
                        ZStack {
                            Rectangle().fill(Color.clear)
                                .lightBackgroundShadow()
                                .frame(width: .infinity, height: .infinity)
                            HStack(alignment: .top) {
                                EpisodeView(episode: firstEpisode, topText: isPlaying ? Text(L10n.nowPlaying.localizedUppercase) : Text(L10n.podcastTimeLeft(CommonWidgetHelper.durationString(duration: firstEpisode.duration)).localizedUppercase), isPlaying: isPlaying)
                                Spacer()
                                Image("logo_red_small")
                                    .frame(width: 28, height: 28)
                                    .unredacted()
                            }
                        }
                        .padding(16)
                        .frame(height: geometry.size.height * 82 / 345)

                        ZStack {
                            Rectangle().fill(darkBackgroundColor)

                            VStack(alignment: .leading, spacing: 10) {
                                if episodes.count > 1 {
                                    ForEach(episodes[1 ... min(4, episodes.count - 1)], id: \.episodeUuid) { episode in

                                        EpisodeView(episode: episode, topText: Text(CommonWidgetHelper.durationString(duration: episode.duration)))
                                            .frame(height: geometry.size.height * 50 / 345)
                                    }
                                }

                                if episodes.count < 5 {
                                    if episodes.count > 1 {
                                        if episodes.count != 4 {
                                            Spacer().frame(height: 1)
                                        }
                                        Divider()
                                            .background(Color(UIColor.opaqueSeparator))
                                    }
                                    if episodes.count != 4 {
                                        Spacer()
                                    }
                                    HStack {
                                        Spacer()
                                        HungryForMoreView()
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            }
                            .padding(16)
                            .frame(width: .infinity, height: .infinity, alignment: .center)
                        }
                    }
                }
                .clearBackground()
            } else {
                EmptyView()
            }
        }
    }
}

struct LargeFilterView: View {
    @Binding var episodes: [WidgetEpisode]
    @Binding var filterName: String?

    var body: some View {
        guard episodes.first != nil else {
            return AnyView(EmptyView())
        }

        return AnyView(
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 16) {
                    EpisodeView.createCompactWhenNecessaryView(episode: episodes.first!)
                        .frame(minHeight: 40, maxHeight: 56)
                    if let secondEpisode = episodes[safe: 1] {
                        EpisodeView.createCompactWhenNecessaryView(episode: secondEpisode)
                            .frame(minHeight: 40, maxHeight: 56)
                    } else {
                        Spacer()
                            .frame(minHeight: 42, maxHeight: 56)
                    }
                    if let thirdEpisode = episodes[safe: 2] {
                        EpisodeView.createCompactWhenNecessaryView(episode: thirdEpisode)
                            .frame(minHeight: 40, maxHeight: 56)
                    } else {
                        Spacer()
                            .frame(minHeight: 42, maxHeight: 56)
                    }
                    if let fourthEpisode = episodes[safe: 3] {
                        EpisodeView.createCompactWhenNecessaryView(episode: fourthEpisode)
                            .frame(minHeight: 40, maxHeight: 56)
                    } else {
                        Spacer()
                            .frame(minHeight: 42, maxHeight: 56)
                    }
                    if let fifthEpisode = episodes[safe: 4] {
                        EpisodeView.createCompactWhenNecessaryView(episode: fifthEpisode)
                            .frame(minHeight: 40, maxHeight: 56)
                    } else {
                        Spacer()
                            .frame(minHeight: 42, maxHeight: 56)
                    }
                }.padding(16)
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        )
    }
}
