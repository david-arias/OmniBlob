# OmniBlob — CLAUDE.md

App nativa para macOS (SwiftUI + AppKit) que convierte el notch en un panel de control interactivo: widgets de productividad, asistente de IA local, utilidades del sistema y avatares dinámicos.

Arquitectura de trabajo: **Funciones Subordinadas** (plantilla genérica adaptada a OmniBlob). Antes de tocar una feature, identifica qué agente es dueño del dominio y consulta su archivo en `.claude/agents/`.

## Stack

- Swift 5.9+ / SwiftUI, AppKit para la ventana del notch (`NSPanel`)
- Target: macOS 14+ (Sonoma) — `NSScreen.safeAreaInsets` y `auxiliaryTopLeftArea` para detectar el notch
- Persistencia local, Keychain y sistema de archivos: APIs nativas (sin backend)
- Pruebas: XCTest + XCUITest

## Agentes

| Agente | Dominio en OmniBlob | Carpeta | Archivo |
|---|---|---|---|
| **Éter** | Gestión de archivos: File Shelf temporal (arrastrar/soltar al notch) | `Sources/Agents/Eter` | `.claude/agents/eter.md` |
| **Deméter** | Persistencia local: historial, configuraciones | `Sources/Agents/Demeter` | `.claude/agents/demeter.md` |
| **Hefesto** | UI/UX SwiftUI: ventana/diseño del notch, avatares, design system | `Sources/Agents/Hefesto` | `.claude/agents/hefesto.md` |
| **Minerva** | Estado de navegación y gestor de widgets activos | `Sources/Agents/Minerva` | `.claude/agents/minerva.md` |
| **Eleuthia** | Claves seguras en Keychain para la IA | `Sources/Agents/Eleuthia` | `.claude/agents/eleuthia.md` |
| **HADES** | QA: pruebas de rendimiento y UI | `Sources/Agents/Hades` | `.claude/agents/hades.md` |
| **Apolo** | Documentación: `CLAUDE.md` y bitácora `HandOff.md` | `Sources/Agents/Apolo` | `.claude/agents/apolo.md` |
| **Poseidón** | Git, dependencias y terminal (formula, **no ejecuta**) | `Sources/Agents/Poseidon` | `.claude/agents/poseidon.md` |

## Estructura de carpetas

```
Sources/
├── App/                      # Composition root (único lugar que conoce tipos concretos de varios agentes). Dueño: Minerva
└── Agents/
    └── <Agente>/
        ├── Public/           # Protocolos y tipos de intercambio. ÚNICO contenido visible para otros agentes
        └── Internal/         # Implementación privada (Views, Models, Services, Logic…)
```

## Reglas de oro

1. **Un archivo, un dueño.** Cada archivo vive bajo el agente dueño de su dominio.
2. **Solo interfaces.** Si una feature cruza dominios, cada agente implementa su parte y se comunican por protocolos en `Public/`. Ningún agente referencia `Internal/` de otro. Solo `Sources/App/` conecta implementaciones concretas.
3. **QA antes de cerrar.** Toda feature pasa por HADES (ver checklist abajo) antes de darse por terminada.
4. **Bitácora al cerrar sesión.** Apolo actualiza `HandOff.md` antes de terminar cualquier sesión.
5. **Poseidón no ejecuta.** Formula los comandos bash exactos como bloques de código; los ejecuta el desarrollador.

## Contratos vigentes (Public/)

- **Minerva → Hefesto:** `NotchNavigating` (`presentation`, `presentationPublisher`, `expand()`, `collapse()`, `toggle()`) y `NotchPresentation` (`.collapsed` / `.expanded`).

## Checklist QA (HADES)

- [ ] Compila sin warnings nuevos
- [ ] Ningún agente importa/referencia `Internal/` de otro
- [ ] Lógica pura cubierta por tests unitarios (`Sources/Agents/Hades/Tests`)
- [ ] Animaciones a 60/120 fps sin trabajo pesado en el main thread
- [ ] Ventana: no roba foco, visible en todos los Spaces, funciona en Macs sin notch (fallback)
- [ ] `HandOff.md` actualizado por Apolo

## Convenciones

- Documentación y bitácora en español; identificadores de código en inglés.
- Commits con prefijo `tipo(Agente): mensaje` (ej. `feat(Hefesto): ventana del notch`).
