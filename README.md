# Run Together 🏃‍♂️

Plataforma para organizar y unirse a carreras/eventos deportivos comunitarios.

## 🚀 Stack Tecnológico

### Backend
- **Ruby** 3.3.0
- **Rails** 7.1.0
- **PostgreSQL** 14

### Frontend
- **esbuild** (JavaScript bundling)
- **Sass** (CSS preprocessing)
- **Bootstrap** 5
- **Turbo Rails**

### Servicios Externos
- **Mapbox** - Mapas y geolocalización
- **Cloudinary** - Almacenamiento de imágenes
- **Supabase** - Base de datos PostgreSQL (producción)

### DevOps
- **Docker** & Docker Compose
- **Render** - Hosting y deployment

## ⚡ Quick Start

### Requisitos
- Docker y Docker Compose
- Git

### Instalación
```
# Clonar el repositorio
git clone <tu-repo>
cd run-together

# Configurar variables de entorno
cp .env.example .env
# Edita .env con tus claves

# Iniciar el proyecto
docker compose up
```

La aplicación estará disponible en `http://localhost:3000`

## 🗂️ Estructura del Proyecto

app/
├── controllers/    # Lógica de controladores
├── models/         # Modelos (User, Race, Runner, Intro)
├── views/          # Vistas ERB
└── assets/         # JavaScript, CSS, imágenes

config/             # Configuración de Rails
db/                 # Migraciones y schema

## 🚧 Work in Progress

Este proyecto está en desarrollo activo. Funcionalidades planificadas:

### 📋 Próximas Features
- [ ] **Sistema de chat en tiempo real** - Comunicación entre runners
- [ ] **Integración completa de Mapbox** - Puntos de encuentro 
- [ ] **Servicio de email** - Notificaciones de lifecycle (alta, confirmaciones, etc)

### 🐛 Fixes Pendientes
- [ ] Actualizar deprecation warnings de Rails 7.2
- [ ] Optimizar queries N+1
- [ ] Mejorar responsive design en mobile

## 🔑 Variables de Entorno

# Base de datos
DATABASE_URL=postgresql://...

# APIs externas
MAPBOX_API_KEY=pk.your_key
CLOUDINARY_URL=cloudinary://...

# Rails
RAILS_MASTER_KEY=your_master_key
RAILS_ENV=development


## 📦 Comandos Útiles

# Desarrollo
docker compose up              # Iniciar servicios
docker compose down            # Detener servicios
docker compose exec app bash   # Entrar al contenedor

# Rails
docker compose exec app rails console      # Rails console
docker compose exec app rails db:migrate   # Correr migraciones
docker compose exec app rails routes       # Ver rutas

# Assets
docker compose exec app yarn build         # Compilar JS
docker compose exec app yarn build:css     # Compilar CSS

## 🌐 Deploy

El proyecto está configurado para deployment en Render con:
- Web Service (Rails app)
- PostgreSQL externa (Supabase)
- Auto-deploy desde `master` branch

## 📄 Licencia

[Tu licencia aquí]

## 👤 Autor

mvisca

---

**Status:** 🚧 En desarrollo activo