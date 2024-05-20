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

PetscErrorCode MaxTimeReducer(MPI_Comm comm, void *invec, void *inoutvec, PetscMPIInt *len, MPI_Datatype *datatype) {
    double *in = (double*)invec;
    double *inout = (double*)inoutvec;
    
    for (PetscMPIInt i = 0; i < *len; ++i) {
        inout[i] = PetscMax(in[i], inout[i]);
    }
    
    return 0;
}

int main(int argc, char **args)
{
    Vec              u, b;
    Mat              A;
    DM               da;
    KSP              ksp;
    PetscInt         m = 16;
    PetscScalar      h = 1.0 / (m-1);
    PetscMPIInt      rank, size;
    DMDAStencilType  stype = DMDA_STENCIL_STAR;
    double           start_time, end_time, assembly_start;
    double           solver_time, program_time, assembly_time;
    PetscScalar v[5];
    MatStencil row, col[5];
    
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
    assembly_start = MPI_Wtime();
    PetscCall(DMDACreate2d(PETSC_COMM_WORLD, DM_BOUNDARY_NONE, DM_BOUNDARY_NONE,
                           stype, m, m, PETSC_DECIDE, PETSC_DECIDE, 1, 1, NULL, NULL, &da ));
    PetscCall(DMSetFromOptions(da));
    PetscCall(DMSetUp(da));

    // create matrix A and vectors b, u
    PetscCall(DMCreateMatrix(da, &A));
    PetscCall(DMCreateGlobalVector(da, &b));
    PetscCall(VecDuplicate(b, &u));
    
    // values
    PetscScalar diag = 4.0 / hsq;
    PetscScalar offdiag = -1.0 / hsq;
    PetscScalar f = 20.0;
    
    // get local assembly range
    PetscInt xmin, ymin, xcount, ycount;
    PetscCall(DMDAGetCorners(da, &xmin, &ymin, NULL, &xcount, &ycount, NULL));
    
    
    for (PetscInt i = xmin; i < xmin + xcount; ++i) {
        for (PetscInt j = ymin; j < ymin + ycount; ++j) {
            row.i = i; row.j = j;
            PetscInt row_index = j * m + i;
            
            // boundary points
            if (i==0 || j==0 || i==m-1 || j==m-1) {
                MatSetValuesStencil(A, 1, &row, 1, &row, &diag, INSERT_VALUES);
                VecSetValue(b, row_index, 0.0, INSERT_VALUES);
            } else {
                // set matrix from stencil
                v[0] = offdiag; col[0].i = i-1; col[0].j = j;
                v[1] = offdiag; col[1].i = i; col[1].j = j-1;
                v[2] = diag; col[2].i = i; col[2].j = j;
                v[3] = offdiag; col[3].i = i; col[3].j = j+1;
                v[4] = offdiag; col[4].i = i+1; col[4].j = j;
                MatSetValuesStencil(A, 1, &row, 5, col, v, INSERT_VALUES);
                // constant source
                VecSetValue(b, row_index, f, INSERT_VALUES);
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
    
    
    // create the ksp context, previously PCCG
    KSPCreate(PETSC_COMM_WORLD, &ksp);
    KSPSetType(ksp, KSPCG);

    // Create a preconditioner context
    PC pc;
    KSPGetPC(ksp, &pc);

    // Set the type of preconditioner, previously PCGAMG
    PCSetType(pc, PCGAMG);
    
    KSPSetFromOptions(ksp);
    PCSetFromOptions(pc);
    
    KSPSetOperators(ksp, A, A);
    KSPSetUp(ksp);
    end_time = MPI_Wtime();
    assembly_time = end_time - assembly_start;
    
    // solve LSE, measure time
    start_time = MPI_Wtime();
    KSPSolve(ksp, b, u);
    end_time = MPI_Wtime();
    solver_time = end_time-start_time;
    program_time = end_time - assembly_start;
    
    // output solution for plotting reasons
    // PetscViewer viewer;
    // PetscViewerASCIIOpen(PETSC_COMM_WORLD, "solution.txt", &viewer);
    // VecView(u, viewer);
    // PetscViewerDestroy(&viewer);
    
    double max_solver_time, max_assembly_time, max_program_time;
    MPI_Reduce(&solver_time, &max_solver_time, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);
    MPI_Reduce(&assembly_time, &max_assembly_time, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);
    MPI_Reduce(&program_time, &max_program_time, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);
    
    // cleanup
    KSPDestroy(&ksp);
    MatDestroy(&A);
    VecDestroy(&u);
    VecDestroy(&b);
    DMDestroy(&da);
   
    
    if (rank == 0) {
        printf("Execution time: %f seconds, Number ranks: %d\n", max_program_time, size);
        printf("Solver time: %f seconds, Number ranks: %d\n", max_solver_time, size);
        printf("Setup time: %f seconds, Number ranks: %d\n", max_assembly_time, size);
    }
    
    PetscCall(PetscFinalize());
    return 0;
}