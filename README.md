<div align="center">
  <img src="https://img.shields.io/badge/Gestión-Ganadera-464704?style=for-the-badge&logo=codeigniter&logoColor=white" alt="Logo Finca La Rosa">
  <h1>🐄 Finca La Rosa | Sistema de Gestión Ganadera</h1>
  <p>
    <em>Plataforma web integral para la administración inteligente de hatos lecheros y producción de lácteos.</em>
  </p>

  ![Java](https://img.shields.io/badge/Java_21-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
  ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
  ![Bootstrap](https://img.shields.io/badge/Bootstrap_5.3-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white)
  ![Tomcat](https://img.shields.io/badge/Apache_Tomcat_11-F8DC75?style=for-the-badge&logo=apache-tomcat&logoColor=black)
</div>

<hr>

Bienvenido al repositorio oficial del sistema central de **Finca La Rosa**, ubicada orgullosamente en **Santa Rosa de Viterbo, Boyacá, Colombia**. Este proyecto está diseñado para revolucionar el control ganadero local mediante una interfaz web moderna, automatización de procesos biológicos e integración profunda entre el hato lechero y la fábrica de productos lácteos.

## ✨ Novedades Recientes

- 🌙 **Modo Oscuro Global:** Interfaz completamente adaptable que reduce la fatiga visual con tonos oscuros elegantes (`#121212`, `#1e1e1e`) y acentos corporativos verdes/marrones.
- 📄 **Generación de PDFs Premium:** Exportación inteligente de inventarios, historias clínicas y comprobantes de asistencia, ocultando datos internos (IDs) y aplicando colores de la marca.
- 📱 **Control de Acceso por QR:** Generación de gafetes con código QR para empleados y lectura integrada a través de la cámara para registro de asistencias.

---

## 🚀 Características Principales

### 🐄 Inventario Ganadero Inteligente
*   **Gestión Integral:** Alta, edición, perfilamiento y baja de animales con soporte fotográfico.
*   **Lógica Biológica:** Automatización del registro de crías (al registrar un parto "Vivo", la cría nace automáticamente en el sistema) y asignación automática del propósito (Leche, Carne o Reproducción) según su género.
*   **Exportación:** Tablas interactivas exportables a Excel y PDF clínico.

### 🩺 Historial y Sanidad
*   Control estricto de eventos sanitarios (vacunaciones, enfermedades, tratamientos).
*   El sistema etiqueta de forma autónoma a las vacas enfermas como "En Tratamiento".

### 🥛 Ordeño y Trazabilidad
*   **Anti-Mastitis:** Bloqueo de sistema para evitar dobles ordeños accidentales en el mismo turno.
*   **Fosa de Descarte Automática:** Si una vaca está "En Tratamiento", su leche es redirigida automáticamente al tanque de descarte y descontada de los litros comercializables.
*   **Alertas Dinámicas:** Notificaciones inteligentes cuando pasan más de 24 horas sin vaciar un tanque lleno.

### 🧀 Fábrica de Lácteos
*   Módulo de procesamiento donde la leche física cruda se transforma en lotes de Quesos, Yogurt, y Mantequilla.
*   Descuento matemático en tiempo real de la capacidad del tanque principal.

### 👥 Recursos Humanos
*   Fichas técnicas de empleados (Operarios, Veterinarios, Vendedores).
*   Impresión de carnets (Gafetes) con códigos QR funcionales.

---

## 🛠️ Stack Tecnológico

| Capa | Tecnologías |
| :--- | :--- |
| **Backend** | Java 21, API de Servlets, JDBC, iText / OpenPDF (Reportes) |
| **Frontend** | JSP, HTML5, Vanilla CSS, JS, Bootstrap 5.3, SweetAlert2, html2pdf.js, DataTables |
| **Base de Datos** | PostgreSQL (Alojada en Supabase / AWS) |
| **Rendimiento** | HikariCP (Connection Pooling para latencia ultra-baja) |
| **Despliegue** | Apache Tomcat 11, Maven |

---

## 📦 Instalación y Despliegue Local

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/tu-usuario/gestion-ganadera.git
   cd gestion-ganadera
   ```

2. **Configurar la Base de Datos:**
   - Asegúrate de tener PostgreSQL instalado.
   - Configura tus credenciales en el archivo `src/main/java/com/finca/utils/DbConnection.java` (o utiliza las variables de entorno si están configuradas en Hikari).

3. **Compilar y Empaquetar (Maven):**
   ```bash
   mvn clean install
   ```

4. **Desplegar en Tomcat:**
   - Copia el archivo `target/gestion-ganadera-1.0-SNAPSHOT.war` a la carpeta `webapps/` de tu instalación de Tomcat 11.
   - Inicia el servidor Tomcat.

5. **Acceder a la aplicación:**
   Abre tu navegador y entra a: `http://localhost:8080/gestion-ganadera`

---

## 🏗️ Arquitectura del Proyecto

```text
gestion-ganadera/
├── src/main/java/com/finca/
│   ├── controllers/   # Servlets (Rutas, Lógica de Peticiones y Seguridad)
│   ├── dao/           # Consultas SQL (Data Access Object)
│   ├── models/        # Entidades (Bovino, Lote, Asistencia, etc.)
│   ├── services/      # Lógica de Negocio y Generación de PDFs
│   └── utils/         # Configuración HikariCP y Helpers
├── src/main/webapp/   # Vistas JSP (Frontend), CSS personalizado y librerías JS
└── pom.xml            # Dependencias Maven (PostgreSQL, Hikari, iText, etc.)
```

---

<div align="center">
  <h3>👨‍💻 Creado por</h3>
  <p><strong>Angel Poveda</strong> (Aprendiz ADSO - SENA)</p>
  <p><em>Desarrollado con pasión para transformar el agro colombiano a través de la tecnología.</em></p>
</div>
