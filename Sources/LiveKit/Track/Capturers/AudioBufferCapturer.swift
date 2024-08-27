import CoreMedia
import Foundation

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif


public class AudioBufferCapturer: AudioCapturer {
    private let capturer = RTC.createAudioCapturer()

    init(delegate: LKRTCAudioCapturerDelegate) {
        super.init(delegate: delegate)
    }

    /// Capture a ``CMSampleBuffer``.
    public func capture(_ sampleBuffer: CMSampleBuffer) {
        capture(sampleBuffer: sampleBuffer, capturer: capturer)
    }

    /// Capture a ``Data``.
    public func capture(data: Data, sampleRate: UInt32, bitsPerChannel: UInt32, channels: UInt32, samplePerBuffer: UInt32) {
        capture(data: data, sampleRate: sampleRate, bitsPerChannel: bitsPerChannel, channels: channels, samplePerBuffer: samplePerBuffer, capturer: capturer)
    }
}

public extension LocalAudioTrack {
    /// Creates a track that can directly capture `CVPixelBuffer` or `Data` for convienience
    static func createBufferTrack(name: String = Track.screenShareAudioName,
                                  reportStatistics: Bool = false) -> LocalAudioTrack
    {
        let audioSource = RTC.createAudioBufferSource()
        let capturer = AudioBufferCapturer(delegate: audioSource)
        return LocalAudioTrack(name: name,
                               source: source,
                               capturer: capturer,
                               audioSource: audioSource,
                               reportStatistics: reportStatistics)
    }
}
 