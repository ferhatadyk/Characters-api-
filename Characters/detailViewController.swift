//
//  detailViewController.swift
//  Characters
//
//  Created by Ferhat Adiyeke on 27.12.2022.
//

import UIKit



class detailViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var attiribute: UILabel!
    @IBOutlet weak var attack: UILabel!
    @IBOutlet weak var legs: UILabel!
    
    var hero: HeroStats?

    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = hero?.localized_name
        attiribute.text = hero?.primary_attr
        attack.text = hero?.attack_type
        legs.text = "\((hero?.legs))"

    }
}
