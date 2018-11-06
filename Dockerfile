FROM ubuntu:17.04
MAINTAINER Michael Bekaert <michael.bekaert@stir.ac.uk>

LABEL description="QDD Docker" version="1.1" Vendor="Institute of Aquaculture, University of Stirling"
ENV DOCKERVERSION 1.1
ENV STACKVERSION 1.47

USER root

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget ca-certificates
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y make bioperl primer3 ncbi-blast+ clustalw

#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget make ca-certificates gcc g++
##RUN DEBIAN_FRONTEND=noninteractive apt-get install -y zlib1g-dev libdbd-mysql-perl samtools libbam-dev perl mysql-client --no-install-recommends
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y zlib1g-dev samtools libbam-dev perl --no-install-recommends
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y bioperl --no-install-recommends
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y primer3 ncbi-blast+ clustalw libxml-parser-perl libwww-perl

RUN cpan App::cpanminus && \
    cpanm Bio::DB::EUtilities && \
    rm -rf /root/.cpanm

RUN wget http://net.imbe.fr/~emeglecz/QDDweb/QDD-3.1.2/QDD-3.1.2.tar.gz -O /usr/local/bin/QDD-3.1.2.tar.gz && \
    cd /usr/local/bin && \
    tar xfz QDD-3.1.2.tar.gz && \
    chmod +x *.pl && \
    ln -s /usr/local/bin/subprogramQDD.pm /etc/perl/subprogramQDD.pm && \
    ln -s /usr/local/bin/ncbi_taxonomy.pm /etc/perl/ncbi_taxonomy.pm && \
    mkdir /etc/qdd/ && \
    mv /etc/primer3_config /usr/bin && \
    sed -i 's/blast_path=/blast_path= \/usr\/bin\//' /usr/local/bin/set_qdd_default.ini && \
    sed -i 's/clust_path =/clust_path = \/usr\/bin\//' /usr/local/bin/set_qdd_default.ini && \
#    sed -i 's/primer3_path = \/usr\/bin\//primer3_path = \/usr\/bin\//' /usr/local/bin/set_qdd_default.ini && \
#    sed -i 's/primer3_version = 2/primer3_version = 2/' /usr/local/bin/set_qdd_default.ini && \
    sed -i 's/qdd_folder = \/home\/qdd\/galaxy-dist\/tools\/qdd\//qdd_folder = \/usr\/local\/bin\//' /usr/local/bin/set_qdd_default.ini && \
    sed -i 's/out_folder = \/home\/qdd\/galaxy-dist\/tools\/qdd\/qdd_output\//out_folder = \/tmp\//' /usr/local/bin/set_qdd_default.ini && \
    sed -i 's/num_threads = 1/num_threads = 15/' /usr/local/bin/set_qdd_default.ini && \
    sed -i 's/blastdb = \/usr\/local\/nt\/nt/blastdb = \/blast_databases\/nt/' /usr/local/bin/set_qdd_default.ini && \
    sed -i 's/local_blast = 0/local_blast = 1/' /usr/local/bin/set_qdd_default.ini && \
    ln -s /usr/local/bin/set_qdd_default.ini /etc/qdd/set_qdd_default.ini && \
    rm -rf QDD-3.1.2.tar.gz

RUN mkdir /qdd && mkdir /blast_databases

RUN git clone https://github.com/brwnj/fastq-join && \
    cd fastq-join && \
    make && \
    mv fastq-join /usr/local/bin && \
    cd .. && \
    rm -rf fastq-join

RUN cd /qdd && \
    wget http://net.imbe.fr/~emeglecz/QDDweb/QDD-3.1.2/QDD-3.1.2_example4.tar.gz -O /qdd/QDD-3.1.2_example4.tar.gz && \
    tar xfz QDD-3.1.2_example4.tar.gz && \
	mkdir example && \
	mv data_example4/example4.fastq example/example4.fastq && \
	mkdir output && \
	rm -rf /qdd/QDD-3.1.2_example4.tar.gz data_example4

RUN wget http://catchenlab.life.illinois.edu/stacks/source/stacks-${STACKVERSION}.tar.gz && \
    tar xzf stacks-${STACKVERSION}.tar.gz && \
    cd stacks-${STACKVERSION} && \
    ./configure --enable-bam && \
    make -j 8 && \
    make -j 8 -k install && \
    make -j 8 -k install && \
    rm -rf /usr/local/share/stacks/php && \
    cd ..  && \
    rm -rf stacks-${STACKVERSION}.tar.gz stacks-${STACKVERSION}

WORKDIR /qdd
