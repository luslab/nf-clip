// Copyright 2011 Martin C. Frith

// Find clusters in 1-dimensional data, using the method described in
// MC Frith et al. Genome Res. 2008 18(1):1-12.

// The input has 4 columns: chromosome, strand, coordinate, value.
// For example: chr20 + 60026 2

#include <algorithm>  // max, min
#include <cassert>
#include <cstdlib>  // EXIT_SUCCESS, EXIT_FAILURE
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <stdexcept>
#include <string>
#include <vector>

typedef unsigned Position;
typedef double Value;

struct Site {
  Position position;
  Value value;
  Site(Position p, Value v) : position(p), value(v) {}
};

typedef std::vector<Site>::const_iterator Ci;

const double infinity = 1e100;

std::vector<Site> sites;
std::string seqname;
char strand;

Ci minPrefix;
double minPrefixDensity;
Ci minSuffix;
double minSuffixDensity;

Value totalValue;

Value minValue;

void weakestPrefix(Ci beg, Ci end) {
  assert(beg < end);
  Position origin = beg->position;
  //minPrefix = beg;
  minPrefixDensity = infinity;
  totalValue = beg->value;
  ++beg;

  while (beg < end) {
    double density = totalValue / (beg->position - origin);
    if (density < minPrefixDensity) {
      minPrefix = beg;
      minPrefixDensity = density;
    }
    totalValue += beg->value;
    ++beg;
  }
}

void weakestSuffix(Ci beg, Ci end) {
  assert(beg < end);
  --end;
  Position origin = end->position;
  //minSuffix = end + 1;
  minSuffixDensity = infinity;
  totalValue = end->value;

  while (end > beg) {
    --end;
    double density = totalValue / (origin - end->position);
    if (density < minSuffixDensity) {
      minSuffix = end + 1;
      minSuffixDensity = density;
    }
    totalValue += end->value;
  }
}

void writeClusters(Ci beg, Ci end, double minDensity) {
  if (beg == end) return;
  weakestPrefix(beg, end);
  if (totalValue < minValue) return;
  weakestSuffix(beg, end);

  double maxDensity = std::min(minPrefixDensity, minSuffixDensity);

  if (maxDensity > minDensity) {
    std::cout << seqname << "\t" << strand << "\t"
              << std::setprecision(20)
              << beg->position << "\t" << (end-1)->position << "\t"
              << (end - beg) << "\t" << totalValue << "\t"
              << std::setprecision(3)
              << minDensity << "\t" << maxDensity << "\n";
  }

  if (maxDensity < infinity) {
    Ci mid = (minPrefixDensity < minSuffixDensity) ? minPrefix : minSuffix;
    double newMinDensity = std::max(minDensity, maxDensity);
    writeClusters(beg, mid, newMinDensity);
    writeClusters(mid, end, newMinDensity);
  }
}

void processOneStream(std::istream &stream) {
  std::string newSeqname;
  char newStrand;
  Position p;
  Value v;
  while (stream >> newSeqname >> newStrand >> p >> v) {
    if (newSeqname == seqname && newStrand == strand) {
      if (p > sites.back().position)
        sites.push_back(Site(p, v));
      else if (p == sites.back().position)
        sites.back().value += v;
      else
        throw std::runtime_error("unsorted input");
    } else {
      writeClusters(sites.begin(), sites.end(), -infinity);
      sites.clear();
      seqname = newSeqname;
      strand = newStrand;
      sites.push_back(Site(p, v));
    }
  }
  if (!stream.eof()) throw std::runtime_error("bad input");
  writeClusters(sites.begin(), sites.end(), -infinity);
}

void processOneFile(const std::string &fileName) {
  if (fileName == "-") {
    processOneStream(std::cin);
  } else {
    std::ifstream ifs(fileName.c_str());
    if (!ifs) throw std::runtime_error("can't open file: " + fileName);
    processOneStream(ifs);
  }
}

void parseMinValue(const std::string &s) {
  std::istringstream iss(s);
  if (!(iss >> minValue) || !(iss >> std::ws).eof())
    throw std::runtime_error("bad minValue: " + s);
}

int main(int argc, char **argv)
try {
  if (argc != 3) throw std::runtime_error("I need a minValue and a fileName");
  parseMinValue(argv[1]);
  std::cout << "# sequence, strand, start, end, sites, sum of values, min d, max d\n";
  processOneFile(argv[2]);
  return EXIT_SUCCESS;
}
catch (const std::exception& e) {
  std::cerr << "paraclu: " << e.what() << '\n';
  return EXIT_FAILURE;
}
