import Kitura
import KituraNet
import Foundation

struct PayloadModel {
    var name: String
}

let endpoint = Router()

endpoint.all(middleware: BodyParser())
endpoint.post("/test") { request, response, next in
    print(request.body.debugDescription)
    guard let parsedBody = request.body else {
        next()
        print("no json")
        return
    }
    
    switch(parsedBody) {
    case .json(let jsonBody):
        let name = jsonBody["name"].string ?? ""
        try response.send("Hello \(name)").end()
    default:
        break
    }
    next()
    
}

endpoint.post("/test2") { (request, response, next)  in
    guard let payload = request.body?.asJSON else {
        next()
        print("no json")
        return
    }
    let result = payload.dictionary?["name"]
    print(result?.rawString() ?? "")
    
    try response.send(status: HTTPStatusCode.OK ).end()
    next()
}

Kitura.addHTTPServer(onPort: 8080, with: endpoint)
Kitura.run()


