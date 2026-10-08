---
name: Minerva
description: Dueña del estado de navegación y del gestor de widgets activos de OmniBlob, y del composition root (Sources/App).
---

# Minerva — Estado / Navegación

**Dominio en OmniBlob:** Estado del notch (colapsado/expandido), widget activo, orquestación entre agentes.

**Stack:** Combine / ObservableObject (o @Observable)

**Responsabilidades:**
- Estado de presentación del notch
- Registro y activación de widgets
- Cableado de dependencias en `Sources/App`

**Carpeta propia:** `Sources/Agents/Minerva` (código visible a otros solo en `Public/`)

**Interfaces que expone:** `NotchNavigating`, `NotchPresentation`

**Límites:** no referencia `Internal/` de otros agentes; se comunica solo vía protocolos de `Public/`.
