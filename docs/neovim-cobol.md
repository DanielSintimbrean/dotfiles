# COBOL en Neovim

Desde la raíz del curso, abre un programa:

```sh
nvim ejemplos/00-hola.cob
```

`.cob`, `.cbl` y `.cpy`, también con extensiones en mayúsculas, activan COBOL.
La configuración usa formato libre, comentarios `*>` y cuatro espacios al indentar.
El resaltado funciona con el vocabulario nativo de Neovim, adaptado para quitar
las restricciones de columnas del formato fijo. El catálogo de nvim-treesitter
que usa esta instalación no incluye COBOL.

SuperBOL arranca como LSP. Busca la raíz por `superbol.toml`, `.git` o `Makefile`;
sin esos archivos usa el directorio del fuente. Resuelve `COPY` en `copybooks/`,
la raíz y el directorio del fuente, sin depender de dónde hayas abierto Neovim.
Un `superbol.toml` existente tiene prioridad sobre los ajustes del editor.

## Atajos existentes

- `Ctrl+Espacio` abre las sugerencias de Blink. Si ya están abiertas, muestra su documentación.
- `Ctrl+n` y `Ctrl+p` seleccionan; `Ctrl+y` acepta; `Ctrl+e` cancela.
- `K` muestra información del símbolo.
- `grd` va a la definición. Funciona también sobre un nombre de copybook en `COPY`.
- `grr` busca referencias y `grn` renombra el símbolo.
- `Ctrl+o` vuelve después de un salto.
- `]d` y `[d` recorren diagnósticos; `Ctrl+w d` muestra el detalle.
- `Espacio q` abre la lista de diagnósticos y `Espacio t d` los oculta o muestra.
- `gcc` comenta la línea con `*>`.
- `Espacio f` solicita formato al LSP. Guardar COBOL no reformatea automáticamente.

`:checkhealth vim.lsp` permite comprobar que está conectado `superbol`.
`cobol_ls`, el servidor de Broadcom instalado en Mason, queda excluido del arranque
automático para evitar que analice los mismos archivos con reglas distintas.

## Diagnósticos y límites

Al abrir un programa guardado y después de guardarlo, nvim-lint invoca directamente
`cobc -free -fsyntax-only -Wall`, con las rutas de COPY del proyecto. No genera
binarios ni ejecuta el programa o el Makefile. Los errores llevan la fuente
`GnuCOBOL`. Los cambios sin guardar todavía no pasan por el compilador.

Los copybooks no son programas independientes. Para comprobar un `.cpy`, guarda
el archivo y vuelve al programa que lo incluye. Los errores de un copybook se
muestran en el programa, sobre su `COPY`, con el archivo y línea del error en el
mensaje. Si el COPY es indirecto, aparecen al principio del programa.
La compilación completa y las
pruebas del curso siguen correspondiendo a `make test` desde su raíz.

SuperBOL usa el dialecto `default`, equivalente a GnuCOBOL. Su parser no cubre toda
la sintaxis moderna; mantenemos desactivada la opción que fuerza diagnósticos de
sintaxis del LSP para ese dialecto. GnuCOBOL da los diagnósticos del compilador.
La navegación depende de que SuperBOL pueda analizar la construcción. La prueba
de rename cubre variables de un programa; no garantiza renombrados globales en
todos los programas que comparten un copybook.

El completado adapta la capitalización al prefijo escrito. Puede sugerir mayúsculas
si se invoca con el prefijo vacío. COBOL admite las palabras clave en minúsculas.

## Herramientas e instalación

`install` incluye GnuCOBOL y descarga SuperBOL 1.1.0 del VSIX oficial de Open VSX,
verifica su SHA-256 y extrae el servidor Node en `~/.local/share/superbol`.
El lanzador `~/.local/bin/superbol` queda enlazado con Stow. Node ya se instala con
mise en estos dotfiles. Java 25 LTS está disponible, pero este servidor no usa Java.
Mason sigue gestionando las herramientas que ya gestionaba; SuperBOL no figura en
su registro consultado.

La caché persistente de SuperBOL está desactivada porque su versión JavaScript
produce errores al serializar funciones de OCaml. El directorio de almacenamiento
apunta a la caché de Neovim para evitar crear `_superbol` en los proyectos.

## Comprobación del problema con minúsculas

El 19 de octubre de 2026, Broadcom 2.5.1 produjo siete errores sobre `00-hola.cob`.
Seis decían `Unexpected indicator area content`; otro señalaba `ication`, el final
de `identification` después de descartar las primeras columnas. Una copia temporal
con solo las palabras clave en mayúsculas produjo los mismos siete errores,
con `ICATION` en el segundo mensaje. Los literales y los identificadores quedaron
intactos. El fallo era interpretar formato libre como fijo.

El registro también contenía peticiones `availableDialects` sin handler y fallos
`MethodNotFound` al resolver la configuración. Son problemas de integración del
cliente y no demuestran que las minúsculas sean incorrectas.

Con esta configuración, ambas versiones de `00-hola.cob` quedan sin diagnósticos.
Se verificaron definición y hover de `cantidad`, tres referencias y tres ediciones
de rename, sin aplicarlas al curso. En `04-consulta.cob`, tanto `COPY` como
`numero-cuenta` llevan a `copybooks/cuentas.cpy`. Blink muestra candidatos de su
fuente LSP. Los quince programas de ejemplos, ejercicios y soluciones abren con
el LSP conectado y sin diagnósticos. En una copia temporal del programa, cambiar una variable por
`NO-EXISTE` produce un error de GnuCOBOL en la línea correcta.

## Referencias

- [SuperBOL, configuración de dialecto, formato, COPY y límites del análisis](https://github.com/OCamlPro/superbol-studio-oss#editing-an-existing-project).
- [Distribución oficial en Open VSX](https://open-vsx.org/extension/OCamlPro/SuperBOL).
- [Lenguajes de nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md).
- [Paquete Broadcom de Mason](https://github.com/mason-org/mason-registry/blob/main/packages/cobol-language-support/package.yaml).
