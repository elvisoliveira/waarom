using JSON
using Sass
using Printf
using Hyperscript
using Dates
using Gettext

bindtextdomain("meetings", joinpath(dirname(@__FILE__), "locales"))
textdomain("meetings")

Sass.compile_file(
    joinpath(dirname(@__FILE__), "style.scss"),
    joinpath(dirname(@__FILE__), "style.css")
)

json_file = open("meetings.json")
schedule = JSON.parse(json_file)
close(json_file)

hour, min = split(schedule["time"], ":")

function time(duration)
    current = start;
    global start = start + Dates.Minute(duration)
    return td(Dates.format(current, "HH:MM"), class="time")
end

@tags table tr td style head body html link thead tbody hr img span title

meetings = Vector{Hyperscript.Node}()

for meeting in schedule["meetings"]
    global start = Time(parse(Int64, hour), parse(Int64, min), 00)
    push!(meetings, table(
        tr([
            td(meeting["date"]),
            td(meeting["theme"]),
            td(_"Chairman"),
            td(meeting["chairman"])
        ]),
        tr([
            td(time(5)),
            td(@sprintf "Song %s" meeting["opening_song"]; :colspan => 3)
        ]),
        tr([
            td(time(1)),
            td(_"Opening Comments"; :colspan => 3)
        ]),
        tr([
            td(_"TREASURES FROM GOD'S WORD"; :colspan => 4)
        ]),
        tr([
            td(time(10)),
            td(meeting["opening_talk"]["theme"]; :colspan => 2),
            td(meeting["opening_talk"]["speaker"]),
        ]),
        tr([
            td(time(10)),
            td(_"Spiritual Gems"; :colspan => 2),
            td(meeting["spiritual_gems"]),
        ]),
        tr([
            td(time(4)),
            td(_"Bible Reading"),
            td(_"Student"),
            td(meeting["bible_reading"]["reader"]),
        ]),
        tr([
            td(_"APPLY YOURSELF TO THE FIELD MINISTRY"; :colspan => 4)
        ]),
        tr([
            td(time(3); :rowspan => 2),
            td(_"Initial Call"; :rowspan => 2),
            td(_"Student"),
            td(meeting["initial_call"]["student"]),
        ]),
        tr([
            td(_"Helper"),
            td(meeting["initial_call"]["assistant"]),
        ]),
        tr([
            td(time(4); :rowspan => 2),
            td(_"Return Visit"; :rowspan => 2),
            td(_"Student"),
            td(meeting["return_visit"]["student"]),
        ]),
        tr([
            td(_"Helper"),
            td(meeting["return_visit"]["assistant"]),
        ]),
        tr([
            td(time(5); :rowspan => 2),
            td(_"Bible Study"; :rowspan => 2),
            td(_"Student"),
            td(meeting["bible_study"]["student"]),
        ]),
        tr([
            td(_"Helper"),
            td(meeting["bible_study"]["assistant"]),
        ]),
        tr([
            td(_"LIVING AS CHRISTIANS"; :colspan => 4)
        ]),
        tr([
            time(5),
            td(@sprintf "%s: %s" _"Song" string(meeting["closing_song"]); :colspan => 3),
            td(_"Prayer", class="title"),
            td(meeting["closing_prayer"], class="assigned"),
        ]), class="meeting"
    ))
end

savehtml("schedule.html", html(
    head(
        link(href="style.css", rel="stylesheet"),
        link(href="https://fonts.googleapis.com/css?family=Fira+Sans|Open+Sans|Oranienbaum", rel="stylesheet"),
        style(
            css("@page", margin="5mm")
        ),
        title(_"Midweek Meeting Schedule")
    ),
    body(
        table(
            thead(
                tr(td(_"Midweek Meeting Schedule")),
                tr(td(schedule["congregation"])),
                tr(td(hr()))
            ),
            tbody(
                [tr([td(meeting)]) for (meeting) in meetings]
            ), class="schedule"
        )
    )
))
