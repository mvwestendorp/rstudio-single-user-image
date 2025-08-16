# JupyterHub single user image
# Includes RStudio Server, odbc necessities
FROM quay.io/jupyter/datascience-notebook:hub-5.3.0

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        psmisc \
        libssl-dev \
        lsb-release \
        libclang-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
# install RStudio
RUN curl https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2025.05.1-513-amd64.deb > rstudio.deb && \
    if [[ $(sha256sum rstudio.deb) == "8e49ca68d154d5d17ae5fcc386e9c93473f9b73f6f573a1511866051e288b547  rstudio.deb" ]]; \
    then \ 
        dpkg -i rstudio.deb; \
    else \ 
        echo "ERROR: SHA mismatch!"; \
        exit 1; \
     fi
# install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

USER jovyan
RUN pip install --no-cache-dir git+https://github.com/jupyterhub/jupyter-rsession-proxy@5113f4572583bc2ba56aae951d02ec68e1a23841
RUN pip install --no-cache-dir git+https://github.com/betatim/vscode-binder@92789f55fb978c7be82ac3c5ea9989248b47353d
# RUN rstudio-server start
