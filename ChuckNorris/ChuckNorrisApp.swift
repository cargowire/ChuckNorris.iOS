import Dip
import SwiftUI

@main
struct ChuckNorrisApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        UINavigationBar.appearance().backgroundColor = .clear
        UITableView.appearance().backgroundColor = .clear
    }
    
    static let container: DependencyContainer = {
        let container = DependencyContainer()
        
        container.register(.singleton) { MoyaICNDbApi() as ICNDbApi }
        container.register(.singleton) { ICNDbJokeRepository(api: try! container.resolve()!) as ChuckNorrisJokeRepository }
        container.register(.singleton) { InMemoryProfileService() as ProfileService }
        
        container.register(.unique) {
            RandomJokeGeneratorViewModel(repository: try! container.resolve()!, profileService: try! container.resolve()!)
        }
        
        container.register(.unique) {
            JokeListViewModel(repository: try! container.resolve()!, profileService: try! container.resolve()!)
        }
        
        container.register(.unique) {
            ProfileViewModel(profileService: try! container.resolve()!)
        }
        
        return container
    }()
}
