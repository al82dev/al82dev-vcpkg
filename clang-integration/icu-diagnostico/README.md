# Diagnóstico del cierre de Clang con ICU

Este diagnóstico compara el reproductor preprocesado generado por Clang 23.1.0 al compilar ICU 79.1, primero con las opciones originales de depuración y después sin `-gno-column-info`, `-gcodeview` y `-debug-info-kind=constructor`. No instala paquetes ni cambia ICU, Clang o el runtime. Genera objetos y registros únicamente en un directorio `resultados-*` nuevo junto a estos archivos.

Entrada original: `A:/msys64/tmp/astro-02d6d5.cpp`; SHA-256 `5AE27016B001F5A200C3216C54868AE6A0A4AA0DC011F56D769995AB7772FC8F`. El archivo es temporal y no está incluido en el respaldo; si desaparece, este diagnóstico necesita recuperarlo o generar otro reproductor equivalente. El script fuente original es `A:/msys64/tmp/astro-02d6d5.sh`.

En `cmd.exe`, el usuario ejecuta:

```bat
A:\al82dev-vcpkg\clang-integration\icu-diagnostico\repro.cmd
```

El comando carga las raíces desde `clang-integration/config.cmd`. Opcionalmente se puede definir `ASTRO_INPUT` antes de iniciarlo para usar una copia del archivo preprocesado. Al terminar, compartir `estado.txt`, `original.log` y `sin-debug.log` del directorio `resultados-*` que se muestra en pantalla. Un código cero indica que esa ejecución del compilador terminó, no que ICU esté verificado. Si ambos fallan de manera idéntica, la información de depuración no queda establecida como causa; si solo falla el original, es una pista, no una prueba de compatibilidad de ICU.

El agente ejecutó el diagnóstico después de recibir autorización: ambos casos terminaron con código 139 en `resultados-qe71ROCX`. Estos scripts no son una corrección del paquete ni certifican el ABI.
