FROM bathmash/base-mathaltnotes-docker-build

RUN mkdir MyLaTeX
RUN mkdir MathAltNotes
COPY ./ /MathAltNotes/
ENV HOME=/MyLaTeX
ENV SHELL=/bin/bash
VOLUME /MyLaTeX
WORKDIR /MyLaTeX
