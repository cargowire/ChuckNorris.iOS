import Combine
import Foundation

class ProfileViewModel: ObservableObject {
    
    @Published var firstName: String = ""
    @Published var firstNameValidationMessage: String = ""
    @Published var lastName: String = ""
    @Published var lastNameValidationMessage: String = ""
    @Published var includeExplicit: Bool = false
    
    private var subscriptions = Set<AnyCancellable>()
    private var isValidating = false
    private var profileService:ProfileService
    
    init(profileService:ProfileService) {
        self.profileService = profileService;

        $firstName
            .handleEvents(receiveOutput: { [self] _ in
                self.isValidating = true
            })
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { [self] value in
                // Attempt to allow multi-lingual names
                if value.range(of: #"^[\p{L}\p{M}'-]{0,30}$"#, options: .regularExpression) == nil {
                    self.firstNameValidationMessage = "profile-firstname-validation-error"
                } else {
                    self.firstNameValidationMessage = ""
                }
                self.isValidating = false
        }.store(in: &subscriptions)
        
        $lastName
            .handleEvents(receiveOutput: { [self] _ in
                self.isValidating = true
            })
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { [self] value in
                // Attempt to allow multi-lingual names
                if value.range(of: #"^[\p{L}\p{M}'-]{0,30}$"#, options: .regularExpression) == nil {
                    self.lastNameValidationMessage = "profile-lastname-validation-error"
                } else {
                    self.lastNameValidationMessage = ""
                }
                self.isValidating = false
        }.store(in: &subscriptions)
        
        if let existingProfile = profileService.getProfile() {
            self.firstName = existingProfile.firstName
            self.lastName = existingProfile.lastName
            self.includeExplicit = existingProfile.includeExplicit
        }
    }
    
    func save() {
        if !self.isValidating && self.firstNameValidationMessage.isEmpty && self.lastNameValidationMessage.isEmpty {
            self.profileService.setProfile(value: UserProfile(firstName: self.firstName, lastName: self.lastName, includeExplicit: self.includeExplicit))
        }
    }
}
