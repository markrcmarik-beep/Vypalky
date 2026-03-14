# Vypalky

[![Docs](https://github.com/markrcmarik-beep/Vypalky/actions/workflows/docs.yml/badge.svg?branch=main)](https://github.com/markrcmarik-beep/Vypalky/actions/workflows/docs.yml)

`Vypalky` je balíček v jazyce Julia pro výpočty spojené s vypalky a rozviny plechů.
Zaměřuje se hlavně na:

- výpočet plochy průřezu a hmotnosti vypalku (kruhové a obdélníkové průřezy, s otvorem i bez),
- výpočet rozvinuté délky plechu různými metodami (k-factor, neutral, BA, BD).

## Instalace

Balíček lze nainstalovat přes správce balíčků Julia:

```julia
using Pkg
Pkg.add(url="https://github.com/markrcmarik-beep/Vypalky")
```

Načtení balíčku:

```julia
using Vypalky
```

## Rychlý start

```julia
using Vypalky

# vypocet plochy a hmotnosti vypalku
v1 = vypalek(t=10, D=100)
println(v1)

# vypocet rozvinute delky (k-factor)
v2 = rozvin(Lp=[100, 50], uhly=[90], R=5, t=2)
println(v2)
```

## Hlavní exportované funkce

- `vypalek`
- `rozvin`

## Dokumentace

Doplňující dokumentace je ve složce `docs/`.

## Kompatibilita

- Julia `1.12`

## Licence

Licence projektu bude doplněna.
