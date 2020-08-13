from raspbian/stretch

COPY ./image/make-diskimage.sh /image/make-diskimage.sh

RUN /image/make-diskimage.sh
