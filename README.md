# Historia de Usuario para el Examen de la Unidad II de Móviles II

## 1. Nombre del curso: 
Soluciones Móviles II

## 2. Nombre del alumno: 
Andree Sebastián Flores Meléndez

## 3. Fecha: 
21/10/2025

## 4. URL del repositorio Github: 
https://github.com/andresebast161616/SM2_EXAMEN_PRACTICO

## 5. Descripción del Proyecto:
PeruFest es una aplicación móvil desarrollada en Flutter que permite la gestión integral de eventos culturales, facilitando la interacción entre visitantes, expositores y administradores para fomentar el turismo y eventos

## 6. Historia de usuario:
Como usuario autenticado,
quiero ver un historial de mis inicios de sesión,
para saber cuándo y desde qué dispositivo accedí a mi cuenta.

## 7. Descripción breve de las funcionalidades implementadas (historia):

• **Registro automático de sesiones**: Al iniciar sesión exitosamente, se registra automáticamente el usuario, fecha/hora del inicio y dirección IP en Firebase Firestore.

• **Visualización del historial**: Nueva sección "Historial de Inicios de Sesión" accesible desde "Mi Perfil" que muestra una lista con usuario, fecha/hora de cada inicio de sesión e IP del dispositivo.

• **Ordenamiento cronológico**: Los registros se muestran ordenados del más reciente al más antiguo con interfaz visual intuitiva.

• **Actualización en tiempo real**: Uso de StreamBuilder para mostrar nuevas sesiones automáticamente sin necesidad de refrescar la pantalla.

## 8. Capturas de imágenes del APP como evidencia de las funcionalidades implementar:

Primero creamos nuestro índice, en mi caso con el nombre de "historial_sesiones_exaFloresM"

![Primero creamos nuestro índice, en mi caso con el nombre de "historial_sesiones_exaFloresM](capturas/1.png)

Después veremos que se a creado un campo con este nombre también en la base de datos, después crearemos nuestro archivos .dart para la funcionalidad que harán referencia a este campo

![Después veremos que se a creado un campo con este nombre también en la base de datos, después crearemos nuestro archivos .dart para la funcionalidad que harán referencia a este campo](capturas/2.png)

Ejecutamos nuestra aplicación paso a paso (iniciamos sesión, nos dirigimos al apartado de mi perfil, después a la parte de "historial de inicios de sesion" y ahí veremos el historial de sesiones registradas)

![Ejecutamos nuestra aplicación paso a paso](capturas/3.png)

registros en la base de datos:
![registros en la base de datos:"](capturas/4.png)