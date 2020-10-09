import Foundation

public enum FileType: CustomStringConvertible {
    case ext(String)
    case uti(String)
    case urlScheme(String)
}

extension FileType {
    public init(
        _ fileType: String
    ) {
        // * Here we consider that the `fileType`s starting with `.` are extensions, eg. `.txt`,
        // * those ending with `://` are URL schemes,
        // * while the reverse domain names are UTIs.
        // * The fallback case is extension, eg.`txt`.
        // Good old Rust match hack.
        switch () {
        // An extension starting with a dot.
        case _ where fileType.starts(with: "."):
            // Truncate the leading dot.
            self = .ext(String(fileType.dropFirst()))
            return
        // An URL Scheme ending with `://`.
        case _ where fileType.hasSuffix("://"):
            // Truncate the suffix `://`.
            self = .urlScheme(String(fileType.prefix(while: { $0 != ":" })))
            return
        // A reverse domain is possibly an UTI.
        case _ where fileType.isReverseDomain():
            self = .uti(fileType)
            return
        default:
            self = .ext(fileType)
            return
        }
    }

    public var description: String {
        switch self {
        case let .ext(x): return ".\(x)"
        case let .uti(u): return u
        case let .urlScheme(s): return "\(s)://"
        }
    }
}
