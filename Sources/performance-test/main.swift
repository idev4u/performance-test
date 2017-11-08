import Kitura
import KituraNet
import Foundation

struct PayloadModel : Codable {
    var name: String
}

let endpoint = Router()
endpoint.all(middleware: BodyParser())
endpoint.post("/test2") { (request, response, next)  in
    guard let payload = request.body else {
        next()
        print("no json")
        return
    }
    
    print(payload.asJSON?.description as Any)
    try response.send("Hello Swift World!").end()
//    try response.send("Hello Swift World!").status(HTTPStatusCode.OK).end()
    next()
}

Kitura.addHTTPServer(onPort: 8080, with: endpoint)
Kitura.run()


