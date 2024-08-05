# Scripts de Instalación de Oracle Forms & Reports 12.2

## El repositorio contiene 2 carpetas en su raíz:
  - install: esta carpeta contiene todos los scripts de instalación de binarios y parchado de los mismos, así como también los scrips de creación y configuración del dominio. Esta carpeta está pensada solo para existir durante el momento de isntalación y configuración del ambiente, y luego debe ser borrada.
  - init: esta carpeta contiene todos los scripts para iniciar y bajar el ambiente que se instaló previamente con los scripts de la carpeta anterior. La misma está pensada para permanecer en cada uno de los hosts donde se instaló el producto para la gestión y administración del mismo.

## Ambas carpetas poseen 2 archivos en común:
- environment.properties: contiene la configuración de variables del ambiente que son específicas para la consola WLST.
- SetEnvironmentVariables.sh: contiene la configuración de variables de entorno que son específicas para la consola del sistema operativo de la instalación.
La configuración de estos dos archivos difiere del momento de instalación ya que en la carpeta install contienen las contraseñas iniciales para configurar las password de los superusuarios, así como también de las wallets para java y el web server. En la carpeta de init, dicho contenido no se encuentra.
También estos 2 archivos, al ser los únicos que son diferentes por ambiente, son los únicos que difieren entre las diferentes ramas, además del archivo  install/passwordfile.txt que contiene las passwords del repositorio del RCU.

## INSTALACIÓN

# Supuestos:

La instalación del ambiente debe ser realizada sobre un sistema operativo Linux que cumpla con la certificación de Oracle para el producto Oracle Forms & Reports 12.2.1.19. Revisar la sección "Linux Operating System Requirements" de la guía de instalación del producto.
Para la instalación se requiere también de una base de datos de metadatos para la ejecución de la utilidad "Repository Creation Assistant (RCU)". La misma debe cumplir con los requisistos especificados en la sección "Database Requirements" de la guía de instalación del producto.

https://docs.oracle.com/en/middleware/developer-tools/forms/12.2.1.19/sysrs/system-requirements-and-specifications.html

Ejecute el siguiente script para crear el usuario en el Sistema Operativo. Si lo considera necesario, modifique el script para cambiarn nombre y/o grupos.
- [Creación del usuario del Sistema operativo (create_os_user.sh)](./install/create_os_user.sh)

# Configuración del entorno:
Configure el archivo de propiedades (environment.properties) y el script SetEnvironmentVariables.sh con los datos de instalación. [Consulte el Anexo I](./AnexoI.txt) para mayor detalle respecto al primero y el [Anexo II](./AnexoII.txt) para el segundo.

# Ejecución de los scripts de instalación:

- [Ejecute el script de creación del repositorio de metadatos create_repository.sh](./install/create_repository.sh)
Este script realiza la creación del repositorio de metadatos con la herramienta del RCU. Consulte los prerrequisitos que debe cumplir la base de datos del repositorio en la documentación del producto mencionada más arriba.

- [Ejecute el script de creación Dominio de Weblogic create_basic_domain.sh](./install/create_basic_domain.sh)
  El script de creación del dominio crea todos los componentes del dominio de weblogic, como servidores manejados, machines y nodemanagers, y los componentes de forms.

- [Inicie el Nodemanager del AdminServer startAdmNM.sh](./init/startAdmNM.sh)
  Este script inicia el manejador del AdminServer para poder configurarlo posteriormente.

- [Ejecute el script de creación de los keyfiles para los usuarios administrativos create_key_files.sh](./install/create_key_files.sh)
  Este script crea el "config file" y el "key file" que permite a los scripts de configuración y de inicio de todos los componentes conectarse al dominio sin la necesidad de proporcionar una contraseña.

- [Inicie el AdminServer startAdmin.sh](./init/startAdmin.sh)

- [Ejecute el script de configuación del modo seguro SSL configure_ssl.sh](./install/configure_ssl.sh)
  Este script configura el modo seguro para todos los componentes del dominio. Esto es necesario para cumplimentar las normativas de seguridad de la gran mayoría de los ambientes, además que permite ejecutar y descargar en modo seguro los componentes ejecutables (como arhivos .jar, ddl, etc) que se requieren del lado del cliente. Antes de ejecutar este script, debe crear los certificados y la JKS que se utilizará para la configuración del SSL. Ante cualquier duda, consulte el [Anexo III](./AnexoIII.txt).

- Activar JRF template para los clusters desde el EM
Ingrese a la consola del Enterprise Manager (https://<URL del AdminServer>:<puerto>/em) y active el JRF en los clusters de Forms y Reports de manera tal que puedan ser monitoreados en la consola administrativa.

- [Baje el AdminServer stopAdmin.sh](./init/stopAdmin.sh)

- [Ralice el empaquetamiento del Dominio del AdminServer pack_domain.sh](./install/pack_domain.sh), y luego, por cada uno de los servidores del cluster desempaquete el dominio en los nodos locales [ejecutando el script](./install/unpack_local_domain.sh)

- En cada uno de los nodos, [inicie el Nodemanager stopAdmin.sh](./init/stopAdmin.sh)

- [Inicie el resto de los componentes startAll.sh](./init/startAll.sh)
  
- Si aplica, [inicie los webservers startAllOHS.sh](./init/startAllOHS.sh)


Aclaración:
- Una vez finalizado el procedimiento de instalación, los archivos environment.properties y SetEnvironmentVariables.sh del directorio de instalación (install) deben ser eliminados ya que poseen contraseñas en texto plano. Es posible también eliminar la carpeta completa, ya que solo se requiere de la carpeta init para administrar los componentes del dominio instalado. Los archivos homónimos de la carpeta init, por el contrario, deben ser guardados.

# Descripción de los scripts de Inicio/Bajado del ambiente:

- [startAdmNM.sh](./init/startAdmNM.sh): Inicia el Nodemanager del AdminServer. El mismo debería ir en el nodo donde se desea que corra el AdminServer o asociado a la IP flotante del mismo.
- [stopAdmNM.sh](./init/stopAdmNM.sh): Baja el NodeManager del AdminServer. Solo debe ejecutarse una vez bajado el AdminServer en el equipo donde se encuentra corriendo.
- [startAdmin.sh](./init/startAdmin.sh): Inicia el AdminServer en el nodo donde se ejecuta. Debe estar previamente iniciado el NodeManager con el script startAdmNm.sh
- [startNM.sh](./init/startNM.sh): Inicia el Nodemanager del nodo local, que administra y monitorea los componentes locales del nodo donde se encuentra corriendo.
- [stopNM.sh](./init/stopNM.sh): Baja el Nodemanager del nodo local.
- [startAll.sh](./init/startAll.sh): Inicia todos los servers (servidores manejados) del dominio. Este script se conecta al AdminServer y solo inicia aquellos servidores que no se encuentran corriendo.
- [startNMAllNodes.sh](./init/startNMAllNodes.sh): Inicia los NodeManagers en todos los equipos del ambiente. Este script requiere que se encuentre configurado el parámetro p_servers con el listado separado por comas de todos los nodos del cluster y además debe poder conectarse de manera segura y sin contraseña por ssh a todos dichos nodos.
- [startOHS.sh](./init/startOHS.sh): Inicia el Oracle Http Server (OHS) del nodo local. Es necesario que se haya iniciado previamente el NodeManager del nodo local.
- [stopOHS.sh](./init/stopOHS.sh): Baja el Oracle Http Server (OHS) del nodo local.
- [startAllOHS.sh](./init/startAllOHS.sh): Inicia todos los OHS (web servers) del dominio. Este script se conecta al AdminServer y solo inicia aquellos web servers que no se encuentran corriendo. Es necesario que se hayan iniciado los NodeManagers locales en todos los hosts del cluster.
- [stopAllOHS.sh](./init/stopAllOHS.sh): Baja todos los OHS (web servers) del dominio.
- [startFyR.sh](./init/startFyR.sh): Inicia todos los servers (servidores manejados) del dominio local, es decir, aquellos administrados por el NodeManager que se encuentra corriendo en el nodo local. Este script se conecta al NodeManager y puede utilizarse para iniciar componentes locales cuando por ejemplo el AdminServer está caído.
- [stopFyR.sh](./init/stopFyR.sh): Baja todos los servers (servidores manejados) del dominio local, es decir, aquellos administrados por el NodeManager local.
