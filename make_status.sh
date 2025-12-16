#!/bin/bash
# ==============================================================================
# make_status.sh - Volcado relevante ft_transcendence (Rails-aware)
# ==============================================================================
# - Incluye SOLO código que define la app
# - Omite boilerplate estándar de Rails
# - Excluye secretos y artefactos
# - Mantiene formato y naming original
# ==============================================================================

rm status*.txt
OUTPUT_FILE="status$(date '+%Y-%m-%d_%H:%M:%S').txt"

cat > "$OUTPUT_FILE" << 'EOF'
================================================================================
PROYECTO: ft_transcendence
FECHA:
================================================================================
EOF

echo "GENERADO: $(date '+%Y-%m-%d %H:%M:%S')" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# ==============================================================================
# ESTRUCTURA RELEVANTE
# ==============================================================================

echo "================================================================================" >> "$OUTPUT_FILE"
echo "ESTRUCTURA RELEVANTE DEL PROYECTO" >> "$OUTPUT_FILE"
echo "================================================================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

find . \
  -type d \
  \( \
    -path '*/app/*' \
    -o -path '*/lib/*' \
    -o -path '*/config/*' \
    -o -path '*/db/*' \
    -o -path '*/spec/*' \
    -o -path '*/test/*' \
  \) \
  ! -path '*/assets/*' \
  ! -path '*/channels/application_cable/*' \
  ! -path '*/jobs/application_job*' \
  ! -path '*/mailers/application_mailer*' \
  ! -path '*/controllers/application_controller*' \
  | sed 's|^\./||' \
  | sort \
  | head -200 >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# ==============================================================================
# VOLCADO DE ARCHIVOS RELEVANTES
# ==============================================================================

echo "================================================================================" >> "$OUTPUT_FILE"
echo "CONTENIDO RELEVANTE DE LA APP" >> "$OUTPUT_FILE"
echo "================================================================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

find . -type f \
  \( \
    -path './app/*' \
    -o -path './lib/*' \
    -o -path './config/*' \
    -o -path './db/*' \
    -o -path './spec/*' \
    -o -path './test/*' \
  \) \
  ! -path '*/assets/*' \
  ! -path '*/node_modules/*' \
  ! -path '*/vendor/*' \
  ! -path '*/storage/*' \
  ! -path '*/tmp/*' \
  ! -path '*/log/*' \
  ! -path '*/.git/*' \
  ! -path '*/.vscode/*' \
  ! -path '*/.idea/*' \
  ! -path '*/docs/*' \
  ! -path '*/coverage/*' \
  ! -path '*/.cache/*' \
  ! -path '*/.turbo/*' \
  ! -path '*/.claude/*' \
  ! -name '*.png' \
  ! -name '*.jpg' \
  ! -name '*.jpeg' \
  ! -name '*.svg' \
  ! -name '*.gif' \
  ! -name '*.ico' \
  ! -name '*.pdf' \
  ! -name '*.zip' \
  ! -name '*.tgz' \
  ! -name '*.lock' \
  ! -name '.env' \
  ! -name '.env.*' \
  ! -name 'credentials.yml.enc' \
  ! -name 'master.key' \
  ! -name 'secrets.yml' \
  ! -name 'schema.rb' \
  ! -name 'structure.sql' \
  ! -name 'application.rb' \
  ! -name 'boot.rb' \
  ! -name 'environment.rb' \
  | sort | while read -r file; do
    echo ">>> ARCHIVO: $file" >> "$OUTPUT_FILE"
    echo "--------------------------------------------------------------------------------" >> "$OUTPUT_FILE"
    sed \
      -e 's/\(password:\).*/\1 [FILTERED]/i' \
      -e 's/\(secret\|token\|api_key\|key:\).*/\1 [FILTERED]/i' \
      "$file" >> "$OUTPUT_FILE" 2>/dev/null || \
      echo "[Archivo no legible]" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
done

# ==============================================================================
# FOOTER
# ==============================================================================

echo "================================================================================" >> "$OUTPUT_FILE"
echo "FIN DEL STATUS - Generado: $(date '+%Y-%m-%d %H:%M:%S')" >> "$OUTPUT_FILE"
echo "================================================================================" >> "$OUTPUT_FILE"

FILE_SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)
LINE_COUNT=$(wc -l < "$OUTPUT_FILE")
FILE_COUNT=$(grep -c '^>>> ARCHIVO:' "$OUTPUT_FILE")

echo ""
echo "✓ Status generado"
echo "  Archivo: $OUTPUT_FILE"
echo "  Archivos incluidos: $FILE_COUNT"
echo "  Tamaño: $FILE_SIZE"
echo "  Líneas: $LINE_COUNT"
echo ""
