using JSON, HTTP, Sockets, Printf, Hyperscript, Dates, Gettext

# Specify the directory where the translation files for the "meetings" domain can be found.
# This path will be used to look for the .mo files that contain the translations.
bindtextdomain("meetings", joinpath(dirname(@__FILE__), "locales"))
textdomain("meetings") #  Specify the current domain to be used for translating messages

# Constants that are used to configure an HTTP server
const HOST = ip"0.0.0.0"
const PORT = 8888
const ROUTER = HTTP.Router()

const FILES = [
    "style.css",
    "treasures.svg",
    "living.svg",
    "apply.svg",
    "favicon.ico"
]

# Generate the time values for each part, adding the duration of
# the current part with the previous one
function time(duration)
    current = start;
    global start = start + Dates.Minute(duration)
    return td(Dates.format(current, "HH:MM"), class="time")
end

@tags table tr td style head body html link thead tbody hr img span title meta script
@tags_noescape div

function main(req::HTTP.Request)
    target = HTTP.Messages.getfield(req, :target)
    params = HTTP.queryparams(HTTP.URI(target))

    # Opens a JSON file and parses its contents
    json_file = open(haskey(params, "file") ? params["file"] : "meetings.json")
    schedule = JSON.parse(json_file)
    close(json_file)

    # Extracting the hour and minute values from a time string
    # It's assumed to have a string value associated with the key "time" in the format "HH:MM"
    hour, min = split(schedule["time"], ":")

    meetings = Vector{Hyperscript.Node}()
    for meeting in schedule["meetings"]
        global start = Time(parse(Int64, hour), parse(Int64, min), 00)
        push!(meetings, haskey(meeting, "message") ? div(meeting["message"], class="message") : table(
            tr([
                td(@sprintf "%s | %s" meeting["date"] meeting["theme"]; :colspan => 4, class="label"),
                td(_"Chairman", class="title"),
                td(meeting["chairman"], class="assigned")
            ], class="head"),
            tr([
                time(5),
                td(@sprintf "%s: %s" _"Song" string(meeting["opening_song"]); :colspan => 5)
            ]),
            tr([
                time(1),
                td(_"Opening Comments"; :colspan => 5)
            ]),
            tr([
                td(img(src="treasures.svg"))
                td(span(_"TREASURES FROM GOD'S WORD"); :colspan => 5)
            ], class="treasures"),
            tr([
                time(10),
                td(meeting["opening_talk"]["theme"]; :colspan => 4),
                td(meeting["opening_talk"]["speaker"], class="assigned"),
            ]),
            tr([
                time(10),
                td(_"Spiritual Gems"; :colspan => 4),
                td(meeting["spiritual_gems"], class="assigned"),
            ]),
            tr([
                time(6),
                td(_"Bible Reading"; :colspan => 3),
                td(_"Student", class="title"),
                td(meeting["bible_reading"]["reader"], class="assigned"),
            ]),
            tr([
                td(img(src="apply.svg"))
                td(span(_"APPLY YOURSELF TO THE FIELD MINISTRY"); :colspan => 3)
            ], class="apply"),
            tr(student(meeting, "initial_call", _"Initial Call", 3 + 1)),
            tr(student(meeting, "return_visit", _"Return Visit", 4 + 1)),
            tr(haskey(meeting, "bible_study") ? student(meeting, "bible_study" , _"Bible Study" , 5 + 1) : [
                time(5 + 1),
                td(@sprintf "%s: %s" _"Talk" meeting["talk"]["theme"]; :colspan => 3),
                td(_"Student", class="title"),
                td(meeting["talk"]["student"], class="assigned")
            ]),
            tr([
                td(img(src="living.svg"))
                td(span(_"LIVING AS CHRISTIANS"); :colspan => 6)
            ], class="living"),
            tr([
                time(5),
                td(@sprintf "%s: %s" _"Song" string(meeting["middle_song"]); :colspan => 5)
            ]),
            [tr([time(part["time"]), td(part["theme"]; :colspan => 4), td(part["speaker"], class="assigned")]) for (part) in meeting["living_as_christians"]],
            # The 30-minute service talk delivered by the circuit overseer will
            # substitute the Congregation Bible Study portion of the Living as
            # Christians section when the congregation is visited by the circuit overseer.
            haskey(meeting, "congregation_bible_study") ? tr([
                time(30),
                td(_"Congregation Bible Study"; :colspan => haskey(meeting["congregation_bible_study"], "reader") ? 0 : 3),
                td(_"Conductor", class="title"),
                td(meeting["congregation_bible_study"]["conductor"], class="assigned"),
                haskey(meeting["congregation_bible_study"], "reader") ? [td(_"Reader", class="title"), td(meeting["congregation_bible_study"]["reader"], class="assigned")] : []
            ]) : [],
            tr([
                time(1),
                td(_"Concluding Comments"; :colspan => 5)
            ]),
            haskey(meeting, "service_talk") ? tr([
                time(30),
                td(meeting["service_talk"]["theme"]; :colspan => 4),
                td(meeting["service_talk"]["speaker"], class="assigned")
            ]) : [],
            tr([
                time(5),
                td(@sprintf "%s: %s" _"Song" string(meeting["closing_song"]); :colspan => 3),
                td(_"Prayer", class="title"),
                td(meeting["closing_prayer"], class="assigned"),
            ]),
            tr(td(hr(); :colspan => 6)), class="meeting"
        ))
    end
    return string(
        html(
            head(
                link(href="style.css", rel="stylesheet"),
                link(href="https://fonts.googleapis.com/css?family=Fira+Sans|Open+Sans|Oranienbaum", rel="stylesheet"),
                style(
                    css("@page", margin="5mm")
                ),
                meta(charset="UTF-8"),
                title(_"Midweek Meeting Schedule")
            ),
            body(
                table(
                    thead(
                        tr([td(schedule["congregation"]), td(_"Midweek Meeting Schedule")]),
                        tr(td(hr(); :colspan => 2))
                    ),
                    tbody(
                        [tr(td([meeting], span(_"Page", class="page"); :colspan => 2)) for (meeting) in meetings]
                    ), class="schedule"
                )
            )
        )
    )
end

function hasprint(dict, key, default)
    return haskey(dict, key) ? dict[key] : default
end

function student(meeting, index, label, minutes)
    return [
        time(minutes),
        td(hasprint(meeting[index], "label", label)),
        haskey(meeting[index], "student")   ? [td(_"Student", class="title"), td(meeting[index]["student"]  , class="assigned")] : [td(), td()],
        haskey(meeting[index], "assistant") ? [td(_"Helper" , class="title"), td(meeting[index]["assistant"], class="assigned")] : [td(), td()]
    ]
end

function get_static_resource(FILE)
    file = open(joinpath(dirname(@__FILE__), FILE))
    bytes = read(file)
    close(file)
    return bytes
end

for FILE in FILES
    HTTP.register!(ROUTER, "GET", "/" * FILE, req->HTTP.Response(200, get_static_resource(FILE)))
end

# Start server
function start_server()
    server_task = @async try
        # Routes definitions
        HTTP.register!(ROUTER, "GET", "/", req->HTTP.Response(200, main(req)))

        HTTP.serve(ROUTER, HOST, PORT)
    catch e
        e === :stop || rethrow()
    end
    errormonitor(server_task)
end

function stop_server(task)
    schedule(task, :stop, error=true)
    wait(task)
end
