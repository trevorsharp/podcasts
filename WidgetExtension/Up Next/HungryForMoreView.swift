import Foundation
import SwiftUI

struct HungryForMoreView: View {
    var body: some View {
        Link(destination: URL(string: "pktc://last_opened")!) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("No Episodes")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.secondary)
                        .lineLimit(1)
                }
            }.offset(x: 0, y: 0)
        }
    }
}

struct HungryForMoreLargeView: View {
    var body: some View {
        Link(destination: URL(string: "pktc://last_opened")!) {
            VStack(alignment: .center, spacing: 16) {
                VStack(spacing: 4) {
                    Text("No Episodes")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.secondary)
                        .lineLimit(1)
                }
            }
        }
    }
}
