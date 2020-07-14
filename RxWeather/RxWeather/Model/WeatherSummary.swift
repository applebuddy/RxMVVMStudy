//
//  Copyright (c) 2019 KxCoding <kky0317@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

<<<<<<< HEAD
// - WeatherSummary : 기본 적인 날씨 API 데이터 모델로서 사용됩니다.

import Foundation

struct WeatherSummary: Codable {
    struct Weather: Codable {
        struct Minutely: Codable {
            struct Sky: Codable {
                let code: String
                let name: String
            }

            struct Temperature: Codable {
                let tc: String
                let tmax: String
                let tmin: String
            }

            let sky: Sky
            let temperature: Temperature
        }

        let minutely: [Minutely]
    }

    struct Result: Codable {
        let code: Int
        let message: String
    }

    let weather: Weather
    let result: Result
=======
import Foundation

struct WeatherSummary: Codable {
   struct Weather: Codable {
      struct Minutely: Codable {
         struct Sky: Codable {
            let code: String
            let name: String
         }
         
         struct Temperature: Codable {
            let tc: String
            let tmax: String
            let tmin: String
         }
         
         let sky: Sky
         let temperature: Temperature
      }
      
      let minutely: [Minutely]
   }
   
   struct Result: Codable {
      let code: Int
      let message: String
   }
   
   let weather: Weather
   let result: Result
>>>>>>> 3e71cad83bc33e1403e23ab974cc2d2837f3574a
}
