//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Sushma Adiga on 27/06/21.
//


import Foundation

class OTMClient {
        
    struct Auth {
        static var key = ""
        static var sessionId = ""
        static var objectId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case createSessionId
        case webAuth
        case logout
        case createStudentLocation
        case getStudentLocation
        case getPublicUserData


        var stringValue: String {
            switch self {
                
            case .createSessionId:
                return Endpoints.base + "/session"
                
            case .webAuth:
                return "https://auth.udacity.com/sign-up"
                            
            case .logout:
                return Endpoints.base + "/session"
            
            case .createStudentLocation:
                return Endpoints.base + "/StudentLocation"
            
            case .getStudentLocation:
                return Endpoints.base + "/StudentLocation" + "?limit=100&order=-updatedAt"
            
            case .getPublicUserData:
                return Endpoints.base + "/users/" + Auth.key
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, start: Int ,completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
               
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
           

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(ResponseType.self, from: data[start..<data.count])
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                        let errorResponse = try JSONDecoder().decode(OTMResponse.self, from: data[start..<data.count]) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func taskForPOSTRequest<ResponseType: Decodable>(url: URL, body: String, responseType: ResponseType.Type, start: Int, completion: @escaping (ResponseType?, Error?) -> Void) {
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.addValue("application/json", forHTTPHeaderField: "Accept")
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.httpBody = try! JSONEncoder().encode(body)
         request.httpBody = body.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            _ = data?[start..<data!.count]

            guard let data = data else {
            DispatchQueue.main.async {
                
                completion(nil, error)
            }
              return
          }
                        
            let decoder = JSONDecoder()
                               do {
                                let responseObject = try decoder.decode(ResponseType.self, from: data[start..<data.count])
                                   DispatchQueue.main.async {
                                       completion(responseObject, nil)
                                   }
                               } catch {
                                print(error)
                                   do {
                                    let errorResponse = try decoder.decode(OTMResponse.self, from: data[start..<data.count])
                                       DispatchQueue.main.async {
                                           completion(nil, errorResponse)
                                       }
                                   } catch {
                                    print(error)
                                       DispatchQueue.main.async {
                                           completion(nil, error)
                                      }
                                }
                            }
                    }
                    task.resume()
             }
    
    class func createSessionId(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
            let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"

        taskForPOSTRequest(url: Endpoints.createSessionId.url, body: body, responseType: SessionResponse.self, start: 5) { (response, error) in

            if let response = response {
                Auth.key = response.account.key
                Auth.sessionId = response.session.id
                completion(true, error)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil

        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
            _ = data?[5..<data!.count]
          Auth.sessionId = ""
          completion()
        }
        task.resume()
    }
    
    class func getStudentLocation(completion: @escaping (Bool,Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getStudentLocation.url, responseType: GetStudentLocationResponse.self, start: 0) { (response, error) in
                   if let response = response {
                    OTMModel.student = response.results
                    completion(true,nil)
                   }
                   else {
                    completion(false,error)
                   }
               }
    }
    
    class func createStudentLocation(firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void) {
            let body = "{\"uniqueKey\": \"\(Auth.key)\",\"firstName\": \"\(firstName)\",\"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\",\"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
        taskForPOSTRequest(url: Endpoints.createStudentLocation.url, body: body, responseType: CreateStudentResponse.self, start: 0) { (response, error) in
                  if let response = response {
                    Auth.objectId = response.objectId
                    completion(true,nil)
                  }
                  else {
                      completion(false,error)
                  }
              }
          }
    
    class func getPublicUserData(completion: @escaping (User?,Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getPublicUserData.url, responseType: User.self, start: 5) { (response, error) in
                   if let response = response {
                    completion(response,nil)
                   }
                   else {
                    completion(nil,error)
                   }
               }
    }

}
