# Buscador-de-Labs
Script Bash orientado a ciberseguridad para consultar información de máquinas de HackTheBox utilizando el archivo `bundle.js`. Permite búsquedas por nombre, IP, dificultad, sistema operativo, skill o enlace de resolución, además de actualizar automáticamente la base de datos local.

---

# Propósito
El objetivo del repositorio es mostrar un script técnico que automatiza la consulta de características de máquinas HackTheBox. Su uso es útil en workflows de pentesting, preparación de certificaciones o gestión de laboratorios personales.

---

# Lista de scripts
| Archivo | Qué hace | Problema que resuelve | Casos de uso |
|--------|----------|------------------------|--------------|
| `htb_query.sh` | Consulta máquinas HackTheBox desde `bundle.js`, permite actualizar la base de datos y filtrar por distintos criterios | Evita búsquedas manuales dentro del bundle oficial y permite obtener información de forma directa y organizada | Preparación de labs HTB, documentación de máquinas, automatización en procesos de estudio |

---

# Descripción detallada del script

## `htb_query.sh`

### Función principal
Automatiza la consulta de datos de máquinas HackTheBox. Trabaja sobre el archivo `bundle.js` alojado en `https://htbmachines.github.io/bundle.js`, permitiendo buscar:

- Nombre de máquina  
- IP  
- Enlace a resolución en YouTube  
- Nivel de dificultad  
- Sistema operativo  
- Skill asociada  
- Filtrado combinado por sistema operativo + dificultad  
- Actualización automática del dataset

---

## Componentes del script

### Panel de ayuda (`helpPanel`)
Muestra los parámetros disponibles para la ejecución, incluyendo todos los modos de consulta.

### Actualización de archivos (`updatefiles`)
Descarga o renueva `bundle.js`. Compara hashes MD5 para determinar si existen cambios.

### Búsquedas por parámetro
- `searchMachin`: información completa por nombre.  
- `searchIP`: devuelve la máquina asociada a una IP.  
- `getLink`: obtiene el enlace de la resolución en YouTube.  
- `searchDifficultyMachin`: filtra por dificultad.  
- `searchOperativeSystem`: filtra por sistema operativo.  
- `getOsDifficulty`: combina dificultad + SO.  
- `searchSkill`: filtra por skill incluida en la máquina.

### Gestión de señales
Controla `CTRL+C` para salir limpiamente.

---

# Requisitos
- `bash` >= 4  
- `curl`  
- `md5sum`  
- `js-beautify`  
- `column`  
- Conexión a Internet para descargas y actualizaciones  
- Permisos de lectura/escritura en el directorio donde se genera `bundle.js`

---


