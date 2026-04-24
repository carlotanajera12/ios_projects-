//
//  DetailViewController.swift
//  ios101-project6-tumblr
//
import UIKit
import Nuke

class DetailViewController: UIViewController {

    var post: Post!

    private let photoImageView = UIImageView()
    private let captionTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Post"
        view.backgroundColor = .black

        photoImageView.contentMode = .scaleAspectFit
        photoImageView.translatesAutoresizingMaskIntoConstraints = false

        captionTextView.isEditable = false
        captionTextView.isScrollEnabled = true
        captionTextView.backgroundColor = .black
        captionTextView.textColor = .white
        captionTextView.font = UIFont.systemFont(ofSize: 18)
        captionTextView.text = post.caption.trimHTMLTags()
        captionTextView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(photoImageView)
        view.addSubview(captionTextView)

        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: 300),

            captionTextView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 12),
            captionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            captionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            captionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        if let photo = post.photos.first {
            ImagePipeline.shared.loadImage(with: photo.originalSize.url) { result in
                switch result {
                case .success(let response):
                    self.photoImageView.image = response.image
                case .failure(let error):
                    print("Image failed to load: \(error)")
                }
            }
        }
    }
}
