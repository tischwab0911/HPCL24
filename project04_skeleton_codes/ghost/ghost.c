/****************************************************************
 *                                                              *
 * This file has been written as a sample solution to an        *
 * exercise in a course given at the CSCS-USI Summer School     *
 * It is made freely available with the understanding that      *
 * every copy of this file must include this header and that    *
 * CSCS/USI take no responsibility for the use of the enclosed  *
 * teaching material.                                           *
 *                                                              *
 * Purpose: Exchange ghost cell in 2 directions using a topology*
 *                                                              *
 * Contents: C-Source                                           *
 *                                                              *
 ****************************************************************/

/* Use only 16 processes for this exercise
 * Send the ghost cell in two directions: left<->right and top<->bottom
 * ranks are connected in a cyclic manner, for instance, rank 0 and 12 are connected
 *
 * process decomposition on 4*4 grid
 *
 * |-----------|
 * | 0| 1| 2| 3|
 * |-----------|
 * | 4| 5| 6| 7|
 * |-----------|
 * | 8| 9|10|11|
 * |-----------|
 * |12|13|14|15|
 * |-----------|
 *
 * Each process works on a 6*6 (SUBDOMAIN) block of data
 * the D corresponds to data, g corresponds to "ghost cells"
 * xggggggggggx
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * xggggggggggx
 */

#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

#define SUBDOMAIN 6
#define DOMAINSIZE (SUBDOMAIN+2)

int main(int argc, char *argv[])
{
    int rank, size, i, j, dims[2], periods[2], rank_top, rank_bottom, rank_left, rank_right;
    double data[DOMAINSIZE*DOMAINSIZE];
    MPI_Request request;
    MPI_Status status;
    MPI_Comm comm_cart;
    MPI_Datatype data_ghost;

    // Initialize MPI
    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (size!=16) {
        printf("please run this with 16 processors\n");
        MPI_Finalize();
        exit(1);
    }

    // initialize the domain
    for (i=0; i<DOMAINSIZE*DOMAINSIZE; i++) {
        data[i]=rank;
    }

    // TODO: set the dimensions of the processor grid and periodic boundaries in both dimensions
    dims[0]=4;
    dims[1]=4;
    periods[0]=1;
    periods[1]=1;

    // TODO: Create a Cartesian communicator (4*4) with periodic boundaries (we do not allow
    // the reordering of ranks) and use it to find your neighboring
    // ranks in all dimensions in a cyclic manner.
    MPI_Cart_create(MPI_COMM_WORLD, 2, dims, periods, 0, &comm_cart);
    
    // TODO: find your top/bottom/left/right neighbor using the new communicator, see MPI_Cart_shift()
    MPI_Cart_shift(comm_cart, 0, 1, &rank_left, &rank_right);
    MPI_Cart_shift(comm_cart, 1, 1, &rank_top, &rank_bottom);

    int rank_top_left, rank_top_right, rank_bottom_left, rank_bottom_right;
    int selfXCoord = rank / 4;
    int selfYCoord = rank % 4;

    rank_top_left = ((selfXCoord + 3) % 4) * 4 + ((selfYCoord + 3) % 4);
    rank_top_right = ((selfXCoord + 3) % 4) * 4 + ((selfYCoord + 1) % 4);
    rank_bottom_left = ((selfXCoord + 1) % 4) * 4 + ((selfYCoord + 3) % 4);
    rank_bottom_right = ((selfXCoord + 1) % 4) * 4 + ((selfYCoord + 1) % 4);

    // printf("Rank: %d\n", rank);
    // printf("Rank Top Left: %d\n", rank_top_left);
    // printf("Rank Top Right: %d\n", rank_top_right);
    // printf("Rank Bottom Left: %d\n", rank_bottom_left);
    // printf("Rank Bottom Right: %d\n", rank_bottom_right);

    //  TODO: create derived datatype data_ghost, create a datatype for sending the column, see MPI_Type_vector() and MPI_Type_commit()
    // data_ghost
    MPI_Type_vector(SUBDOMAIN, 1, 1, MPI_DOUBLE, &data_ghost);
    MPI_Type_commit(&data_ghost);

    MPI_Datatype data_column;
    MPI_Type_vector(SUBDOMAIN, 1, DOMAINSIZE, MPI_DOUBLE, &data_column);
    MPI_Type_commit(&data_column);

    //  TODO: ghost cell exchange with the neighbouring cells in all directions
    //  use MPI_Irecv(), MPI_Send(), MPI_Wait() or other viable alternatives

    MPI_Request requests[8];
    MPI_Status statuses[8];

    //  to the left
    MPI_Isend(&data[1+ DOMAINSIZE], 1, data_ghost, rank_left, 42, comm_cart, &requests[0]);
    MPI_Irecv(&data[1], 1, data_ghost, rank_left, MPI_ANY_TAG, comm_cart, &requests[1]);
    
    //  to the right
    MPI_Isend(&data[1 + (DOMAINSIZE-2) * DOMAINSIZE], 1, data_ghost, rank_right, 42, comm_cart, &requests[2]);
    MPI_Irecv(&data[1 + (DOMAINSIZE-1) * DOMAINSIZE], 1, data_ghost, rank_right, MPI_ANY_TAG, comm_cart, &requests[3]);

    //  to the top
    MPI_Isend(&data[DOMAINSIZE + 1], 1, data_column, rank_top, 42, comm_cart, &requests[4]);
    MPI_Irecv(&data[DOMAINSIZE], 1, data_column, rank_top, MPI_ANY_TAG, comm_cart, &requests[5]);

    //  to the bottom
    MPI_Isend(&data[2 * DOMAINSIZE - 2], 1, data_column, rank_bottom, 42, comm_cart, &requests[6]);
    MPI_Irecv(&data[2 * DOMAINSIZE - 1], 1, data_column, rank_bottom, MPI_ANY_TAG, comm_cart, &requests[7]);


    MPI_Waitall(8, requests, statuses);

    // send data in ordinal directions
    MPI_Isend(&data[1 + DOMAINSIZE], 1, MPI_DOUBLE, rank_top_left, 42, MPI_COMM_WORLD, &requests[0]);
    MPI_Irecv(data, 1, MPI_DOUBLE, rank_top_left, MPI_ANY_TAG, MPI_COMM_WORLD, &requests[4]);

    MPI_Isend(&data[2 * DOMAINSIZE- 2], 1, MPI_DOUBLE, rank_top_right, 42, MPI_COMM_WORLD, &requests[1]);
    MPI_Irecv(&data[DOMAINSIZE - 1], 1, MPI_DOUBLE, rank_top_right, MPI_ANY_TAG, MPI_COMM_WORLD, &requests[5]);

    MPI_Isend(&data[(DOMAINSIZE-2) * (DOMAINSIZE) + 1], 1, MPI_DOUBLE, rank_bottom_left, 42, MPI_COMM_WORLD, &requests[2]);
    MPI_Irecv(&data[(DOMAINSIZE-1) * DOMAINSIZE], 1, MPI_DOUBLE, rank_bottom_left, MPI_ANY_TAG, MPI_COMM_WORLD, &requests[6]);

    MPI_Isend(&data[(DOMAINSIZE-1) * (DOMAINSIZE) - 2], 1, MPI_DOUBLE, rank_bottom_right, 42, MPI_COMM_WORLD, &requests[3]);
    MPI_Irecv(&data[DOMAINSIZE * DOMAINSIZE -1], 1, MPI_DOUBLE, rank_bottom_right, MPI_ANY_TAG, MPI_COMM_WORLD, &requests[7]);

    MPI_Waitall(8, requests, statuses);
    

    // if (rank==9) {
        printf("Data from rank %d after communication\n", rank);
        for (j=0; j<DOMAINSIZE; j++) {
            for (i=0; i<DOMAINSIZE; i++) {
                // printf("%.1f ", data[i+j*DOMAINSIZE]);
                printf("%4.1f ", data[i+j*DOMAINSIZE]);
            }
            printf("\n");
        }
    // }

    // Free MPI resources (e.g., types and communicators)
    MPI_Type_free(&data_column);
    MPI_Type_free(&data_ghost);

    MPI_Comm_free(&comm_cart);
    

    // Finalize MPI
    MPI_Finalize();

    return 0;
}
