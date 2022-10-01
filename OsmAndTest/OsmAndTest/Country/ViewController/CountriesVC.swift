//
//  ViewController.swift
//  OsmAndTest
//
//  Created by Hasan Hasanov on 27.09.22.
//

import UIKit
class CountriesVC: UIViewController {

    @IBOutlet weak var progressBar: ProgressView!
    
    @IBOutlet weak var countriesTableView: UITableView!{
        didSet{
            countriesTableView.register(UINib(nibName: "CountriesMapCell", bundle: nil), forCellReuseIdentifier: "MapsCell")
            countriesTableView.delegate = self
            countriesTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var freeMemory: UILabel!
    
    
    let vm = CoutriesVM()
    
    var progressDict: [String: Float] = [:]
    
    var myData: Countries?
    
    var downloadManager = DownloadManager.shared
    
    
    var countriesData: [Region] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupView()
    }
    func setupView(){
        reloadFreeSpacer()
        vm.getJsonData{ data in
            self.myData = data
        }
        vm.getCountriesData { data in
            self.countriesData = data?.region ?? []
            DispatchQueue.global(qos: .userInteractive).sync {
                self.countriesTableView.reloadData()
            }
        }
        downloadManager.delegate = self

    }
    func reloadFreeSpacer(){
        let frac = vm.getFilledSpaceFrac()
        progressBar.updateProgress(frac: frac)
        let freeSpace = convert(UIDevice.current.freeDiskSpaceInBytes)
        self.freeMemory.text = "Free \(freeSpace ?? "-") GB"
    }
}
extension CountriesVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapsCell") as! CountriesMapCell
        let suffix = myData?.first(where: { element in
            return element.type == "continent"
        })
        let id = downloadManager.generateSpecificID(name: countriesData[indexPath.row].name, suffix: suffix?.name ?? "-")
        cell.setupCountriesCell(country: countriesData[indexPath.row], progress: progressDict[id])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let suffix = myData?.first(where: { element in
            return element.type == "continent"
        })
        let id = downloadManager.generateSpecificID(name: countriesData[indexPath.row].name, suffix: suffix?.name ?? "-")
        if progressDict[id] == nil && countriesData[indexPath.row].region == nil{
            downloadManager.submitToQueue(id: id)
        }else if countriesData[indexPath.row].region != nil{
            let sb = UIStoryboard(name: "Region", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "RegionsVC") as! RegionsVC
            vc.regions = countriesData[indexPath.row]
            vc.suffix = suffix?.name ?? "-"
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
    }
    
}
extension CountriesVC: UpdateProgress{
    func didUpdateProgrress(progress: [String : Float]) {
        self.progressDict = progress
        let indexes = self.vm.getIndex(countriesData: self.countriesData, myData: self.myData, progress: progress)
        DispatchQueue.main.async {
            indexes.forEach { item in
                if let cell = self.countriesTableView.cellForRow(at: IndexPath(row: item.0, section: 0)) as? CountriesMapCell{
                    cell.updateProgress(progress: progress[item.1]!)
                }
            }
        }
    }
    
    
}
