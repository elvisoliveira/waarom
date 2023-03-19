# https://discourse.julialang.org/t/is-it-possible-to-use-revise-jl-to-reload-webserver-on-file-save/94866/18
using Sass, Revise

includet("meetings.jl")

server_task = Ref(start_server())

entr(["meetings.json", "meetings.jl", "style.scss"], [], postpone=true) do
    stop_server(server_task[])
    # Compile a Sass file into a CSS file
    @async Sass.compile_file(
        joinpath(dirname(@__FILE__), "style.scss"),
        joinpath(dirname(@__FILE__), "style.css")
    )
    server_task[] = start_server()
end