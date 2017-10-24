import Kitura

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


Kitura.addHTTPServer(onPort: 8080, with: endpoint)
Kitura.run()
