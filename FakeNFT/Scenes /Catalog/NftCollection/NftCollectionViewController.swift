import UIKit

final class NftCollectionViewController: UIViewController {
    private let nftCollection: NftCollection
    
    init(nftCollection: NftCollection) {
        self.nftCollection = nftCollection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        title = nftCollection.name
    }
}
