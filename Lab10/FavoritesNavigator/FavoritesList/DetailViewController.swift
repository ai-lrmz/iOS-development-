
import UIKit

class DetailViewController: UIViewController {

    var item: FavoriteItem?
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star4ImageView: UIImageView!
    @IBOutlet weak var star5ImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let item = item else { return }

        title = item.title

        posterImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        descriptionLabel.text = item.description

        navigationItem.largeTitleDisplayMode = .never

        let stars = [
            star1ImageView,
            star2ImageView,
            star3ImageView,
            star4ImageView,
            star5ImageView
        ]

        for (index, star) in stars.enumerated() {
            let symbolName = index < item.rating ? "star.fill" : "star"
            star?.image = UIImage(systemName: symbolName)
            star?.tintColor = .systemOrange
        }
    }

}

