# Poseidón — estructura y pasos (solo formulados, NO ejecutados)

## Estructura lógica del proyecto Xcode (grupos = carpetas)

```
OmniBlob (proyecto Xcode, target app macOS 14+)
└── Sources/
    ├── App/                         OmniBlobApp.swift, AppDelegate.swift      [Minerva]
    └── Agents/
        ├── Eter/      Public/  Internal/{Models,Services}                     File Shelf
        ├── Demeter/   Public/  Internal/{Models,Stores}                       Persistencia
        ├── Hefesto/   Public/  Internal/{Views,Window,Logic,Avatars,DesignSystem}
        ├── Minerva/   Public/  Internal/{State,Widgets}
        ├── Eleuthia/  Public/  Internal/Keychain
        ├── Hades/     Tests/  Performance/  UITests/                          [targets de test]
        ├── Apolo/     Public/  Internal/                                      (docs viven en raíz)
        └── Poseidon/  SETUP.md
```

Nota: se usó `Sources/Agents/...` (ya existente en el repo) en lugar de `OmniBlob/Agents/...`.

## Pasos para el desarrollador (ejecutar manualmente)

1. Crear el proyecto en Xcode: File ▸ New ▸ Project ▸ macOS ▸ App (SwiftUI), nombre `OmniBlob`, guardar en la raíz del repo. Borrar `ContentView.swift` y el `@main` generado.
2. Arrastrar `Sources/` al navegador como *folder reference* (o grupos), marcando el target `OmniBlob`.
3. Crear un target `OmniBlobTests` (Unit Testing Bundle) y añadir `Sources/Agents/Hades/Tests/` y los archivos testeados (`NotchGeometry.swift`, `NotchNavigationStore.swift`, `NotchNavigating.swift`).
4. En Info.plist añadir `Application is agent (UIElement)` = `YES` (LSUIElement) para que no aparezca en el Dock.
5. Verificar: Cmd+B, luego Cmd+U.
6. Commit sugerido:

```bash
git add -A
git status
git commit -m "feat(Hefesto): ventana del notch con expansión; docs(Apolo): CLAUDE.md y agentes"
```
