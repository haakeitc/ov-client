from raspbian/stretch

COPY ./image/make-diskimage.sh /image/make-diskimage.sh

# RUN /image/make-diskimage.sh

RUN apt update
RUN apt upgrade --assume-yes
RUN apt install --assume-yes git zita-njbridge jackd2 liblo-dev nodejs libcurl4-openssl-dev build-essential libxml++2.6-dev libwebkit2gtk-4.0-dev libasound2-dev libboost-all-dev libcairomm-1.0-dev libeigen3-dev libfftw3-dev libfftw3-double3 libfftw3-single3 libgsl-dev libgtkmm-3.0-dev libgtksourceviewmm-3.0-dev libjack-jackd2-dev libltc-dev libmatio-dev libsndfile1-dev imagemagick libsamplerate0-dev

RUN cd /

# install TASCAR
RUN git clone https://github.com/gisogrimm/tascar.git
RUN cd tascar && make && make install 

RUN useradd -m -G audio,dialout ov

# get autorun file:
RUN rm -f autorun
RUN    wget https://github.com/gisogrimm/ov-client/raw/master/tools/pi/autorun
RUN    chmod a+x autorun

# update real-time priority priviledges:
RUN sed -i -e '/.audio.*rtprio/ d' -e '/.audio.*memlock/ d' /etc/security/limits.conf
RUN echo "@audio - rtprio 99"| tee -a /etc/security/limits.conf
RUN echo "@audio - memlock unlimited"| tee -a /etc/security/limits.conf

# register autorun script in /etc/rc.local:
RUN sed -i -e '/exit 0/ d' -e '/.*autorun.*autorun/ d' -i /etc/rc.local
RUN echo "test -x /home/pi/autorun && su -l pi /home/pi/autorun &"| tee -a /etc/rc.local
RUN echo "exit 0"| tee -a /etc/rc.local

# setup host name
RUN echo ovbox |  tee /etc/hostname
RUN sed -i "s/127.0.1.1.*raspberry/127.0.1.1\tovbox/g" /etc/hosts

# clone ovbox repo if not yet available:
RUN su -l ov -c "test -e ov-client || git clone http://github.com/gisogrimm/ov-client"
RUN su -l ov -c "make -C ov-client"

# activate overlay image to avoid damage of the SD card upon power off:
RUN raspi-config nonint enable_overlayfs


