import Foundation

extension MainEpisodeActionView: UIPointerInteractionDelegate {
    func enablePointerInteraction() {
        if pointerInteraction != nil {
            addInteraction(pointerInteraction!)
        }
    }

    func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
        UIPointerStyle(effect: .automatic(.init(view: self)))
    }
}
