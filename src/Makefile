EXE_INCLUDEPATH = -I../include
#CFLAGS=-O3 -std=c++0x -m64 -DMKL_ILP64 -fopenmp -DDEBUG -DUSE_MKL
CFLAGS=-O3 -std=c++0x -m64 -DMKL_ILP64 -fopenmp -DUSE_MKL


platform=$(shell uname)
ifeq ($(platform),Darwin)
#mac
CFLAGS += -DOSX
EXE_INCLUDEPATH = -I../include  -I/opt/intel/compilers_and_libraries_2016.1.111/mac/mkl/include/ 
CFLAGS+=-DMKL_CUSTOM_LIBRARY='"libfastpca_custommkl.dylib"'
#LIBS =  -L../lib  -lfastpca_custommkl -L../lib -liomp5 -ldl -lpthread -lm -Wl,-rpath,/Users/george/Research_Local/FastPCA4/FastPCA/lib
#LIBS =  -L../lib  -lfastpca_custommkl -L../lib -liomp5 -ldl -lpthread -lm -Wl,-rpath,/Users/george/Research_Local/FastPCA4/FastPCA/lib  -DMKL_ILP64 -m64
#@executable_path is $origin in linux
LIBS =  -L../lib -m64 -Wl,-rpath,'@executable_path/../lib' -lfastpca_custommkl -L../lib -liomp5 -ldl -lpthread -lm -DMKL_ILP64 
CC = clang-omp++
EXE_TARGET = ../build/fastpca.osx
CSV_BINARY_TARGET = csv2binary.osx
else

#Linux
CFLAGS+=-DMKL_CUSTOM_LIBRARY='"libfastpca_custommkl.so"'
EXE_INCLUDEPATH = -I../include -I/opt/intel/composer_xe_2015.1.133/mkl/include/
#LIBS =  -Wl,--no-as-needed  -L../lib -lfastpca_custommkl -liomp5 -ldl -lpthread -lm -Wl,-rpath,/data/Linderman/FastPCA5/FastPCA/lib
#LIBS =  -Wl,--no-as-needed  -L../lib -lfastpca_custommkl -liomp5 -ldl -lpthread 
LIBS =  -L../lib -m64 -Wl,-R,'$$ORIGIN/../lib' -lfastpca_custommkl -liomp5 -ldl -lpthread -lm 
CC = g++
EXE_TARGET = ../build/fastpca.linux
CSV_BINARY_TARGET = csv2binary.linux

endif


EXE_CPP_FILES := $(wildcard *.cpp)
EXE_OBJ_FILES := $(addprefix ../build/,$(notdir $(EXE_CPP_FILES:.cpp=.o)))


all: EXE_target csv2binary
debug: CFLAGS += -DDEBUG
debug: EXE_target

#Cleans all the objects
clean:
	rm -f $(EXE_OBJ_FILES)  $(EXE_TARGET)
#Link the objects into the final EXE executable
EXE_target: $(EXE_OBJ_FILES) 
	$(CC) $(CFLAGS) -o $(EXE_TARGET) $(EXE_OBJ_FILES) $(LIBS)
	cp $(EXE_TARGET) ../oocRPCA/inst/build/$(EXE_TARGET)
	g++ -I../include -o ../build/$(CSV_BINARY_TARGET) csv2binary/csv2binary.cpp
	cp ../build/$(CSV_BINARY_TARGET) ../oocRPCA/inst/build/$(CSV_BINARY_TARGET)

#Link the objects into the final R library

#Build the CPP files into objects
../build/%.o: %.cpp
	$(CC) $(CFLAGS) -fPIC -c -o $@ $< $(EXE_INCLUDEPATH) 
#install_name_tool -change libiomp5.dylib /Users/george/Research_Local/FastPCA4/FastPCA/lib/libiomp5.dylib libfastpca_custommkl.dylib
#install_name_tool -change libiomp5.dylib @rpath/libiomp5.dylib libfastpca_custommkl.dylib


#install_name_tool -id "@rpath/libiomp5.dylib" ../lib/libiomp5.dylib
#install_name_tool -id "@rpath/libfastpca_custommkl.dylib" libfastpca_custommkl.dylib #install_name_tool -add_rpath %s  fastrpca.so
#otool -D libfastpca_custommkl.dylib 
#Plan: Make all the names for libraries to be rpath, and then just add rpath to each of the libraries.



#CHANGE_SCRIPT=`echo 'system(sprintf("install_name_tool -change libiomp5.dylib %s/libiomp5.dylib %s/libfastpca_custommkl.dylib",system.file("libs", package="fastRPCA"), system.file("libs", package="fastRPCA") ))' | R --vanilla --slave`
#CHANGE_SCRIPT=`echo 'system(sprintf("install_name_tool -change /Users/george/Research_Local/FastPCA4/FastPCA/lib/libfastpca_custommkl.dylib  %s/libfastpca_custommkl.dylib %s/libfastpca.so",system.file("libs", package="fastRPCA"), system.file("libs", package="fastRPCA") ))' | R --vanilla --slave`
#CHANGE_SCRIPT=`echo 'system(sprintf('install_name_tool -change /Users/george/Research_Local/FastPCA4/FastPCA/lib/libiomp5.dylib %s/libiomp5.dylib %s/libfastpca.so',system.file("libs", package="fastRPCA"), system.file("libs", package="fastRPCA") ))' | R --vanilla --slave`

#install_name_tool -change /usr/local/lib/gcc/5/libgcc_s.1.dylib  @rpath/libgcc_s.1.dylib ../fastRPCA/inst/libs/libfastpca.dylib
#install_name_tool -change /usr/local/lib/gcc/5/libgcc_s.1.dylib  @rpath/libgcc_s.1.dylib ../fastRPCA/inst/libs/libfastpca.dylib

#Need tor un this everytime you make the file
#install_name_tool -id "@rpath/libfastpca.dylib" inst/libs/libfastpca.dylib


#This works:
#CHANGE_SCRIPT=`echo 'system(sprintf("install_name_tool -add_rpath %s  %s/libfastpca.so",system.file("libs", package="fastRPCA"), system.file("libs", package="fastRPCA") ))' | R --vanilla --slave`


