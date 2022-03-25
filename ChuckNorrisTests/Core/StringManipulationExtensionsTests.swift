import XCTest

@testable import ChuckNorris

class StringManipulationExtensions_wrapTests : XCTestCase {
       
    func test_nilPrefixAndSuffix_unchangedString() {
        let sut:String = "test string"
        let result = sut.wrap(prefix: nil, suffix: nil)
        
        XCTAssertEqual(sut, result)
    }
    
    func test_nilPrefix_stringFollowedBySuffix() {
        let sut:String = "test string"
        let result = sut.wrap(prefix: nil, suffix: "]")
        
        XCTAssertEqual("test string]", result)
    }
    
    func test_nilSuffix_stringLeadByPrefix() {
        let sut:String = "test string"
        let result = sut.wrap(prefix: "[", suffix: nil)
        
        XCTAssertEqual("[test string", result)
    }
}
