FROM mcr.microsoft.com/mssql/server:2022-latest

# Variables obligatorias de SQL Server
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=SYSSAE+2025

# Crear carpeta para scripts
USER root
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copiar la semilla corregida al contenedor
COPY Semilla.sql /usr/src/app/Semilla.sql

# Instalar mssql-tools (para usar sqlcmd dentro del contenedor)
RUN apt-get update \
    && apt-get install -y curl apt-transport-https gnupg \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list > /etc/apt/sources.list.d/msprod.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev \
    && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

# Exponer el puerto estándar de SQL Server
EXPOSE 1433

# Iniciar SQL Server y ejecutar la semilla
CMD /bin/bash -c "/opt/mssql/bin/sqlservr & \
    sleep 25 && \
    /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -i /usr/src/app/Semilla.sql && \
    tail -f /dev/null"
