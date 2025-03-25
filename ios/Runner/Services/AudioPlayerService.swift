//
//  AudioPlayerService.swift
//  Runner
//
//  Created by Kai Koga on 25/03/25.
//

import AVFoundation
import Flutter

class AudioPlayerHandler: NSObject, FlutterPlugin {
    var audioPlayer: AVPlayer?
    var playerItem: AVPlayerItem?

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "audio_player", binaryMessenger: registrar.messenger())
        let instance = AudioPlayerHandler()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "play":
            audioPlayer?.play()
            result(nil)

        case "pause":
            audioPlayer?.pause()
            result(nil)

        case "seekTo":
            guard let args = call.arguments as? [String: Any],
                  let position = args["position"] as? Int else {
                result(FlutterError(code: "INVALID_POSITION", message: "Invalid seek position", details: nil))
                return
            }
            seekTo(position: position)
            result(nil)

        case "stop":
            stopAudio()
            result(nil)

        case "getDuration":
            guard let args = call.arguments as? [String: Any],
                  let urlString = args["url"] as? String,
                  let url = URL(string: urlString) else {
                result(FlutterError(code: "INVALID_URL", message: "Invalid audio URL", details: nil))
                return
            }
            playerItem = AVPlayerItem(url: url)
            audioPlayer = AVPlayer(playerItem: playerItem)
            result(playerItem?.asset.duration.seconds ?? 0)

        case "getCurrentPosition":
            result(audioPlayer?.currentTime().seconds ?? 0)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func seekTo(position: Int) {
        let time = CMTime(seconds: Double(position) / 1000, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        audioPlayer?.seek(to: time)
    }

    private func stopAudio() {
        audioPlayer?.pause()
        audioPlayer = nil
        playerItem = nil
    }
}
