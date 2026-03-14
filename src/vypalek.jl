## Funkce Julia v1.12
###############################################################
## Popis funkce:
# Slouží k výpočtu plochy průřezu a hmotnosti vypalku na základě 
# zadaných rozměrů a tloušťky. Podporuje jak kruhové, tak obdélníkové 
# průřezy, a umožňuje zadat hustotu materiálu pro výpočet hmotnosti.
# ver: 2026-03-14
## Funkce: nazev_funkce()
## Autor: Martin
#
## Cesta uvnitř balíčku:
# StrojniSoucasti/src/vypalky/vypalek.jl
#
## Vzor:
## vystupni_promenne = vypalek(vstupni_promenne)
## Vstupní proměnné:
# - t: tloušťka vypalku [mm] (povinné)
# - D: vnější průměr pro kruhový průřez [mm] (nepovinné)
# - d: vnitřní průměr pro kruhový průřez s otvorem [mm] (nepovinné)
# - a: délka pro obdélníkový průřez [mm] (nepovinné)
# - b: šířka pro obdélníkový průřez [mm] (nepovinné)
# - rho: hustota materiálu [kg/m^3] (nepovinné, výchozí hodnota 7850 kg/m^3 pro ocel)
## Výstupní proměnné:
# - A: plocha průřezu vypalku [mm^2]
# - A_text: textový popis vzorce pro plochu průřezu
# - A_info: popis významu plochy průřezu
# - m: hmotnost vypalku [kg]
# - m_text: textový popis vzorce pro hmotnost
# - m_info: popis významu hmotnosti vypalku
## Použité balíčky:
#
## Použité uživatelské funkce:
#
## Příklad:
# vypalek(t=10, D=100)
# vypalek(t=5, D=100, d=40)
# vypalek(t=3, a=20, b=30)
###############################################################
## Použité proměnné vnitřní:
#
function vypalek(; t=nothing, D=nothing, d=nothing, a=nothing, 
    b=nothing, rho=nothing)

    if t === nothing
        error("Nezadali jste tloušťku vypalku.")
    end
    if !(t isa Number)
        error("t musi byt cislo.")
    end
    if t <= 0
        error("t musi byt kladna hodnota.")
    end

    if rho === nothing
        rho = 7850
    end
    if !(rho isa Number)
        error("rho musi byt cislo.")
    end
    if rho <= 0
        error("rho musi byt kladna hodnota.")
    end

    if D !== nothing
        if !(D isa Number)
            error("D musi byt cislo.")
        end
        if D <= 0
            error("D musi byt kladna hodnota.")
        end
    end
    if d !== nothing
        if !(d isa Number)
            error("d musi byt cislo.")
        end
        if d <= 0
            error("d musi byt kladna hodnota.")
        end
    end
    if a !== nothing
        if !(a isa Number)
            error("a musi byt cislo.")
        end
        if a <= 0
            error("a musi byt kladna hodnota.")
        end
    end
    if b !== nothing
        if !(b isa Number)
            error("b musi byt cislo.")
        end
        if b <= 0
            error("b musi byt kladna hodnota.")
        end
    end

    if D !== nothing && d === nothing
        A = pi * D^2 / 4
        A_text = "\\frac{\\pi D^2}{4}"
    elseif D !== nothing && d !== nothing
        if d >= D
            error("d musi byt mensi nez D.")
        end
        A = pi * (D^2 - d^2) / 4
        A_text = "\\frac{\\pi (D^2 - d^2)}{4}"
    elseif a !== nothing && b !== nothing
        A = a * b
        A_text = "a \\cdot b"
    else
        error("Nezadali jste dostatečné rozměry pro výpočet průřezu.")
    end

    m = A * t * rho
    m_text = "A \\cdot t \\cdot \\rho"

    VV = Dict{Symbol,Any}()
    VV[:A] = A # plocha průřezu vypalku
    VV[:A_text] = A_text # textový popis vzorce pro plochu průřezu
    VV[:A_info] = "Plocha vypalku"
    VV[:m] = m # hmotnost vypalku
    VV[:m_text] = m_text # textový popis vzorce pro hmotnost
    VV[:m_info] = "Hmotnost vypalku"
    return VV

end
