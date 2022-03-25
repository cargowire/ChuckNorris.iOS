import Foundation

protocol ProfileService {
    
    func getProfile() -> UserProfile?
    
    func setProfile(value: UserProfile)
    
}
