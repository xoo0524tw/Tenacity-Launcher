#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="${SCRIPT_DIR}/"
SAVE_DIR="${ROOT}save"
NATIVES_DIR="${SAVE_DIR}/natives-macos-x86_64"
RELEASE_REPO="xoo0524tw/Tenacity-Launcher"

# The bundled macOS LWJGL/JInput libraries are Intel binaries.  On Apple
# silicon, the x86_64 Java 8 runtime runs them through Rosetta automatically.
JAVA_HOME_X86=""
for candidate in \
    "/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home" \
    "/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home"; do
    if [ -x "${candidate}/bin/java" ] && \
       file "${candidate}/bin/java" | grep -q 'x86_64'; then
        JAVA_HOME_X86="$candidate"
        break
    fi
done

if [ -z "$JAVA_HOME_X86" ]; then
    echo "[Launcher] Intel (x86_64) Java 8 was not found."
    echo "[Launcher] This launcher needs it because Tenacity ships Intel-only macOS native libraries."
    echo "[Launcher] Install an x86_64 Java 8 runtime, then run this file again."
    exit 1
fi

JAVA_EXE="${JAVA_HOME_X86}/bin/java"
mkdir -p "$SAVE_DIR" "$NATIVES_DIR"

echo "[Launcher] Using Intel Java: $JAVA_EXE"

for native_jar in \
    "${ROOT}files/libs/lwjgl-platform-2.9.4-nightly-20150209-natives-osx.jar" \
    "${ROOT}files/libs/jinput-platform-2.0.5-natives-osx.jar" \
    "${ROOT}files/libs/twitch-platform-6.5-natives-osx.jar"; do
    if [ ! -f "$native_jar" ]; then
        echo "[Launcher] Missing required macOS native library: $native_jar"
        exit 1
    fi
    unzip -oq "$native_jar" -d "$NATIVES_DIR"
done

if ! bash "${ROOT}files/Update-Tenacity.sh" --root "$ROOT" --repo "$RELEASE_REPO"; then
    echo "[Updater] Failed to check or download the latest Tenacity.jar."
    if [ -f "${ROOT}Tenacity.jar" ]; then
        echo "[Updater] Launching the local Tenacity.jar instead."
    else
        echo "[Updater] Tenacity.jar is missing. Please check your internet connection and try again."
        exit 1
    fi
fi

cd "$SAVE_DIR"

exec arch -x86_64 "$JAVA_EXE" \
    -noverify \
    -Djava.library.path="$NATIVES_DIR" \
    -cp "${ROOT}Tenacity.jar:${ROOT}files/libs/*" \
    net.minecraft.client.main.Main \
    --version Tenacity \
    --accessToken 0 \
    --userProperties '{}' \
    --gameDir "." \
    --assetsDir "${ROOT}files/assets" \
    --assetIndex 1.8 \
    --width 854 \
    --height 480
