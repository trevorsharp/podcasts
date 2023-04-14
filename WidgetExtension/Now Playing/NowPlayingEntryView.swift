import Foundation
import WidgetKit
import SwiftUI

struct NowPlayingWidgetEntryView: View {
    @State var entry: NowPlayingProvider.Entry

    @Environment(\.showsWidgetContainerBackground) var showsWidgetBackground

    var body: some View {
        if let playingEpisode = entry.episode {
            VStack(alignment: .leading, spacing: 5) {
                GeometryReader { geometry in
                    HStack(alignment: .top) {
                        SmallArtworkView(imageData: playingEpisode.imageData)
                            .frame(maxHeight: 70)
                    }.padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                        .background(
                            VStack {
                                if showsWidgetBackground {
                                    Rectangle()
                                        .fill(Color(UIColor(hex: playingEpisode.podcastColor)).opacity(0.85))
                                        .frame(height: 0.667 * geometry.size.height, alignment: .top)
                                }
                                Spacer()
                            })
                }
                Text(playingEpisode.episodeTitle)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.primary)
                    .lineLimit(3)
                    .frame(height: 56, alignment: .center)
                    .layoutPriority(1)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))

            }.widgetURL(URL(string: "pktc://last_opened"))
        } else {
            VStack(alignment: .center) {
                HungryForMoreView()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(darkBackgroundColor)
        }
    }
}
