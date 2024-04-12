# USGSviewer

Autor: Jesús Jiménez

Linkedin: https://www.linkedin.com/in/jesusjimenezquijada/

Proyecto de prueba para vacante de "Software Development Engineer" en Frogmi

Nunca antes había trabajado con Ruby on Rails, lo encontré muy interesante 
y fue muy entretenido del desarrollo de este pequeño proyecto, aún cuando 
no resulte seleccionado, he de seguir aprendiendo a utilizar este framework.

El desarrollo se realizó con las siguientes tecnologías

* Backend Rails 7.1.3.2

* frontend Nodejs v18.19.0, @vue/cli 5.0.8

* Database SQLite 3.40.1

* SO Debian GNU/Linux 12 (bookworm)

* Docker version 26.0.0


Instrucciones:

- abrir terminal

- Clonar el proyecto $ git clone https://github.com/jesuez/USGSviewer.git

- Entrar en el directorio del proyecto $ cd USGSviewer

- Ejecutar $ docker compose up -d


Una vez ejecutados los pasos anteriores se habrán creado y estarán corriendo
dos contenedores de nombre frontend_container y backend_container los cuales
alojan la aplicación vue y la aplicación ror respectivamente, en este punto
las migraciones ya han sido ejecutadas sin embargo las tablas están vacías.

Ejecutar el comando $ docker exec -it backend_container bash, el cual abrirá
una terminal interactiva en el contenedor del backend, entoces se debe ejecutar
la tarea de recuperación de la información sísmica con el comando # rake earthquakes


Ahora se debe abrir en el navegador la dirección http://localhost:8080/
La api esta activa en http://localhost:3000/ y se pueden hacer consultas a la
misma mediante cURL, Postman o cualquier otra herramienta destinada a tal efecto.
Hay en la api 4 endpoints los cuales se explican a continuación:

* get 'api/features’
Devuelve la primera página de la lista de “features”(temblores),  el número por
defecto de registros es 50, este endpoint admite 3 parámetros opcionales que son,
number: el número de registros por página; page: el número de la página y finalmente
magtype: que son los tipos de magitud separados por guiones. El orden de los parámetros
es  como sigue: 'api/features/number/integer/page/integer/magtype/string’

este endpoint devuelve un objeto con el siguiente formato:

{
    "data": [
        {
            "id": 24,
            "type": "Feature",
            "attributes": {
                "external_id": "us7000mbqp",
                "magnitude": "5.8",
                "place": "114 km WNW of Kirakira, Solomon Islands",
                "time": "1712937558992",
                "tsunami": "0",
                "mag_type": "mww",
                "title": "M 5.8 - 114 km WNW of Kirakira, Solomon Islands",
                "coordinates": {
                    "longitude": "160.9221",
                    "latitude": "-10.1604"
                }
            },
            "links": {
                "external_url": "https://earthquake.usgs.gov/earthquakes/eventpage/us7000mbqp"
            }
        }
    ],
    "pagination": {
        "current_page": 1,
        "total": 149,
        "per_page": 1,
        "magtype": ["mww","mwr"],
        "mag_types": ["md", "ml", "mb", "mw", "mww", "mwr", "mb_lg", "mh"]
    }
}


* get '/api/features/:id'
Obtiene los datos de un temblor(feature) en particular, incluidos los comentarios
asociados, a partir del id del temblor, retorna un objeto con el siguiente formato:

{
    "data": {
        "id": 100,
        "type": "Feature",
        "attributes": {
            "external_id": "ak0244qg37nr",
            "magnitude": "1.6",
            "place": "29 km ESE of Skwentna, Alaska",
            "time": "1712903256712",
            "tsunami": "0",
            "mag_type": "ml",
            "title": "M 1.6 - 29 km ESE of Skwentna, Alaska",
            "coordinates": {
                "longitude": "-150.9008",
                "latitude": "61.858"
            }
        },
        "links": {
            "external_url": "https://earthquake.usgs.gov/earthquakes/eventpage/ak0244qg37nr"
        }
    },
    "comments": []
}


* put '/api/features/:id'
Actualiza la información de un temblor específico por su id, al no haberse especificado
que campos se podía o debía actualizar y por ser una operación destructiva, este endpoint
solo permite actualizar 23 campos con información arbitraria, los cuales son: el título,
la magnitud y el typo de magnitud.

Este endpoint recibe un objeto de la siguiente forma:

{
  "feature": {
            "external_id": "ak0244qg37nr",
            "magnitude": "ACTUALIZABLE",
            "place": "29 km ESE of Skwentna, Alaska",
            "time": "1712903256712",
            "tsunami": "0",
            "mag_type": "ACTUALIZABLE",
            "title": "ACTUALIZABLE",
            "coordinates": {
                "longitude": "-150.9008",
                "latitude": "61.858"
    }
  }
}

* post '/api/features/:id/comment/new'
Añade comentarios a los temblores, recibe un objeto como se describe a continuación
{
  "comment": {
    "body": "It's time to sake it."
  }
}

