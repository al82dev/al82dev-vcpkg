#!/usr/bin/env python3
"""Copia las bibliotecas y cabeceras Clang instaladas a un SDK de Windows."""

import argparse
import hashlib
import shutil
import sys
from pathlib import Path


def digest(path):
    h = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            h.update(chunk)
    return h.digest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--installed", type=Path, default=Path(r"A:\al82dev-vcpkg\installed"))
    parser.add_argument("--destino", type=Path, default=Path(r"A:\sdk-clang-llvm-win64"))
    args = parser.parse_args()
    installed = args.installed.resolve()
    destination = args.destino.resolve()
    if installed == destination or installed in destination.parents or destination in installed.parents:
        parser.error("El origen y el destino deben ser carpetas independientes.")

    triplets = (("x64-windows-clang", "dynamic"), ("x64-windows-clang-static", "static"))
    found = [(installed / name, linkage) for name, linkage in triplets if (installed / name).is_dir()]
    if not found:
        parser.error(f"No se encontró ningún triplet Clang en {installed}")
    for name, _ in triplets:
        if not (installed / name).is_dir():
            print(f"Aviso: no existe {installed / name}", file=sys.stderr)

    # Se revisan primero los conflictos entre los dos conjuntos de cabeceras y
    # con el destino para no reemplazar archivos distintos silenciosamente.
    files = {}
    conflicts = []
    def collect(source, relative_destination):
        if not source.is_dir():
            return
        for item in sorted(source.rglob("*")):
            if not item.is_file():
                continue
            relative = relative_destination / item.relative_to(source)
            key = str(relative).casefold()
            if key in files:
                old_relative, old_source = files[key]
                if digest(item) != digest(old_source):
                    conflicts.append((old_relative, old_source, item))
            else:
                files[key] = (relative, item)

    for root, linkage in found:
        collect(root / "include", Path("include"))
        collect(root / "lib", Path("lib") / "release" / linkage)
        collect(root / "debug" / "lib", Path("lib") / "debug" / linkage)
        if linkage == "dynamic":
            collect(root / "bin", Path("bin") / "release")
            collect(root / "debug" / "bin", Path("bin") / "debug")

    for relative, source in files.values():
        target = destination / relative
        if target.exists() and (not target.is_file() or digest(source) != digest(target)):
            conflicts.append((relative, target, source))
    if conflicts:
        for relative, first, second in conflicts:
            print(f"Conflicto: {relative}\n  {first}\n  {second}", file=sys.stderr)
        print("No se copió ningún archivo. Revisa las diferencias antes de continuar.", file=sys.stderr)
        return 1

    for directory in ("include", "lib/release/static", "lib/release/dynamic", "lib/debug/static", "lib/debug/dynamic", "bin/release", "bin/debug"):
        (destination / directory).mkdir(parents=True, exist_ok=True)
    copied = 0
    for relative, source in files.values():
        target = destination / relative
        if target.exists():
            continue
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, target)
        copied += 1
    print(f"SDK: {destination}\nArchivos copiados: {copied}\nArchivos ya existentes e idénticos: {len(files) - copied}")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except OSError as exc:
        print(f"Error de acceso o copia: {exc}", file=sys.stderr)
        sys.exit(1)
