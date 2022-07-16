//
// https://github.com/atacan
// 16.07.22
	

protocol HaveInitOptional {
    init?(_ : String)
}


extension Int: HaveInitOptional {}
extension Double: HaveInitOptional {}
extension Bool: HaveInitOptional {}
