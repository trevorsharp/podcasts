import SwiftUI

struct PlusPaywallReviewsStars: View {
    let appStoreInfo: AppStoreInfo

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.plusGradient)
                .mask {
                    HStack(spacing: Constants.containerSpacing) {
                        ForEach(0..<Constants.maxStars, id: \.self) { index in
                            Constants.starImage
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(height: Constants.containerSize.height)
                }
                .frame(width: Constants.containerSize.width, height: Constants.containerSize.height)
                .padding(.bottom, Constants.containerBottomPadding)

            Text(L10n.upgradeExperimentReviewsAppStoreInfo(appStoreInfo.rating, appStoreInfo.reviewCount))
                .font(size: Constants.textSize, style: .body, weight: .medium)
                .foregroundStyle(.white)
        }
    }
    private enum Constants {
        static let maxStars = 5
        static let starImage = Image("star-full")
        static let containerSpacing = 4.0
        static let containerBottomPadding = 8.0
        static let containerSize = CGSize(width: 160.0, height: 30.0)
        static let textSize = 15.0
    }
}

#Preview {
    PlusPaywallReviewsStars(appStoreInfo: AppStoreInfo(rating: "4.3", reviewCount: "5.7", reviews: []))
        .background(.black)
}
