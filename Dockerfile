# container for easy use
FROM ubuntu:18.04

ADD extract_pdf_notes.py /usr/bin/extract_pdf_notes
RUN apt update && \
    apt install --quiet -y --no-install-recommends python3-poppler-qt5 locales && \
    apt-get clean && \
    chmod a+x /usr/bin/extract_pdf_notes && \
    rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base && \
    locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
USER nobody
WORKDIR /notes
ENTRYPOINT ["/usr/bin/extract_pdf_notes"]
