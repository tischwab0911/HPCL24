# M.L. for High Performance Computing Lab @USI & @ETHZ - malik.lechekhab@usi.ch 
"""
    inertial_part(A, coords)

Compute the bi-partions of graph `A` using inertial method based on the
`coords` of the graph.

# Examples
```julia-repl
julia> inertial_part(A, coords)
 1
 ⋮
 2
```
"""
function inertial_part(A, coords)
    d = size(coords)[2]
    N = size(coords)[1]

    # 1. Compute the center of mass.
    COM = mean(coords, dims=1)

    # 2. Construct the matrix M. (see pdf of the assignment)
    S_xx = 0.0
    S_xy = 0.0
    S_yy = 0.0
    for i in 1:N
        S_xx += (coords[i,1] - COM[1])^2
        S_xy += (coords[i,1] - COM[1]) * (coords[i,2] - COM[2])
        S_yy += (coords[i,2] - COM[2])^2
    end
        
    M = [ S_xx S_xy;
          S_xy S_yy ]

    # 3. Compute the eigenvector associated with the smallest eigenvalue of M.
    eigenvalue_min, eigenvector_min = eigs(M, nev=1, which=:SM)
    #eigenvalues = eigen_M.values[1]
    ##eigenvector_min = eigen_M.vectors[: ,1]
    #eigenvector_min = eigenvectors[:, index_of_min_eigenvalue]

    # 4. Partition the nodes around line L 
    #    (use may use the function partition(coords, eigv))
    p1, p2 = partition(coords, eigenvector_min)

    # 5. Return the indicator vector
    p = ones(Int, N)
    p[p1] .= 1
    p[p2] .= 2

    return p

end
