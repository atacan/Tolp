//
// https://github.com/atacan
// 16.07.22


import Plot
import SwiftSoup

/// doesn't have children. has a text content as a string argument
struct ElementString {
    let element: SwiftSoup.Element
    
    init(element: SwiftSoup.Element) {
        self.element = element
    }
    
    var name: String {
        element.nodeName()
    }
    
    var content: String? {
        let text = element.ownText()
        guard !text.isEmpty else {
            return nil
        }
        
        return text
    }
    
    var attributes: [String]? {
        guard let attributesUnwrapped = element.getAttributes(),
              attributesUnwrapped.size() > 0
        else {
            return nil
        }
        
        return attributesUnwrapped.map { attribute in
            return Converter.shared.decode(attribute: attribute, of: element)
        }
    }
    
    func build() -> String {
        let start = ".\(name)("
        var output = [String]()
        
        if let content = content {
            output.append("\"\(content)\"")
        }
        
        if let attributes = attributes {
            output.append(contentsOf: attributes)
        }
        let end = ")\n"
        return start + output.joined(separator: ", ") + end
    }
}

/// has other elements in its content
struct ElementContent {
    let element: SwiftSoup.Element
    
    init(element: SwiftSoup.Element) {
        self.element = element
    }
    
    var name: String {
        let nodeName = element.nodeName()
        switch nodeName {
        case "html":
            return "HTML"
        default:
            return ".\(nodeName)"
        }
    }
    
    var content: [String]? {
        let children = element.children()
        guard !children.isEmpty else {
            return nil
        }
        
        return children.compactMap { child in
            //            ElementContent(element: child).build()
            Converter.shared.decode(element: child)
        }
    }
    
    /// string that is not inside any other child tag
    var singleText: String? {
        let text = element.ownText()
        guard !text.isEmpty else {
            return nil
        }
        
        return text
    }
    
    var attributes: [String]? {
        guard let attributes = element.getAttributes(),
              attributes.size() > 0
        else {
            return nil
        }
        
        return attributes.map { attribute in
            return Converter.shared.decode(attribute: attribute, of: element)
        }
    }
    
    func build() -> String {
        var output = ["\(name)(\n"]
        
        if let attributes = attributes {
            let inner = "\(attributes.joined(separator: ", ")),\n"
            output.append(inner)
        }
        
        if let content = content {
            let inner = content.joined(separator: ", ")
            output.append(inner)
        }
        
        if let ownText = singleText {
            output.append(", \"\(ownText)\"")
        }
        
        output.append(")\n")
        return output.joined()
        
    }
}

public class Converter {
    public static let shared = Converter()
    
    public init() {}
    
    public func decode(element: SwiftSoup.Element) -> String {
        var output = ""
        
        if element.children().isEmpty() {
            let built = ElementString(element: element).build()
            output.append(built)
        } else {
            let built = ElementContent(element: element).build()
            output.append(built)
        }
        return output
    }
    
    public func decode(attribute: SwiftSoup.Attribute, of element: SwiftSoup.Element) -> String {
        switch attribute.getKey() {
        case "async", "autocomplete", "checked", "contenteditable", "spellcheck":
            return AttributeStringInit<Bool>(attribute: attribute).build()
        case "charset":
            return AttributeEnum<Plot.DocumentEncoding>(attribute: attribute).build()
        case "lang":
            return AttributeEnum<Plot.Language>(attribute: attribute).build()
        case "method":
            return AttributeEnum<Plot.HTMLFormMethod>(attribute: attribute).build()
        case "rel":
            return AttributeEnum<Plot.HTMLLinkRelationship>(attribute: attribute).build()
        case "target":
            return AttributeEnum<Plot.HTMLAnchorTarget>(attribute: attribute).build()
        case "type":
            switch element.nodeName() {
            case "source":
                switch element.parent()?.nodeName() {
                case "audio":
                    return AttributeEnum<Plot.HTMLAudioFormat>(attribute: attribute).build()
                default:
                    return AttributeKeyValue(attribute: attribute).build()
                }
            case "button":
                return AttributeEnum<Plot.HTMLButtonType>(attribute: attribute).build()
            case "input":
                return AttributeEnum<Plot.HTMLInputType>(attribute: attribute).build()
            default:
                return AttributeKeyValue(attribute: attribute).build()
            }
        default:
            return AttributeKeyValue(attribute: attribute).build()
        }
    }
    
    public func convert(html: String) throws -> String {
        let doc: SwiftSoup.Document = try SwiftSoup.parse(html)
        let root = doc.child(0)
        let decoded = decode(element: root)
        return decoded
    }
}
