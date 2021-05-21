//
//  ComicsHomeViewController.swift
//  MarvelComicsV2
//
//  Created by Norah Almaneea on 18/05/2021.
//

import UIKit
import Firebase

class ComicsHomeViewController: UITableViewController {

    var heroes: [Hero] = []
    var name: String?
    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    var loadingHeroes: Bool = false
    var currentPage: Int = 0
    var total = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Looking for heroes! Wait.."
        loadHeroes()
        self.navigationItem.title = "Marvel Comics"
        
    }
    // MARK: - Function to load comics
    func loadHeroes() {
        loadingHeroes = true
        MarvelAPI.loadHeroes(name: name, page: currentPage) { (info) in
            if let info = info {
                self.heroes += info.data.results
                self.total = info.data.total
                print(self.total)
                print(self.heroes.count)
                DispatchQueue.main.async {
                    self.loadingHeroes = false
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! WebViewController
        vc.hero = heroes[tableView.indexPathForSelectedRow!.row]
    }
    // MARK: - Table View Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = heroes.count == 0 ? label : nil
        return heroes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comicsCell", for: indexPath) as! ComicsTableViewCell
        

        let hero = heroes[indexPath.row]
        cell.prepareHero(with: hero)
      

        return cell
    }
 
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == heroes.count - 10 && !loadingHeroes && heroes.count != total {
            currentPage += 1
            loadHeroes()
        }
    }
    
 
}

