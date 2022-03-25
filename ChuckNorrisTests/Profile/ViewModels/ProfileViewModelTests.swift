import Combine
import CombineMoya
import Moya
import XCTest

@testable import ChuckNorris

class ProfileViewModelTests : XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    func test_validFirstName_publishesEmptyValidationMessage() {
        let expectation = expectation(description: "")
        
        let profileService = InMemoryProfileService()
        let sut = ProfileViewModel(profileService: profileService)
               
        sut.firstName = "valid"
               
        sut.$firstNameValidationMessage
            .dropFirst(1) // Ignore initial state of property and wait for set from validation
            .sink(receiveCompletion: { completion in
            }, receiveValue: { value in
                XCTAssertTrue(value.isEmpty)
                expectation.fulfill()
            })
            
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_validInternationalName_publishesEmptyValidationMessage() {
        let expectation = expectation(description: "")
        
        let profileService = InMemoryProfileService()
        let sut = ProfileViewModel(profileService: profileService)
               
        sut.firstName = "あかり"
               
        sut.$firstNameValidationMessage
            .dropFirst(1) // Ignore initial state of property and wait for set from validation
            .sink(receiveCompletion: { completion in
            }, receiveValue: { value in
                XCTAssertTrue(value.isEmpty)
                expectation.fulfill()
            })
            
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_invalidFirstName_publishesValidationMessage() {
        let expectation = expectation(description: "")
        
        let profileService = InMemoryProfileService()
        let sut = ProfileViewModel(profileService: profileService)
               
        sut.firstName = "0123"
               
        sut.$firstNameValidationMessage
            .dropFirst(1) // Ignore initial state of property and wait for set from validation
            .sink(receiveCompletion: { completion in
            }, receiveValue: { value in
                XCTAssertFalse(value.isEmpty)
                expectation.fulfill()
            })
            
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
