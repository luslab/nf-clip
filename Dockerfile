FROM continuumio/miniconda3:4.8.2
LABEL authors="chris.cheshire@crick.ac.uk" \
      description="Docker image containing all requirements for the luslab/group-nextflow-clip pipeline"

<<<<<<< HEAD
# Install procps so that Nextflow can poll CPU usage
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils unzip procps=2:3.3.15-2 build-essential git \
=======
# Install apt packages
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
 apt-utils=1.8.2 \
 unzip=6.0-23+deb10u1 \
 procps=2:3.3.15-2 \
 build-essential=12.6 \
>>>>>>> dev
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install conda packages
COPY environment.yml /
RUN conda env create -f /environment.yml && conda clean -a
ENV PATH /opt/conda/envs/luslab-clip-0.1/bin:$PATH

# Install Paraclu
<<<<<<< HEAD
RUN wget http://cbrc3.cbrc.jp/~martin/paraclu/paraclu-9.zip && \
unzip paraclu-9.zip && cd paraclu-9 && make \
&& cp paraclu ../bin/paraclu && cp paraclu-cut.sh ../bin/paraclu-cut.sh

# Install PEKA
RUN wget https://raw.githubusercontent.com/ulelab/imaps/master/src/imaps/sandbox/kmers.py 
RUN mkdir src && mv kmers.py src/kmers.py

=======
WORKDIR /home
RUN mkdir bin && wget http://cbrc3.cbrc.jp/~martin/paraclu/paraclu-9.zip && unzip paraclu-9.zip
WORKDIR /home/paraclu-9
RUN make && cp paraclu /home/bin/paraclu && cp paraclu-cut.sh /home/bin/paraclu-cut.sh
>>>>>>> dev
