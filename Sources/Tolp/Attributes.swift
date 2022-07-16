//
// https://github.com/atacan
// 16.07.22
	

import Plot
import SwiftSoup

/// has predefined values in an enum
struct AttributeEnum<T: RawRepresentable> {
    let attribute: SwiftSoup.Attribute
    var key: String { attribute.getKey() }
    var value: String {
        let value = attribute.getValue()
        if let type = T(rawValue: value as! T.RawValue) {
            return ".\(type)"
        } else if let type = T(rawValue: value.lowercased() as! T.RawValue) {
            return ".\(type)"
        } else if let type = T(rawValue: value.uppercased() as! T.RawValue) {
            return ".\(type)"
        }
        return "\"\(value)\""
    }
    
    func build() -> String {
        return ".\(key)(\(value))"
    }
}

/// has predefined values in an enum
struct AttributeStringInit<T: HaveInitOptional> {
    let attribute: SwiftSoup.Attribute
    var key: String { attribute.getKey() }
    var value: String {
        let value = attribute.getValue()
        if let typeValue = T(value) {
            return "\(typeValue)"
        }
        return "\"\(value)\""
    }
    
    func build() -> String {
        return ".\(key)(\(value))"
    }
}

struct AttributeKeyValue {
    let attribute: SwiftSoup.Attribute
    var key: String { attribute.getKey() }
    var value: String  { attribute.getValue() }
    
    func build() -> String {
        return ".\(key)(\"\(value)\")"
    }
}
