FROM bathmash/base-mathaltnotes-docker-build:v18.04-pandoc2.7.3
RUN mkdir /home/mathaltuser
RUN mkdir /home/mathaltuser/MathAltNotes
COPY ./ /home/mathaltuser/MathAltNotes/
ENV HOME=/home/mathaltuser
WORKDIR /home/mathaltuser
CMD ["/home/mathaltuser/MathAltNotes/setuser.sh"]