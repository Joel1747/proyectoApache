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
Esta es la prueba del index.html del sitio1
![Foto html](https://github.com/Joel1747/proyectoApache/blob/master/capturas/Prueba_sitio1.png)
### Prueba Sitio 2
Esta es la prueba del index.php del Sitio2
![Foto PHP](https://github.com/Joel1747/proyectoApache/blob/master/capturas/pruebasitio2.png)

## Añadir el servidor _DNS_ a nuestro servidor _APACHE_

Como ya vimos en practicas anteriores para montar el servidor _DNS_ tendremos que modificar el fichero _docker-compose.yml_ crear una carpera que contenga la subcarperta de _confg_ y también la de _zonas_

### Fichero docker-compose.yml
Al añadir el servidor _DNS_  y un cliente _Alpine_ nuestro fichero pasrá a quedar de la siguente manera:
~~~
version: "3.9" 
services:
    asir_php:
      ports:
        - '80:80'
        - '8000:8000'
      container_name: asir_my-apache-php-app
      volumes:
          - '/home/asir2a/Documentos/SRI/proyectoApache/html:/var/www/html'
          - ./confApache:/etc/apache2
      image: 'php:7.4-apache'
      networks:
        bind9_subnetPA:
          ipv4_address: 10.1.2.250 #ip fija del servidor DNS
    bind9:
      container_name: asir2_bind9_pa
      image: internetsystemsconsortium/bind9:9.16
      ports:
        - 5401:53/udp
        - 5401:53/tcp
      networks:
        bind9_subnetPA:
          ipv4_address: 10.1.2.254 #ip fija del servidor DNS
      volumes:
        - /home/asir2a/Documentos/SRI/proyectoApache/confDNS/confg:/etc/bind
        - /home/asir2a/Documentos/SRI/proyectoApache/confDNS/zonas:/var/lib/bind
    asir_clientePA: 
      container_name: asir_clientePA
      image: alpine
      networks:
        - bind9_subnetPA
      stdin_open: true
      tty: true
      dns:
        - 10.1.2.254
networks:
    bind9_subnetPA:
      external: true   
~~~
### Carpeta _Confg_
Esta carpeta contendrá tres ficheros que serán los siguetes:
-_named.conf_
-_named.conf.options(configuración forwardes)_
-_named.conf.local_

#### _named.conf_
En este fichero se hace referencia a los otros dos ficheros que contendrán la configuración:
~~~
include "/etc/bind/named.conf.options";
include "/etc/bind/named.conf.local";
~~~

#### _named.conf.options(configuración forwardes)_
Tendremos que crear el fichero named.conf.options en el cual tendremos un código parecido a este segun las opciones que neceitemos
~~~
options {
        directory "/var/cache/bind";

        forwarders {
            8.8.8.8;
            8.8.4.4; 
        };
        forward only;

        listen-on { any; };
        listen-on-v6 { any; };
        allow-query {
            any;
        };

        allow-recursion {
                none;
        };
        allow-transfer {
                none;
        };
        allow-update {
                none;
        };
};
~~~

#### _named.conf.local_
Tendremos que crear el fichero named.conf.local en el cual tendremos un código parecido a este donde haremos referencia a la zona
~~~
zone "fabulas.com." {
        type master;
        file "/var/lib/bind/db.fabulas.com";
        notify explicit;
        allow-query {
            any;
        };
};
~~~

### Carpeta _Zonas_
En el directorio zonas solo crearemos un archivo que será el nombre de la zona en este caso db.fabulas.com en el cual habrá el siguiente código:
~~~
$TTL    36000
@       IN      SOA     ns.fabulas.com. joel.danielcastelao.org. (
                     16112022           ; Serial
                         3600           ; Refresh [1h]
                          600           ; Retry   [10m]
                        86400           ; Expire  [1d]
                          600 )         ; Negative Cache TTL [1h]
;
@       IN      NS     ns.fabulas.com.  
ns      IN      A      10.1.2.254
oscuras    IN      A      10.1.2.250 
maravillosas   IN      CNAME  oscuras   
~~~
### ficheros _sites-avaliables_
tendremos que cambiar en los ficheros _000-default.conf_ y _002-default.conf_ el serverName para que nos lleve a los _index_ de nuestros dos sitios y al hacer el _wget_ nos descargue el correspodinete fichero. tendremos que cambiar la siguinete linea:
#### _000-default.conf_
realizar lo mismo para el _002-default.conf_
~~~
<VirtualHost *:80>
	# The ServerName directive sets the request scheme, hostname and port that
	# the server uses to identify itself. This is used when creating
	# redirection URLs. In the context of virtual hosts, the ServerName
	# specifies what hostname must appear in the request's Host: header to
	# match this virtual host. For the default virtual host (this file) this
	# value is not decisive as it is used as a last resort host regardless.
	# However, you must set it for any further virtual host explicitly.
	ServerName oscuras.fabulas.com #habilitar esta linea y cambiar la direción en este caso a oscuras

	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/html/Sitio1

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
## Una vez añadido todo esto no hay que olvidarse de crear la _Red_ para que todo esto funcione, la cual crearemos con el siguiente comando:
~~~
docker network create --subnet 10.1.2.0/24 --gateway 10.1.2.1 bind9_subnetPA
~~~
## Prueba de funcionamento
Una vez realizadas todas estas configuraciones anteriores ya solo nos queda conectarnos al cliente alpine que tenemos incorporado y realizar los correspondientes _pings_ para ver si resuelve los nombres de las zonas

### Prueba Sitio 1
Esta es la prueba del _ping_ a maravillosas.fabulas.com y que resuelve correctamente
![Foto oscuras](https://github.com/Joel1747/proyectoApache/blob/master/capturas/oscuras.png)
![Foto oscuras2](https://github.com/Joel1747/proyectoApache/blob/master/capturas/oscuras2.png)
### Prueba Sitio 2
Esta es la prueba del _ping_ a maravillosas.fabulas.com y que resuelve correctamente
![Foto maravillosas](https://github.com/Joel1747/proyectoApache/blob/master/capturas/maravillosas.png)
![Foto maravillosas2](https://github.com/Joel1747/proyectoApache/blob/master/capturas/maravillosas2.png)

## Uso del _directoryIndex_ 
Sirver para elegir en nuestros _virtualhosts_ para que seleccionemos que fichero queremos que aparezca primero, en vez del _index_ que se muestra por defecto, hay un fichero para cambiarlo que es _dir.conf_ que aplica para todo los _virtualhost_, o bien como en este caso podemos configurarlo dentro de los propios _virtualhost_ 
~~~
<VirtualHost *:80>
	# The ServerName directive sets the request scheme, hostname and port that
	# the server uses to identify itself. This is used when creating
	# redirection URLs. In the context of virtual hosts, the ServerName
	# specifies what hostname must appear in the request's Host: header to
	# match this virtual host. For the default virtual host (this file) this
	# value is not decisive as it is used as a last resort host regardless.
	# However, you must set it for any further virtual host explicitly.
	ServerName maravillosas.fabulas.com

	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/html/sitio2

  #las lineas de a continuación seran las que cambien lo que muestre por defecto
	<Directory "/var/www/html/sitio2">
		DirectoryIndex patata2.html
	</Directory>

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


## Creación de un _sitioSSL_ 
Vamos a crear un sitio que sea seguro para el cual necesitamos un fichero SSL, en sites avaliable encontraremos _default-ssl.conf_ que es un sitio ssl ya creado el cual podremos modificar, tenemos que acordarnos de en el fichero _portss.conf_ asegurarnos de que escuche el puerto 443
### fichero _ports_
como podemos observar solo escucha en el puerto 443 si esta en _enable_ el modulo _SSL_ 
~~~
Listen 80
Listen 8000 

<IfModule ssl_module>
	Listen 443
</IfModule>

<IfModule mod_gnutls.c>
	Listen 443
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
~~~
### Habilitar modulo ssl
Para esto necesitaremos levantar el servidor y abrirlo con el visual en este caso, en el cual nos dará un terminal con root en el servidor el en cual tendremos que aplicar los siguentes comandos tanto para habilitar el _moduloSSL_ y el _sitioSSL_
#### Comando habilitar _moduloSSL_
~~~
a2enmod ssl
~~~
#### Comando habilitar _sitioSSL_
~~~
a2ensite default-ssl
~~~

Una vez hecho esto tenemos que crear un certificado ssl para nuestro sitio web, lo crearemos de la sigunete manera:
#### Creación certificado
debemos instalar el openssl si no lo tenemos
~~~
apt-get update
apt-get install apache2 openssl
~~~
~~~
a2enmod ssl
a2enmod rewrite
~~~
Tenemos que agragarle la siguinete linea al fichero _apache2.conf_ 
~~~
<Directory /var/www/html>
AllowOverride All
</Directory>
~~~
Y ya solo queda crear el certificado con las sigunetes lineas:
~~~
mkdir /etc/apache2/certificate
cd /etc/apache2/certificate
openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out apache-certificate.crt -keyout apache.key
~~~
####  _default-ssl.conf_
Una vez creado el certificado iremos a nuestro fichero _default-ssl.conf_ en el cual pondremos el siguente código:
~~~
<VirtualHost *:443>
		#ServerAdmin segura.fabulas.com
		DocumentRoot /var/www/html/sitioSSL
		ErrorLog ${APACHE_LOG_DIR}/error.log
		CustomLog ${APACHE_LOG_DIR}/access.log combined
		SSLEngine on
		SSLCertificateFile	/etc/apache2/certificate/apache-certificate.crt
		SSLCertificateKeyFile /etc/apache2/apache.key
		
	</VirtualHost>
~~~
Una vez configurado este fichero ya solo nos queda reiniciar el servidor apache para que se aplique la configuración que hemos colocado.

### Comprobación SSL
Ya solo nos queda entar al navegador en este caso firefox y comprobar que podemos acceder a nuestro sitio seguro.
![Foto maravillosas2](https://github.com/Joel1747/proyectoApache/blob/master/capturas/maravillosas2.png)