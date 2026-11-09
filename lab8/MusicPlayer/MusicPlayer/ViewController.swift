import UIKit
import AVFoundation

class ViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!

    // MARK: - Properties

    private var audioPlayer: AVAudioPlayer?
    private var currentTrackIndex = 0
    private var isPlaying = false

    private let tracks = TrackLibrary.tracks

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // MARK: - Update UI

    private func updateUI() {
        let track = tracks[currentTrackIndex]

        titleLabel.text = track.title
        artistLabel.text = track.artist

        coverImageView.image = UIImage(
            named: track.coverImageName
        )

        let icon = isPlaying ? "pause.fill" : "play.fill"

        playPauseButton.setImage(
            UIImage(systemName: icon),
            for: .normal
        )
    }

    // MARK: - Load Audio

    private func loadTrack() {
        let track = tracks[currentTrackIndex]

        guard let url = Bundle.main.url(
            forResource: track.fileName,
            withExtension: "mp3"
        ) else {
            audioPlayer = nil
            print("Audio file not found: \(track.fileName)")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
        } catch {
            audioPlayer = nil
            print("Failed to load audio: \(error)")
        }
    }

    // MARK: - Play / Pause

    @IBAction func playPauseTapped(_ sender: Any) {
        if isPlaying {
            audioPlayer?.pause()
            isPlaying = false
        } else {
            if audioPlayer == nil {
                loadTrack()
            }

            isPlaying = audioPlayer?.play() ?? false
        }

        updateUI()
    }

    // MARK: - Next Track

    @IBAction func nextTapped(_ sender: Any) {
        changeTrack(by: 1)
    }

    // MARK: - Previous Track

    @IBAction func previousTapped(_ sender: Any) {
        changeTrack(by: -1)
    }

    // MARK: - Change Track

    private func changeTrack(by offset: Int) {
        let wasPlaying = isPlaying

        audioPlayer?.stop()
        audioPlayer = nil

        currentTrackIndex = (
            currentTrackIndex + offset + tracks.count
        ) % tracks.count

        loadTrack()

        if wasPlaying {
            isPlaying = audioPlayer?.play() ?? false
        } else {
            isPlaying = false
        }

        updateUI()
    }
}

// MARK: - Audio Player Delegate

extension ViewController: AVAudioPlayerDelegate {

    func audioPlayerDidFinishPlaying(
        _ player: AVAudioPlayer,
        successfully flag: Bool
    ) {
        guard flag else {
            isPlaying = false
            updateUI()
            return
        }

        currentTrackIndex = (
            currentTrackIndex + 1
        ) % tracks.count

        audioPlayer = nil
        loadTrack()

        isPlaying = audioPlayer?.play() ?? false
        updateUI()
    }
}
