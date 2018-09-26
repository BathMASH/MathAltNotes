FROM bathmash/base-mathaltnotes-docker-build
RUN groupadd -g 1001 mathaltuser
RUN useradd -r -u 1001 -g mathaltuser mathaltuser
RUN mkdir /home/mathaltuser
RUN mkdir /home/mathaltuser/MathAltNotes
COPY ./ /home/mathaltuser/MathAltNotes/
RUN chown -R mathaltuser:mathaltuser /home/mathaltuser/
USER mathaltuser
ENV HOME=/home/mathaltuser
WORKDIR /home/mathaltuser
