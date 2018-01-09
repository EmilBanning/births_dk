FROM mikkelkrogsholm/rstudio

# Pick up some TF dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        libfreetype6-dev \
        libzmq3-dev \
        pkg-config \
        python \
        python-dev \
        rsync \
        software-properties-common \
        unzip \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN pip --no-cache-dir install \
        ipykernel \
        jupyter \
        matplotlib \
        numpy \
        scipy \
        virtualenv \
        && \
    python -m ipykernel.kernelspec

RUN install2.r --error \
    devtools

USER rstudio
# Install the R libraries for tensorflow and keras
RUN R -e "devtools::install_github('rstudio/reticulate'); devtools::install_github('rstudio/tensorflow'); devtools::install_github('rstudio/keras')"

# Install tensorflow and keras to beused by R
RUN R -e "tensorflow::install_tensorflow(); keras::install_keras()"
###

USER root
