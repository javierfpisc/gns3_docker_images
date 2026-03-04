#!/usr/bin/env bash
SNORT_REPO=$1
DAQ_REPO=$2
SNORT_PREFIX=$3

set -euo pipefail

# ========= Config =========
BUILD_DIR="/usr/src/snort-build"
JOBS="$(nproc)"

export DEBIAN_FRONTEND=noninteractive

echo "[1/7] Actualizando sistema e instalando dependencias..."
apt update
apt install -y --no-install-recommends \
  build-essential cmake pkg-config git autoconf automake libtool \
  bison flex libfl-dev \
  libpcap-dev libpcre2-dev libdumbnet-dev zlib1g-dev \
  liblzma-dev libssl-dev libluajit-5.1-dev libunwind-dev \
  libmnl-dev libnfnetlink-dev libnetfilter-queue-dev \
  libhwloc-dev libhyperscan-dev \
  libpcap0.8 libpcre2-8-0 libdumbnet1 zlib1g liblzma5 libssl3 libluajit-5.1-2 \
  libunwind8 libmnl0 libnfnetlink0 libnetfilter-queue1 \
  libhwloc15 libhyperscan5 numactl \
  ca-certificates

echo "[2/7] Preparando directorio de compilación..."
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

echo "[3/7] Descargando y compilando libdaq..."
if [[ -d libdaq ]]; then
  rm -rf libdaq
fi
git clone --depth 1 "${DAQ_REPO}" libdaq
cd libdaq
./bootstrap
./configure --prefix="${SNORT_PREFIX}"
make -j"${JOBS}"
make install
ldconfig

echo "[4/7] Descargando Snort 3..."
cd "${BUILD_DIR}"
if [[ -d snort3 ]]; then
  rm -rf snort3
fi
git clone --depth 1 "${SNORT_REPO}" snort3
cd snort3

echo "[5/7] Configurando y compilando Snort 3..."
./configure_cmake.sh --prefix="${SNORT_PREFIX}"
cd build
make -j"${JOBS}"
make install
ldconfig

echo "[6/7] Creando estructura mínima de configuración..."
mkdir -p "${SNORT_PREFIX}/etc/snort/rules" /var/log/snort

if [[ ! -f "${SNORT_PREFIX}/etc/snort/rules/local.rules" ]]; then
  cat > "${SNORT_PREFIX}/etc/snort/rules/local.rules" <<'EOF'
alert icmp any any -> any any (msg:"ICMP test"; sid:1000001; rev:1;)
EOF
fi

echo "[7/7] Verificando instalación..."
"${SNORT_PREFIX}/bin/snort" -V

echo "Instalación completada."

echo "[8/8] Limpieza para reducir tamaño de imagen..."

# Eliminar código fuente
rm -rf "${BUILD_DIR}"

# Strip binarios (reduce varios MB)
if command -v strip >/dev/null 2>&1; then
  strip "${SNORT_PREFIX}/bin/snort" || true
fi

# Eliminar dependencias de compilación
apt purge -y \
  build-essential cmake pkg-config git autoconf automake libtool \
  bison flex libfl-dev

# Eliminar librerías -dev (no necesarias en runtime)
apt purge -y \
  libpcap-dev libpcre2-dev libdumbnet-dev zlib1g-dev \
  liblzma-dev libssl-dev libluajit-5.1-dev libunwind-dev \
  libmnl-dev libnfnetlink-dev libnetfilter-queue-dev \
  libhwloc-dev libhyperscan-dev

# Autoremove de dependencias huérfanas
apt autoremove -y

# Limpiar cache de apt
apt clean
rm -rf /var/lib/apt/lists/*

# echo "Prueba de config:"
# echo "  ${SNORT_PREFIX}/bin/snort -c ${SNORT_PREFIX}/etc/snort/snort.lua -R ${SNORT_PREFIX}/etc/snort/rules/local.rules -T"
# echo
# echo "Ejecución (cambia eth0 por tu interfaz):"
# echo "  ${SNORT_PREFIX}/bin/snort -c ${SNORT_PREFIX}/etc/snort/snort.lua -R ${SNORT_PREFIX}/etc/snort/rules/local.rules -i eth0 -A alert_fast"
