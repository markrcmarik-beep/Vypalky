# Použití balíčku

## Instalace

```julia
using Pkg
Pkg.add(url="https://github.com/markrcmarik-beep/Vypalky")
```

## Typický postup výpočtu

Nejběžnější workflow v balíčku má tento sled:

1. zvolit geometrii vypalku (kruh nebo obdélník),
2. zadat tloušťku a případně hustotu materiálu,
3. spočítat plochu a hmotnost (`vypalek`),
4. pro ohyby spočítat rozvinutou délku (`rozvin`).

## Příklad A: kruhový vypalek

```julia
using Vypalky

VV = vypalek(t=8, D=120)
println(VV[:A])
println(VV[:m])
```

## Příklad B: kruhový vypalek s otvorem

```julia
using Vypalky

VV = vypalek(t=6, D=120, d=40)
println(VV[:A])
println(VV[:m])
```

## Příklad C: obdélníkový vypalek

```julia
using Vypalky

VV = vypalek(t=5, a=50, b=30)
println(VV[:A])
println(VV[:m])
```

## Příklad D: rozvin (k-factor)

```julia
using Vypalky

RR = rozvin(Lp=[100, 50], uhly=[90], R=5, t=2, k=0.33)
println(RR[:L])
```

## Příklad E: rozvin (BA/BD)

```julia
using Vypalky

# zadani BA primo
RR1 = rozvin(Lp=[100, 50], t=2, metoda="ba", BA=[5.2])
println(RR1[:L])

# zadani BD primo
RR2 = rozvin(Lp=[100, 50], t=2, metoda="bd", BD=[3.1])
println(RR2[:L])
```

## Poznámky k jednotkám

Vstupy se zadávají v milimetrech, hustota v kg/m^3. Výstupy plochy jsou v mm^2
a hmotnost je ve kg. Pokud používáte jednotky z `Unitful`, je možné si převody
řídit explicitně, ale balíček jednotky nevyžaduje.
