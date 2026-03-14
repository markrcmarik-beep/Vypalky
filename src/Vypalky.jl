## Balíček Julia v1.12
###############################################################
## Popis balíčku
# Balíček Vypalky obsahuje funkce pro výpočet plochy, hmotnosti 
# vypalků a rozvinuté délky vypalků.
# ver: 2026-03-14
## Autor: Martin
## Cesta uvnitř balíčku:
# Vypalky/src/Vypalky.jl
#
## Použité balíčky:
#
###############################################################
## Použité proměnné vnitřní:
#
module Vypalky

include("vypalek.jl") # vypalky
include("rozvin.jl") # rozvin

export vypalek, rozvin

end # module Vypalky
