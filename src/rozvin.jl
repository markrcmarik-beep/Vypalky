## Funkce Julia v1.12
###############################################################
## Popis funkce:
# Vypocet rozvinute delky plechu podle ruznych metod.
# ver: 2026-03-14
## Funkce: rozvin()
## Autor: Martin
#
## Cesta uvnitr balicku:
# StrojniSoucasti/src/vypalky/rozvin.jl
#
## Vzor:
## vystupni_promenne = rozvin(vstupni_promenne)
## Vstupni promenne:
# - Lp: prime delky [mm] (povinne)
# - uhly: uhly ohybu [deg] (povinne pro metody k_factor/neutral/bd,
#         nepovinne pokud zadate BA/BD primo)
# - R: polomer ohybu [mm] (povinne pro metody k_factor/neutral/bd)
# - t: tloustka plechu [mm] (povinne)
# - k: K-faktor (nepovinne, vychozi 0.33)
# - metoda: "k_factor" (vychozi), "neutral", "ba", "bd"
# - BA: prispevky ohybu (bend allowance) [mm] (nepovinne)
# - BD: odecty ohybu (bend deduction) [mm] (nepovinne)
## Vystupni promenne:
# - L: rozvinuta delka [mm]
# - L_text: textovy popis vzorce
# - L_info: popis vysledku
# - metoda: pouzita metoda
# - BA: vektor prispevku ohybu [mm]
# - BD: vektor odectu ohybu [mm]
###############################################################
## Pouzite promenne vnitrni:
#
function rozvin(; Lp=nothing, uhly=nothing, R=nothing, t=nothing,
    k=nothing, metoda::AbstractString="k_factor", BA=nothing, BD=nothing)

    to_vec(x) = x isa Number ? [x] : collect(x)
    deg2rad(x) = pi * x / 180

    if t === nothing
        error("Nezadali jste tloustku plechu t.")
    end
    if !(t isa Number)
        error("t musi byt cislo.")
    end
    if t <= 0
        error("t musi byt kladna hodnota.")
    end

    if Lp === nothing
        error("Nezadali jste prime delky Lp.")
    end
    Lp_vec = to_vec(Lp)
    if isempty(Lp_vec)
        error("Lp nesmi byt prazdne.")
    end
    for v in Lp_vec
        if !(v isa Number)
            error("Lp musi obsahovat pouze cisla.")
        end
        if v < 0
            error("Lp musi byt nezaporna hodnota.")
        end
    end

    metoda_low = lowercase(metoda)
    if !(metoda_low in ("k_factor", "k", "kf", "neutral", "ba", "bd"))
        error("Neznama metoda. Pouzijte k_factor, neutral, ba nebo bd.")
    end

    if k === nothing
        k = 0.33
    end
    if !(k isa Number)
        error("k musi byt cislo.")
    end
    if k < 0 || k > 1
        error("k musi byt v rozsahu 0..1.")
    end

    BA_vec = nothing
    BD_vec = nothing

    if metoda_low in ("k_factor", "k", "kf", "neutral", "bd", "ba")
        # pro vypocet BA/BD je potreba uhel a polomer,
        # pokud nejsou BA/BD zadane primo
        if BA === nothing && BD === nothing
            if uhly === nothing
                error("Nezadali jste uhly ohybu.")
            end
            if R === nothing
                error("Nezadali jste polomer ohybu R.")
            end
        end
    end

    if uhly !== nothing
        uhly_vec = to_vec(uhly)
        if isempty(uhly_vec)
            error("Uhly nesmi byt prazdne.")
        end
        for a in uhly_vec
            if !(a isa Number)
                error("Uhly musi obsahovat pouze cisla.")
            end
            if a <= 0 || a >= 180
                error("Uhly musi byt v rozsahu (0, 180) stupnu.")
            end
        end
    else
        uhly_vec = nothing
    end

    if R !== nothing
        R_vec = to_vec(R)
        if isempty(R_vec)
            error("R nesmi byt prazdne.")
        end
        for r in R_vec
            if !(r isa Number)
                error("R musi obsahovat pouze cisla.")
            end
            if r < 0
                error("R musi byt nezaporna hodnota.")
            end
        end
    else
        R_vec = nothing
    end

    if BA !== nothing
        BA_vec = to_vec(BA)
        for b in BA_vec
            if !(b isa Number)
                error("BA musi obsahovat pouze cisla.")
            end
            if b < 0
                error("BA musi byt nezaporna hodnota.")
            end
        end
    end

    if BD !== nothing
        BD_vec = to_vec(BD)
        for b in BD_vec
            if !(b isa Number)
                error("BD musi obsahovat pouze cisla.")
            end
            if b < 0
                error("BD musi byt nezaporna hodnota.")
            end
        end
    end

    # pomocna normalizace delky vektoru
    function expand_or_check(vec, n, name)
        if vec === nothing
            return nothing
        end
        if length(vec) == 1 && n > 1
            return fill(vec[1], n)
        end
        if length(vec) != n
            error("Delka $name neodpovida poctu ohybu.")
        end
        return vec
    end

    # priprava BA/BD podle metody
    if metoda_low in ("k_factor", "k", "kf")
        if uhly_vec === nothing || R_vec === nothing
            error("Pro metodu k_factor zadejte uhly a R.")
        end
        n = length(uhly_vec)
        Rn = expand_or_check(R_vec, n, "R")
        BA_vec = [deg2rad(uhly_vec[i]) * (Rn[i] + k * t) for i in 1:n]
        L = sum(Lp_vec) + sum(BA_vec)
        L_text = "sum(Lp) + sum(BA), BA = \\theta (R + k t)"
    elseif metoda_low == "neutral"
        if uhly_vec === nothing || R_vec === nothing
            error("Pro metodu neutral zadejte uhly a R.")
        end
        n = length(uhly_vec)
        Rn = expand_or_check(R_vec, n, "R")
        k_neutral = 0.5
        BA_vec = [deg2rad(uhly_vec[i]) * (Rn[i] + k_neutral * t) for i in 1:n]
        L = sum(Lp_vec) + sum(BA_vec)
        L_text = "sum(Lp) + sum(BA), BA = \\theta (R + t/2)"
        k = k_neutral
    elseif metoda_low == "ba"
        if BA_vec === nothing
            if uhly_vec === nothing || R_vec === nothing
                error("Pro metodu ba zadejte BA nebo uhly a R.")
            end
            n = length(uhly_vec)
            Rn = expand_or_check(R_vec, n, "R")
            BA_vec = [deg2rad(uhly_vec[i]) * (Rn[i] + k * t) for i in 1:n]
        else
            if uhly_vec !== nothing
                BA_vec = expand_or_check(BA_vec, length(uhly_vec), "BA")
            end
        end
        L = sum(Lp_vec) + sum(BA_vec)
        L_text = "sum(Lp) + sum(BA)"
    elseif metoda_low == "bd"
        if BD_vec === nothing
            if uhly_vec === nothing || R_vec === nothing
                error("Pro metodu bd zadejte BD nebo uhly a R.")
            end
            n = length(uhly_vec)
            Rn = expand_or_check(R_vec, n, "R")
            BA_vec = [deg2rad(uhly_vec[i]) * (Rn[i] + k * t) for i in 1:n]
            BD_vec = [2 * (Rn[i] + t) * tan(deg2rad(uhly_vec[i]) / 2) - BA_vec[i] for i in 1:n]
        else
            if uhly_vec !== nothing
                BD_vec = expand_or_check(BD_vec, length(uhly_vec), "BD")
            end
        end
        L = sum(Lp_vec) - sum(BD_vec)
        L_text = "sum(Lp) - sum(BD)"
    end

    VV = Dict{Symbol,Any}()
    VV[:L] = L
    VV[:L_text] = L_text
    VV[:L_info] = "Rozvinuta delka plechu"
    VV[:metoda] = metoda_low
    VV[:metoda_info] = "Pouzita metoda vypoctu"
    VV[:Lp] = Lp_vec
    VV[:Lp_info] = "Prime delky"
    if uhly_vec !== nothing
        VV[:uhly] = uhly_vec
        VV[:uhly_info] = "Uhly ohybu"
    end
    if R_vec !== nothing
        VV[:R] = R_vec
        VV[:R_info] = "Polomer ohybu"
    end
    if BA_vec !== nothing
        VV[:BA] = BA_vec
        VV[:BA_info] = "Prispevky ohybu (bend allowance)"
    end
    if BD_vec !== nothing
        VV[:BD] = BD_vec
        VV[:BD_info] = "Odecty ohybu (bend deduction)"
    end
    VV[:k] = k
    VV[:k_info] = "K-faktor"

    return VV
end
