// main file, just copy and paste the code where you want it in your own code (not in a loop), and don't forget to add a stopTelemetry() at the end of your flight



// Call to startTelemetry, this is an example of a call with the values being time, pitch, yaw, etc..

startTelemetry("0:/telemetry.csv", // in the same folder as the other codes 
    list("time","pitch","yaw","roll","alt_radar",
        "speed","vspeed","hspeed","accel","throttle"), // Values example, just replace with the ones you want to test
    {
        local fac is ship:facing.
        local vs is ship:velocity:surface.
        local vspeed is ship:verticalspeed.
        local hvec is vs - vspeed * ship:up:vector.
        local acc is ship:sensors:acc:mag.

        return list( // The list of the values you want to be in the csv (they must correspond to the list above)
            round(time:seconds,2),
            round(fac:pitch,2), round(fac:yaw,2), round(fac:roll,2),
            round(alt:radar,1),
            round(vs:mag,2), round(vspeed,2), round(hvec:mag,2),
            round(acc,2),throttle
        ).
    }

).


