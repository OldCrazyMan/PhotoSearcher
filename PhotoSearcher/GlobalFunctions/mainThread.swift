//
//  mainThread.swift
//  PhotoSearcher
//
//  Created by Tim Akhmetov on 04.12.2022.
//

import Foundation

public func mainThread(closure: @escaping ()->()) {
    DispatchQueue.main.async {
        closure()
    }
}
