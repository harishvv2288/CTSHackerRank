//
//  ViewController.swift
//  HackerRankProject
//
//  Created by Harish V V on 22/06/19.
//  Copyright © 2019 Company. All rights reserved.
//

import UIKit


///This is the View class which handles just the View creation/rendering

class ViewController: UIViewController {
    
    var feature: Feature?
    var country: Canada?
    
    private var navigationBar: UINavigationBar!
    private var tableView: UITableView!
    
    let imageCache = NSCache<NSString, UIImage>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setUpView()
        
        self.feature = Feature()
        
        //actual trigger for the service call from View which just mentions the service type
        let _  = self.feature?.triggerServiceCall(serviceType: .aboutCanada, completion: { (result) in
            if !result.hasError {
                self.country = result.value as? Canada
                
                DispatchQueue.main.async {
                    //do all UI operations in main thread after successful response is read
                    let navigationItem = UINavigationItem()
                    navigationItem.title = self.country?.title
                    self.navigationBar.items = [navigationItem]
                    
                    self.tableView.reloadData()
                }
            } else {
                print("Failed to receive response!")
            }
        })
    }
    
    //do all initial setup to draw the UI in this function
    private func setUpView() {
        self.navigationBar = UINavigationBar(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height, width: self.view.frame.size.width, height: CGFloat(ConstantsStruct.NavigationBarHeight)))
        self.view.addSubview(self.navigationBar)
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height + self.navigationBar.frame.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        self.tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: IDENTIFIERS.ROWS_CELL_ID)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
    }
}


//handle all tableview delegates in this extension
extension ViewController: UITableViewDelegate, UITableViewDataSource {
   
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.country?.rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.ROWS_CELL_ID) ?? UITableViewCell(style: .subtitle, reuseIdentifier: IDENTIFIERS.ROWS_CELL_ID)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.ROWS_CELL_ID, for: indexPath as IndexPath)
        //
        //        if cell == nil {
        //            cell = UITableViewCell(style: UITableViewCell.CellStyle.value2, reuseIdentifier: "cellId")
        //        }
        
        
        let title = self.country?.rows[indexPath.row].title
        let description = self.country?.rows[indexPath.row].description
        
        cell.textLabel!.text = title
        cell.detailTextLabel?.text = description
        
        //        let label = UILabel.init(frame: CGRect(x:0,y:0,width:100,height:20))
        //        label.text = description
        //        cell.accessoryView = label
        
        var currentUrl: URL?
        
        
        if let imageString = self.country?.rows[indexPath.row].imageUrl {
            currentUrl = URL.init(string: imageString)
            if let cachedImage = self.imageCache.object(forKey: imageString as NSString) {
                cell.imageView?.image = cachedImage
            } else {
                let sessionConfig = URLSessionConfiguration.default
                let session = URLSession.init(configuration: sessionConfig)
                guard let url = URL.init(string: imageString) else {
                    return cell
                }
                let task = session.dataTask(with: url) { (data, response, error) in
                    if error == nil {
                        
                        DispatchQueue.main.async {
                            if let downloadedImage = UIImage(data: data!) {
                                //Only cache and set the image view when the downloaded image is the one from last request
                                if (url == currentUrl) {
                                    self.imageCache.setObject(downloadedImage, forKey: imageString as NSString)
                                    cell.imageView?.image = downloadedImage
                                }
                                
                            }
                        }
                    }
                    else {
                        print(error)
                    }
                }
                task.resume()
            }
            
        }
//            } else {
//                if imageString.count != 0
//                {
//                    DispatchQueue.global(qos: .background).async {
//                        guard let url = URL.init(string: imageString) else {
//                            return
//                        }
//
//                        do {
//                        let data = try Data(contentsOf: url)
//                            let image: UIImage = UIImage(data: data)!
//                            DispatchQueue.main.async {
//                                self.imageCache.setObject(image, forKey: imageString as NSString)
//                                cell.imageView?.image = image
//                            }
//                        } catch {
//                            print("failure")
//                        }
//
//
//                    }
//                }
//            }
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(String(describing: self.country?.rows[indexPath.row].title))")
    }
    
}


//To Do
//coder decoder
//pull to refresh
//custom cell
//test cases
