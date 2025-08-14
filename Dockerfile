# JupyterHub single user image
# Includes RStudio Server, mssql odbc necessities
FROM quay.io/jupyter/datascience-notebook:hub-5.3.0

USER root
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb && \
    dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb
RUN apt-get update && \
    apt-get install psmisc libapparmor1 lsb-release libclang-dev libpq5 postgresql-client libpq-dev unixodbc-dev gnupg2 krb5-user default-jdk -y && \
RUN curl https://download2.rstudio.org/server/focal/amd64/rstudio-server-2025.05.1-513-amd64.deb > rstudio.deb && \
    dpkg -i rstudio.deb
# install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg
RUN curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18
RUN ACCEPT_EULA=Y apt-get install -y mssql-tools18
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN R -e "install.packages(c('odbc', 'sparklyr'), dependencies=TRUE, repos='http://cran.rstudio.com/')"
COPY krb5.conf /etc/krb5.conf
COPY hosts /etc/hosts
USER jovyan
RUN pip install --no-cache-dir git+https://github.com/betatim/vscode-binder@92789f55fb978c7be82ac3c5ea9989248b47353d
# RUN rstudio-server start
