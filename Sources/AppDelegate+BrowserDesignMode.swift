import AppKit

extension AppDelegate {
    /// Routes the customizable browser-only shortcut without moving keyboard focus.
    func handleBrowserDesignModeShortcut(_ event: NSEvent) -> Bool? {
        guard matchConfiguredShortcut(event: event, action: .toggleBrowserDesignMode) else {
            return nil
        }
        guard let panel = shortcutEventBrowserPanel(event) else { return false }
        Task { @MainActor in
            _ = await panel.toggleDesignMode(reason: "configuredShortcut")
        }
        return true
    }
}

extension Notification.Name {
    /// Posted after design-mode context is copied, so it can also be injected
    /// into the browser's paired terminal (see `handleBrowserDesignModeDidSendContext`).
    static let browserDesignModeDidSendContext = Notification.Name("cmux.browserDesignModeDidSendContext")
}

/// `userInfo` keys for `.browserDesignModeDidSendContext`.
enum BrowserDesignModeDeliveryKey {
    static let workspaceId = "workspaceId"
    static let browserPanelId = "browserPanelId"
    static let content = "content"
}
