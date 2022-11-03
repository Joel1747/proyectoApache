# proyecto Apache
Queremos levantar un servidor de apache que admita php para ello necesitaremos un archivo _Docker-compose_ y una carpeta _html_(donde guardaremos los html y php)
## Ficehero _Docker-compose_
Para nuestro sevidor necesitamos un servicio de apache que nos permita usar ficheros php, en _docker-hub_ encontraremos lo qe necesitemos, en este caso tenemos que pasar la siguente linea al fichero _Docker-compose_:
~~~
docker run -d -p 80:80 --name my-apache-php-app -v "$PWD":/var/www/html php:7.2-apache
~~~
Y en el fichero _Docker-compose_ quedará de la siguente manera:
~~~
version: "3.9" 
services:
    asir_php:
        ports:
          - '80:80'
        container_name: Asir_my-apache-php-app
        volumes:
           - '/home/asir2a/Documentos/SRI/proapa/html:/var/www/html'
        image: 'php:7.4-apache'
~~~
En el apartado de _Volumenes_ tendremos que mapear la ruta de nuestra carpera _html_(donde guardaremos nuestros ficheros) con el _:/var/www/html_ del servidor para que vaya a buscar los ficheros a dicha carpeta.

Con esto solo nos quedaría levantar nuestro servicio y comprobar que todo funciona correctamente añadiendo un html y un php a la carpeta.

## Prueba de funcionamiento
### Pueba fichero html
### Prueba fichero PHP
![Foto html](https://github.com/Joel1747/proyectoApache/blob/master/capturas/Captura%20de%20pantalla%20de%202022-11-03%2016-15-31.png)
### Prueba fichero PHP
![Foto php](https://github.com/Joel1747/proyectoApache/blob/master/capturas/Captura%20de%20pantalla%20de%202022-11-03%2016-14-47.png)

