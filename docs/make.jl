# ver: 2026-03-14
using Documenter
using Vypalky

makedocs(
    sitename = "Vypalky",
    modules = [Vypalky],
    pages = [
        "Uvod" => "index.md",
        "Pouziti balicku" => "pouziti.md",
        "API" => "api.md",
    ],
)

deploydocs(
    repo = "github.com/markrcmarik-beep/Vypalky.git",
)
