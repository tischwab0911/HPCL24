static char help[] = "Solver for 2D Poisson Equation on the unit square with\n\
zero Dirichlet boundary conditions and a constant source function.\n\
Discretizing the domain using second order centered finite differences.\n\
Input arguments are -m <size> : grid size \n\n";

#include <petscsys.h>
#include <petscksp.h>
#include <petscvec.h>
#include <petscdm.h>
#include <petscdmda.h>
#include <stdio.h>

int main(int argc, char **args)
{
    Vec              u, b;
    Mat              A;
    DM               da;
    KSP              ksp;
    PetscInt         m = 16;
    PetscInt         Istart, Iend;
    PetscScalar      h = 1.0 / (m-1);
    PetscMPIInt      rank, size;
    DMDAStencilType  stype = DMDA_STENCIL_STAR;
    double           start_time, end_time;
    
    PetscFunctionBeginUser;
    PetscCall(PetscInitialize(&argc, &args, (char *)0, help));
    
    // create the ksp context
    PetscCall(KSPCreate(PETSC_COMM_WORLD, &ksp));
    
    // get MPI rank and size
    PetscCallMPI(MPI_Comm_rank(PETSC_COMM_WORLD, &rank));
    PetscCallMPI(MPI_Comm_size(PETSC_COMM_WORLD, &size));
    
    // get mesh size
    PetscCall(PetscOptionsGetInt(NULL, NULL, "-m", &m, NULL));
    h = 1.0 / (m-1);
    PetscScalar hsq = h*h;
    
    // uncomment to time matrix assembly
    // start_time = MPI_Wtime();
    
    // finite difference matrix
    MatCreate(PETSC_COMM_WORLD, &A);
    MatSetSizes(A, PETSC_DECIDE, PETSC_DECIDE, m*m, m*m);
    MatSetFromOptions(A);
    MatSetUp(A);
    
    // solution vector
    VecCreate(PETSC_COMM_WORLD, &u);
    VecSetSizes(u, PETSC_DECIDE, m*m);
    VecSetFromOptions(u);
    
    // rhs vector
    VecCreate(PETSC_COMM_WORLD, &b);
    VecSetSizes(b, PETSC_DECIDE, m*m);
    VecSetFromOptions(b);
    
    // values
    PetscScalar diag = 4.0 / hsq;
    PetscScalar offdiag = -1.0 / hsq;
    PetscScalar f = 20.0;
    
    for (PetscInt i = 0; i < m; ++i) {
        for (PetscInt j = 0; j < m; ++j) {
            PetscInt index = i* m + j;
            
            // set diagonal value
            MatSetValue(A, index, index, diag, INSERT_VALUES);
            
            // set off-diagonal values
            if (j > 0) {
                MatSetValue(A, index, index - 1, offdiag, INSERT_VALUES);
            }
            
            if (j < m-1) {
                MatSetValue(A, index, index + 1, offdiag, INSERT_VALUES);
            }
            
            if (i > 0) {
                MatSetValue(A, index, index - m, offdiag, INSERT_VALUES);
            }
            
            if (i < m-1) {
                MatSetValue(A, index, index + m, offdiag, INSERT_VALUES);
            }
            
            // Dirichlet boundary conditions else constant source
            if (i == 0 || i == m-1 || j == 0 || j == m-1) {
                VecSetValue(b, index, 0.0, INSERT_VALUES);
            } else {
                VecSetValue(b, index, f, INSERT_VALUES);
            }
        }
    }
    
    MatSetOption(A, MAT_SYMMETRIC, PETSC_TRUE);
    
    // assemble matrix
    MatAssemblyBegin(A, MAT_FINAL_ASSEMBLY);
    MatAssemblyEnd(A, MAT_FINAL_ASSEMBLY);
    
    // assemble rhs vector
    VecAssemblyBegin(b);
    VecAssemblyEnd(b);
    
    // uncomment to time matrix assebly
    // end_time = MPI_Wtime();
    
    // create the ksp context
    KSPCreate(PETSC_COMM_WORLD, &ksp);
    KSPSetType(ksp, KSPCG);

    // Create a preconditioner context
    PC pc;
    KSPGetPC(ksp, &pc);

    // Set the type of preconditioner (e.g., Jacobi, ILU)
    PCSetType(pc, PCGAMG);
    
    KSPSetFromOptions(ksp);
    PCSetFromOptions(pc);
    
    KSPSetOperators(ksp, A, A);
    KSPSetUp(ksp);
    
    // solve LSE, measure time
    start_time = MPI_Wtime();
    KSPSolve(ksp, b, u);
    end_time = MPI_Wtime();
    
    // output solution for plotting reasons
    PetscViewer viewer;
    PetscViewerASCIIOpen(PETSC_COMM_WORLD, "solution.txt", &viewer);
    VecView(u, viewer);
    PetscViewerDestroy(&viewer);
    
    // cleanup
    KSPDestroy(&ksp);
    MatDestroy(&A);
    VecDestroy(&u);
    VecDestroy(&b);
   
    
    if (rank == 0) {
        printf("Execution time: %f seconds, Number ranks: %d\n", end_time - start_time, size);
    }
    
    PetscCall(PetscFinalize());
    return 0;
}