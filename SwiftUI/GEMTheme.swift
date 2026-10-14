import SwiftUI

// Replace the PostScript font names if your downloaded font version differs.
// Download fonts from their respective official/open-source distributors.
enum GEMFont {
    static func display(_ size: CGFloat) -> Font {
        .custom("Sora-ExtraBold", size: size, relativeTo: .largeTitle)
    }

    static func headline(_ size: CGFloat) -> Font {
        .custom("NotoSansTC-Bold", size: size, relativeTo: .headline)
    }

    static func body(_ size: CGFloat) -> Font {
        .custom("NotoSansTC-Regular", size: size, relativeTo: .body)
    }
}

enum GEMPalette {
    static let purple = Color(red: 0.70, green: 0.45, blue: 0.99)
    static let violet = Color(red: 0.44, green: 0.25, blue: 0.83)
    static let gold = Color(red: 0.99, green: 0.82, blue: 0.55)

    static func background(dark: Bool) -> LinearGradient {
        LinearGradient(
            colors: dark
                ? [Color(red: 0.060, green: 0.042, blue: 0.105),
                   Color(red: 0.115, green: 0.066, blue: 0.195),
                   Color(red: 0.055, green: 0.045, blue: 0.105)]
                : [Color(red: 0.985, green: 0.974, blue: 0.994),
                   Color(red: 0.952, green: 0.923, blue: 0.980),
                   Color(red: 0.993, green: 0.979, blue: 0.982)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static func foreground(for scheme: ColorScheme) -> Color {
        scheme == .dark ? .white : Color(red: 0.16, green: 0.10, blue: 0.22)
    }

    static func secondary(for scheme: ColorScheme) -> Color {
        scheme == .dark
            ? Color(red: 0.75, green: 0.70, blue: 0.82)
            : Color(red: 0.42, green: 0.36, blue: 0.48)
    }

    static func card(for scheme: ColorScheme) -> Color {
        scheme == .dark
            ? Color(red: 0.16, green: 0.115, blue: 0.235)
            : .white
    }
}
