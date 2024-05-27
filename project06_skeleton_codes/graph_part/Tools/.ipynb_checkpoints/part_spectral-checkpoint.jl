# M.L. for High Performance Computing Lab @USI & @ETHZ - malik.lechekhab@usi.ch 
"""
    spectral_part(A, fiedler=false)

Compute the bi-partions of graph `A` using spectral method.

If `fiedler` is true, return the entries of the fiedler vector.

# Examples
```julia-repl
julia> spectral_part(A)
 1
 ⋮
 2
```
"""
function spectral_part(A)
    n = size(A)[1]

    if n > 4*10^4
        @warn "graph is large. Computing eigen values may take too long."     
    end

    # 1. Construct the Laplacian matrix.
    column_sums = sum(A, dims=1)
    L = Diagonal(column_sums[1, :]) .- A

    # 2. Compute its eigendecomposition.
    maxiter = 10000
    eigenvals, eigenvecs = eigs(L, nev=2, which=:SR, maxiter=maxiter)

    fiedler_vec = eigenvecs[:, 2]

    # 3. Label the vertices with the entries of the Fiedler vector.
    epsilon = median(fiedler_vec)

    # 4. Partition them around their median value, or 0.
    p = ones(Int, length(fiedler_vec))
    for i in 1:length(fiedler_vec)
        if fiedler_vec[i] < epsilon
            p[i] = 1
        else
            p[i] = 2
        end
    end
        

    # 5. Return the indicator vector
    return p
    # RANDOM PARTITIONING - REMOVE AFTER COMPLETION OF THE EXERCISE
    #n = size(A)[1];
    #rng = MersenneTwister(1234);
    #p = Int.(bitrand(rng, n));
    #return p

end
