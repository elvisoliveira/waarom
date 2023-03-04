# Now I know

Start the HTTP live server

```
LANGUAGE=pt_BR julia --project=. ./start.jl
```

To install the dependencies

```
julia --project=. -e "import Pkg; Pkg.instantiate()"
```

To compile the translation file

```
cd locales/pt_BR/LC_MESSAGES
msgfmt meetings.po -o meetings.mo
```
