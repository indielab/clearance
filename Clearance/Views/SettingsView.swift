import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: AppSettings

    var body: some View {
        Form {
            Picker("Default Open Mode", selection: $settings.defaultOpenMode) {
                ForEach(WorkspaceMode.allCases) { mode in
                    Text(mode.title).tag(mode)
                }
            }
            .pickerStyle(.segmented)

            Text("Newly opened files start in this mode.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Divider()

            Picker("Theme", selection: $settings.theme) {
                ForEach(AppTheme.allCases) { theme in
                    Text(theme.title).tag(theme)
                }
            }
            .pickerStyle(.radioGroup)

            Text(settings.theme.subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)

            Picker("Appearance", selection: $settings.appearance) {
                ForEach(AppearancePreference.allCases) { appearance in
                    Text(appearance.title).tag(appearance)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(16)
        .frame(width: 440)
    }
}
