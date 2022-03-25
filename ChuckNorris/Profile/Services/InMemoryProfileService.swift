import Combine
import Foundation

class InMemoryProfileService : ProfileService {
    
    private var userProfile: UserProfile?
    
    func getProfile() -> UserProfile? {
        return self.userProfile;
    }
    
    func setProfile(value: UserProfile) {
        self.userProfile  = value;
    }
}
