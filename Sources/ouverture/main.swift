func main() {
    print("Hello, ouverture!")

    let ext = "txt"
    // print("The default opener for \(ext) is:\n\(Preferences.test(for: ext))")
    print("The pref uti for \(ext) is:\t\(Preferences.getUtiString(for: ext))")
    print("The default opener for \(ext) is:\t\(Preferences.getDefault(for: ext))")
}

main()
