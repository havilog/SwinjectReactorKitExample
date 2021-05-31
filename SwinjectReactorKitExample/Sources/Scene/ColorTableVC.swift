//
//  ColorTableVC.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/05/28.
//

import UIKit

final class ColorTableVC: UIViewController {
    
} 

extension ColorTableVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        return cell
    }
    
    
}
