# Triplets de Clang para Windows x64

El historial y el estado de las correcciones se encuentran en [CAMBIOS.md](CAMBIOS.md).
El inventario y los límites de la revisión de proyectos se encuentran en [REVISION-CMAKE.md](REVISION-CMAKE.md).

Estado: implementación en curso. Los registros de una ejecución anterior muestran que `fmt` se compiló con Clang y LLD en Debug y Release para `x64-windows-clang`. La integración posterior con la raíz MSYS2 elegida, las otras variantes y el consumo de la biblioteca no están verificados. El usuario realizará las compilaciones y pruebas pendientes.

## Entradas

`config.cmd` centraliza las raíces de LLVM, del sysroot y de MSYS2, así como las versiones del toolset y SDK. El gestor permite elegir las tres raíces; el ejecutable `pkg-config` se deriva de la raíz MSYS2 como `ucrt64/bin/pkg-config.exe`. Esas carpetas son entradas de solo lectura y no están incluidas en la copia de restauración. El perfil es x64 y usa ABI MSVC con Clang y LLD; no necesita buscar una instalación de Visual Studio. Los componentes del runtime y SDK son los suministrados en el sysroot.

- `x64-windows-clang`: bibliotecas dinámicas y runtime dinámico.
- `x64-windows-clang-static`: bibliotecas estáticas y runtime estático.
- `x64-windows-clang-static-md`: bibliotecas estáticas y runtime dinámico.

El port puede no admitir la combinación solicitada. El archivo de toolchain incluye el toolchain Windows del clon, por lo que la compatibilidad de cada nueva revisión de vcpkg debe comprobarse. El contenido de `config.cmd` y de `windows.cmake` participa en el hash de ABI; los manifiestos externos no garantizan que la caché detecte modificaciones en las bibliotecas del sysroot. Después de cambiar el contenido del sysroot, se debe usar una caché limpia o una identidad de configuración diferente.

## Uso manual

El usuario debe disponer de `vcpkg.exe` y de las herramientas de compilación auxiliares que requiera cada port. El script configura la sesión de la invocación y selecciona por defecto `x64-windows-clang` para las dependencias de host. Ejemplo para que lo ejecute el usuario en Símbolo del sistema (`cmd.exe`) desde la raíz del fork:

```bat
clang-integration\vcpkg-clang.cmd install fmt
```

Para elegir otra variante, establezca primero, en la misma ventana: `set VCPKG_CLANG_TRIPLET=x64-windows-clang-static` o `set VCPKG_CLANG_TRIPLET=x64-windows-clang-static-md`. El valor predeterminado es `x64-windows-clang`.

Este comando no se ha vuelto a ejecutar con la integración actual de MSYS2. Revise el compilador detectado y los registros; algunas recetas pueden invocar herramientas o sistemas que no respeten esta configuración y fallar. No se han implementado sustitutos generales para MSBuild o `dumpbin`. No seleccione otros triplets explícitamente en los argumentos o en el manifiesto si se necesita mantener esta cadena.

Tras una ejecución previa, el usuario autorizó usar herramientas auxiliares de su instalación existente de MSYS2. La configuración usa su raíz seleccionada para `pkg-config`, `bash` y `make`. La compilación C/C++ se configura con `clang-cl` y el enlace con `lld-link`, no con el compilador de MSYS2. La ejecución todavía no se ha verificado con estas rutas.

La integración redirige las solicitudes habituales de `vcpkg_acquire_msys` a esa instalación y comprueba los paquetes solicitados en su base de datos. Si falta alguno, informa el nombre y detiene el port; no lo instala automáticamente. Las solicitudes de paquetes directos no están implementadas. La integración no controla las descargas propias de cada port ni puede garantizar por sí sola qué compilador invoca un script de terceros; revise los registros. No se modifica la instalación existente de MSYS2.

## Restauración

La copia independiente vive en `A:/al82dev-vcpkg-clang-backup`. Siga su `README.md`: contiene la lista de rutas, el procedimiento manual y un script opcional de restauración. No sobrescriba cambios existentes sin revisarlos. La restauración no incluye el binario de vcpkg, LLVM ni el sysroot.
