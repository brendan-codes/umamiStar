//
//  ViewController.swift
//  umamiStar
//
//  Created by Brendan Stanton on 1/22/18.
//  Copyright © 2018 Brendan Stanton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var buttonStyle: UIButton!
    @IBOutlet weak var umamiLogo: UILabel!
    var whiteStar: Bool = false
    
    @IBOutlet weak var quote: UILabel!
    @IBOutlet weak var author: UILabel!
    
    @IBOutlet weak var quoteLoad: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonStyle.layer.borderWidth = 1
        buttonStyle.layer.borderColor = UIColor.white.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // ========= HTTP TOOLING ==========
    
    func getQuotesTest(){
        let url = URL(string: "http://quotes.rest/quote/random.json")
        if let usableUrl = url {
            var request = URLRequest(url: usableUrl)
            request.addValue("INSERT_API_KEY_HERE", forHTTPHeaderField: "X-TheySaidSo-Api-Secret")
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
                if let data = data {
                    if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                        
                        // ==== manipulate JSON here!! ====
                        print(stringData)
                        
                        print("1")
                        // === ridiclous JSON unwrapping ===
                        if let myData = stringData.toJSON() as? NSDictionary {
                            print("2")
                            if let quotes = myData.value(forKey: "contents") as? NSDictionary {
                                print("3")
//                                if let quotes = contents.value(forKey: "quotes") as? NSDictionary {
                                    print("4")
                                    print(quotes.value(forKey: "author") as! String)
                                    print(quotes.value(forKey: "quote") as! String)
                                    
                                    DispatchQueue.main.async {
                                        self.quoteLoad.stopAnimating()
                                        let myQuote = "\u{201c}\(String(describing: quotes.value(forKey: "quote") as! String))\u{201d}"
                                        self.quote.text = myQuote
                                        self.author.text = quotes.value(forKey: "author") as? String
                                    }
//                                }
                            }
                        }
                    }
                }
            })
            task.resume()
        }
    }
    
    
    
    // ======= HELPERS & EXTENSIONS ======
    
    @IBAction func starButton(_ sender: UIButton) {
        print("YO")
        if(!whiteStar){
            umamiLogo.text = "umami ★"
            whiteStar = true
        }else{
            umamiLogo.text = "umami ☆"
            whiteStar = false
        }
        
    }
    @IBOutlet weak var starmeLabel: UIButton!
    
    @IBAction func starMe(_ sender: UIButton) {
        self.quoteLoad.startAnimating()
        author.text = ""
        quote.text = ""
        getQuotesTest()
    }
    
}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}

