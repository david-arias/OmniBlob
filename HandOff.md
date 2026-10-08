# HandOff — Bitácora de OmniBlob (mantenida por Apolo)

## Sesión 1 — 2026-10-08 — Inicio del proyecto

### Hecho
- **Apolo:** `CLAUDE.md` (arquitectura, tabla de agentes, reglas, checklist QA) y 8 archivos en `.claude/agents/` (Éter, Deméter, Hefesto, Minerva, Eleuthia, HADES, Apolo, Poseidón).
- **Poseidón:** estructura lógica por dominio en `Sources/Agents/<Agente>/{Public,Internal}` + `Sources/App`. Pasos para el desarrollador en `Sources/Agents/Poseidon/SETUP.md` (no ejecutados).
- **Minerva:** contrato `NotchNavigating` / `NotchPresentation` (Public), `NotchNavigationStore` (Internal), composition root en `Sources/App` (`OmniBlobApp`, `AppDelegate`).
- **Hefesto:** `NotchPanel` (NSPanel transparente, sin bordes, sobre la barra de menús, todos los Spaces), `NotchWindowController` (posición superior central, resize según estado, clic fuera = colapsar), `NotchGeometry` (lógica pura, fallback sin notch), `NotchShape`, `NotchView` (expansión con spring al hacer clic). Expone `NotchWindowHosting` + `HefestoFactory` en Public.
- **HADES:** tests unitarios en `Sources/Agents/Hades/Tests` (geometría y store).

### QA (HADES) — veredicto: PENDIENTE DE COMPILAR
- Revisión estática: sin referencias cruzadas a `Internal/` entre agentes (salvo tests de HADES, que necesitan acceso al código bajo prueba).
- **No se compiló ni ejecutó nada**: el entorno de la sesión no tiene Swift/Xcode. Hay que hacer Cmd+B y Cmd+U en Xcode.
- Riesgo a vigilar: `@MainActor` + protocolo `NotchNavigating: ObservableObject` genérico; si el compilador se queja, relajar la anotación en el protocolo.

### Decisiones
- Carpetas `Sources/Agents/...` (ya existían en el repo) en vez de `OmniBlob/Agents/...`.
- Ventana de tamaño variable (se agranda al expandir, se reduce tras la animación) para no bloquear clics en zonas transparentes.
- Target mínimo macOS 14.

### Pendiente / siguientes pasos
1. Crear el proyecto Xcode y targets (ver `SETUP.md`), activar `LSUIElement`.
2. Compilar, correr tests, probar en Mac con y sin notch.
3. Primeras features: File Shelf (Éter), ajustes (Deméter), clave de IA en Keychain (Eleuthia), registro de widgets (Minerva).
4. Pruebas de rendimiento y UI (HADES/Performance, UITests).
