# SquareSymmetries

[![Build Status](https://github.com/icetube23/SquareSymmetries.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/icetube23/SquareSymmetries.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/icetube23/SquareSymmetries.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/icetube23/SquareSymmetries.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

SquareSymmetries is a small Julia package that allows applying elements of the symmetry group of a square (a.k.a. the dihedral group _D<sub>4</sub>_) to matrices. The symmetry group consists of operations like 90° rotations and flipping elements along an axis (see also [here](https://en.wikipedia.org/wiki/Symmetry_group)).

## Installation

To install this package, from the Julia REPL, enter Pkg mode by typing `]` and execute the following:
```julia
pkg> add SquareSymmetries
```

## Usage

You can apply the provided operations (i.e., the group elements) to matrices just like a simple function:
```julia
julia> using SquareSymmetries

julia> m = rand(2, 2)
2×2 Matrix{Float64}:
 0.945848  0.755452
 0.339932  0.975451

julia> rotate90(m)
2×2 Matrix{Float64}:
 0.339932  0.945848
 0.975451  0.755452

julia> flipx(m)
2×2 Matrix{Float64}:
 0.339932  0.975451
 0.945848  0.755452
```

You can also compose operations using Julia's function composition syntax:
```julia
julia> (rotate180 ∘ flipdiag)(m) # this is equivalent to flipadiag(m)
2×2 Matrix{Float64}:
 0.975451  0.755452
 0.339932  0.945848
```

## The group elements

This package provides all eight elements of _D<sub>4</sub>_. Each element is represented by a Julia function: `unit`, `rotate90`, `rotate180`, `rotate270`, `flipx`, `flipy`, `flipdiag`, and `flipadiag`.
```julia
julia> m = ["a11", "a12", "a21", "a22"]
2×2 Matrix{String}:
 "a11"  "a12"
 "a21"  "a22"

julia> unit(m) # identity
2×2 Matrix{String}:
 "a11"  "a12"
 "a21"  "a22"

julia> rotate90(m) # rotate matrix by 90° to the right
2×2 Matrix{String}:
 "a21"  "a11"
 "a22"  "a12"

julia> rotate180(m) # rotate by 180° (i.e., reverse elements)
2×2 Matrix{String}:
 "a22"  "a21"
 "a12"  "a11"

julia> rotate270(m) # rotate 270° to the right (or 90° to the left)
2×2 Matrix{String}:
 "a12"  "a22"
 "a11"  "a21"

julia> flipx(m) # flip elements along x-axis
2×2 Matrix{String}:
 "a21"  "a22"
 "a11"  "a12"

julia> flipy(m) # flip elements along y-axis
2×2 Matrix{String}:
 "a12"  "a11"
 "a22"  "a21"

julia> flipdiag(m) # flip elements along main diagonal (i.e., transpose)
2×2 Matrix{String}:
 "a11"  "a21"
 "a12"  "a22"

julia> flipadiag(m) # flip elements along anti diagonal
2×2 Matrix{String}:
 "a22"  "a12"
 "a21"  "a11"
```
To obtain all eight symmetries at once, you can use the `symmetries` function:
```julia
julia> symmetries(m);
```

## The symmetry group _D<sub>4</sub>_

Sometimes it might be useful to take advantage of the group structure of _D<sub>4</sub>_. The group _D<sub>4</sub>_ consists of our group elements, the binary operation `∘`, and the unary operation `inv`. We can use this operations directly on our group elements:
```julia
julia> rotate90 ∘ rotate180
rotate270 (generic function with 1 method)

julia> rotate180 ∘ rotate180
unit (generic function with 1 method)

julia> inv(rotate270)
rotate90 (generic function with 1 method)

julia> inv(flipdiag)
flipdiag (generic function with 1 method)
```

We can make use of the fact that for group elements _g<sub>1</sub>_,...,_g<sub>n</sub>_, the transformation _g<sub>1</sub>_(..._g<sub>n</sub>_(_m_)...) can always be replaced by a single group element, i.e., by _g<sub>1</sub>_ ∘ ... ∘ _g<sub>n</sub>_.\
This can improve performance because we effectively replace _n_ computations by only a single computation. Consider this example where we want to validate that rotating by 180° twice indeed yields the original matrix:
```julia
julia> m = rand(10000, 10000); # some huge test matrix

julia> @time rotate180(rotate180(m)) == m # this works but rotates the huge matrix twice
  0.228518 seconds (4 allocations: 1.490 GiB, 1.19% gc time)
true

julia> @time (rotate180 ∘ rotate180)(m) == m # this is much more efficient as rotate180 ∘ rotate180 = unit = id
  0.045496 seconds
true
```
Admittedly, this example is somewhat artificial. Nevertheless, note the huge difference in allocated memory. This shows that whenever we have a situation where we need to apply multiple group elements consecutively, it is beneficial to take their composition first and apply it afterwards.

It can also be useful to take the inverse of a group element. For example, consider you have an algorithm that performs some matrix transformation and this transformation should be invariant to the elements of _D<sub>4</sub>_. Then, we could use the following code to verify this:
```julia
julia> my_alg(m) = ... # some super clever matrix transformation

julia> m = rand(10, 10); # our test matrix

julia> for g in SquareSymmetries.D4
           @assert inv(g)(my_alg(g(m))) == my_alg(m)
       end 
```
The above code checks that applying `my_alg` to `g(m)` and applying `inv(g)` (i.e., _g<sup>-1</sup>_) to the output yields the same result as applying `my_alg` to `m` directly for all _g_.
