# ver: 2026-03-14
# Testovaci skript pro funkci rozvin.jl

using StrojniSoucasti, Test

include(joinpath(@__DIR__, "..", "..", "src", "vypalky", "rozvin.jl"))

@testset "rozvin" begin
    @testset "k_factor default" begin
        Lp = [100, 50]
        uhly = [90]
        R = 5
        t = 2
        VV = rozvin(Lp=Lp, uhly=uhly, R=R, t=t)
        expected_BA = (pi * 90 / 180) * (5 + 0.33 * 2)
        expected_L = 150 + expected_BA
        @test isapprox(VV[:L], expected_L; rtol=1e-12)
        @test VV[:metoda] == "k_factor"
    end

    @testset "neutral" begin
        Lp = [100, 50]
        uhly = [90]
        R = 5
        t = 2
        VV = rozvin(Lp=Lp, uhly=uhly, R=R, t=t, metoda="neutral")
        expected_BA = (pi * 90 / 180) * (5 + 0.5 * 2)
        expected_L = 150 + expected_BA
        @test isapprox(VV[:L], expected_L; rtol=1e-12)
        @test VV[:metoda] == "neutral"
    end

    @testset "bd vypocet" begin
        Lp = [100, 50]
        uhly = [90]
        R = 5
        t = 2
        k = 0.4
        VV = rozvin(Lp=Lp, uhly=uhly, R=R, t=t, metoda="bd", k=k)
        expected_BA = (pi * 90 / 180) * (5 + k * 2)
        expected_BD = 2 * (5 + 2) * tan((pi * 90 / 180) / 2) - expected_BA
        expected_L = 150 - expected_BD
        @test isapprox(VV[:L], expected_L; rtol=1e-12)
        @test VV[:metoda] == "bd"
    end

    @testset "ba prime zadani" begin
        Lp = [100, 50]
        BA = [10]
        t = 2
        VV = rozvin(Lp=Lp, BA=BA, t=t, metoda="ba")
        expected_L = 150 + 10
        @test VV[:L] == expected_L
        @test VV[:metoda] == "ba"
    end

    @testset "chybi tloustka" begin
        @test_throws ErrorException rozvin(Lp=[10], uhly=[90], R=5)
    end
end
