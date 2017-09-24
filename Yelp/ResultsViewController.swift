//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var businesses: [Business]!
    
    @IBOutlet weak var resultsTableView: UITableView!
    var searchBar: UISearchBar!
    var filterSearchSettings = FilterSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.estimatedRowHeight = 100
        resultsTableView.rowHeight = UITableViewAutomaticDimension
                
        //add a search bar
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        //perform search at first loaded
        doSearch()
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: Error!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return businesses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell") as! ResultCell
        
        cell.business = businesses[indexPath.section]
        
        return cell
    }
    
    // MARK: - Perform Search
    fileprivate func doSearch() {
        
        //MBProgressHUD.showAdded(to: self.view, animated: true)

        let term = filterSearchSettings.searchString ?? "Everything"
        let sortby = YelpSortMode(rawValue: filterSearchSettings.sortbySelectedIndex)
        var categories: [String]?
        let selectedCategories = filterSearchSettings.selectedCategories
        if selectedCategories.count > 0 {
            categories = [String] ()
            for (key, value) in selectedCategories {
                    categories?.append(value)
            }
        }
        let deals = filterSearchSettings.isOfferingDeal
        let distance = filterSearchSettings.radius[filterSearchSettings.distanceSelectedIndex]
        
        Business.searchWithTerm(term: term, sort: sortby, categories: categories, deals: deals, distance: distance, completion: { (businesses: [Business]?, error: Error?) -> Void in

            self.businesses = businesses
            self.resultsTableView.reloadData()
            //MBProgressHUD.hide(for: self.view, animated: true)
        }
        )
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowFilterSettings" {
            
            guard let filterNav = segue.destination as? UINavigationController,
                let filterVC = filterNav.viewControllers.first as? FiltersViewController else {
                    return
            }
        
            filterVC.prepare(filterSetting: filterSearchSettings, filterSettingsHandler: { (filters) in
                self.filterSearchSettings = filters
                self.doSearch()
            })
        
        }
        
    }
    
    
    
}

//search bar extension
extension ResultsViewController: UISearchBarDelegate {
    
    //on search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filterSearchSettings.searchString = searchBar.text
        doSearch()
    }
    
     //on search bar text changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterSearchSettings.searchString = searchText
        doSearch()
    }
    
    //show cancel button
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    //dismiss cancel button
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    //dismiss input keyboard
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
    }
    
    
}
