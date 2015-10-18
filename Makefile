SOURCE_DIRS:= ./source 
INCLUDE_DIRS:= ./include
LINKER_DIRS:=

OUTPUT_EXEC:= myProg 

C_SOURCE_FILES:= 
CXX_SOURCE_FILES:= main.cc
ASM_SOURCE_FILES:=
LINKER_FILES:=

LD_SCRIPTS:= 

C_OBJECTS:= $(C_SOURCE_FILES:.c=.o)
CXX_OBJECTS:= $(CXX_SOURCE_FILES:.cc=.o)
ASM_OBJECTS:= $(ASM_SOURCE_FILES:.S=.o)

COMMON_FLAGS:= -Wall -g 
USER_CPP_FLAGS:=
USER_DEFINES:= 
USER_ASM_FLAGS:= 
USER_C_FLAGS:= -std=c99
USER_CXX_FLAGS:= -std=c++11
USER_LINKER_FLAGS:= -std=c++11

CPP_DEFINES:= $(USER_DEFINES)
CPP_DEFINE_FLAGS:=$(patsubst %,-D%,$(CPP_DEFINES))
INCLUDE_FLAGS:= $(patsubst %,-I%,$(INCLUDE_DIRS))
CPP_FLAGS:= $(CPP_DEFINE_FLAGS) $(INCLUDE_FLAGS) $(USER_CPP_FLAGS)

#LINKER OPTIONS
#The linker script
LD_SCRIPTS:=
#the directories for linker files
LIB_DIRS:= 
#the libraries to link
LIB_NAMES:=
#linker flags
LFLAGS:= $(patsubst %,-L%,$(LIB_DIRS)) $(patsubst %,-l%,$(LIB_NAMES)) -T$(LD_SCRIPTS)

ASM_FLAGS:= $(ARCH_FLAGS) $(COMMON_FLAGS) $(USER_ASM_FLAGS)
C_FLAGS:= $(ARCH_FLAGS) $(COMMON_FLAGS) $(USER_C_FLAGS)
CXX_FLAGS:= $(ARCH_FLAGS) $(COMMON_FLAGS) $(USER_CXX_FLAGS)
LINKER_FLAGS:= $(ARCH_FLAGS) $(COMMON_FLAGS) $(USER_LINKER_FLAGS) $(patsubst %,-L%,$(LIB_DIRS)) $(patsubst %,-l%,$(LIB_NAMES))

OBJECTS_DIR:= objects
BIN_DIR:= bin

DIRS_TO_CREATE:= $(OBJECTS_DIR) $(BIN_DIR)

OBJECTS:= $(C_OBJECTS) $(CXX_OBJECTS) $(ASM_OBJECTS)
OBJECTS_WITH_PATH:= $(patsubst %,$(OBJECTS_DIR)/%,$(OBJECTS))

CC=gcc
CXX=g++
AS=g++
LN=g++

vpath %.c $(SOURCE_DIRS)
vpath %.cc $(SOURCE_DIRS)
vpath %.S $(SOURCE_DIRS)
vpath %.o $(OBJECTS_DIR)
vpath %.a $(BIN_DIR) $(LINKER_DIRS)
vpath % $(BIN_DIR)
vpath %.elf $(BIN_DIR)

.PHONY: disp clean test_clean dist_clean test

all: $(OUTPUT_EXEC)
$(OUTPUT_EXEC): $(OBJECTS) $(LINKER_FILES) | $(BIN_DIR)
	$(LN) $(OBJECTS_WITH_PATH) $(LINKER_FILES) $(LINKER_FLAGS) -o $(BIN_DIR)/$@
$(DIRS_TO_CREATE): %:
	mkdir $@
$(C_OBJECTS): %.o : %.c | $(OBJECTS_DIR)
	$(CC) -c $(C_FLAGS) $(CPP_FLAGS) $< -o $(OBJECTS_DIR)/$@
$(ASM_OBJECTS): %.o : %.S | $(OBJECTS_DIR)
	$(AS) -c $(ASM_FLAGS) $(CPP_FLAGS) $< -o $(OBJECTS_DIR)/$@
$(CXX_OBJECTS): %.o : %.cc | $(OBJECTS_DIR)
	$(CXX) -c $(CXX_FLAGS) $(CPP_FLAGS) $< -o $(OBJECTS_DIR)/$@
clean:
	rm -rf $(DIRS_TO_CREATE) $(OUTPUT_EXEC)
dist_clean: clean
	$(MAKE) --directory=./tests dist_clean 
test_clean:
	$(MAKE) --directory=./tests clean 
test:
	$(MAKE) --directory=./tests test 
run: $(OUTPUT_EXEC)
	$(BIN_DIR)/$(OUTPUT_EXEC)
