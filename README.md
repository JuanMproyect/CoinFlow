![Estado del Proyecto](https://img.shields.io/badge/ESTADO-COMPLETADO-brightgreen)
![Flutter](https://img.shields.io/badge/Flutter-v3.19-blue)
![Dart](https://img.shields.io/badge/Dart-v3.3-blue)
![IDE](https://img.shields.io/badge/IDE-Visual%20Studio%20Code%20%7C%20Android%20Studio-blue)
![Base de Datos](https://img.shields.io/badge/Base_de_Datos-Firebase_Firestore-blue)
![API](https://img.shields.io/badge/API-Exchangerate--API-lightgrey)

# CoinFlow

### Proyecto de la clase de Programación Móvil

Aplicación móvil completa para la conversión de divisas, construida en Flutter con un enfoque moderno en usabilidad. Incluye sincronización en tiempo real, modo offline y un sistema de favoritos. También ofrece manejo de historial y configuración de tema (claro/oscuro).

---

## Características Principales

- ✅ **Conversión en tiempo real**  
  Utiliza Exchangerate-API para obtener las tasas de cambio actualizadas.

- ⭐ **Personalización y Favoritos**  
  Permite administrar monedas favoritas y cambiar rápidamente entre ellas.

- ☁️ **Integración con Firebase Firestore**  
  Almacena el historial de conversiones y los ajustes directamente en Firestore.

- 🔔 **Notificaciones**  
  (En desarrollo) Se planea enviar alertas basadas en cambios de tasas.

- 🌗 **Tema Claro / Oscuro**  
  Incluye un conmutador para cambiar entre modos de visualización.

---

## Tecnologías
- **Framework:** Flutter
- **Lenguaje:** Dart
- **Base de Datos:** Firebase Firestore
- **API:** Exchangerate-API
- **Editor / IDE:** Visual Studio Code, Android Studio

---

## Requisitos

- **Flutter SDK**: ≥ 3.19  
- **Firebase Core**: Conectado a Firestore  
- **HTTP & Provider**: Para consumo de APIs y manejo de estados  
- **Dart**: ≥ 3.3

---

## Cómo Ejecutar

1. Clonar este repositorio.
2. Ejecutar:  
   • flutter pub get  
   • flutter run
3. Establecer la clave de Exchangerate-API en el archivo de configuración.
4. Asegurarse de que Firebase esté configurado en el proyecto para Firestore.

---

¡Gracias por usar CoinFlow!