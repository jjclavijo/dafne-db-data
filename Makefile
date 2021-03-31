#* Datos GPS
#
#Se utilizan los productos que provee el laboratorio de geodesia de la universidad de nevada, Reno.
#
#CITE:
#Blewitt, G., W. C. Hammond, and C. Kreemer (2018), Harnessing the GPS data explosion for interdisciplinary science, Eos, 99, https://doi.org/10.1029/2018EO104623.
#
#La lista de estaciones disponibles puede bajarse directamente:
#

default: 
	@echo Visite http://geodesy.unr.edu antes de usar este makefile
	@echo Sea responsable y no sobrecargue de tráfico inutil la página

puntos-http.lonlath:
	-mkdir http-nevada-st_list
	cd http-nevada-st_list;\
	curl http://geodesy.unr.edu/NGLStationPages/GlobalStationList |\
	     sed -nE '/href.*sta/ {s/^.*\"(.*?)\">([^<>]*)<.*/\1 \2/p}' \
			 > Station_list;\
	curl http://geodesy.unr.edu/NGLStationPages/DataHoldings.txt \
		   -o Estaciones_http.tsv;\
	cat Estaciones_http.tsv | awk '{print $1,$3,$2,$4}' |\
	     tail -n +2 > $@


#Las estaciones se pueden bajar por http.
#
#Para inicializar el repositorio y poder armar datasets de entrenamiento bajamos todos los datos.

http-nevada:
	mkdir http-nevada

.PHONY: data
data: http-nevada
	curl http://geodesy.unr.edu/gps_timeseries/tenv3/IGS14/ -o parent.html
	# extraer todos los links disponibles.
	sed -nE '/href.*tenv/ {s/^.*href=\"([^<>]*)\">([^<>]*)<.*/http:\/\/geodesy.unr.edu\/gps_timeseries\/tenv3\/IGS14\/\1 \2/p}' parent.html | tail -n +2 > filelist
	# bajar los datos y guardarlos comprimidos con xz --Comprime mejor que Bz--.
	while read url fn;\
	do echo Bajando $$fn...;\
			if [ -f ${fn%%.*}.IGS14.tenv3.xz ];\
			then echo Ya existe el archivo;\
			else curl "$url" | xz > http-nevada/${fn%%.*}.IGS14.tenv3.xz;\
			fi;\
	done < filelist

#* Terremotos
#
#Conslutar la base de USGS es trivial, usamos el formato GEOJSON.
#

terremotos:
	mkdir terremotos

terremotos/5.5.pgdump: terremotos
	cd terremotos;\
	curl "https://earthquake.usgs.gov/fdsnws/event/1/query.geojson?starttime=1994-01-10%2000:00:00&endtime=2020-01-17%2023:59:59&minmagnitude=5.5&orderby=time" -o 5.5+.geojson;
	ogr2ogr -f PGDump terremotos/5.5+.pgdump terremotos/5.5+.geojson -nln usgs_sismos;
	ln -s terremotos/5.5+.pgdump $@

TAG:="jjclavijo/dafne-db"
VERSION:=data-21.01

.PHONY: docker-image
docker-image:
	docker build . -t ${TAG}:${VERSION}

