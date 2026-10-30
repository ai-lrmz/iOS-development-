//
//  ViewController.swift
//  FavoritesRoulette
//
//  Created by MacBook PRO on 17.10.2026.
//

import UIKit

struct FavoriteItem {
    let title: String
    let description: String
    let imageName: String
}

class ViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Data (10 дорам)
        private let favorites: [FavoriteItem] = [
            FavoriteItem(
                title: "Потомки солнца",
                description: "История любви капитана спецназа и военного врача, разворачивающаяся в горячей точке вымышленной страны Урук.",
                imageName: "fav1"
            ),
            FavoriteItem(
                title: "К2 — Телохранитель",
                description: "Остросюжетный боевик о бывшем наёмнике, которого нанимают охранять тайную дочь кандидата в президенты.",
                imageName: "fav2"
            ),
            FavoriteItem(
                title: "Подснежник",
                description: "Драматичная история любви студентки университета и таинственного раненого парня на фоне политических событий Сеула 1987 года.",
                imageName: "fav3"
            ),
            FavoriteItem(
                title: "Аварийная посадка любви",
                description: "Романтическая история южнокорейской наследницы, случайно приземлившейся на параплане в Северной Корее, и офицера, решившего её спрятать.",
                imageName: "fav4"
            ),
            FavoriteItem(
                title: "Мышь",
                description: "Напряжённый психологический триллер об охоте честного молодого патрульного и опытного детектива на безжалостного серийного убийцу.",
                imageName: "fav5"
            ),
            FavoriteItem(
                title: "Врачи",
                description: "Вдохновляющая история бунтарки со сложным прошлым, которая благодаря поддержке наставника становится блестящим нейрохирургом.",
                imageName: "fav6"
            ),
            FavoriteItem(
                title: "Счастье",
                description: "Апокалиптический триллер о жителях элитного жилого комплекса, оказавшихся запертыми на карантине из-за вспышки неизвестного вируса.",
                imageName: "fav7"
            ),
            FavoriteItem(
                title: "Болтун",
                description: "Захватывающий нуар о неудачливом адвокате, которого по ошибке принимают за гениального афериста по прозвищу Большая Мышь.",
                imageName: "fav8"
            ),
            FavoriteItem(
                title: "Силачка До Бон Сун",
                description: "Романтическая комедия о миниатюрной девушке с наследственной сверхчеловеческой силой, которая устраивается телохранителем директора игровой компании.",
                imageName: "fav9"
            ),
            FavoriteItem(
                title: "Хваран",
                description: "Историческая дорама о дружбе, взрослении и страстях элитного отряда прекрасных молодых воинов древнего королевства Силла.",
                imageName: "fav10"
            )
        ]
    
    private var currentIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        showRandomFavorite()
        // Do any additional setup after loading the view.
    }

    private func configureAppearance() {
            cardView.layer.cornerRadius = 24
            cardView.layer.masksToBounds = true

            favoriteImageView.layer.cornerRadius = 16
            favoriteImageView.clipsToBounds = true
        }
    
    private func showRandomFavorite() {
            guard favorites.count > 1 else { return }

            var nextIndex = Int.random(in: 0..<favorites.count)
            while nextIndex == currentIndex {
                nextIndex = Int.random(in: 0..<favorites.count)
            }

            currentIndex = nextIndex
            let item = favorites[nextIndex]

            favoriteImageView.image = UIImage(named: item.imageName)
            titleLabel.text = item.title
            descriptionLabel.text = item.description
        }
    
    @IBAction func spinButtonTapped(_ sender: UIButton) {
        showRandomFavorite()
    }
    
}

