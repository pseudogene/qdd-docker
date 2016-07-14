FROM ubuntu:16.04
MAINTAINER Michael Bekaert <michael.bekaert@stir.ac.uk>

LABEL description="QDD Docker" version="1.0" Vendor="Institute of Aquaculture, University of Stirling"
ENV DOCKERVERSION 1.0

USER root

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget ca-certificates
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y make bioperl primer3 ncbi-blast+ clustalw

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

RUN cd /qdd && \
    wget http://net.imbe.fr/~emeglecz/QDDweb/QDD-3.1.2/QDD-3.1.2_example4.tar.gz -O /qdd/QDD-3.1.2_example4.tar.gz && \
    tar xfz QDD-3.1.2_example4.tar.gz && \
	mkdir example && \
	mv data_example4/example4.fastq example/example4.fastq && \
	mkdir output && \
	rm -rf /qdd/QDD-3.1.2_example4.tar.gz data_example4

WORKDIR /qdd
