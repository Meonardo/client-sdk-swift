/*
 * Copyright 2024 LiveKit
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Combine
import Foundation

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

@objc
public class LocalAudioTrack: Track, LocalTrack, AudioTrack {
    @objc
    public internal(set) var capturer: AudioCapturer?

    var audioSource: LKRTCAudioBufferSource?

    /// ``AudioCaptureOptions`` used to create this track.
    let captureOptions: AudioCaptureOptions

    init(name: String,
         source: Track.Source,
         track: LKRTCMediaStreamTrack,
         reportStatistics: Bool,
         captureOptions: AudioCaptureOptions)
    {
        self.captureOptions = captureOptions

        super.init(name: name,
                   kind: .audio,
                   source: source,
                   track: track,
                   reportStatistics: reportStatistics)
    }

    init (name: String,
          source: Track.Source,
          capturer: AudioCapturer,
          audioSource: LKRTCAudioBufferSource,
          reportStatistics: Bool)
    {
        self.capturer = capturer
        self.captureOptions = AudioCaptureOptions()
        self.audioSource = audioSource

        let rtcTrack = RTC.createAudioTrack(source: audioSource)

        super.init(name: name,
                   kind: .audio,
                   source: source,
                   track: rtcTrack,
                   reportStatistics: reportStatistics)
    }

    public static func createTrack(name: String = Track.microphoneName,
                                   options: AudioCaptureOptions? = nil,
                                   reportStatistics: Bool = false) -> LocalAudioTrack
    {
        let options = options ?? AudioCaptureOptions()

        let constraints: [String: String] = [
            "googEchoCancellation": options.echoCancellation.toString(),
            "googAutoGainControl": options.autoGainControl.toString(),
            "googNoiseSuppression": options.noiseSuppression.toString(),
            "googTypingNoiseDetection": options.typingNoiseDetection.toString(),
            "googHighpassFilter": options.highpassFilter.toString(),
            "googNoiseSuppression2": options.experimentalNoiseSuppression.toString(),
            "googAutoGainControl2": options.experimentalAutoGainControl.toString(),
        ]

        let audioConstraints = DispatchQueue.liveKitWebRTC.sync { LKRTCMediaConstraints(mandatoryConstraints: nil,
                                                                                        optionalConstraints: constraints) }

        let audioSource = RTC.createAudioSource(audioConstraints)
        let rtcTrack = RTC.createAudioTrack(source: audioSource)
        rtcTrack.isEnabled = true

        return LocalAudioTrack(name: name,
                               source: .microphone,
                               track: rtcTrack,
                               reportStatistics: reportStatistics,
                               captureOptions: options)
    }

    @discardableResult
    override func onPublish() async throws -> Bool {
        let didPublish = try await super.onPublish()
        if didPublish {
            AudioManager.shared.trackDidStart(.local)
        }
        return didPublish
    }

    @discardableResult
    override func onUnpublish() async throws -> Bool {
        let didUnpublish = try await super.onUnpublish()
        if didUnpublish {
            AudioManager.shared.trackDidStop(.local)
        }
        return didUnpublish
    }

    public func mute() async throws {
        try await super._mute()
    }

    public func unmute() async throws {
        try await super._unmute()
    }
}

public extension LocalAudioTrack {
    var publishOptions: TrackPublishOptions? { super._state.lastPublishOptions }
    var publishState: Track.PublishState { super._state.publishState }
}
