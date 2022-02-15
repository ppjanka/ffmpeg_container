# A basic Ubuntu dockerfile with ffmpeg installed
# Patryk Pjanka, 2020
#  - follwing ffmpeg installation instructions from
#   https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

# basic image
FROM ubuntu:20.04
RUN mkdir -p /home/workdir && \
  echo "export SHELL='/bin/bash'" >> ~/.bashrc && \
  echo "export PATH=\"$HOME/bin:$PATH\"" >> ~/.bashrc
WORKDIR ~

# Install ffmpeg (see https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu)
#  0) Set up certificates
#  1) install compilation dependencies
#  2) install required dependencies
#  3) install ffmpeg
#  4) clean up compilation dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq \
 && apt-get -y --no-install-recommends install \
  autoconf \
  automake \
  build-essential \
  cmake \
  git-core \
  libass-dev \
  libfreetype6-dev \
  libgnutls28-dev \
  libmp3lame-dev \
  libsdl2-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  meson \
  ninja-build \
  pkg-config \
  texinfo \
  wget \
  yasm \
  zlib1g-dev \
 && mkdir -p ~/ffmpeg_sources ~/bin
RUN apt-get -y --no-install-recommends install \
  nasm \
  libx264-dev \
  libx265-dev libnuma-dev \
  libvpx-dev \
  libfdk-aac-dev \
  libopus-dev \
 && apt-get -y --no-install-recommends install --reinstall ca-certificates && \
  mkdir -p /usr/local/share/ca-certificates/cacert.org && \
  wget -P /usr/local/share/ca-certificates/cacert.org http://www.cacert.org/certs/root.crt http://www.cacert.org/certs/class3.crt && \
  update-ca-certificates && \
  git config --global http.sslCAinfo /etc/ssl/certs/ca-certificates.crt \
 && cd ~/ffmpeg_sources && \
  git -C aom pull 2> /dev/null || git clone --depth 1 https://aomedia.googlesource.com/aom && \
  mkdir -p aom_build && \
  cd aom_build && \
  PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_TESTS=OFF -DENABLE_NASM=on ../aom && \
  PATH="$HOME/bin:$PATH" make && \
  make install \
 && cd ~/ffmpeg_sources && \
  git -C SVT-AV1 pull 2> /dev/null || git clone https://gitlab.com/AOMediaCodec/SVT-AV1.git && \
  mkdir -p SVT-AV1/build && \
  cd SVT-AV1/build && \
  PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DCMAKE_BUILD_TYPE=Release -DBUILD_DEC=OFF -DBUILD_SHARED_LIBS=OFF .. && \
  PATH="$HOME/bin:$PATH" make && \
  make install \
 && apt install -y --no-install-recommends python3-pip && \
  pip3 install --user meson && \
  cd ~/ffmpeg_sources && \
  git -C dav1d pull 2> /dev/null || git clone --depth 1 https://code.videolan.org/videolan/dav1d.git && \
  mkdir -p dav1d/build && \
  cd dav1d/build && \
  meson setup -Denable_tools=false -Denable_tests=false --default-library=static .. --prefix "$HOME/ffmpeg_build" --libdir="$HOME/ffmpeg_build/lib" && \
  ninja && \
  ninja install \
 && cd ~/ffmpeg_sources && \
  wget https://github.com/Netflix/vmaf/archive/v2.1.1.tar.gz && \
  tar xvf v2.1.1.tar.gz && \
  mkdir -p vmaf-2.1.1/libvmaf/build &&\
  cd vmaf-2.1.1/libvmaf/build && \
  meson setup -Denable_tests=false -Denable_docs=false --buildtype=release --default-library=static .. --prefix "$HOME/ffmpeg_build" --bindir="$HOME/ffmpeg_build/bin" --libdir="$HOME/ffmpeg_build/lib" && \
  export PATH="$PATH:$HOME/ffmpeg_build/bin" && \
  ninja && \
  ninja install \
 && apt install -y --no-install-recommends libunistring-dev \
 && cd ~/ffmpeg_sources && \
  wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
  tar xjvf ffmpeg-snapshot.tar.bz2 && \
  cd ffmpeg && \
  PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
      --prefix="$HOME/ffmpeg_build" \
      --pkg-config-flags="--static" \
      --extra-cflags="-I$HOME/ffmpeg_build/include" \
      --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
      --extra-libs="-lpthread -lm" \
      --ld="g++" \
      --bindir="$HOME/bin" \
      --enable-gpl \
      --enable-gnutls \
      --enable-libaom \
      --enable-libass \
      --enable-libfdk-aac \
      --enable-libfreetype \
      --enable-libmp3lame \
      --enable-libopus \
      --enable-libsvtav1 \
      --enable-libdav1d \
      --enable-libvorbis \
      --enable-libvpx \
      --enable-libx264 \
      --enable-libx265 \
      --enable-nonfree && \
  PATH="$HOME/bin:$PATH" make && \
  make install && \
  hash -r \
 && . ~/.profile \
 && apt autoremove -y
ENV PATH="/root/bin:/root/ffmpeg_build/bin:$PATH"
# && echo "export PATH=\"$HOME/bin:$PATH\"" >> ~/.bashrc