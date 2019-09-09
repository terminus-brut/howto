FROM fedora:30
WORKDIR /howto
RUN dnf -y install asciidoc dia javapackages-tools m4 make python3-ansi2html
COPY . /howto
CMD ["make", "antora"]
