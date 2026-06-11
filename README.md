# 🐄 Sistema de Gestión Ganadera (Finca La Rosa)

![Java](https://img.shields.io/badge/Java-21-orange?style=flat-square&logo=java) ![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3-blue?style=flat-square&logo=bootstrap) ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Supabase-green?style=flat-square&logo=postgresql) ![HikariCP](https://img.shields.io/badge/HikariCP-Fast_Pool-red?style=flat-square)

Bienvenido al repositorio oficial del sistema de gestión para la **Finca La Rosa**. Este proyecto está diseñado para centralizar la información ganadera, optimizando la toma de decisiones mediante un control preciso del hato, automatización de la fábrica de lácteos y una interfaz moderna.

---

## 🚀 Características Principales

* 🐄 **Inventario Ganadero Inteligente:** CRUD completo con soporte de imágenes. Incluye lógica biológica para automatizar el registro de crías recién nacidas y la asignación automática de propósitos según el género.
* 🩺 **Historial Médico:** Seguimiento detallado de vacunas, enfermedades y eventos sanitarios. El sistema actualiza automáticamente el estado del animal a "En Tratamiento" cuando detecta una enfermedad.
* 🥛 **Control de Producción:** Registro de ordeños con protección de salud (evita el doble ordeño por turno para prevenir mastitis) y envío invisible de leche a "Fosa de Descarte" si el animal está en tratamiento.
* 🧀 **Fábrica de Lácteos:** Módulo de transformación de materia prima en productos finales (lotes). Descuenta automáticamente los litros de leche invertidos del tanque principal.
* 🎨 **UI/UX Rústico-Premium:** Diseño visual blindado y responsivo, basado en una paleta de colores institucional elegante (*Dark Moss Green, Sage, Khaki, Ivory y Drab Dark Brown*).
* ⚡ **Alto Rendimiento:** Integración de **HikariCP** para manejar un Pool de Conexiones a la base de datos, reduciendo los tiempos de respuesta a milisegundos.
* 🔐 **Seguridad:** Autenticación de usuarios y protección de rutas mediante roles (Administrador, Veterinario, Operario, etc.).

---

## 🛠️ Tecnologías Utilizadas

| Componente | Tecnología |
| :--- | :--- |
| **Backend** | Java 21 (Servlets, JDBC) |
| **Frontend** | JSP, Bootstrap 5.3, Bootstrap Icons, SweetAlert2, Chart.js |
| **Base de Datos** | PostgreSQL (Alojada en Supabase / AWS) |
| **Optimización BD** | HikariCP (Connection Pool), SLF4J |
| **Herramientas** | Apache Maven, Apache Tomcat 11 |

---

## 📸 Capturas de Pantalla

*prontos*

---

## 🏗️ Estructura del Proyecto

```text
gestion-ganadera/
├── src/main/java/com/finca/controllers/  # Lógica de Servlets (Producción, Lácteos, etc.)
├── src/main/java/com/finca/dao/          # Acceso a base de datos y transacciones
├── src/main/java/com/finca/models/       # Clases de entidad (Bovino, Ordeno, Lote, etc.)
├── src/main/java/com/finca/utils/        # Utilidades (DbConnection con HikariCP)
├── src/main/webapp/                      # Vistas JSP, estilos integrados y scripts
└── uploads/                              # Almacenamiento local de imágenes
*👨‍💻 Autor
*Desarrollado con pasión por Angel Poveda (Aprendiz ADSO - SENA).

