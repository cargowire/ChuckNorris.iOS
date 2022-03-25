import Combine
import Foundation

protocol ChuckNorrisJokeRepository {
    
    func random(firstName:String?, lastName:String?, includeExplicit: Bool) -> AnyPublisher<ChuckNorrisJoke, Error>
    
    func randomNumber(number:Int, firstName:String?, lastName:String?, includeExplicit: Bool) -> AnyPublisher<[ChuckNorrisJoke], Error>
}
