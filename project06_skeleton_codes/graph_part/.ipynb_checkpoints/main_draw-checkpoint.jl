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
    p = metis_part(A, 2, :KWAY);
    # p = metis_part(A, 4, :RECURSIVE);
    print("Edge-cut of $mesh mesh with METIS: $(count_edge_cut(A, p))\n\n");
    save("images/metis/$(mesh)_metis.pdf", draw_graph(A, coords, p));    
end

#meshes2 = ["mesh3e1", "airfoil1", "netz4504_dual", "stufe", "3elt", "barth4",
#              "ukerbe1", "crack"]

#for (i, mesh) in enumerate(meshes2)
    # Read data
#    A, coords = getData(mesh);

    # 1. Coordinate
#    pCoordinate08 = rec_bisection("coordinate_part", 3, A, coords);
#    pCoordinate16 = rec_bisection("coordinate_part", 4, A, coords);

    # 2. METIS (KWAY)
#    pMetis_kway08 = metis_part(A,  8, :KWAY);
#    pMetis_kway16 = metis_part(A, 16, :KWAY);

    # 3. METIS (RECURSIVE)
#    pMetis_recursive08 = metis_part(A,  8, :RECURSIVE);
#    pMetis_recursive16 = metis_part(A, 16, :RECURSIVE);

    # 4. Inertial
#    pInertial08 = rec_bisection("inertial_part", 3, A, coords);
#    pInertial16 = rec_bisection("inertial_part", 4, A, coords);

    # 5. Spectral
#    pSpectral08 = rec_bisection("spectral_part", 3, A);
#    pSpectral16 = rec_bisection("spectral_part", 4, A);
    
    # Save images for each partition method
#    save("images/coordinate/$(mesh)_coordinate_08.pdf", draw_graph(A, coords, pCoordinate08));
#    save("images/coordinate/$(mesh)_coordinate_16.pdf", draw_graph(A, coords, pCoordinate16));

#    save("images/metis/$(mesh)_metis_kway_08.pdf", draw_graph(A, coords, pMetis_kway08));
#    save("images/metis/$(mesh)_metis_kway_16.pdf", draw_graph(A, coords, pMetis_kway16));

#    save("images/metis/$(mesh)_metis_recursive_08.pdf", draw_graph(A, coords, pMetis_recursive08));
#    save("images/metis/$(mesh)_metis_recursive_16.pdf", draw_graph(A, coords, pMetis_recursive16));

#    save("images/inertial/$(mesh)_inertial_08.pdf", draw_graph(A, coords, pInertial08));
#    save("images/inertial/$(mesh)_inertial_16.pdf", draw_graph(A, coords, pInertial16));

#    save("images/spectral/$(mesh)_spectral_08.pdf", draw_graph(A, coords, pSpectral08));
#    save("images/spectral/$(mesh)_spectral_16.pdf", draw_graph(A, coords, pSpectral16));
#end