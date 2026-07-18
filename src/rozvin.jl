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

    # --- Validace a příprava vstupů ---
    if t === nothing
        error("Nezadali jste tloustku plechu t.")
    end
    if !(t isa Number && t > 0)
        error("t (tloušťka) musí být kladné číslo.")
    end

    if Lp === nothing
        error("Nezadali jste prime delky Lp.")
    end
    Lp_vec = to_vec(Lp)
    if isempty(Lp_vec) || !all(x -> isa(x, Number) && x >= 0, Lp_vec)
        error("Lp musí být (vektor) nezáporných čísel a nesmí být prázdné.")
    end

    metoda_low = lowercase(metoda)
    if !(metoda_low in ("k_factor", "k", "kf", "neutral", "ba", "bd"))
        error("Neznama metoda. Pouzijte k_factor, neutral, ba nebo bd.")
    end

    k_val = k === nothing ? 0.33 : k
    if !(isa(k_val, Number) && 0 <= k_val <= 1)
        error("k musi byt v rozsahu 0..1.")
    end
    k = k_val # Přeřazení validované hodnoty

    # Pomocná funkce pro validaci a konverzi vektorů
    function validate_vec(val, check_fn, error_msg)
        val === nothing && return nothing
        vec = to_vec(val)
        (isempty(vec) || !all(check_fn, vec)) && error(error_msg)
        return vec
    end

    uhly_vec = validate_vec(uhly, x -> isa(x, Number) && 0 < x < 180,
        "Uhly musí být (vektor) čísel v rozsahu (0, 180) stupňů.")

    R_vec = validate_vec(R, x -> isa(x, Number) && x >= 0,
        "R musí být (vektor) nezáporných čísel.")

    BA_vec = validate_vec(BA, x -> isa(x, Number) && x >= 0,
        "BA musí být (vektor) nezáporných čísel.")

    BD_vec = validate_vec(BD, x -> isa(x, Number) && x >= 0,
        "BD musí být (vektor) nezáporných čísel.")
    # --- Konec validace ---

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
