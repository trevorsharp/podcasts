import Foundation
import SwiftUI

struct UpNextWidgetEntryView: View {
    @State var entry: UpNextProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        if let episodes = entry.episodes, episodes.count > 0 {
            if family == .systemMedium {
                UpNextMediumWidgetView(episodes: episodes, filterName: entry.filterName, isPlaying: entry.isPlaying)
            } else {
                UpNextLargeWidgetView(episodes: episodes, filterName: entry.filterName, isPlaying: entry.isPlaying)
            }
        } else {
            VStack(alignment: .center) {
                if family == .systemMedium {
                    HungryForMoreView()
                } else {
                    HungryForMoreLargeView()
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(darkBackgroundColor)
        }
    }
}
