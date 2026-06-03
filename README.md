🐄 Gestión Ganadera - Proyecto Finca La Rosa
Sistema integral de gestión ganadera desarrollado para automatizar y optimizar el control administrativo, productivo y sanitario de una finca. Este proyecto permite llevar un registro detallado de los bovinos, la producción láctea, los lotes de producción y el historial clínico de los animales.

🛠 Tecnologías Utilizadas
Lenguaje: Java

Arquitectura: MVC (Model-View-Controller)

Servidor Web: Apache Tomcat 11.0

Base de Datos: PostgreSQL (alojado en Supabase)

Gestión de Dependencias: Apache Maven

Frontend: HTML5, Bootstrap 5.3, CSS3, JavaScript

Control de Versiones: Git

📋 Funcionalidades Principales
CRUD de Bovinos: Registro, edición, eliminación y visualización completa del inventario (Hato Lechero y Lote para Venta).

Gestión de Imágenes Dinámica: Subida de fotografías de bovinos con nombre único generado mediante UUID y aretes, asegurando persistencia de datos.

Historial Médico: Registro de eventos médicos (vacunas, enfermedades, controles) vinculados al historial de cada bovino.

Control de Producción: Registro de ordeños diarios y cálculo automático de stock.

Gestión de Lotes: Producción y transformación de leche cruda a productos lácteos (quesos, etc.).

Autenticación: Sistema de usuarios con roles y gestión de sesiones.

🚀 Instalación y Configuración
Clonar el repositorio:

Bash
git clone [URL_DE_TU_REPOSITORIO]
cd gestion-ganadera

2. **Base de Datos:**
   * Asegúrate de tener una base de datos PostgreSQL activa.
   * Configura las credenciales de conexión en `src/main/java/com/finca/utils/DbConnection.java`.

3. **Compilación:**
   ```bash
mvn clean install
Despliegue:

Despliega el archivo .war generado en la carpeta target/ en tu servidor Tomcat.

📁 Estructura del Proyecto
/src/main/java/com/finca/controllers: Controladores (Servlets) de la aplicación.

/src/main/java/com/finca/dao: Objetos de Acceso a Datos para las consultas SQL.

/src/main/java/com/finca/models: Clases POJO representando las entidades (Bovino, Usuario, etc.).

/src/main/webapp: Vistas JSP y recursos estáticos.

/uploads: Carpeta de almacenamiento persistente para imágenes de los bovinos.

👤 Autor
Ángel - [Aprendiz ADSO - SENA]