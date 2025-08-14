# JupyterHub single user image
# Includes RStudio Server, mssql odbc necessities
FROM quay.io/jupyter/datascience-notebook:hub-5.3.0

USER root

RUN apt-get update && \
    apt-get install psmisc libapparmor1 lsb-release libclang-dev libpq5 postgresql-client libpq-dev unixodbc-dev gnupg2 krb5-user default-jdk -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
# install RStudio
RUN curl https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2025.05.1-513-amd64.deb > rstudio.deb && \
    dpkg -i rstudio.deb
# install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

USER jovyan
RUN pip install --no-cache-dir git+https://github.com/jupyterhub/jupyter-rsession-proxy@5113f4572583bc2ba56aae951d02ec68e1a23841
RUN pip install --no-cache-dir git+https://github.com/betatim/vscode-binder@92789f55fb978c7be82ac3c5ea9989248b47353d
# RUN rstudio-server start
