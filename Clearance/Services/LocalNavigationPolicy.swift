import Foundation

enum LocalNavigationPolicy {
    static func allows(_ url: URL?) -> Bool {
        guard let url else {
            return true
        }

        guard let scheme = url.scheme?.lowercased() else {
            return true
        }

        switch scheme {
        case "about", "data", "file":
            return true
        default:
            return false
        }
    }
}
