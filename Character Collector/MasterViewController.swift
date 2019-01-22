import UIKit

class MasterViewController: UICollectionViewController {
    
    let charactersData = Characters.loadCharacters()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController!.isToolbarHidden = true
        
        // Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MasterViewController.refreshControlDidFire), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        // weird representation at the beginning
        let layout = collectionViewLayout as! CharacterFlowLayout
        let standardItemSize = layout.itemSize.width * layout.standardItemScale
        layout.estimatedItemSize = CGSize(width: standardItemSize, height: standardItemSize)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MasterToDetail" {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.character = sender as? Characters
        }
    }
    
    func refreshControlDidFire() {
        
        collectionView?.reloadData()
        collectionView?.refreshControl?.endRefreshing()
    }
    
}


// MARK: UICollectionViewDataSource
extension MasterViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return charactersData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharactersCell
        
        // Configure the cell
        let character = charactersData[indexPath.item]
        cell.characterImage.image = UIImage(named: character.name)
        cell.characterTitle.text = character.title
        
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension MasterViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = charactersData[indexPath.item]
        performSegue(withIdentifier: "MasterToDetail", sender: character)
    }
}



