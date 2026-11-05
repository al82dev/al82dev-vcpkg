# Diagnóstico de Shader Slang con Clang independiente

Estado: **experimental e incompleto**. El port de `shader-slang` todavía instala binarios precompilados. Estos archivos preservan el diagnóstico, no una receta final de instalación ni una afirmación de compatibilidad funcional.

Los comandos se ejecutan desde la raíz del repositorio con `cmd.exe`. Las copias de esta carpeta deben trasladarse a `buildtrees` antes de ejecutarse, porque esa es la ruta que utilizan entre sí. Lea y ajuste primero las rutas absolutas de cada archivo: fijan el repositorio en `A:/al82dev-vcpkg`, las fuentes LLVM en `C:/llvm-project-23.1.0.src`, LLVM en `C:/clang-llvm`, el runtime en `A:/vc2026-runtime` y las versiones de Ninja y CMake descargadas por vcpkg. No escriben en las rutas de LLVM, sus fuentes ni el runtime.

1. Instale `zstd:x64-windows-clang-static-md` con el lanzador de Clang y compruebe que el triplet de destino tenga zlib.
2. Obtenga en `buildtrees/shader-slang-source-v2026.20` el tag `v2026.20` de `https://github.com/shader-slang/slang.git` con sus submódulos. Compare el commit con `d9ede2dd5836afc0e9586da18d9236b171d0faa8`.
3. En ese clon aplique `ports/shader-slang/clang-source-diagnostic.patch`. Es un parche candidato; conserva la ruta JIT RuntimeDyld y adapta la generación del proxy y el punto flotante para LLVM 23. No se ha certificado su comportamiento.
4. Copie los archivos `configure-llvm-md.cmd`, `build-llvm-md.cmd`, `configure-slang-clang.cmd`, `build-slang-clang.cmd` y `slang-diagnostic-deps.cmake` a `buildtrees`. Ejecute primero la configuración y construcción de LLVM y luego las de Slang, revisando los registros de cada etapa.

El diagnóstico de Slang inicialmente usó el LLVM de `C:/clang-llvm`, cuyas bibliotecas estáticas usan `/MT`; el enlace con Slang `/MD` falló. La copia auxiliar en `buildtrees/llvm-clang-md-install` se está construyendo con `/MD`; el comando de configuración de Slang apunta ahora a ella, pero esa combinación aún no se ha probado. La copia auxiliar se configuró sin el lector PDB DIA porque falta `atlbase.h`; LLVM conserva su lector PDB nativo, pero esa diferencia y el JIT no se han validado. Slang puede descargar DXC y componentes WebGPU precompilados. No confunda este diagnóstico con una instalación que cumpla el objetivo.

Las rutas `buildtrees/llvm-clang-md`, `buildtrees/llvm-clang-md-install`, `buildtrees/shader-slang-source-v2026.20` y `buildtrees/shader-slang-clang-diagnostic` contienen datos de construcción que no se incluyen en este respaldo. Los scripts conservados aquí son una instantánea de trabajo y deben volver a comprobarse tras cada actualización de las herramientas o del repositorio.
