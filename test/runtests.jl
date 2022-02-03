using SquareSymmetries
using Test

@testset "SquareSymmetries" begin
    @testset "Symmetry group" begin
        include("symmetry.jl")
    end
end
