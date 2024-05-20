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

# List the meshes to draw
meshes = ["CH-4468", "CL-13042", "GB-5946", "GR-3117", "NO-9935", "VN-4031",
          "mesh1e1", "mesh2e1", "mesh3e1", "airfoil1", "netz4504_dual",
          "stufe", "3elt", "barth4", "ukerbe1", "crack"]

# Draw meshes
for (i, mesh) in enumerate(meshes)
    # Read data
    A, coords = getData(mesh);

    # Draw
    save("images/meshes/$(mesh).pdf", draw_graph(A, coords));
    
    # Partitioning: Coordinate bisection
    p = coordinate_part(A, coords); 
    print("Edge-cut of $mesh mesh with coordinate bisection: " *
          "$(count_edge_cut(A, p))\n\n");
    save("images/coordinate/$(mesh)_coordinate.pdf", draw_graph(A, coords, p));

    p = inertial_part(A, coords); 
    print("Edge-cut of $mesh mesh with inertial bisection: " *
          "$(count_edge_cut(A, p))\n\n");
    save("images/inertial/$(mesh)_inertial.pdf", draw_graph(A, coords, p));
    
    p = spectral_part(A)
    print("Edge-cut of $mesh mesh with spectral bisection: " *
          "$(count_edge_cut(A, p))\n\n");
    save("images/spectral/$(mesh)_spectral.pdf", draw_graph(A, coords, p));

    # Partitioning: METIS
    p = metis_part(A, 4, :KWAY);
    # p = metis_part(A, 4, :RECURSIVE);
    print("Edge-cut of $mesh mesh with METIS: $(count_edge_cut(A, p))\n\n");
    save("images/metis/$(mesh)_metis.pdf", draw_graph(A, coords, p));
end
