
import UIKit

class FavoriteCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        posterImageView.image = nil
        titleLabel.text = nil
    }

    // Сериал туралы мәліметтерді көрсету
    func configure(with item: FavoriteItem) {
        titleLabel.text = item.title
        posterImageView.image = UIImage(named: item.imageName)
    }
}
