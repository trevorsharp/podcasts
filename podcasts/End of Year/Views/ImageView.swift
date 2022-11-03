import SwiftUI
import Kingfisher

/// A SwiftUI representation of UIImageView
///
/// This is necessary because `Image` does not render correctly
/// when taking screenshots of it — the image doesn't appear.
struct ImageView: UIViewRepresentable {
    let url: URL

    init(_ url: URL) {
        self.url = url
    }

    func makeUIView(context: Context) -> UIImageView {
        let v = UIImageView()

        v.setContentHuggingPriority(.defaultLow, for: .vertical)
        v.setContentHuggingPriority(.defaultLow, for: .horizontal)
        v.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        v.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return v
    }

    func updateUIView(_ uiImage: UIImageView, context: Context) {
        uiImage.kf.setImage(with: url)
    }
}
