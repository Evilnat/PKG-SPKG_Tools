## ----------------------- ##
## pkg/spkg tools makefile ##
## ----------------------- ##

SOURCE	=	source/
INCLUDE	=	include/
BUILD	=	build/
TOOLS	=	$(SOURCE)spkg    $(SOURCE)unspkg $(SOURCE)new_unpkg $(SOURCE)new_pkg
COMMON	=	$(SOURCE)tools.o $(SOURCE)aes.o  $(SOURCE)sha1.o    $(SOURCE)ec.o 
COMMON	+=	$(SOURCE)mingw_mmap.o $(SOURCE)self.o $(SOURCE)bn.o 
DEPS	=	Makefile $(INCLUDE)tools.h $(INCLUDE)types.h

CC	?=  gcc
CFLAGS	+=  -g -O2 -Wall -W
LDLIBS  =  -lz

# Darwin's MacPorts Default Path
ifeq ($(shell test -e /opt/local/include/gmp.h; echo $$?),0)
CFLAGS  += -I/opt/local/include
LDLIBS  += -L/opt/local/lib
endif
 
OBJS	= $(COMMON) $(addsuffix .o, $(TOOLS))

all: $(TOOLS)

$(TOOLS): %: %.o $(COMMON) $(DEPS)	
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@$(SUFFIX) $< $(COMMON) $(LDLIBS)
	@mkdir -p build
	@-mv $(SOURCE)*.exe $(BUILD)
	

$(OBJS): %.o: %.c $(DEPS)
	$(CC) $(CFLAGS) -c -o $@ $<
	

clean:
	@-rm -f $(OBJS) $(TOOLS)
	@-rm -f $(BUILD)*.*
	@-rm -f -r build
