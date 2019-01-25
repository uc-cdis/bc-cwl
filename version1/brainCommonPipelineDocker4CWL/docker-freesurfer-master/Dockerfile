FROM neurodebian:xenial
MAINTAINER Soichi Hayashi <hayashis@iu.edu>, Xingyan Kuang <xyk7412@gmail.com>

RUN apt-get update

#download and untar freesurfer installation on /usr/local/freesurfer

RUN apt-get install -y curl tar tcsh libglu1-mesa libgomp1 libjpeg62 libxext6 libxtst6  libxt6 libxt-dev libxmu6
RUN curl ftp://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.0/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz | tar xvz -C /usr/local

#recon-all dependencies
RUN apt-get install -y jq bc libsys-hostname-long-perl

#make it work under singularity
RUN ldconfig && mkdir -p /N/u /N/home /N/dc2 /N/soft
COPY license /usr/local/freesurfer/license.txt

ENV FREESURFER_HOME /usr/local/freesurfer
ENV FMRI_ANALYSIS_DIR /usr/local/freesurfer/fsfast
ENV FSFAST_HOME /usr/local/freesurfer/fsfast
ENV FUNCTIONALS_DIR /usr/local/freesurfer/sessions
ENV LOCAL_DIR /usr/local/freesurfer/local
ENV MINC_BIN_DIR /usr/local/freesurfer/mni/bin
ENV MINC_LIB_DIR /usr/local/freesurfer/mni/lib
ENV MNI_DATAPATH /usr/local/freesurfer/mni/data
ENV MNI_DIR /usr/local/freesurfer/mni
ENV MNI_PERL5LIB /usr/local/freesurfer/mni/share/perl5
ENV PERL5LIB /usr/local/freesurfer/mni/share/perl5
ENV SUBJECTS_DIR /usr/local/freesurfer/subjects
ENV PATH /usr/local/freesurfer/bin:/usr/local/freesurfer/fsfast/bin:/usr/local/freesurfer/tktools:/usr/local/freesurfer/mni/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ADD extract_subfields.sh /mnt/
ADD initialize_subDir.sh /mnt/
ADD extract_subcortical.sh /mnt/
ADD outlierDetection.sh /mnt/
COPY runtime2012b.tar.gz /usr/local/freesurfer/
RUN curl "https://surfer.nmr.mgh.harvard.edu/fswiki/MatlabRuntime?action=AttachFile&do=get&target=runtime2012bLinux.tar.gz" -o "/usr/local/freesurfer/runtime2012b.tar.gz" 
RUN tar xf /usr/local/freesurfer/runtime2012b.tar.gz -C /usr/local/freesurfer/ \
  && /bin/rm /usr/local/freesurfer/runtime2012b.tar.gz

