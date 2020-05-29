FROM alpine:latest

#add curl for better handling
RUN apk add --no-cache curl
RUN apk add linux-headers 
# Update & Install dependencies
RUN apk add --no-cache --update \
    git \
    bash \
    portaudio-dev \
    zlib-dev \
    libffi-dev \
    bzip2-dev \
    openssl-dev \
    readline-dev \
    sqlite-dev \
    build-base


# Set Python version
ARG PYTHON_VERSION='3.7.0'
RUN export PYTHON_VERSION
# Set pyenv home
ARG PYENV_HOME=/root/.pyenv
RUN export PYENV_HOME

# Install pyenv, then install python versions
RUN git clone --depth 1 https://github.com/pyenv/pyenv.git $PYENV_HOME && \
    rm -rfv $PYENV_HOME/.git

ENV PATH $PYENV_HOME/shims:$PYENV_HOME/bin:$PATH

RUN pyenv install $PYTHON_VERSION
RUN pyenv global $PYTHON_VERSION
RUN pip install --upgrade pip && pyenv rehash

# Clean
RUN rm -rf ~/.cache/pip

# Done python3.7 setup

# Install Audio Driver
#RUN apk add portaudio-dev
# Setup emby2jelly

## setup home folder
#RUN mkdir -p /root/.config/Emby2Jelly/ 
#ENV EMBY2JELLY_HOME=/root/.config/Emby2Jelly/
#ARG EMBY2JELLY_HOME=/root/.config/Emby2Jelly/
#RUN export EMBY2JELLY_HOME

#install ledfx    
#COPY requirements.txt $EMBY2JELLY_HOME/requirements.txt
RUN pip install cython && pip install ledfx

EXPOSE 8888

ENTRYPOINT ledfx --open-ui


