FROM debian:10.3-slim

RUN apt-get update
RUN apt-get install -y --no-install-recommends eatmydata
RUN eatmydata apt-get install -y --no-install-recommends gettext librsvg2-bin mingw-w64 python3-pip wget lbzip2 python3-setuptools python3-wheel
RUN wget --progress=dot:mega https://adafruit-circuit-python.s3.amazonaws.com/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2
RUN tar -C /usr --strip-components=1 -xaf gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2
RUN wget --progress=dot:mega https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-centos6.tar.gz
RUN tar -C /usr --strip-components=1 -xaf riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-centos6.tar.gz
RUN rm -f gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2 riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-centos6.tar.gz
RUN eatmydata python3 -mpip install requests sh click setuptools cpp-coveralls "Sphinx<3" sphinx-rtd-theme recommonmark sphinxcontrib-svg2pdfconverter polib pyyaml awscli

ENTRYPOINT ["sh", "-c"]
