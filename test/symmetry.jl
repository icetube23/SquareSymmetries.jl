@testset "Symmetric matrices" begin
    m = [
        1 2 1
        2 3 2
        1 2 1
    ]

    @test unit(m) == m
    @test rotate90(m) == m
    @test rotate180(m) == m
    @test rotate270(m) == m
    @test flipdiag(m) == m
    @test flipadiag(m) == m
    @test flipx(m) == m
    @test flipy(m) == m
end

@testset "Non-symmetric matrices" begin
    m = [
        1 2 3
        4 5 6
        7 8 9
    ]

    @test unit(m) == m
    @test rotate90(m) == [
        7 4 1
        8 5 2
        9 6 3
    ]
    @test rotate180(m) == [
        9 8 7
        6 5 4
        3 2 1
    ]
    @test rotate180(m) == [
        9 8 7
        6 5 4
        3 2 1
    ]
    @test rotate270(m) == [
        3 6 9
        2 5 8
        1 4 7
    ]
    @test flipdiag(m) == [
        1 4 7
        2 5 8
        3 6 9
    ]
    @test flipadiag(m) == [
        9 6 3
        8 5 2
        7 4 1
    ]
    @test flipx(m) == [
        7 8 9
        4 5 6
        1 2 3
    ]
    @test flipy(m) == [
        3 2 1
        6 5 4
        9 8 7
    ]
end

@testset "Group operation" begin
    # the '∘' function acts as function composition and group operation at the same time
    # it can be used prevent unneeded computations, e.g., (rotate180 ∘ rotate180)(m) does
    # not actually rotate m twice by 180 degrees but directly returns unit(m)
    elements = [unit, rotate90, rotate180, rotate270, flipx, flipy, flipdiag, flipadiag]
    m = rand(10, 10)

    for g1 in elements
        for g2 in elements
            @test (g1 ∘ g2)(m) == g1(g2(m))
        end
    end
end

@testset "Inverse elements" begin
    elements = [unit, rotate90, rotate180, rotate270, flipx, flipy, flipdiag, flipadiag]
    m = rand(10, 10)

    # for all group elements g and all matrices m, g(g^(-1)(m)) = g^(-1)(g(m)) = m
    for g in elements
        @test g(inv(g)(m)) == inv(g)(g(m)) == m
    end

    for g in elements
        @test g ∘ inv(g) == inv(g) ∘ g == unit
    end
end
