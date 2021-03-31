# Dafne-db data

## Repositorio para construir imagen docker con datos de http://geodesy.unr.edu

La imagen con los datos hasta el 17 de enero de 2021 está subida a Dockerhub en
mi usuario, con el tag data-21.01 en el repositorio

https://hub.docker.com/repository/docker/jjclavijo/dafne-db

La imagen es una imagen debian:buster-slim

Se le agregan en el directorio data/http-nevada los archivos .tenv3 descargados
para todas las estaciones.

También se agrega en el directorio data/terremotos un archivo gejson que
contiene los sismos mayores a 5.5 Mw hasta la fecha misma de los datos.

El makefile tiene todo lo necesario para descargar los datos:

```bash
make data
make terremotos/5.5.pgdump
```

Usar con cuidado, la descarga implica algunos GB, y no se debe cargar al
servidor sin motivo

## Cita a los datos:
Blewitt, G., W. C. Hammond, and C. Kreemer (2018), Harnessing the GPS data explosion for interdisciplinary science, Eos, 99, https://doi.org/10.1029/2018EO104623.
