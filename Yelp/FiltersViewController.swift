//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Liqiang Ye on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CategoryCellDelegate {

    @IBOutlet weak var filtersTableView: UITableView!

    fileprivate var filterSettings: FilterSettings = FilterSettings.init()
    fileprivate var filterSettingsHandler: (FilterSettings) -> Void = { (filters) in }
    fileprivate var filterCellIdentifiers = ["OfferFilterCell", "DistanceHeaderCell", "DistanceFilterCell", "SortbyHeaderCell", "SortbyFilterCell", "CategoryHeaderCell", "CategoryFilterCell", "SeeAllCategoriesCell"]
    
    var categories: [[String: String]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filtersTableView.delegate = self
        filtersTableView.dataSource = self
        
        filtersTableView.estimatedRowHeight = 100
        filtersTableView.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view.
    }

    func prepare(filterSetting: FilterSettings?, filterSettingsHandler: @escaping (FilterSettings) -> Void) {
        
        if let filterSetting = filterSetting {
            self.filterSettings = filterSetting
        }
        
        self.filterSettingsHandler = filterSettingsHandler
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onCancelNavButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onSearchNavButtonClicked(_ sender: Any) {
        filterSettingsHandler(filterSettings)
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
            return filterSettings.showAllCategories ? filterSettings.categories.count : 3
        case 7:
            return filterSettings.showAllCategories ? 0 : 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        switch section {
        case 0, 1, 3, 5:
            return 30

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
                filtersTableView.reloadSections([2], with: .automatic)
                //filtersTableView.reloadData()
            case 4:
                if filterSettings.showSortBy {
                    filterSettings.sortbySelectedIndex = indexPath.row
                }
                filterSettings.showSortBy = !filterSettings.showSortBy
                filtersTableView.reloadSections([4], with: .automatic)
            case 7:
                filterSettings.showAllCategories = !filterSettings.showAllCategories
                filtersTableView.reloadSections([6, 7], with: .automatic)
            default:
                ()
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let defaultTableViewCell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            guard let offerFilterCell = filtersTableView.dequeueReusableCell(withIdentifier: filterCellIdentifiers[0]) as? OfferFilterCell else { return defaultTableViewCell }
            
            
            offerFilterCell.offerFilterSwitch = {(isOn: Bool) in
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
                distanceFilterCell.distanceDropDownLabel.isHidden = true
                distanceFilterCell.distanceLabel.text = filterSettings.distances[indexPath.row]
                distanceFilterCell.accessoryType = indexPath.row == filterSettings.distanceSelectedIndex ? .checkmark : .none
            } else {
                distanceFilterCell.distanceDropDownLabel.isHidden = false
                distanceFilterCell.distanceLabel.text = filterSettings.distances[filterSettings.distanceSelectedIndex]
                distanceFilterCell.accessoryType = .none
            }
            
            return distanceFilterCell

        case 3:
            guard let sortbyHeaderCell = filtersTableView.dequeueReusableCell(withIdentifier: filterCellIdentifiers[3]) as? SortbyHeaderCell else { return defaultTableViewCell }
            return sortbyHeaderCell

        case 4:
            
            guard let sortbyFilterCell = filtersTableView.dequeueReusableCell(withIdentifier: filterCellIdentifiers[4]) as? SortbyFilterCell else { return defaultTableViewCell }
            
            if filterSettings.showSortBy {
                sortbyFilterCell.sortbyDropDownLabel.isHidden = true
                sortbyFilterCell.sortbyLabel.text = filterSettings.sortBys[indexPath.row]
                sortbyFilterCell.accessoryType = indexPath.row == filterSettings.sortbySelectedIndex ? .checkmark : .none
            } else {
                sortbyFilterCell.sortbyDropDownLabel.isHidden = false
                sortbyFilterCell.sortbyLabel.text = filterSettings.sortBys[filterSettings.sortbySelectedIndex]
                sortbyFilterCell.accessoryType = .none
            }
            
            return sortbyFilterCell

        case 5:
            guard let categoryHeaderCell = filtersTableView.dequeueReusableCell(withIdentifier: filterCellIdentifiers[5]) as? CategoryHeaderCell else { return defaultTableViewCell}
            return categoryHeaderCell
        
        case 6:
            guard let categoryFilterCell = filtersTableView.dequeueReusableCell(withIdentifier: filterCellIdentifiers[6]) as? CategoryFilterCell else { return defaultTableViewCell }
            
            //#4. make category filter cell delegate to self
            categoryFilterCell.delegate = self

            let category_name: String = filterSettings.categories[indexPath.row]["name"]!
            categoryFilterCell.categoryLabel.text = category_name
            categoryFilterCell.categorySwitch.isOn = filterSettings.categoryFilters[indexPath.row]
            
            return categoryFilterCell
        case 7:
            guard let seeAllCategoriesCell = filtersTableView.dequeueReusableCell(withIdentifier: filterCellIdentifiers[7]) as? SeeAllCategoriesCell else { return defaultTableViewCell }
            return seeAllCategoriesCell
        default:
            return defaultTableViewCell
        }
        
    }
    
    //#5: delegate function
    func categorySwitchChanged(categoryCell: CategoryFilterCell, switchIsOn: Bool) {
        let indexPath = filtersTableView.indexPath(for: categoryCell)!
        filterSettings.categoryFilters[indexPath.row] = switchIsOn
        
        let category_name: String = filterSettings.categories[indexPath.row]["name"]!
        let category_code: String = filterSettings.categories[indexPath.row]["code"]!
        
        if switchIsOn {
            filterSettings.selectedCategories[category_name] = category_code
        } else {
            filterSettings.selectedCategories.removeValue(forKey: category_name)
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
