// Create the .csv file with all the variables you want



set logHeadersWritten to lexicon().

function logRow {
    parameter pathx.
    parameter values.
    parameter header is list().

    if header:length > 0 and not logHeadersWritten:haskey(pathx) {
        if exists(pathx) { deletepath(pathx). }
        log csvJoin(header) to pathx.
        logHeadersWritten:add(pathx, true).
    }
    log csvJoin(values) to pathx.
}

function csvJoin {
    parameter values.
    local line is "".
    local first is true.
    for vx in values {
        if first {
            set line to "" + vx.
            set first to false.
        } else {
            set line to line + "," + vx.
        }
    }
    return line.
}

set telemetryActive to false.
set telemetryNextT to 0.
set telemetryInterval to 0.5.
set telemetryPath to "".
set telemetryHeader to list().
set telemetryRowBuilder to { return list(). }.

// Start the recording of the .csv file : call it one time only
//   path       : path to CSV.
//   header     : list("col1","col2",...)

function startTelemetry {
    parameter pathx.
    parameter header.
    parameter rowBuilder.
    parameter interval is 0.5.

    set telemetryPath to pathx.
    set telemetryHeader to header.
    set telemetryRowBuilder to rowBuilder.
    set telemetryInterval to interval.

    set telemetryActive to true.
    set telemetryNextT to time:seconds.

    when time:seconds >= telemetryNextT then {
        logRow(telemetryPath, telemetryRowBuilder(), telemetryHeader).
        set telemetryNextT to time:seconds + telemetryInterval.
        if telemetryActive {
            preserve.
        }
    }
}

function stopTelemetry {
    set telemetryActive to false.
}
