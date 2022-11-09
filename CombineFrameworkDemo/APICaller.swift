//
//  APICaller.swift
//  CombineFrameworkDemo
//
//  Created by MANOJ SOLANKI on 08/11/22.
//

import Foundation
import Combine

class APICaller{
    private static var sharedInstance :APICaller {
        return APICaller()
    }
    private init(){}
    
    class func shared () -> APICaller{
        return sharedInstance
    }
    
    func fetchData() -> Future<[String],Error>{
        return Future { promixe in
            promixe(.success(["Bhagwanti","Gopal", "Laxmi", "Manoj" ,"Aayu","Niyati", "Nirvi"]))
        }
    }
}
