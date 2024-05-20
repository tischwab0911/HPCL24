# M.L. for High Performance Computing Lab @USI & @ETHZ - malik.lechekhab@usi.ch 
# Main file of Project 6
using Pkg
Pkg.instantiate()
Pkg.add(Pkg.PackageSpec(name="Arpack", version="0.5.3"))

# I/O packages
using DelimitedFiles, MAT
# Math packages
using Arpack, LinearAlgebra, Metis, Random, SparseArrays, Statistics
# Plot packages
using Graphs, SGtSNEpi, Colors, CairoMakie, PrettyTables

# Tools
include("./Tools/add_paths.jl");

# Run benchmark
benchmark_bisection()
benchmark_recursive()
