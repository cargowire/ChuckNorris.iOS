import Combine
import CombineMoya
import Foundation
import Moya

class ICNDbJokeRepository : ChuckNorrisJokeRepository {
    
    private let api : ICNDbApi
    
    init(api:ICNDbApi) {
        self.api = api
    }
           
    func random(firstName:String?, lastName:String?, includeExplicit: Bool) -> AnyPublisher<ChuckNorrisJoke, Error> {
        return self.api.random(firstName: firstName, lastName: lastName, exclude: includeExplicit ? nil : ["explicit"])
            .map { response -> ChuckNorrisJoke in
                return response.value
            }
            .eraseToAnyPublisher()
    }
    
    func randomNumber(number:Int, firstName:String?, lastName:String?, includeExplicit: Bool) -> AnyPublisher<[ChuckNorrisJoke], Error> {
        return self.api.randomNumber(number: number, firstName: firstName, lastName: lastName, exclude: includeExplicit ? nil : ["explicit"])
            .map { response -> [ChuckNorrisJoke] in
                return response.value
            }
            .eraseToAnyPublisher()
    }
}
