import NMapsMap

internal struct NOverlayImage {
    let path: String
    let mode: NOverlayImageMode

    var overlayImage: NMFOverlayImage {
        switch mode {
        case .file, .temp, .widget: return makeOverlayImageWithPath()
        case .asset: return makeOverlayImageWithAssetPath()
        }
    }

    private func makeOverlayImageWithPath() -> NMFOverlayImage {
        let image = UIImage(contentsOfFile: path)
        let imageData = image!.pngData()!
        let scaledImage = UIImage(data: imageData, scale: UIScreen.main.scale)
        let overlayImg = NMFOverlayImage(image: scaledImage!)
        return overlayImg
    }

    private func makeOverlayImageWithAssetPath() -> NMFOverlayImage {
        let assetPath = SwiftFlutterNaverMapPlugin.getAssets(path: path)
        let img = NMFOverlayImage(name: assetPath)
        return img
    }

    func toMessageable() -> Dictionary<String, Any> {
        [
            "path": path,
            "mode": mode.rawValue
        ]
    }

    static func fromMessageable(_ v: Any) -> NOverlayImage {
        let d = asDict(v)
        return NOverlayImage(
                path: asString(d["path"]!),
                mode: NOverlayImageMode(rawValue: asString(d["mode"]!))!
        )
    }

    static let none = NOverlayImage(path: "", mode: .temp)
}
