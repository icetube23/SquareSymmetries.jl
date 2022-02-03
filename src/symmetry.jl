# direct implementations
unit(x::AbstractMatrix) = x
flipdiag(x::AbstractMatrix) = permutedims(x)
flipx(x::AbstractMatrix) = reverse(x; dims=1)
flipy(x::AbstractMatrix) = reverse(x; dims=2)
rotate90(x::AbstractMatrix) = rotr90(x)
rotate180(x::AbstractMatrix) = rot180(x)
rotate270(x::AbstractMatrix) = rotl90(x)

# no base function directly returns this, but we can easily compose it
flipadiag(x::AbstractMatrix) = rotate180(flipdiag(x))

# binary group operation for elements of the symmetry group
Base.:∘(::typeof(unit), ::typeof(unit)) = unit
Base.:∘(::typeof(unit), ::typeof(flipx)) = flipx
Base.:∘(::typeof(unit), ::typeof(flipy)) = flipy
Base.:∘(::typeof(unit), ::typeof(flipdiag)) = flipdiag
Base.:∘(::typeof(unit), ::typeof(flipadiag)) = flipadiag
Base.:∘(::typeof(unit), ::typeof(rotate90)) = rotate90
Base.:∘(::typeof(unit), ::typeof(rotate180)) = rotate180
Base.:∘(::typeof(unit), ::typeof(rotate270)) = rotate270

Base.:∘(::typeof(flipx), ::typeof(unit)) = flipx
Base.:∘(::typeof(flipx), ::typeof(flipx)) = unit
Base.:∘(::typeof(flipx), ::typeof(flipy)) = rotate180
Base.:∘(::typeof(flipx), ::typeof(flipdiag)) = rotate270
Base.:∘(::typeof(flipx), ::typeof(flipadiag)) = rotate90
Base.:∘(::typeof(flipx), ::typeof(rotate90)) = flipadiag
Base.:∘(::typeof(flipx), ::typeof(rotate180)) = flipy
Base.:∘(::typeof(flipx), ::typeof(rotate270)) = flipdiag

Base.:∘(::typeof(flipy), ::typeof(unit)) = flipy
Base.:∘(::typeof(flipy), ::typeof(flipx)) = rotate180
Base.:∘(::typeof(flipy), ::typeof(flipy)) = unit
Base.:∘(::typeof(flipy), ::typeof(flipdiag)) = rotate90
Base.:∘(::typeof(flipy), ::typeof(flipadiag)) = rotate270
Base.:∘(::typeof(flipy), ::typeof(rotate90)) = flipdiag
Base.:∘(::typeof(flipy), ::typeof(rotate180)) = flipx
Base.:∘(::typeof(flipy), ::typeof(rotate270)) = flipadiag

Base.:∘(::typeof(flipdiag), ::typeof(unit)) = flipdiag
Base.:∘(::typeof(flipdiag), ::typeof(flipx)) = rotate90
Base.:∘(::typeof(flipdiag), ::typeof(flipy)) = rotate270
Base.:∘(::typeof(flipdiag), ::typeof(flipdiag)) = unit
Base.:∘(::typeof(flipdiag), ::typeof(flipadiag)) = rotate180
Base.:∘(::typeof(flipdiag), ::typeof(rotate90)) = flipx
Base.:∘(::typeof(flipdiag), ::typeof(rotate180)) = flipadiag
Base.:∘(::typeof(flipdiag), ::typeof(rotate270)) = flipy

Base.:∘(::typeof(flipadiag), ::typeof(unit)) = flipadiag
Base.:∘(::typeof(flipadiag), ::typeof(flipx)) = rotate270
Base.:∘(::typeof(flipadiag), ::typeof(flipy)) = rotate90
Base.:∘(::typeof(flipadiag), ::typeof(flipdiag)) = rotate180
Base.:∘(::typeof(flipadiag), ::typeof(flipadiag)) = unit
Base.:∘(::typeof(flipadiag), ::typeof(rotate90)) = flipy
Base.:∘(::typeof(flipadiag), ::typeof(rotate180)) = flipdiag
Base.:∘(::typeof(flipadiag), ::typeof(rotate270)) = flipx

Base.:∘(::typeof(rotate90), ::typeof(unit)) = rotate90
Base.:∘(::typeof(rotate90), ::typeof(flipx)) = flipdiag
Base.:∘(::typeof(rotate90), ::typeof(flipy)) = flipadiag
Base.:∘(::typeof(rotate90), ::typeof(flipdiag)) = flipy
Base.:∘(::typeof(rotate90), ::typeof(flipadiag)) = flipx
Base.:∘(::typeof(rotate90), ::typeof(rotate90)) = rotate180
Base.:∘(::typeof(rotate90), ::typeof(rotate180)) = rotate270
Base.:∘(::typeof(rotate90), ::typeof(rotate270)) = unit

Base.:∘(::typeof(rotate180), ::typeof(unit)) = rotate180
Base.:∘(::typeof(rotate180), ::typeof(flipx)) = flipy
Base.:∘(::typeof(rotate180), ::typeof(flipy)) = flipx
Base.:∘(::typeof(rotate180), ::typeof(flipdiag)) = flipadiag
Base.:∘(::typeof(rotate180), ::typeof(flipadiag)) = flipdiag
Base.:∘(::typeof(rotate180), ::typeof(rotate90)) = rotate270
Base.:∘(::typeof(rotate180), ::typeof(rotate180)) = unit
Base.:∘(::typeof(rotate180), ::typeof(rotate270)) = rotate90

Base.:∘(::typeof(rotate270), ::typeof(unit)) = rotate270
Base.:∘(::typeof(rotate270), ::typeof(flipx)) = flipadiag
Base.:∘(::typeof(rotate270), ::typeof(flipy)) = flipdiag
Base.:∘(::typeof(rotate270), ::typeof(flipdiag)) = flipx
Base.:∘(::typeof(rotate270), ::typeof(flipadiag)) = flipy
Base.:∘(::typeof(rotate270), ::typeof(rotate90)) = unit
Base.:∘(::typeof(rotate270), ::typeof(rotate180)) = rotate90
Base.:∘(::typeof(rotate270), ::typeof(rotate270)) = rotate180

# unary inverse operation
Base.inv(::typeof(unit)) = unit
Base.inv(::typeof(flipx)) = flipx
Base.inv(::typeof(flipy)) = flipy
Base.inv(::typeof(flipdiag)) = flipdiag
Base.inv(::typeof(flipadiag)) = flipadiag
Base.inv(::typeof(rotate90)) = rotate270
Base.inv(::typeof(rotate180)) = rotate180
Base.inv(::typeof(rotate270)) = rotate90
