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
            td(@sprintf "%s | %s" meeting["date"] meeting["theme"]; :colspan => 4, class="label"),
            td(_"Chairman", class="title"),
            td(meeting["chairman"], class="assigned")
        ]),
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
            time(4),
            td(_"Bible Reading"; :colspan => 3),
            td(_"Student", class="title"),
            td(meeting["bible_reading"]["reader"], class="assigned"),
        ]),
        tr([
            td(img(src="apply.svg"))
            td(span(_"APPLY YOURSELF TO THE FIELD MINISTRY"); :colspan => 3)
        ], class="apply"),
        tr([
            time(3),
            td(_"Initial Call"),
            td(_"Student", class="title"),
            td(meeting["initial_call"]["student"], class="assigned"),
            td(_"Helper", class="title"),
            td(meeting["initial_call"]["assistant"], class="assigned"),
        ]),
        tr([
            time(4),
            td(_"Return Visit"),
            td(_"Student", class="title"),
            td(meeting["return_visit"]["student"], class="assigned"),
            td(_"Helper", class="title"),
            td(meeting["return_visit"]["assistant"], class="assigned"),
        ]),
        tr([
            time(5),
            td(_"Bible Study"),
            td(_"Student", class="title"),
            td(meeting["bible_study"]["student"], class="assigned"),
            td(_"Helper", class="title"),
            td(meeting["bible_study"]["assistant"], class="assigned"),
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
        tr([
            time(30),
            td(_"Congregation Bible Study"),
            td(_"Conductor", class="title"),
            td(meeting["congregation_bible_study"]["conductor"], class="assigned"),
            td(_"Reader", class="title"),
            td(meeting["congregation_bible_study"]["reader"], class="assigned"),
        ]),
        tr([
            time(1),
            td(_"Concluding Comments"; :colspan => 5)
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
