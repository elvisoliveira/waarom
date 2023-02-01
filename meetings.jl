using JSON
using Printf
using Hyperscript
using Dates
using Gettext

locales = joinpath(dirname(@__FILE__), "locales")

bindtextdomain("meetings", locales)
textdomain("meetings")

println(_"Hello, World!")

start = Dates.DateTime(2023, 2, 1, 19, 15)

function time(duration)
    current = start;
    global start = start + Dates.Minute(duration)
    return Dates.format(current, "HH:MM")
end

@tags table tr td

json_file = open("meetings.json")
meetings = JSON.parse(json_file)
close(json_file)

for meeting in meetings
    doc = table(
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
            td(meeting["opening_talk"][1]; :colspan => 2),
            td(meeting["opening_talk"][2]),
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
            td(meeting["bible_reading"]),
        ]),
        tr([
            td(_"APPLY YOURSELF TO THE FIELD MINISTRY"; :colspan => 4)
        ]),
        tr([
            td(time(3); :rowspan => 2),
            td(_"Initial Call"; :rowspan => 2),
            td(_"Student"),
            td(meeting["initial_call"][1]),
        ]),
        tr([
            td(_"Helper"),
            td(meeting["initial_call"][2]),
        ]),
        tr([
            td(time(4); :rowspan => 2),
            td(_"Return Visit"; :rowspan => 2),
            td(_"Student"),
            td(meeting["return_visit"][1]),
        ]),
        tr([
            td(_"Helper"),
            td(meeting["return_visit"][2]),
        ]),
        tr([
            td(time(5); :rowspan => 2),
            td(_"Bible Study"; :rowspan => 2),
            td(_"Student"),
            td(meeting["bible_study"][1]),
        ]),
        tr([
            td(_"Helper"),
            td(meeting["bible_study"][2]),
        ]),
        tr([
            td(_"LIVING AS CHRISTIANS"; :colspan => 4)
        ]),
        tr([
            td(time(5)),
            td(@sprintf "Song %s" meeting["middle_song"]; :colspan => 3)
        ]),
        [tr([td(time(10)), td(theme; :colspan => 2), td(conductor)]) for (theme, conductor) in meeting["living_as_christians"]],
        tr([
            td(time(30); :rowspan => 2),
            td(_"Congregation Bible Study"; :rowspan => 2),
            td(_"Conductor"),
            td(meeting["congregation_bible_study"]["conductor"]),
        ]),
        tr([
            td(_"Reader"),
            td(meeting["congregation_bible_study"]["reader"]),
        ]),
        tr([
            td(time(1)),
            td(_"Concluding Comments"; :colspan => 3)
        ]),
        tr([
            td(time(5)),
            td(@sprintf "Song %s" meeting["closing_song"]),
            td(_"Prayer"),
            td(meeting["closing_prayer"]),
        ]); :border => 1
    )
    savehtml("test.html", doc);
end
