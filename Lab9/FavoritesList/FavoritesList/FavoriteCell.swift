
import UIKit

class FavoriteCell: UITableViewCell {

    // Сериалдың постері
    @IBOutlet weak var posterImageView: UIImageView!

    // Сериалдың атауы
    @IBOutlet weak var titleLabel: UILabel!

    // Сериалдың сипаттамасы
    @IBOutlet weak var subtitleLabel: UILabel!

    // Рейтинг жұлдыздары
    @IBOutlet var starImageViews: [UIImageView]!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        posterImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
    }

    // Сериал туралы мәліметтерді көрсету
    func configure(with item: FavoriteItem) {

        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        posterImageView.image = UIImage(named: item.imageName)

        // 0-ден 5-ке дейінгі рейтинг
        let rating = max(0, min(5, item.rating))

        for (index, star) in starImageViews.enumerated() {
            let symbolName = index < rating ? "star.fill" : "star"

            star.image = UIImage(systemName: symbolName)
            star.tintColor = .systemYellow
            star.contentMode = .scaleAspectFit
        }
    }
}
