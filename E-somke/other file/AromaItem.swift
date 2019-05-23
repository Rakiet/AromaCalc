/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import Firebase

struct AromaItem {
  
    let ref: DatabaseReference?
    let nameCompany: String
    let aromaName: String
    let sku: String
    let concentrationMin: Int
    let concentrationMax: Int
  
    init(nameCompany: String, aromaName: String, sku: String, conMin: Int, conMax: Int) {
        self.ref = nil
        self.nameCompany = nameCompany
        self.aromaName = aromaName
        self.sku = sku
        self.concentrationMin = conMin
        self.concentrationMax = conMax
  }
  
  init?(snapshot: DataSnapshot) {
    guard
        let value = snapshot.value as? [String: AnyObject],
        let nameCompany = value["nameCompany"] as? String,
        let aromaName = value["aromaName"] as? String,
        let sku = value["sku"] as? String,
        let concentraionMin = value["conMin"] as? Int,
        let concentraionMax = value["conMax"] as? Int
        else {
            return nil
    }
    
    self.ref = snapshot.ref
    self.nameCompany = nameCompany
    self.aromaName = aromaName
    self.sku = sku
    self.concentrationMax = concentraionMax
    self.concentrationMin = concentraionMin
  }
  
  func toAnyObject() -> Any {
    return [
        "nameCompany": nameCompany,
        "aromaName": aromaName,
        "sku": sku,
        "conMin": concentrationMin,
        "conMax": concentrationMax
    ]
  }
}
