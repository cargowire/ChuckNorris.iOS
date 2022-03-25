import XCTest

@testable import ChuckNorris

class HtmlStringExtensions_htmlEncodedStringTests : XCTestCase {
        
    func test_noHtmlIncluded_unchangedString() {
        let sut:String = "test string"
        let result = String(htmlEncodedString: sut)
        
        XCTAssertEqual(sut, result)
    }
    
    func test_quoteEntitiesIncluded_quotesDecoded() {
        let sut:String = "test &quot;string&quot;"
        let result = String(htmlEncodedString: sut)
        
        XCTAssertEqual("test \"string\"", result)
    }
    
    func test_ampersandEntitiesIncluded_stringLeadByPrefix() {
        let sut:String = "test &amp;&amp;string"
        let result = String(htmlEncodedString: sut)
        
        XCTAssertEqual("test &&string", result)
    }
}
