CXXFLAGS=-std=c++17 -ggdb -Wall -fdiagnostics-color=always -fmax-errors=4 -Werror \
    -Wno-misleading-indentation -Wno-unused-function -ftrack-macro-expansion=0 -fopenmp

APP = zapp
APP_OBJS = zapp.o

all: build

build: $(APP)

$(APP): $(APP_OBJS)
	$(CXX) $(LDFLAGS) -o $@ $(APP_OBJS) $(LDLIBS) -fopenmp -l:libzdma.so.1 -lopencv_core -lopencv_highgui -lopencv_imgcodecs

clean:
	rm -f $(APP) $(APP_OBJS)
