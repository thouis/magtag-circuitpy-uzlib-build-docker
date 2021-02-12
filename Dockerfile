FROM debian:stable
RUN apt-get update
RUN apt-get install -y --no-install-recommends eatmydata
RUN eatmydata apt-get install -y --no-install-recommends gettext librsvg2-bin mingw-w64 python3-pip wget lbzip2 python3-setuptools python3-wheel
RUN wget --progress=dot:mega https://adafruit-circuit-python.s3.amazonaws.com/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2
RUN tar -C /usr --strip-components=1 -xaf gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2
RUN wget --progress=dot:mega https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-centos6.tar.gz
RUN tar -C /usr --strip-components=1 -xaf riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-centos6.tar.gz
RUN rm -f gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2 riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-centos6.tar.gz
RUN eatmydata python3 -mpip install requests sh click setuptools cpp-coveralls "Sphinx<3" sphinx-rtd-theme recommonmark sphinxcontrib-svg2pdfconverter polib pyyaml awscli
RUN eatmydata apt-get install -y git libusb-1.0-0 

RUN mkdir /circuitpython
WORKDIR /circuitpython
RUN git init .
RUN eatmydata git fetch --recurse-submodules=no https://github.com/adafruit/circuitpython refs/tags/*:refs/tags/*
RUN eatmydata git checkout --progress --force refs/tags/6.2.0-beta.2
RUN eatmydata git submodule sync
RUN eatmydata git -c protocol.version=2 submodule update --init --force
RUN git log -1
RUN eatmydata git fetch --recurse-submodules=no https://github.com/adafruit/circuitpython refs/tags/*:refs/tags/*
RUN git describe --dirty --tags
WORKDIR /circuitpython//ports/esp32s2/esp-idf
RUN git submodule update --init
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ls -l
RUN bash -c "tools/idf_tools.py --non-interactive install required && tools/idf_tools.py --non-interactive install cmake && tools/idf_tools.py --non-interactive install-python-env && rm -rf dist"
RUN sh install.sh
RUN bash -c "source export.sh && pip install requests sh click setuptools awscli && apt-get install -y gettext ninja-build"

RUN apt-get install -y build-essential
WORKDIR /circuitpython/
RUN bash -c "make -C mpy-cross -j2"

ENV IDF_PATH=/circuitpython//ports/esp32s2/esp-idf
ENV BOARDS=adafruit_magtag_2.9_grayscale

WORKDIR /circuitpython/ports/esp32s2
RUN sed -ie '/^#include "py.circuitpy_mpconfig.h"/a #define MICROPY_PY_UZLIB (1)' mpconfigport.h
RUN cat mpconfigport.h

WORKDIR /circuitpython/extmod
RUN sed -ie 's/mp_obj_decompio_t .self = (mp_obj_decompio_t.)p;/mp_obj_decompio_t *self = (mp_obj_decompio_t*)(void *)p;/g' moduzlib.c
RUN head -37 moduzlib.c | tail -10

WORKDIR /circuitpython/locale
RUN bash -c "mv en_US.po ..; rm *.po; mv ../en_US.po ."

WORKDIR /circuitpython/tools
RUN bash -c "source $IDF_PATH/export.sh && python3 -u build_release_files.py"

ENTRYPOINT ["sh", "-c"]
