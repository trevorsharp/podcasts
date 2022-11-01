import PocketCastsServer
import PocketCastsUtils
import UIKit

class SonosLinkController: PCViewController {
    @IBOutlet var sonosImage: UIImageView! {
        didSet {
            sonosImage.image = Theme.isDarkTheme() ? UIImage(named: "sonos-dark") : UIImage(named: "sonos-light")
        }
    }

    @IBOutlet weak var titleLabel: ThemeableLabel!
    @IBOutlet var connectBtn: ThemeableRoundedButton!
    @IBOutlet var mainMessage: ThemeableLabel!

    var callbackUri = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        title = L10n.sonosConnectPrompt
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))

        titleLabel.style = .primaryText01
        titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)

        mainMessage.style = .primaryText02
        mainMessage.font = .systemFont(ofSize: 18)

        connectBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if SyncManager.isUserLoggedIn() {
            mainMessage.text = L10n.sonosConnectionPrivacyNotice
            updateConnectButtonTitle(L10n.sonosConnectAction)
        } else {
            mainMessage.text = L10n.sonosConnectionSignInPrompt
            updateConnectButtonTitle(L10n.continue.localizedUppercase)
        }
    }

    @IBAction func connect(_ sender: Any) {
        guard SyncManager.isUserLoggedIn() else {
            signIntoPocketCasts()
            return
        }

        connectWithSonos()
    }

    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
}

    func connectWithSonos() {
        guard ServerSettings.syncingEmail() != nil else {
            updateConnectButtonTitle(L10n.retry.localizedUppercase)
            return
        }

        Task {
            let token = try? await AuthenticationHelper.refreshLogin(scope: .sonos)

            DispatchQueue.main.async { [weak self] in
                guard let token = token else {
                    self?.updateConnectButtonTitle(L10n.retry.localizedUppercase)
                    SJUIUtils.showAlert(title: L10n.sonosConnectionFailedTitle, message: L10n.sonosConnectionFailedAccountLink, from: self)
                    return
                }

                FileLog.shared.addMessage("Sync Token refreshed source: Sonos")
                guard let strongSelf = self else { return }

                let fullUrl = strongSelf.callbackUri + "&code=" + token.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                if let url = URL(string: fullUrl) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    strongSelf.connectBtn.buttonTitle = L10n.retry.localizedUppercase
                    SJUIUtils.showAlert(title: L10n.sonosConnectionFailedTitle, message: L10n.sonosConnectionFailedAppMissing, from: self)
                }
            }
        }
    }

    func signIntoPocketCasts(signInMode: Bool) {
        let signinPage = SyncSigninViewController()
        signinPage.delegate = self
        navigationController?.pushViewController(signinPage, animated: true)
    }

    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Sign In Delegate

    func signingProcessCompleted() {
        navigationController?.popViewController(animated: true)
    }
}
