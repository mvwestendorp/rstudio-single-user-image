# JupyterHub single user image
# Includes RStudio Server, mssql odbc necessities
FROM jupyter/datascience-notebook:hub-4.0.2

USER root
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb && \
    dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb
RUN apt-get update && \
    apt-get install psmisc libapparmor1 lsb-release libclang-dev libpq5 postgresql-client libpq-dev unixodbc-dev gnupg2 krb5-user default-jdk -y && \
    wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2023.09.0-463-amd64.deb && \
    dpkg -i rstudio-server-2023.09.0-463-amd64.deb
    # Add SQL Server ODBC Driver 17 for Ubuntu 22.04
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
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
RUN pip install --no-cache-dir git+https://github.com/jupyterhub/jupyter-rsession-proxy@d1f04108fc7aa689e34aa9d93192f2ed6a997faa
# RUN rstudio-server start
