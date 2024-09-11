import Foundation

extension MainEpisodeActionView: UIPointerInteractionDelegate {
    func enablePointerInteraction() {
        pointerInteraction = pointerInteraction ?? UIPointerInteraction(delegate: self)
        if let interaction = pointerInteraction {
            addInteraction(interaction)
        }
    }

    func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
        UIPointerStyle(effect: .automatic(.init(view: self)))
    }
}
