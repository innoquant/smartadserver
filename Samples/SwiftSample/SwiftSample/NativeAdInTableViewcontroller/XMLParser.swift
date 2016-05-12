//
//  XMLParser.swift
//  SplitAndPopover
//
//  Created by Gabriel Theodoropoulos on 17/9/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

import UIKit


@objc protocol XMLParserDelegate {
    func parser(parser: XMLParser, didFinishParsing results: [Dictionary<String, String>])
}

class XMLParser: NSObject, NSXMLParserDelegate {
    
    static let ITEM_KEY = "item"
    static let TITLE_KEY = "title"
    static let DESCRIPTION_KEY = "description"
    static let LINK_KEY = "link"
    static let PUBDATE_KEY = "pubDate"
    static let URL_KEY = "url"
    
    private var arrParsedData = [Dictionary<String, String>]()
    private var currentDataDictionary = Dictionary<String, String>()
    
    private var currentElement = ""
    private var foundCharacters = ""
    private var foundUrl = ""
    
    weak var delegate : XMLParserDelegate?
    
    func startParsingWithContentsOfURL(rssURL: NSURL!) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
            self.arrParsedData.removeAll();
            let parser = NSXMLParser(contentsOfURL: rssURL)
            parser!.delegate = self
            parser!.parse()
        }
    }
    
    // MARK: - NSXMLParserDelegate method implementation
    
    func parserDidEndDocument(parser: NSXMLParser) {
        dispatch_async(dispatch_get_main_queue()) {
            self.delegate?.parser(self, didFinishParsing:self.arrParsedData)
        }
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case XMLParser.DESCRIPTION_KEY:
            currentDataDictionary[XMLParser.URL_KEY] = foundUrl;
            foundUrl = ""
            currentDataDictionary[XMLParser.DESCRIPTION_KEY] = foundCharacters
            foundCharacters = ""
        case "link":
            currentDataDictionary[currentElement] = (foundCharacters as NSString).substringFromIndex(3)
        case XMLParser.ITEM_KEY:
            arrParsedData.append(currentDataDictionary)
        default:
            currentDataDictionary[currentElement] = foundCharacters
            break
        }
        
        foundCharacters = ""
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if currentElement == XMLParser.TITLE_KEY || currentElement == XMLParser.DESCRIPTION_KEY || currentElement == XMLParser.LINK_KEY || currentElement == XMLParser.PUBDATE_KEY {
            foundCharacters += string
        }
    }
  
    func parser(parser: NSXMLParser, foundCDATA CDATABlock: NSData) {
        if currentElement == XMLParser.DESCRIPTION_KEY {
            extractDataFromDescription(NSString(data: CDATABlock, encoding: NSUTF8StringEncoding))
        }
    }
    
    private func extractDataFromDescription(description: NSString?) {
        if let theString = description {
            let startPos = theString.rangeOfString("src=\"")
            
            if startPos.location != NSNotFound {
                let endPos = theString.rangeOfString("\"", options: NSStringCompareOptions.LiteralSearch, range: NSMakeRange(startPos.location + 5, theString.length - startPos.location - 5))
                if endPos.location != NSNotFound {
                    foundUrl = theString.substringWithRange(NSMakeRange(startPos.location + 5, endPos.location - startPos.location - 5))
                }
                
                let startDescPos = theString.rangeOfString("/>")
                if startDescPos.location != NSNotFound {
                    foundCharacters += theString.substringWithRange(NSMakeRange(startDescPos.location + 2, theString.length - startDescPos.location - 2))
                }
            }
        }
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        print(parseError.description)
    }
    
    func parser(parser: NSXMLParser, validationErrorOccurred validationError: NSError) {
        print(validationError.description)
    }
    
}
