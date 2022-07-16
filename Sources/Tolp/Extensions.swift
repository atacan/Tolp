//
// https://github.com/atacan
// 16.07.22
	

extension String {
    /// keep the single space, while removing whitespaces. Because CharacterSet.whitespaces includes also the single space
    func condensingWhitespace() -> String {
        return self.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
    
    func removingWhitespace() -> String {
        return self.components(separatedBy: .whitespacesAndNewlines)
            .joined(separator: "")
    }
}
