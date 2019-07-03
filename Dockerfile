FROM bathmash/base-mathaltnotes-docker-build
RUN mkdir /home/mathaltuser
RUN mkdir /home/mathaltuser/MathAltNotes
COPY ./ /home/mathaltuser/MathAltNotes/
ENV HOME=/home/mathaltuser
WORKDIR /home/mathaltuser
CMD ["/home/mathaltuser/MathAltNotes/setuser.sh"]