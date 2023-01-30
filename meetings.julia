using JSON
using Hyperscript

@tags table tr td

json_file = open("meetings.json")
meetings = JSON.parse(json_file)

for meeting in meetings
    doc = table(
        tr([
            td(meeting["date"]),
            td(meeting["theme"]),
            td("Chairman"),
            td(meeting["chairman"])
        ]),
        tr([
            td("19:45"),
            td("Song 90"),
            td("Prayer"),
            td("Hal Jordan")
        ]),
        tr([
            td("19:50 "),
            td("Opening Comments (1 min)"; :colspan => "3")
        ]),
        tr([
            td("TREASURES FROM GOD'S WORD"; :colspan => "4")
        ]),
        tr([
            td("19:51"),
            td("Talk themes (10 min.)"; :colspan => "2"),
            td("Steve Rogers"),
        ]),
        tr([
            td("20:01"),
            td("Spiritual Gems (10 min.)"; :colspan => "2"),
            td("Barry Allen"),
        ]),
        tr([
            td("20:11 "),
            td(" Bible Reading (4 min) "),
            td("Student"),
            td("Tony Stark"),
        ]),
        tr([
            td("APPLY YOURSELF TO THE FIELD MINISTRY"; :colspan => "4")
        ]),
        tr([
            td("20:15"; :rowspan => "2"),
            td("Initial Call"; :rowspan => "2"),
            td("Student"),
            td("Barbara Gordon"),
        ]),
        tr([
            td("Helper"),
            td("Gwen Stacy"),
        ]),
        tr([
            td("20:15"; :rowspan => "2"),
            td("Return Visit"; :rowspan => "2"),
            td("Student"),
            td("Natasha Romanoff"),
        ]),
        tr([
            td("Helper"),
            td("Jean Grey"),
        ]),
        tr([
            td("20:15"; :rowspan => "2"),
            td("Bible Study"; :rowspan => "2"),
            td("Student"),
            td("Selina Kyle"),
        ]),
        tr([
            td("Helper"),
            td("Mary Jane Watson"),
        ]),
        tr([
            td("LIVING AS CHRISTIANS"; :colspan => "4")
        ]),
        tr([
            td("20:30"),
            td("Song 107"; :colspan => "3")
        ]),
        tr([
            td("20:35"),
            td("Local Needs"; :colspan => "2"),
            td("James Howlett"),
        ]),
        tr([
            td("20:50"; :rowspan => "2"),
            td("Congregation Bible Study (30 min.)"; :rowspan => "2"),
            td("Conductor"),
            td("Bruce Wayne"),
        ]),
        tr([
            td("Reader"),
            td("Clark Kent"),
        ]),
        tr([
            td("21:20"),
            td("Concluding Comments (3 min)"; :colspan => "3")
        ]),
        tr([
            td("21:22"),
            td("Song 2 "),
            td("Prayer"),
            td("Peter Parker"),
        ])
    )
    savehtml("test.html", doc);
end

close(json_file)
