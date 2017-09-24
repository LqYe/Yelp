//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Liqiang Ye on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var filtersTableView: UITableView!

    fileprivate var filterSettings: FilterSettings = FilterSettings.init()
//    fileprivate var filterSettingHandler: (FilterSettings) -> Void = { (filters) in }
    fileprivate var filterCellIdentifiers = ["OfferFilterCell", "DistanceHeaderCell", "DistanceFilterCell", "SortbyHeaderCell", "SortbyFilterCell", "CategoryHeaderCell", "CategoryFilterCell"]
    
    var categories: [[String: String]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filtersTableView.delegate = self
        filtersTableView.dataSource = self
        
        filtersTableView.estimatedRowHeight = 100
        filtersTableView.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onCancelNavButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onSearchNavButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Tableview Setup
    func numberOfSections(in tableView: UITableView) -> Int {
        return filterCellIdentifiers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1, 3, 5:
            return 1
        case 2:
            return filterSettings.showDistance ? filterSettings.distances.count : 1
        case 4:
            return filterSettings.showSortBy ? filterSettings.sortBys.count : 1
        case 6:
            return filterSettings.showCategories ? filterSettings.categories.count : 3
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
            case 2:
                if filterSettings.showDistance {
                    filterSettings.distanceSelectedIndex = indexPath.row
                }
                filterSettings.showDistance = !filterSettings.showDistance
                filtersTableView.reloadSections(IndexSet (integer: 2), with: .automatic)
                //filtersTableView.reloadData()
            case 4:
                if filterSettings.showSortBy {
                    filterSettings.sortbySelectedIndex = indexPath.row
                }
                filterSettings.showSortBy = !filterSettings.showSortBy
                filtersTableView.reloadSections(IndexSet (integer: 4), with: .automatic)

            default:
                ()
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let defaultTableViewCell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            guard let offerFilterCell = filtersTableView.dequeueReusableCell(withIdentifier: filterCellIdentifiers[0]) as? OfferFilterCell else { return defaultTableViewCell }
            
            offerFilterCell.offerFilterSwitch = {(isOn) in
                self.filterSettings.isOfferingDeal = isOn
            }
            
            offerFilterCell.offerSwitch.isOn = filterSettings.isOfferingDeal
            
            return offerFilterCell
        case 1:
            guard let distanceHeaderCell = filtersTableView.dequeueReusableCell(withIdentifier: filterCellIdentifiers[1]) as? DistanceHeaderCell else { return defaultTableViewCell }
            return distanceHeaderCell
        case 2:

            guard let distanceFilterCell = filtersTableView.dequeueReusableCell(withIdentifier: filterCellIdentifiers[2]) as? DistanceFilterCell else { return defaultTableViewCell }
            
            if filterSettings.showDistance {
                distanceFilterCell.distanceLabel.text = filterSettings.distances[indexPath.row]
                distanceFilterCell.accessoryType = indexPath.row == filterSettings.distanceSelectedIndex ? .checkmark : .none
            } else {
                distanceFilterCell.distanceLabel.text = filterSettings.distances[filterSettings.distanceSelectedIndex]
                distanceFilterCell.accessoryType = .checkmark
            }
            
            return distanceFilterCell

        case 3:
            guard let sortbyHeaderCell = filtersTableView.dequeueReusableCell(withIdentifier: filterCellIdentifiers[3]) as? SortbyHeaderCell else { return defaultTableViewCell }
            return sortbyHeaderCell

        case 4:
            
            guard let sortbyFilterCell = filtersTableView.dequeueReusableCell(withIdentifier: filterCellIdentifiers[4]) as? SortbyFilterCell else { return defaultTableViewCell }
            
            if filterSettings.showSortBy {
                sortbyFilterCell.sortbyLabel.text = filterSettings.sortBys[indexPath.row]
                sortbyFilterCell.accessoryType = indexPath.row == filterSettings.sortbySelectedIndex ? .checkmark : .none
            } else {
                sortbyFilterCell.sortbyLabel.text = filterSettings.sortBys[filterSettings.sortbySelectedIndex]
                sortbyFilterCell.accessoryType = .checkmark
            }
            
            return sortbyFilterCell

        case 5:
            guard let categoryHeaderCell = filtersTableView.dequeueReusableCell(withIdentifier: filterCellIdentifiers[5]) as? CategoryHeaderCell else { return defaultTableViewCell}
            return categoryHeaderCell
        
        case 6:
            guard let categoryFilterCell = filtersTableView.dequeueReusableCell(withIdentifier: filterCellIdentifiers[6]) as? CategoryFilterCell else { return defaultTableViewCell }

            return categoryFilterCell
        default:
            return defaultTableViewCell
        }
        
    }
    
    
    
   /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    //}
    */

}
