import NMapsMap

struct NCameraUpdate {
    let signature: String
    let target: NMGLatLng?
    let zoom: Double?
    let zoomBy: Double?
    let tilt: Double?
    let tiltBy: Double?
    let bearing: Double?
    let bearingBy: Double?
    let bounds: NMGLatLngBounds?
    let boundsPadding: NEdgeInsets?
    let pivot: NPoint?
    let animation: NMFCameraUpdateAnimation
    let duration: Int // mill seconds. not Second.

    var cameraUpdate: NMFCameraUpdate? {
        get throws {
            let cameraUpdate: NMFCameraUpdate

            switch signature {
            case "withParams": cameraUpdate = NMFCameraUpdate(params: params)
            case "fitBounds": cameraUpdate = boundsPadding != nil
                    ? NMFCameraUpdate(fit: bounds!, paddingInsets: boundsPadding!.uiEdgeInsets)
                    : NMFCameraUpdate(fit: bounds!)
            default: throw NSError()
            }

            if let pivot {
                cameraUpdate.pivot = pivot.cgPoint
            }

            cameraUpdate.animation = animation
            cameraUpdate.animationDuration = (Double(duration) / 1000)

            return cameraUpdate
        }
    }

    private var params: NMFCameraUpdateParams {
        get {
            let p = NMFCameraUpdateParams()
            if let target {
                p.scroll(to: target)
            }
            if let zoom {
                p.zoom(to: zoom)
            }
            if let zoomBy {
                p.zoom(by: zoomBy)
            }
            if let tilt {
                p.tilt(to: tilt)
            }
            if let tiltBy {
                p.tilt(by: tiltBy)
            }
            if let bearing {
                p.rotate(by: bearing)
            }
            if let bearingBy {
                p.rotate(by: bearingBy)
            }
            return p
        }
    }

    static func fromDict(_ v: Any) -> NCameraUpdate {
        let d = asDict(v)
        return NCameraUpdate(
                signature: asString(d["sign"]!),
                target: castOrNull(d["target"], caster: asLatLng),
                zoom: castOrNull(d["zoom"], caster: asDouble),
                zoomBy: castOrNull(d["zoomBy"], caster: asDouble),
                tilt: castOrNull(d["tilt"], caster: asDouble),
                tiltBy: castOrNull(d["tiltBy"], caster: asDouble),
                bearing: castOrNull(d["bearing"], caster: asDouble),
                bearingBy: castOrNull(d["bearingBy"], caster: asDouble),
                bounds: castOrNull(d["bounds"], caster: asLatLngBounds),
                boundsPadding: castOrNull(d["boundsPadding"], caster: NEdgeInsets.fromDict),
                pivot: castOrNull(d["pivot"], caster: NPoint.fromDict),
                animation: asCameraAnimation(d["animation"]!),
                duration: asInt(d["duration"]!)
        )
    }
}