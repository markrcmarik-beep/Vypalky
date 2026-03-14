# Vypalky

`Vypalky` je balíček v jazyce Julia pro výpočty spojené s vypalky a rozviny plechů.
Zaměřuje se na výpočet plochy a hmotnosti vypalků a na výpočet rozvinuté délky
plechu různými metodami.

## Co balíček umí

- **Vypalky**: výpočet plochy průřezu a hmotnosti (`vypalek`).
- **Rozviny**: výpočet rozvinuté délky plechu (`rozvin`).

## Rychlý start

```julia
using Vypalky

# 1) Vypalek - plocha a hmotnost
VV = vypalek(t=10, D=100)
println(VV)

# 2) Rozvin - k-factor
RR = rozvin(Lp=[100, 50], uhly=[90], R=5, t=2)
println(RR)
```

Podrobný návod je v kapitole [Použití balíčku](pouziti.md) a seznam API v [API](api.md).
