FROM bathmash/base-mathaltnotes-docker-build
RUN groupadd -g 999 mathaltuser && \
    useradd -r -u 999 -g mathaltuser mathaltuser
USER appuser
RUN mkdir MyLaTeX
RUN mkdir MathAltNotes
COPY ./ /MathAltNotes/
ENV HOME=/MyLaTeX
WORKDIR /MyLaTeX
