## Balíček Julia v1.13
###############################################################
## Popis balíčku
# Balíček Vypalky obsahuje funkce pro výpočet plochy, hmotnosti 
# vypalků a rozvinuté délky vypalků.
# ver: 2026-11-04
## Autor: Martin
## Cesta uvnitř balíčku:
# Vypalky/src/Vypalky.jl
#
## Použité balíčky:
#
###############################################################
## Použité proměnné vnitřní:
#
"""
$(read(joinpath(@__DIR__, "..", "docs", "src", "Vypalky.md"), String))
"""
module Vypalky

include("vypalek.jl") # vypalky
include("rozvin.jl") # rozvin

export vypalek, rozvin

end # module Vypalky
