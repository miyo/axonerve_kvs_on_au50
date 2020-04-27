CFLAGS=-O3 -Wall -std=gnu99

all: perf_check

perf_check: perf_check.o
	$(CC) $(CFLAGS) -o $@ $^

.c.o:
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	-rm -f perf_check
	-rm -f *.o
