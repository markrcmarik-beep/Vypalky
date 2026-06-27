# ver: 2026-03-14
# Testovaci skript pro funkci vypalek.jl

using Vypalky, Test

@testset "vypalek" begin
    @testset "chybi tloustka" begin
        @test_throws ErrorException vypalek(D=10)
    end

    @testset "kruhovy prurez" begin
        VV = vypalek(t=10, D=100)
        expected_A = pi * 100^2 / 4
        expected_m = expected_A * 10 * 7850
        @test isapprox(VV[:A], expected_A; rtol=1e-12)
        @test isapprox(VV[:m], expected_m; rtol=1e-12)
        @test VV[:A_text] == "\\frac{\\pi D^2}{4}"
        @test VV[:m_text] == "A \\cdot t \\cdot \\rho"
        @test VV[:A_info] == "Plocha vypalku"
        @test VV[:m_info] == "Hmotnost vypalku"
    end

    @testset "kruhovy prurez s otvorem" begin
        VV = vypalek(t=5, D=100, d=40)
        expected_A = pi * (100^2 - 40^2) / 4
        expected_m = expected_A * 5 * 7850
        @test isapprox(VV[:A], expected_A; rtol=1e-12)
        @test isapprox(VV[:m], expected_m; rtol=1e-12)
        @test VV[:A_text] == "\\frac{\\pi (D^2 - d^2)}{4}"
    end

    @testset "obdelnikovy prurez" begin
        VV = vypalek(t=3, a=20, b=30)
        expected_A = 20 * 30
        expected_m = expected_A * 3 * 7850
        @test VV[:A] == expected_A
        @test VV[:m] == expected_m
        @test VV[:A_text] == "a \\cdot b"
    end

    @testset "chybi rozmery" begin
        @test_throws ErrorException vypalek(t=1)
    end

    @testset "neplatne hodnoty" begin
        @test_throws ErrorException vypalek(t=-1, D=10)
        @test_throws ErrorException vypalek(t=1, D=10, d=10)
        @test_throws ErrorException vypalek(t=1, a=0, b=5)
        @test_throws ErrorException vypalek(t=1, D=10, rho=0)
    end

    @testset "vlastni hustota" begin
        VV = vypalek(t=2, D=10, rho=8000)
        expected_A = pi * 10^2 / 4
        expected_m = expected_A * 2 * 8000
        @test isapprox(VV[:m], expected_m; rtol=1e-12)
    end
end
