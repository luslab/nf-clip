CXX = g++
CXXFLAGS = -Wall -W -O3

all: paraclu

paraclu: paraclu.cc Makefile
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(LDFLAGS) -o $@ paraclu.cc

clean: FORCE
	rm -f paraclu

log: FORCE
	hg log --style changelog > ChangeLog.txt

distdir = paraclu-`hg id -n`

dist: log
	mkdir ${distdir}
	cp *.cc *.sh *.txt Makefile ${distdir}
	zip -qrm ${distdir} ${distdir}

FORCE:
