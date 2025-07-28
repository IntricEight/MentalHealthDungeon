//
//  Timer.swift
//  MHDungeon
//

import Foundation

/// A timer used when we need to deal with DHMS formatting.
///
/// DHMS = Days, hours, minutes, seconds
struct DHMSTimer {
    /// Updates and formats the remaining time for the display.
    ///
    /// Adds the remaining time after the provided template. If no template is provided, then the DHMS time will return alone.
    ///
    /// - Parameters:
    ///   - remaining: The `String` display of the time remaining between `now` and the provided expiration `Date`. This can be customized using the `template` parameter.
    ///   - expiration: The `Date` that we are using as our reference end time. The DHMS is the time remaining until this `Date` has passed.
    ///   - template: Modify the returned DHMS `String` by added a preface to it. The format is [template]DHMS.
    ///   - message: The `String` that should replace the remaining time once the expiration `Date` has been passed.
    func UpdateTimeRemaining(timeRemaining remaining: inout String, expirationTime expiration: Date, template: String = "", message: String = "") -> Void {
        // NOTE: To my knowledge, I cannot return values within the onAppear() that this is used in. If this changes, consider returning a string instead of using timeRemaining (inout)
        
        /// Record the present time to stop the value changing from now until execution time.
        let now = Date.now
        
        // Ensure that the expiration time hasn't already passed.
        // Removed 1 second to remove "0 seconds" from the display. At this time, let's just let them complete it
        guard expiration.addingTimeInterval(-1) > now else {
            remaining = message
            return
        }
        
        /// Store the time remaining in a formatted string.
        let formatting: String = self.GetDHMSTimeBetweenDates(earlier: now, later: expiration)
        
        // Pass through the newly updated timer string
        remaining = "\(template)\(formatting)"
    }
    
    /// Get a provided time in the DHMS format. The order of the times is not checked inside this function.
    ///
    /// Returns the provided date in that form "Days days, HOURS hours, MINUTES minutes, SECONDS seconds".
    /// Minutes will be ignored if days remain.
    /// Seconds will be ignored if anything else remains.
    ///
    /// - Parameters:
    ///   - earlyTime: The earlier `Date` being passed in for referencing.
    ///   - laterTime: The later `Date` being passed in for referencing.
    func GetDHMSTimeBetweenDates(earlier earlyTime: Date, later laterTime: Date) -> String {
        /// Store the time remaining in a formatted string.
        var hmsFormat: String = ""
        
        // Record whether the segment was used for format assistance.
        var hasDays: Bool = false
        var hasHours: Bool = false
        var hasMinutes: Bool = false
        
        // Calculate the time difference
        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: earlyTime, to: laterTime)
        
        // Add the days remaining if there are any
        if let daysRemaining = components.day, daysRemaining > 0 {
            // Record that our string will contain days
            hasDays = true
            hmsFormat += "\(daysRemaining) day"
            
            // Show the plurality
            if daysRemaining > 1 {
                hmsFormat += "s"
            }
        }
        
        // Add the hours remaining if there are any
        if let hoursRemaining = components.hour, hoursRemaining > 0 {
            // Format the days segment to account for the hours segment
            if hasDays {
                hmsFormat += ", "
            }
            
            // Record that our string will contain hours
            hasHours = true
            hmsFormat += "\(hoursRemaining) hour"
            
            // Show the plurality
            if hoursRemaining > 1 {
                hmsFormat += "s"
            }
        }
        
        // Add the minutes remaining if there are any, so long as no days remain either
        if !hasDays {
            if let minutesRemaining = components.minute, minutesRemaining > 0 {
                // Format the hours segment to account for the minutes segment
                if hasHours {
                    hmsFormat += ", "
                }
                
                // Record that our string will contain minutes
                hasMinutes = true
                hmsFormat += "\(minutesRemaining) minute"
                
                // Show the plurality
                if minutesRemaining > 1 {
                    hmsFormat += "s"
                }
            }
        }
        
        // If there are no days, hours, or minutes, then there is likely only seconds left on the clock and we will display that
        if !hasDays && !hasHours && !hasMinutes {
            if let secondsRemaining = components.second, secondsRemaining > 0 {
                hmsFormat = "\(secondsRemaining) second"
                
                // Show the plurality
                if secondsRemaining > 1 {
                    hmsFormat += "s"
                }
            }
        }
        
        return hmsFormat
    }
    
    
}
