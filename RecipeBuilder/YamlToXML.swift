import Foundation
import Yams
import AppKit

// Yaml to XML Functions
// Function to convert Dictionary to XML (Apple plist format)
func dictionaryToXML(dict: [String: Any]) -> String? {
    do {
        let data = try PropertyListSerialization.data(fromPropertyList: dict, format: .xml, options: 0)
        return String(data: data, encoding: .utf8)
    } catch {
        print("Error converting Dictionary to XML: \(error)")
        outputToLogView (logString: "⚠️ Error converting Dictionary to XML: \(error)\n")
        return nil
    }
}


// Function to parse YAML into Dictionary
func yamlToDictionary(yamlString: String) -> [String: Any]? {
    do {
        if let dictionary = try Yams.load(yaml: yamlString) as? [String: Any] {
            return dictionary
        } else {
            print("Error: YAML did not convert to Dictionary")
            outputToLogView (logString: "⚠️ Error: YAML did not convert to Dictionary\n")
            return nil
        }
    } catch {
        print("Error parsing YAML: \(error)")
        outputToLogView (logString: "⚠️ Error parsing YAML: \(error)\n")
        return nil
    }
}


// Function to convert YAML to XML
func yamlToXML(yamlString: String) -> String? {
    if let dictionary = yamlToDictionary(yamlString: yamlString) {
        return dictionaryToXML(dict: dictionary)
    }
    return nil
}


// Output the converted Yaml as XML
func YamlToXML() {
    var yamlDocument = (appDelegate().outputTextField.textStorage as NSAttributedString?)!.string
    if yamlDocument == "" {return }
    
    // Clear Set of error message
    loggedMessages.removeAll()
    
    // Replace empty array from YAML with empty value for XML [] if existing
    yamlDocument = yamlDocument.replacingOccurrences(
        of: #"(?m)(?<=\bProcess:)\s*(?=\n\s*\n|\z)"#,
        with: " []",
        options: [.regularExpression, .caseInsensitive]
    )
    if let xmlOutput = yamlToXML(yamlString: yamlDocument) {
        appDelegate().outputTextField.string = ""
        highlightr!.setTheme(to: "xcode")
        highlightr!.theme.codeFont = NSFont(name: "Menlo", size: 12)
        let highlightedCode = highlightr!.highlight(xmlOutput, as: "xml")!
        appDelegate().outputTextField.textStorage?.insert(highlightedCode, at: 0)
    }
    
    // If we run multiple then we need a check for this
    if loggedMessages.isEmpty {
        outputToLogView(logString: "✅ No problems found\n")
    }
}
