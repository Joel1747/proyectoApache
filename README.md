# proyecto Apache
Queremos levantar un servidor de apache que admita php para ello necesitaremos un archivo _Docker-compose_ y una carpeta _html_(donde guardaremos los html y php)
## Fichero _Docker-compose_
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

## Configuración de sitios
despues de haber probado todo esto vamos a pasar los ficheros a sus sitios correspondientes, en el que cada sitio tendra su propio archivo de configuración, su puerto propio y sus ficheros correspondientes. Para esto tocaremos los ficheros: _ports.conf_, el _docker-compose_, en la carpeta _sites-avaliables_ los ficheros para nuestros sitios.

### fichero _ports.conf_
Aqui añadiremos los puertos que usaremos y queremos que escuche en dichos puertos, el fichero quedará de la siguiente manera:
~~~
Listen 80
Listen 8000 #hemos añadido esta linea a mas para el sitio2

<IfModule ssl_module>
	Listen 443
</IfModule>

<IfModule mod_gnutls.c>
	Listen 443
</IfModule>

~~~
 ### fichero _docker-compose_ 
 Añadiremos el puerto 8000 que pasaremos a usar para el _sitio2_
~~~
version: "3.9" 
services:
    asir_php:
        ports:
          - '80:80'
          - '8000:8000' #puerto para el sitio2
        container_name: asir_my-apache-php-app
        volumes:
           - '/home/asir2a/Documentos/SRI/proyectoApache/html:/var/www/html'
           - ./confApache:/etc/apache2
        image: 'php:7.4-apache'
~~~

### Carpeta de _sites-avaliables_ 
Dentro nos encontraremos un fichero que se llama _000-default.conf_ que trae la configuración del sitio por defecto, en nuestro caso este fichero pasará a ser el fichero del sitio1 por lo tanto cambiaremos la configuración de este para que quede de la siguiente manera:
#### _000-default.conf_
~~~
<VirtualHost *:80>
	# The ServerName directive sets the request scheme, hostname and port that
	# the server uses to identify itself. This is used when creating
	# redirection URLs. In the context of virtual hosts, the ServerName
	# specifies what hostname must appear in the request's Host: header to
	# match this virtual host. For the default virtual host (this file) this
	# value is not decisive as it is used as a last resort host regardless.
	# However, you must set it for any further virtual host explicitly.
	#ServerName www.example.com

	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/html/Sitio1 #aqui mapeamos a que busque el fichero index.html/php en la carpeta del sitio1

	# Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
	# error, crit, alert, emerg.
	# It is also possible to configure the loglevel for particular
	# modules, e.g.
	#LogLevel info ssl:warn

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined

	# For most configuration files from conf-available/, which are
	# enabled or disabled at a global level, it is possible to
	# include a line for only one particular virtual host. For example the
	# following line enables the CGI configuration for this host only
	# after it has been globally disabled with "a2disconf".
	#Include conf-available/serve-cgi-bin.conf
</VirtualHost>
~~~
#### _002-default.conf_
Este va a ser el fichero de configuración de nuestro _sitio2_ 
~~~
<VirtualHost *:8000>#y aqui le cambiamos el puerto para que pase a usar el 8000
	# The ServerName directive sets the request scheme, hostname and port that
	# the server uses to identify itself. This is used when creating
	# redirection URLs. In the context of virtual hosts, the ServerName
	# specifies what hostname must appear in the request's Host: header to
	# match this virtual host. For the default virtual host (this file) this
	# value is not decisive as it is used as a last resort host regardless.
	# However, you must set it for any further virtual host explicitly.
	#ServerName www.example.com

	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/html/sitio2 #mapeamos a la carpeta del Sitio2

	# Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
	# error, crit, alert, emerg.
	# It is also possible to configure the loglevel for particular
	# modules, e.g.
	#LogLevel info ssl:warn

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined

	# For most configuration files from conf-available/, which are
	# enabled or disabled at a global level, it is possible to
	# include a line for only one particular virtual host. For example the
	# following line enables the CGI configuration for this host only
	# after it has been globally disabled with "a2disconf".
	#Include conf-available/serve-cgi-bin.conf
</VirtualHost>
~~~

### Carpeta de _sites-enabled_
Una vez hayamos realizado todo esto pasaremos a la carpeta de _sites-enabled_ que contiene los ficheros de configuración de nuestros sitios en uso en la cual tendremos los ficheros de la carpeta _sites-avaliables_ que queremos usar.

Para hacer que los ficheros de _sites-avaliables_ pasen a estar en la carpeta de _sites-enabled_ tambien tendremos que levantar nuestro servicio, y realizarle un _attach shell_ para que nos abra la terminal de nuesto servidor, en la terminal realizaremos el siguente comando _a2ensite [nombre del fichero de conf]_ que queremos que pase a estar _enabled_ , una vez hecho el esto nos dirá que reiniciemos el servicio, como podremos ver en la carpeta de _sites-enabled_ pasaran a estar los ficheros a los que realizamos el comando.

## Prueba funcionamiento
Una vez reinicado el servicio podremos comprobar si funciona correctamente nuestros sitios, para ello buscaremos localhost:y los puertos configurados.

### Prueba Sitio 1

