#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
//#include <omp.h>


#define EPS 1e-6
int error=0;
int otv[100];
char dual, sol, int_sol;
int n, an, on, m, am, *basis, condition;
double **C, **A, **A_new, *B, *B_new, **Z, W[2];

double local_round(double x)
{
    double tmp1 = x, tmp2 = round(x);
    return fabs(tmp1 - tmp2) > EPS ? tmp1 : tmp2;
}

void global_round()
{
    int i, j;

    for (i = 0; i < m; i++)
    {
        for (j = 0; j < n; j++) A[i][j] = local_round(A[i][j]);
        B[i] = local_round(B[i]);
    }
    for (j = 0; j < n; j++)
    {
        Z[j][0] = local_round(Z[j][0]);
        Z[j][1] = local_round(Z[j][1]);
    }
    W[0] = local_round(W[0]);
    W[1] = local_round(W[1]);
}

void print_simplex_table()
{
    int i, j;

    printf("   ");
    for (j = 0; j < n; j++)
    {
        printf("|   a%-2d  ", j + 1);
    }
    printf("|   b    |   c            \n---");
    for (j = 0; j < n + 2; j++)
    {
        printf("|--------");
    }
    printf("\n");
    for (i = 0; i < m; i++)
    {
        printf("a%-2d", basis[i] + 1);
        for (j = 0; j < n; j++)
        {
            printf("| %-7.2f", A[i][j] == 0 ? 0 : A[i][j]);
        }
        if (C[basis[i]][1] != 0)
        {
            printf("| %-7.2f| %-5.2f*M", B[i] == 0 ? 0 : B[i], C[basis[i]][1] == 0 ? 0 : C[basis[i]][1]);
        }
        else
        {
            printf("| %-7.2f| %-7.2f", B[i] == 0 ? 0 : B[i], C[basis[i]][0] == 0 ? 0 : C[basis[i]][0]);
        }
        printf("\n");
    }
    printf("---");
    for (j = 0; j < n + 2; j++)
    {
        printf("|--------");
    }
    printf("\n z ");
    for (j = 0; j < n; j++)
    {
        printf("| %-7.2f", Z[j][0] == 0 ? 0 : Z[j][0]);
    }
    printf("| %-7.2f|", W[0] == 0 ? 0 : W[0]);
    for (j = 0; j < n; j++)
    {
        if (Z[j][1] != 0 || W[1] != 0)
        {
            printf("\n   |");
            for (j = 0; j < n; j++)
            {
                printf(Z[j][1] != 0 ? " %-7.2f|" : "        |", Z[j][1]);
            }
            if (W[1] != 0)
            {
                printf(" %-7.2f|", W[1]);
            }
            break;
        }
    }
    printf("\n---");
    for (j = 0; j < n + 1; j++)
    {
        printf("|--------");
    }
    printf("|\nc-z|");
    for (j = 0; j < n; j++)
    {
        printf(" %-7.2f|", C[j][0] - Z[j][0] == 0 ? 0 : C[j][0] - Z[j][0]);
    }
    for (j = 0; j < n; j++)
    {
        if (C[j][1] - Z[j][1] != 0)
        {
            printf("\n   |");
            for (j = 0; j < n; j++)
            {
                printf(C[j][1] - Z[j][1] != 0 ? " %-7.2f|" : "        |", C[j][1] - Z[j][1]);
            }
            break;
        }
    }
    printf("\n\n\n");
}

void process_file(char *filename)
{
    char c, s[3];
    int i, j;
    FILE *file;

    if (!(file = fopen(filename, "r")))
    {
        fprintf(stderr, "Cannot open file \"%s\"\n", filename);
        exit(1);
    }

    fscanf(file, "%d%d", &n, &m);
    an = n;
    on = n;
    am = m;
    m *= 2;
    if (!((C = calloc(n + 2*m, sizeof(double *))) &&
          (A = calloc(m, sizeof(double *))) &&
          (A_new = calloc(m, sizeof(double *))) &&
          (B = calloc(m, sizeof(double))) &&
          (B_new = calloc(m, sizeof(double))) &&
          (Z = calloc(n + 2*m, sizeof(double *))) &&
          (basis = calloc(m, sizeof(int)))))
    {
        fprintf(stderr, "Not enough memory\n");
        exit(1);
    }
    for (i = 0; i < m; i++)
    {
        if (!((A[i] = calloc(n + 2*m, sizeof(double))) &&
              (A_new[i] = calloc(n + 2*m, sizeof(double)))))
        {
            fprintf(stderr, "Not enough memory\n");
            exit(1);
        }
        basis[i] = -1;
        for (j = 0; j < n + 2*m; j++)
        {
            A[i][j] = 0;
        }
    }
    for (j = 0; j < n + 2*m; j++)
    {
        if (!((C[j] = calloc(2, sizeof(double))) &&
              (Z[j] = calloc(2, sizeof(double)))))
        {
            fprintf(stderr, "Not enough memory\n");
            exit(1);
        }
        C[j][1] = 0;
    }

    for (j = 0; j < n; j++)
    {
        fscanf(file, "%lf", &C[j][0]);
    }
    if (!fscanf(file, " -> %s", s))
    {
        printf("Input error\n");
        exit(1);
    }
    if (!strcmp(s, "min"))
    {
        condition = -1;
        for (j = 0; j < n; j++)
        {
            C[j][0] *= condition;
        }
    }
    else if (!strcmp(s, "max"))
    {
        condition = 1;
    }
    else
    {
        printf("Input error\n");
        exit(1);
    }
    m = am;
    for (i = 0; i < m; i++)
    {
        for (j = 0; j < n; j++)
        {
            fscanf(file, "%lf", &A[i][j]);
        }

        fscanf(file, " %c", &c);
        switch (c)
        {
            case '=':
                fscanf(file, "%lf", &B[i]);
                break;
            case '>':
                if (!fscanf(file, "= %lf", &B[i]))
                {
                    printf("Input error\n");
                    exit(1);
                }
                A[i][an] = -1;
                C[an][0] = 0;
                C[an++][1] = 0;
                break;
            case '<':
                if (!fscanf(file, "= %lf", &B[i]))
                {
                    printf("Input error\n");
                    exit(1);
                }
                A[i][an] = 1;
                C[an][0] = 0;
                C[an++][1] = 0;
                break;
            default:
                printf("Input error\n");
                exit(1);
        }

        if (!dual && B[i] < 0)
        {
            for (j = 0; j < an; j++)
            {
                A[i][j] *= -1;
            }
            B[i] *= -1;
        }
    }
    n = an;
}

int is_basis(j)
{
    int i;

    for (i = 0; i < m; i++)
    {
        if (basis[i] == j) return i;
    }
    return -1;
}

void find_or_make_basis()
{
    char bstate;
    int i, j, bi, bj, k;
    double tmp, btmp;

    for (j = 0; j < n; j++)
    {
        for (i = 0, bstate = 0; i < m; i++)
        {
            tmp = A[i][j];
            if (dual && tmp < 0) tmp *= -1;
            if ((tmp > 0 && bstate == 1) || tmp < 0)
            {
                bstate = -1;
            }
            else if (tmp > 0)
            {
                bstate = 1;
                bi = i;
                bj = j;
                btmp = A[i][j];
            }
            if (bstate < 0) break;
        }
        if (bstate > 0 && basis[bi] < 0)
        {
            for (k = 0; k < n; k++)
            {
                A[bi][k] /= btmp;
            }
            B[bi] /= btmp;
            basis[bi] = bj;
        }
    }

    for (i = 0; i < m; i++)
    {
        if (basis[i] < 0)
        {
            A[i][n] = 1;
            C[n][0] = 0;
            C[n][1] = -1;
            basis[i] = n++;
        }
    }
}

void new_basis(int nb_i, int nb_j)
{
    int i, j;

    basis[nb_i] = nb_j;
    for (i = 0; i < m; i++)
    {
        if (basis[i] == nb_j)
        {
            for (j = 0; j < n; j++)
                A_new[i][j] = A[i][j]/A[nb_i][nb_j];
            B_new[i] = B[i]/A[nb_i][nb_j];
        }
        else
        {
            for (j = 0; j < n; j++)
                A_new[i][j] = A[i][j] - A[nb_i][j]*A[i][nb_j]/A[nb_i][nb_j];
            B_new[i] = B[i] - B[nb_i]*A[i][nb_j]/A[nb_i][nb_j];
        }
    }
    for (i = 0; i < m; i++)
    {
        for (j = 0; j < n; j++)
            A[i][j] = A_new[i][j];
        B[i] = B_new[i];
    }
}

int simplex_method()
{
    char allow;
    int i, j, nb_i, nb_j;
    double tmp1, tmp2, tmp3[2], tmp4[2];

    for (j = 0; j < n; j++)
    {
        Z[j][0] = Z[j][1] = 0;
        for (i = 0; i < m; i++)
        {
            Z[j][0] += A[i][j]*C[basis[i]][0];
            Z[j][1] += A[i][j]*C[basis[i]][1];
        }
    }
    W[0] = W[1] = 0;
    for (i = 0; i < m; i++)
    {
        W[0] += B[i]*C[basis[i]][0];
        W[1] += B[i]*C[basis[i]][1];
    }

    global_round();
   // print_simplex_table();

    allow = 1;
    for (j = 0; j < n; j++)
    {
        if ((C[j][0] - Z[j][0] > 0 && C[j][1] - Z[j][1] == 0) || C[j][1] - Z[j][1] > 0)
        {
            allow = 0;
            break;
        }
    }
    if (dual && allow)
    {
        tmp1 = B[0];
        nb_i = 0;
        for (i = 1; i < m; i++)
        {
            tmp2 = B[i];
            if (tmp2 < tmp1)
            {
                tmp1 = tmp2;
                nb_i = i;
            }
        }

        if (tmp1 < 0)
        {
            for (j = 0; j < n && A[nb_i][j] >= 0; j++);
            if (j < n)
            {
                tmp3[0] = (C[j][0] - Z[j][0])/A[nb_i][j];
                tmp3[1] = (C[j][1] - Z[j][1])/A[nb_i][j];
                nb_j = j++;
                for (; j < n; j++)
                {
                    if (A[nb_i][j] < 0)
                    {
                        tmp4[0] = (C[j][0] - Z[j][0])/A[nb_i][j];
                        tmp4[1] = (C[j][1] - Z[j][1])/A[nb_i][j];
                        if (tmp4[1] < tmp3[1] || (tmp4[1] == tmp3[1] && tmp4[0] < tmp3[0]))
                        {
                            tmp3[0] = tmp4[0];
                            tmp3[1] = tmp4[1];
                            nb_j = j;
                        }
                    }
                }
                new_basis(nb_i, nb_j);
                return 1;
            }
            else
            {
                printf("No solutions.\n\n");
                error=1;
                return 0;
            }
        }
    }
    else
    {
        tmp3[0] = C[0][0] - Z[0][0];
        tmp3[1] = C[0][1] - Z[0][1];
        nb_j = 0;
        for (j = 1; j < n; j++)
        {
            tmp4[0] = C[j][0] - Z[j][0];
            tmp4[1] = C[j][1] - Z[j][1];
            if (tmp4[1] > tmp3[1] || (tmp4[1] == tmp3[1] && tmp4[0] > tmp3[0]))
            {
                tmp3[0] = tmp4[0];
                tmp3[1] = tmp4[1];
                nb_j = j;
            }
        }

        if (tmp3[1] > 0 || (tmp3[1] == 0 && tmp3[0] > 0))
        {
            for (i = 0; i < m && A[i][nb_j] <= 0; i++);
            if (i < m)
            {
                tmp1 = B[i]/A[i][nb_j];
                nb_i = i++;
                for (; i < m; i++)
                {
                    if (A[i][nb_j] > 0)
                    {
                        tmp2 = B[i]/A[i][nb_j];
                        if (tmp2 < tmp1)
                        {
                            tmp1 = tmp2;
                            nb_i = i;
                        }
                    }
                }
                new_basis(nb_i, nb_j);
                return 1;
            }
            else
            {
                printf("No solutions.\n\n");
                return 0;
            }
        }
    }

    tmp1 = basis[0];
    for (i = 1; i < m; i++)
    {
        if (basis[i] > tmp1)
        {
            tmp1 = basis[i];
        }
    }
    if (tmp1 >= an && int_sol == 'n')
    {
        printf("No solutions.\n\n");
    }
    else
    {
        printf("X = {");
        for (j = 0; j < on; j++)
        {	otv[j]=(int)B[is_basis(j)];
            printf("%.2lf%s", (i = is_basis(j)) != -1 ? B[i] : 0, on - j == 1 ? "" : ", ");
        }
        printf("}\nW = %.2lf\n\n", W[0]*condition);
        sol = 1;
    }
    return 0;
}

int int_solution()
{
    int i, j;

    for (j = 0; j < on; j++)
    {
        if ((i = is_basis(j)) != -1 && B[i] != round(B[i])) return 0;
    }
    if (W[0] != round(W[0])) return 0;

    return 1;
}

void gomorys_cut()
{
    int i, j, s;
    double tmp1, tmp2;

    tmp1 = B[0] - floor(B[0]);
    s = 0;
    for (i = 1; i < m; i++)
    {
        tmp2 = B[i] - floor(B[i]);
        if (tmp2 > tmp1)
        {
            tmp1 = tmp2;
            s = i;
        }
    }
    B[m] = -tmp1;
    for (j = 0; j < n; j++)
    {
        A[m][j] = floor(A[s][j]) - A[s][j];
    }
    A[m][n] = 1;
    basis[m] = n;
    n++;
    m++;
}

void free_mem()
{
    int i;

    free(C[0]);
    free(C[1]);
    free(C);
    for (i = 0; i < m; i++)
    {
        free(A[i]);
        free(A_new[i]);
    }
    free(A);
    free(A_new);
    free(B);
    free(B_new);
    free(Z[0]);
    free(Z[1]);
    free(Z);
}

int main(int argc, char *argv[])
{



   // printf("Use dual simplex method? (y/n): ");

//double ttime;
//ttime = omp_get_wtime();
  //  while ((dual = getchar()) != 'y' && dual != 'n') printf("Write y or n\n");
  //  dual = dual == 'y' ? 1 : 0;
    dual = 1;
    process_file(argc < 2 ? "simplex_data.txt" : argv[1]);
    find_or_make_basis();
    sol = 0;
    while (simplex_method());
    if (sol && !int_solution())
    {
      //  printf("Make integer solution? (y/n): ");
       // while ((int_sol = getchar()) != 'y' && int_sol != 'n') printf("Write y or n\n");
        //int_sol = int_sol == 'y' ? 1 : 0;
        int_sol =1 ;
        dual = 1;
        if (int_sol) do
        {
            gomorys_cut();
            sol = 0;
            while (simplex_method());
        } while (sol && !int_solution());
    }
    free_mem();

//ttime = omp_get_wtime()-ttime;
//printf("%lf",ttime);
printf("\n");
int j;


   FILE *fp;
     
   if((fp=fopen("simplex_out.txt", "wb")) == NULL) 
   {
      printf("Не удаётся открыть файл.\n");
      exit(1);
   }
   if (error==0){
      for (j = 0; j < on; j++)
        {
			fprintf(fp,"%d ",otv[j]);
           
        }
	}else{fprintf(fp,"error ");}
     fclose(fp);
     
    // printf("\n");
     return 0;
}
