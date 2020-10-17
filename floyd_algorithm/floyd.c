/*
	Script for apply Floyd's algorithm to a given graph.
	Designed for 9 vertices graphs, if you want to apply
	the algoritm to a bigger graph, you should replace
	"matrix[9][9]" by "matrix[n][n]" where "n" is the
	number of vertices of your graph. In linux it can be
	done easily with the next command:

	"sed -i 's/\[9\]\[9\]/[n][n]/g floyd.c"

	For non-adjacent vertices enter negative distance i.e:
		dist(1,2) = -1	
					Author: Sergio Apellaniz
*/ 

#include <stdio.h>
#include <string.h>

void printMatrix(int matrix[9][9], int n)
{
  int i, j;

  for(i = 0 ; i < n ; i++)
  {
    for(j = 0 ; j < n ; j++)
    {
      printf("  %d", matrix[i][j]);
    }
    printf("\n\n");
  }
}

void main()
{
  int n, i, j, k;

  printf("Floyd's algorithm calculator\n\n");
  printf("Number of vertices: ");
  scanf("%d", &n);
  printf("\n");

  int matrix[9][9] = {0};

  // Init matrix
  for(i = 0 ; i < n ; i++)
  {
    for(j = 0 ; j< n ; j++)
    {
      if(j == i)
        matrix[i][j] = 0;
      else
      {
        printf("dist(%d,%d) = ", i+1, j+1);
        scanf("%d", &matrix[i][j]);
      }
    }
  }

  printf("\nd0 =\n\n");
  printMatrix(matrix, n);


  // Apply the algorithm
  for(k = 0 ; k < n ; k++)
  {
    for(i = 0 ; i < n ; i++)
    {
      for(j = 0 ; j < n ; j++)
      {
	if(k != i && k != j && i != j)
	  if((matrix[i][k] + matrix[k][j]) < matrix[i][j] || matrix[i][j] < 0)
	    if(matrix[i][k] > 0 && matrix[k][j] > 0)
	      matrix[i][j] = matrix[k][i] + matrix[k][j];
      }
    }

    printf("d%d =\n\n", k);
    printMatrix(matrix, n);
  }

}
