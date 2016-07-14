qdd-docker - QDD in a Docker

[![Build Status](https://travis-ci.org/pseudogene/qdd-docker.svg?branch=master)](https://travis-ci.org/pseudogene/qdd-docker)

# qdd-docker

We foster the openness, integrity, and reproducibility of scientific research.

Scripts and funtion used deploy [QDD version 3.1+](http://net.imbe.fr/~emeglecz/qdd.html) and all required tools (excluding [RepeatMasker](http://www.repeatmasker.org/)).


## Short Description

In microsatellite development, high throughput sequencing has replaced the classical cloning based methods and in this process the first two versions of QDD played an important role by dealing with the essential bio-informatics steps leading from raw sequences to primer design - Now in a Docker


## Associated publication

> **QDD version 3.1: a user-friendly computer program for microsatellite selection and primer design revisited: experimental validation of variables determining genotyping success rate.**
> Meglécz E1, Pech N, Gilles A, Dubut V, Hingamp P, Trilles A, Grenier R, Martin JF.
> Mol Ecol Resour. 2014 Nov;14(6):1302-13.


## How to use this repository?

This repository hosts both scripts and funtion used deploy [QDD version](http://net.imbe.fr/~emeglecz/qdd.html) 3.1+ and all required tools (excluding [RepeatMasker](http://www.repeatmasker.org/)).

To look at our scripts and raw results, **browse** through this repository. If you want to reproduce our results, you will need to **clone** this repository, build the docker, and the run all the scripts. If you want to use our data for our own research, **fork** this repository and **cite** the authors.


## Prepare a docker

All required files and tools run in a self-contained [docker](https://www.docker.com/) image.

#### Clone the repository

```
git clone https://github.com/pseudogene/qdd-docker.git
cd qdd-docker
```


#### Download the NCBI nt database (optional for running pipe4)

If you plan to use the contamination check from a local copy of the NCBI nt database (`-check_contamination 1`), you need to get a copy it. Create a folder to store it and run the installation script

```
mkdir /blast
make -f Makefile.nt DEST=/blast
```

#### Create a docker

```
docker build --rm=true -t qdd .
```


#### Start the docker

To import and export the results of your analyse you need to link a folder to the docker. It this example your data will be store in `qdd_test` (current filesystem) which will be seem as been `/qdd` from within the docker by using `-v <absolute_path_userfolder>/qdd_test:/qdd`. Similarly the NCBI nt database stored in `/blast` (current filesystem) will be seem as been `/blast_databases` from within the docker.

```
docker run -i -t --rm \
       -v <absolute_path_userfolder>/qdd_test:/qdd \
       -v /blast:/blast_databases \
       qdd /bin/bash
```


#### Run a new analysis

Make sure your input files are in a sub-folder in `<absolute_path_userfolder>/qdd_test`. Refer to [QDD version 3.1+](http://net.imbe.fr/~emeglecz/qdd_run.html#examples) manual for tutorials and examples.

To run the full pipeline:

```
QDD.pl -input_folder ./example -out_folder ./output -fastq 1 -check_contamination 1 -local_blast 0
```


## Issues

If you have any problems with or questions about the scripts, please contact us through a [GitHub issue](https://github.com/pseudogene/qdd-docker/issues).
Any issue related to QDD itself must be done directly with the QDD authors from [QDD website](http://net.imbe.fr/~emeglecz/qdd.html).


## Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.


## License and distribution

The content of this project itself including the raw data and work are licensed under the [Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/), and the source code presented is licensed under the [GPLv3 license](http://www.gnu.org/licenses/gpl-3.0.html).
