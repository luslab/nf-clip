% PARACLU Paraclu User Manual
% Martin Frith

NAME
====

paraclu - finds clusters in data attached to sequences

paraclu-cut - subset the output of paraclu

SYNOPSIS
========

paraclu [*minValue*] [*my_input*] > [*my_output*]

paraclu-cut.sh [*my_output*] > [*my_cut*]

DESCRIPTION
===========

Paraclu finds clusters in data attached to sequences.  It was first
applied to transcription start counts in genome sequences, but it
could be applied to other things too.

Paraclu is intended to explore the data, imposing minimal prior
assumptions, and letting the data speak for itself.

One consequence of this is that paraclu can find clusters within
clusters.  Real data sometimes exhibits clustering at multiple scales:
there may be large, rarefied clusters; and within each large cluster
there may be several small, dense clusters.

SETUP
=====

Using the command line, go into the paraclu directory and type "make".
This assumes you have a C++ compiler.

INPUT
=====

The input to paraclu should have four columns, like this:

  chr1	+	17689	3

The first column is the sequence name, then the strand, then the
coordinate, then the data value.  For example, this might mean that we
observed 3 transcripts starting at position 17689 on the + strand of
chromosome 1.

All the data for one strand of one sequence should appear
consecutively (else it will treat the data as coming from different
sequences).  Furthermore, the data for one strand of one sequence
should be in ascending order of coordinate (else it will complain).

USAGE
=====

If the data is in a file called "my_input", run paraclu like this:

  paraclu 30 my_input > my_output

This will write the output to a file called "my_output".  The "30"
tells it to omit clusters whose total data value is less than 30.  (In
other words, it omits clusters where the sum of the data values in the
cluster is less than minValue.)

If you wish to read standard input (e.g. from a pipe), use the special
file name "-".

OUTPUT
======

The output has one cluster per line.  It has eight columns, like this:

  chr1	+	787298	787382	64	317	0.5	2.56

 - Column 1: the sequence name.
 - Column 2: the strand.
 - Column 3: the first position in the cluster.
 - Column 4: the last position in the cluster.
 - Column 5: the number of positions with data in the cluster.
 - Column 6: the sum of the data values in the cluster.
 - Column 7: the cluster's "minimum density".
 - Column 8: the cluster's "maximum density".

For an explanation of "density", please consult the paraclu
publication (see below).  Briefly, the greater the fold-change between
min and max density, the more prominent the cluster, and the less
likely that it is due to chance fluctuations in the data.

paraclu-cut.sh
==============

This script simplifes the output of paraclu, by getting a subset of
the clusters.  The usage is like this:

  `paraclu-cut.sh my_output > my_cut`

This performs the following steps:

 1. Remove single-position clusters.
 2. Remove clusters longer than 200.  (Length = column_4 - column_3.)
 3. Remove clusters with (maximum density / baseline density) < 2.
 4. Remove any cluster that is contained in a larger cluster.

The "baseline density" of a cluster X is the "minimum density" of the
outermost cluster that contains X (or is X) and passed step 2.

Options:

-h  show a help message and exit
-l  maximum cluster length (default 200)
-d  minimum density increase (default 2)
-s  use an alternative version of step 3:
    remove clusters with (maximum density / minimum density) < 2

MISCELLANEOUS
=============

The original paraclu is a perl script, which is available here:
http://people.binf.ku.dk/albin/supplementary_data/tss_code/
The new version works identically to the original, but is much faster
and copes with much bigger data.

LICENSE
=======

Paraclu is distributed under the GNU General Public License, either
version 3 of the License, or (at your option) any later version.  For
details, see COPYING.txt.

REFERENCE
=========

If you use paraclu in your research, please cite:
"A code for transcription initiation in mammalian genomes"
MC Frith, E Valen, A Krogh, Y Hayashizaki, P Carninci, A Sandelin
Genome Research 2008 18(1):1-12.

CONTACT
=======

Website: http://www.cbrc.jp/paraclu/
E-mail: paraclu (ATmark) cbrc (dot) jp
