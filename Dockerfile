FROM bathmash/base-mathaltnotes-docker-build
RUN mkdir MyLaTeX
RUN mkdir MathAltNotes
COPY ./ /MathAltNotes/
ENV HOME=/MyLaTeX
WORKDIR /MyLaTeX
