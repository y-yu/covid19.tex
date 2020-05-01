FROM alpine:3.11

LABEL maintainer="Yoshimura Yuu <yyu [at] mental.poker>"

ENV TEXLIVE_DEPS \
    xz \
    tar \
    fontconfig-dev
    
ENV TEXLIVE_PATH /usr/local/texlive

ENV PERSISTENT_DEPS \
    wget \
    make \
    perl \
    ghostscript \
    bash \
    imagemagick \
    git

ENV PATH $TEXLIVE_PATH/bin/x86_64-linuxmusl:$PATH

RUN apk upgrade --update

# Install basic dependencies
RUN apk add --no-cache --virtual .persistent-deps $PERSISTENT_DEPS

# Set timezone to Tokyo
RUN apk --no-cache add tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    echo 'Asia/Tokyo' > /etc/timezone

# Install TeXLive
RUN apk add --no-cache --virtual .texlive-deps $TEXLIVE_DEPS && \
    mkdir /tmp/install-tl-unx && \
    wget -qO- http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | \
      tar -xz -C /tmp/install-tl-unx --strip-components=1 && \
    printf "%s\n" \
      "TEXDIR $TEXLIVE_PATH" \
      "selected_scheme scheme-small" \
      "option_doc 0" \
      "option_src 0" \
      > /tmp/install-tl-unx/texlive.profile && \
    /tmp/install-tl-unx/install-tl \
      -profile /tmp/install-tl-unx/texlive.profile

# Install TeX packages
RUN tlmgr install latexmk collection-luatex collection-fontsrecommended \
      standalone download pgfplots datetime2 tracklang && \
    luaotfload-tool -u -vvv && \
    apk del .texlive-deps

VOLUME ["/workdir"]

WORKDIR /workdir

ENTRYPOINT ["/bin/bash", "-c", "lualatex -shell-escape covid19.tex && convert -density 300 covid19.pdf covid19-%d.png"]
