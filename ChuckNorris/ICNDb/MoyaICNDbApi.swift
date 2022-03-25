import Combine
import CombineMoya
import Foundation
import Moya

class MoyaICNDbApi : ICNDbApi {
    
    private let api = MoyaProvider<ICNDbEndpoints>()
    
    func get(id:Int) -> AnyPublisher<ICNDbResult<ChuckNorrisJoke>, Error> {
        return self.api.requestPublisher(
            .get(
                id: id
            )
        )
        .map { response in response.data }
        .decode(
            type: ICNDbResult<ChuckNorrisJoke>.self,
            decoder: JSONDecoder()
        )
        .eraseToAnyPublisher()
    }
    
    func random(firstName:String?, lastName:String?, exclude:[String]?) -> AnyPublisher<ICNDbResult<ChuckNorrisJoke>, Error> {
        return self.api.requestPublisher(
            .random(
                firstName: firstName?.isEmpty == true ? nil : firstName,
                lastName: lastName?.isEmpty == true ? nil : lastName,
                limitTo: nil,
                exclude: exclude
            )
        )
        .map { response in response.data }
        .decode(
            type: ICNDbResult<ChuckNorrisJoke>.self,
            decoder: JSONDecoder()
        )
        .eraseToAnyPublisher()
    }
    
    func randomNumber(number:Int, firstName:String?, lastName:String?, exclude:[String]?) -> AnyPublisher<ICNDbResult<[ChuckNorrisJoke]>, Error> {
        return self.api.requestPublisher(
            .randomNumber(
                number: number,
                firstName: firstName?.isEmpty == true ? nil : firstName,
                lastName: lastName?.isEmpty == true ? nil : lastName,
                limitTo: nil,
                exclude: exclude
            )
        )
        .map { response in response.data }
        .decode(
            type: ICNDbResult<[ChuckNorrisJoke]>.self,
            decoder: JSONDecoder()
        )
        .eraseToAnyPublisher()
    }
    
    func categories() -> AnyPublisher<ICNDbResult<[String]>, Error> {
        return self.api.requestPublisher(
            .categories
        )
        .map { response in response.data }
        .decode(
            type: ICNDbResult<[String]>.self,
            decoder: JSONDecoder()
        )
        .eraseToAnyPublisher()
    }
}
