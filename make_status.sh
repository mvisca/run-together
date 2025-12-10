#!/bin/bash

# ==============================================================================
# make_status.sh - Generador de status.txt para ft_transcendence
# ==============================================================================
# Genera un volcado COMPLETO y RECURSIVO del proyecto
# - Incluye TODOS los archivos (excepto los excluidos)
# - Busca recursivamente en todas las subcarpetas
# - Mantiene nombre y formato original: status_YYYY-MM-DD_HH-MM-SS.txt
# ==============================================================================

# Limpieza
rm status*.txt

# Configuración
OUTPUT_FILE="status$(date '+%Y-%m-%d_%H:%M:%S').txt"

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ==============================================================================
# HEADER
# ==============================================================================

cat > "$OUTPUT_FILE" << 'EOF'
================================================================================
PROYECTO: ft_transcendence
FECHA: 
================================================================================

EOF

echo "GENERADO: $(date '+%Y-%m-%d %H:%M:%S')" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# ==============================================================================
# ESTRUCTURA DEL PROYECTO
# ==============================================================================

echo "================================================================================" >> "$OUTPUT_FILE"
echo "ESTRUCTURA DEL PROYECTO" >> "$OUTPUT_FILE"
echo "================================================================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Intentar con tree
if command -v tree &> /dev/null; then
    tree -L 5 \
        --charset ascii \
        -I 'docs|node_modules|dist|build|.git|.vscode|pnpm-lock.yaml|*.db|.next|out|coverage|.cache|.turbo' \
        >> "$OUTPUT_FILE" 2>/dev/null || {
        echo "Árbol de directorios:" >> "$OUTPUT_FILE"
        find . -type d \
            ! -path '*/node_modules/*' \
            ! -path '*/.git/*' \
            ! -path '*/dist/*' \
			! -path '*/docs/*' \
            ! -path '*/build/*' \
            ! -path '*/.vscode/*' \
            ! -path '*/coverage/*' \
            ! -path '*/.next/*' \
            ! -path '*/.cache/*' \
            ! -path '*/.turbo/*' \
            ! -path '*/.claude/*' \
            | head -100 >> "$OUTPUT_FILE"
    }
else
    echo "Árbol de directorios:" >> "$OUTPUT_FILE"
    find . -type d \
        ! -path '*/node_modules/*' \
        ! -path '*/.git/*' \
        ! -path '*/dist/*' \
        ! -path '*/build/*' \
        ! -path '*/.vscode/*' \
        ! -path '*/coverage/*' \
        ! -path '*/.next/*' \
        ! -path '*/out/*' \
        ! -path '*/docs/*' \
        ! -path '*/.cache/*' \
        ! -path '*/.turbo/*' \
        | head -100 >> "$OUTPUT_FILE"
fi

echo "" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# ==============================================================================
# VOLCADO RECURSIVO - TODOS LOS ARCHIVOS
# ==============================================================================

echo "================================================================================" >> "$OUTPUT_FILE"
echo "CONTENIDO COMPLETO DE ARCHIVOS" >> "$OUTPUT_FILE"
echo "================================================================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Buscar TODOS los archivos recursivamente, excluir lo necesario
find . -type f \
    ! -path '*/node_modules/*' \
    ! -path '*/.claude/*' \
    ! -path '*/docs/*' \
    ! -path '*/.git/*' \
    ! -path '*/dist/*' \
    ! -path '*/build/*' \
    ! -path '*/.vscode/*' \
    ! -path '*/coverage/*' \
    ! -path '*/.next/*' \
    ! -path '*/out/*' \
    ! -path '*/.cache/*' \
    ! -path '*/.turbo/*' \
    ! -name '.env' \
    ! -name '.env.*' \
    ! -name 'pnpm-lock.yaml' \
    ! -name 'package-lock.json' \
    ! -name '*.db' \
    ! -name '*.db-shm' \
    ! -name '*.db-wal' \
    ! -name '*.log' \
    ! -name '.DS_Store' \
    ! -name 'Thumbs.db' \
    ! -name '*.tgz' \
    ! -name 'tsconfig.tsbuildinfo' \
    | while read -r file; do
    
    echo ">>> ARCHIVO: $file" >> "$OUTPUT_FILE"
    echo "--------------------------------------------------------------------------------" >> "$OUTPUT_FILE"
    cat "$file" >> "$OUTPUT_FILE" 2>/dev/null || echo "[Archivo binario o no legible]" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
done

# ==============================================================================
# INFORMACIÓN DEL SISTEMA
# ==============================================================================

echo "================================================================================" >> "$OUTPUT_FILE"
echo "INFORMACIÓN DEL SISTEMA" >> "$OUTPUT_FILE"
echo "================================================================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

{
    echo "Node.js:"
    node --version 2>&1 || echo "  (no disponible)"
    echo ""
    echo "npm/pnpm:"
    pnpm --version 2>&1 || npm --version 2>&1 || echo "  (no disponible)"
    echo ""
    echo "TypeScript (instalado):"
    pnpm list typescript 2>/dev/null | head -3 || echo "  (no disponible)"
    echo ""
    echo "Git Status:"
    git status --short 2>/dev/null | head -20 || echo "  (no disponible)"
    echo ""
    echo "Tamaño del proyecto (sin node_modules):"
    du -sh . 2>/dev/null | grep -v node_modules || echo "  (no disponible)"
} >> "$OUTPUT_FILE"

# ==============================================================================
# FOOTER
# ==============================================================================

echo "" >> "$OUTPUT_FILE"
echo "================================================================================" >> "$OUTPUT_FILE"
echo "FIN DEL STATUS - Generado: $(date '+%Y-%m-%d %H:%M:%S')" >> "$OUTPUT_FILE"
echo "================================================================================" >> "$OUTPUT_FILE"

# ==============================================================================
# OUTPUT EN CONSOLA
# ==============================================================================

FILE_SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)
LINE_COUNT=$(wc -l < "$OUTPUT_FILE")
FILE_COUNT=$(find . -type f \
    ! -path '*/node_modules/*' \
    ! -path '*/.claude/*' \
    ! -path '*/.git/*' \
    ! -path '*/dist/*' \
    ! -path '*/build/*' \
    ! -path '*/.vscode/*' \
    ! -path '*/coverage/*' \
    ! -path '*/.next/*' \
    ! -path '*/out/*' \
    ! -path '*/docs/*' \
    ! -path '*/.cache/*' \
    ! -path '*/.turbo/*' \
    ! -name '.env' \
    ! -name '.env.*' \
    ! -name 'pnpm-lock.yaml' \
    ! -name 'package-lock.json' \
    ! -name '*.db' \
    ! -name '*.db-shm' \
    ! -name '*.db-wal' \
    ! -name '*.log' \
    ! -name '.DS_Store' \
    ! -name 'Thumbs.db' \
    ! -name '*.tgz' \
    ! -name 'tsconfig.tsbuildinfo' \
    | wc -l)

echo ""
echo -e "${GREEN}✓${NC} Status generado exitosamente"
echo -e "  ${BLUE}Archivo:${NC} $OUTPUT_FILE"
echo -e "  ${BLUE}Archivos incluidos:${NC} $FILE_COUNT"
echo -e "  ${BLUE}Tamaño:${NC} $FILE_SIZE"
echo -e "  ${BLUE}Líneas:${NC} $LINE_COUNT"
echo ""
echo -e "${YELLOW}FUENTE DE VERDAD${NC}: Este archivo es la referencia oficial del proyecto"
echo -e "  → Úsalo en prompts para contexto completo"
echo -e "  → Contiene TODOS los archivos del proyecto"
echo ""
