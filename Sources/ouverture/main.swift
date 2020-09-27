func main() {
    print("Hello, ouverture!")
    test2()
}

func test1() {
    let ext = "txt"
    print("The pref uti for \(ext) is:\t\(Preferences.getUtiString(for: ext))")
    print("The default opener for \(ext) is:\t\(Preferences.getDefault(for: ext))")
}

func test2() {
    let dir = "Mock"
    let types = Preferences.readSupportedFileTypesFromPlist(dir: dir)
    print(types)
}

main()
