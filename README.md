# Why am I using this lang? lol

To generate the `.html` file

```
LANGUAGE=pt_BR julia meetings.jl
```

To install the dependencies

```
julia -e "import Pkg; Pkg.add(\"Gettext\"); Pkg.add(\"JSON\"); Pkg.add(\"Printf\"); Pkg.add(\"Hyperscript\"); Pkg.add(\"Dates\"); Pkg.add(\"Gettext\")"
```
