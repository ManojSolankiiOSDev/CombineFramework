//
//  ViewControllerViM.swift
//  CombineFrameworkDemo
//
//  Created by MANOJ SOLANKI on 08/11/22.
//

import Foundation
import Combine

protocol ViewContollerVMProtocol{
    
}

class ViewControllerVM:ViewContollerVMProtocol{
    var observer : AnyCancellable?
    
    var action = PassthroughSubject<[String],Error>()
    
    func fetchDataForList(){
        observer = APICaller.shared().fetchData()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished!!")
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            }, receiveValue: { [weak self] values in
                self?.action.send(values)
            })
    }
}
