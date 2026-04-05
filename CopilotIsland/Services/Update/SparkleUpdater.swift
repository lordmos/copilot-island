import Foundation
import Sparkle

/// Manages automatic app updates via Sparkle framework.
/// The appcast URL points to GitHub Releases RSS feed for the repository.
final class SparkleUpdater: ObservableObject {
    private var updaterController: SPUStandardUpdaterController

    /// Published so the menu can bind to "Check for Updates" enabled state.
    @Published var canCheckForUpdates = false

    init() {
        updaterController = SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: nil,
            userDriverDelegate: nil
        )
        // Mirror Sparkle's internal state into our published property
        updaterController.updater.publisher(for: \.canCheckForUpdates)
            .assign(to: &$canCheckForUpdates)
    }

    func checkForUpdates() {
        updaterController.checkForUpdates(nil)
    }
}
