FLAGS = -Wall 
CC = gcc

ifeq ($(flags),use)
	FLAGS += -march=native -mtune=native -Ofast -funroll-loops
# march:  Specify the type of the target processor; possibilities are ( native->  Selects the CPU of the compiling machine)

# funroll-loops
#            Unroll loops whose number of iterations can be determined at compile time or upon entry to the loop.  -funroll-loops
#            implies -frerun-cse-after-loop.  This option makes code larger, and may or may not make it run faster.
endif

ifeq ($(USE_OMP),y)
	FLAGS += -fopenmp -D_USE_OMP=1 -O3
	CC = nvc
endif

ifeq ($(USE_OMP_TARGET),y)
	FLAGS += -fopenmp -D_USE_OMP_TARGET=1
	CC = nvc
endif

ifeq ($(USE_MPI),y)
	FLAGS += -D_USE_MPI=1 -O3
	CC = mpicc
endif

ifeq ($(SERIAL),y)
	FLAGS += -D_SERIAL
endif

ifeq ($(PRINT_D),y)
	FLAGS += -D_PRINT_DISTANCE=1
endif


all: 
	$(CC) $(FLAGS) -g -c lib/floyd-library.c -o lib/floyd-library.o
	$(CC) $(FLAGS) -g -c lib/time-library.c -o lib/time-library.o
	$(CC) $(FLAGS) -g -c floyd-main.c
	$(CC) $(FLAGS) -g -o floyd-main floyd-main.o lib/floyd-library.o lib/time-library.o 


# floyd-main : floyd-main.o lib/floyd-library.o lib/time-library.o 
# 	$(CC) $(FLAGS) -o floyd-main floyd-main.o lib/floyd-library.o lib/time-library.o

# floyd-main.o : floyd-main.c 
# 	$(CC) $(FLAGS) -c floyd-main.c

# floyd-library.o : floyd-library.c floyd-library.h
# 	$(CC) $(FLAGS) -c floyd-library.c

# lib/time-library.o: lib/time-library.c 
# 	gcc -c -o lib/time-library.o lib/time-library.c 


clean:
	rm *.o lib/*.o

graph: graph/graph.dot
	dot -Tpng graph/graph.dot -o graph/graph.png

# load-module:
# 	module load nvhpc/22.11
# 	module load cuda/10.2
# 	module load openmpi

git:
	git add *
	git commit -m "commit automatico"
	git push -u origin main