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

import Foundation

extension String {
    func unpack() -> (participantSid: Participant.Sid, trackId: Track.Sid?) {
        let parts = split(separator: "|")
        if parts.count == 2 {
            return (Participant.Sid(from: String(parts[0])), Track.Sid(from: String(parts[1])))
        }
        return (Participant.Sid(from: self), nil)
    }
}

extension Bool {
    func toString() -> String {
        self ? "true" : "false"
    }
}

extension URL {
    var isSecure: Bool {
        scheme == "https" || scheme == "wss"
    }
}

public extension Double {
    func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
