//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2025/10/29.
//

import UIKit

final class ViewController: UIViewController {

    private let filename: String = "BigBuckBunny.mp4"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else { return }
        
        let time = FFmpegWrapper.getDurationOfVideo(at: url)
        print(time)
    }
}

