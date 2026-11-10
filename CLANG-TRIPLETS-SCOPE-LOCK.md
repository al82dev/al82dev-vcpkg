# Scope lock: Windows x64 Clang triplets

- Objective: integrate modular Clang/LLVM triplets in this fork and provide a separate restorable copy with instructions.
- Branch requested: `clang-rules`; initial HEAD read from `.git/refs/heads/clang-rules`: `afa249f12f52ed8a3b919f195495ba8b330288d1`.
- Protected read-only roots: `C:\clang-llvm` and `A:\vc2026-runtime`.
- Compiler and linker: the LLVM installation at `C:\clang-llvm`; Windows headers and libraries: the versioned sysroot under `A:\vc2026-runtime`.
- No dependency on a Visual Studio installation, MinGW, GCC, or similar toolchains.
- The integration is active inside `A:\al82dev-vcpkg`; an independent copy must permit restoration into a fresh clone.
- Preserve existing triplets and unrelated user changes. Do not alter unrelated ports or repositories.
- No builds, installs, project scripts, or tests are to be executed by the agent. The user will build and validate.
- Read-only inspection is authorized. Implementation and runtime verification are distinct; unexecuted checks must be reported as unverified.
- Completion requires the integration, its restorable copy and instructions, and the user's validation evidence; no package compatibility is assumed.

## Amendment: installation campaign authorized on 2026-11-05

- The user authorizes the agent to execute the supplied vcpkg install command, diagnose failures, make minimal fixes and rerun until all requested packages and features are installed. This supersedes the earlier prohibition on the agent running builds, installs, scripts, and required checks for this campaign only.
- After every attempt, remove from subsequent explicit install lists only requested packages whose successful installation and requested features are evidenced; allow vcpkg to resolve dependencies. Retain pending items.
- Commit authorized changes in `clang-rules`, preserve unrelated changes, document each correction, and synchronize the independent restorable backup. No push was requested.
- The protected roots, compiler and linker, prohibition on Visual Studio compiler, GCC and MinGW, permitted MSYS2 auxiliary tools, ABI and behavior preservation remain unchanged. The user permits Microsoft runtime libraries from the configured sysroot.
