FROM mcr.microsoft.com/mssql/server:2022-latest

# Variables de entorno requeridas por SQL Server
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=SYSSAE+2025

# Crear carpeta para scripts
USER root
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copiar la semilla al contenedor
COPY Semilla.sql /usr/src/app/Semilla.sql

# Exponer el puerto estándar de SQL Server
EXPOSE 1433

# Script de arranque: levanta SQL Server y ejecuta la semilla
CMD /bin/bash -c "/opt/mssql/bin/sqlservr & \
    sleep 20 && \
    /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -i /usr/src/app/Semilla.sql && \
    tail -f /dev/null"
