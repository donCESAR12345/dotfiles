#!/usr/bin/env bash
set -euo pipefail

SCRIPT_UNDER_TEST="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.local/bin" && pwd)/rclone-bisync-notify-failed"
TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

passed=0
failed=0

# Mock notify-send inside temp PATH
mock_bin="$TEMP_DIR/mock_bin"
mkdir -p "$mock_bin"
cat << 'EOF' > "$mock_bin/notify-send"
#!/usr/bin/env bash
printf "%s\n" "$@"
EOF
chmod +x "$mock_bin/notify-send"

run_test() {
    local test_name="$1"
    local log_content="$2"
    local expected_cause="$3"
    local expected_detail="${4:-}"
    
    local test_log="$TEMP_DIR/test.log"
    printf "%s\n" "$log_content" > "$test_log"
    
    local output
    output=$(PATH="$mock_bin:$PATH" "$SCRIPT_UNDER_TEST" "testprofile" "$test_log" 2>&1) || true
    
    local pass=true
    if ! printf '%s\n' "$output" | grep -Fq "<b>Causa:</b> $expected_cause"; then
        pass=false
    fi
    if [[ -n "$expected_detail" ]] && ! printf '%s\n' "$output" | grep -Fq "$expected_detail"; then
        pass=false
    fi

    if [ "$pass" = true ]; then
        echo "[PASS] $test_name"
        passed=$((passed + 1))
    else
        echo "[FAIL] $test_name"
        echo "Expected cause: $expected_cause"
        [[ -n "$expected_detail" ]] && echo "Expected detail containing: $expected_detail"
        echo "Actual output:"
        echo "$output"
        failed=$((failed + 1))
    fi
}

echo "Ejecutando pruebas de diagnóstico..."

run_test "1. Portal cautivo UdeA" \
  "2026/09/16 12:46:32 CRITICAL: Failed: couldn't fetch token: tls: failed to verify certificate: x509: certificate is valid for *.udea.edu.co, udea.edu.co, not oauth2.googleapis.com" \
  "Portal cautivo de red UdeA interceptando tráfico HTTPS"

run_test "2. Token OAuth expirado o revocado" \
  "2026/09/16 10:00:00 ERROR : couldn't fetch token: oauth2: cannot fetch token: 400 Bad Request Response: {\"error\":\"invalid_grant\",\"error_description\":\"Token has been expired or revoked.\"}" \
  "Credenciales OAuth expiradas o revocadas (re-autenticar)"

run_test "3. Límite de borrado de seguridad" \
  "2026/09/16 11:00:00 ERROR : Bisync critical error: Safety abort: too many deletions (95/90). Use --max-delete or --force" \
  "Límite de borrado de seguridad excedido (--max-delete)"

run_test "4. Lock previo o proceso en ejecución" \
  "2026/09/16 12:00:00 ERROR : Bisync critical error: prior lock file found: /home/cesar/.cache/rclone/bisync/gdrive.lck. Bisync is already running" \
  "Sincronización bloqueada (lock previo activo)"

run_test "5. Re-sincronización requerida" \
  "2026/09/16 13:00:00 ERROR : Bisync critical error: Path1 and Path2 are out of sync. Must use --resync to recover." \
  "Desincronización crítica (requiere --resync)"

run_test "6. Rate Limit Google (429)" \
  "2026/09/16 14:00:00 CRITICAL: Failed to create file system: googleapi: got HTTP response code 429 with body: <html>Sorry...</html>" \
  "Límite de peticiones de Google Drive (HTTP 429)"

run_test "7. Espacio insuficiente en disco/nube" \
  "2026/09/16 15:00:00 ERROR : file.zip: Failed to copy: googleapi: Error 403: The user's Drive storage quota has been exceeded., storageQuotaExceeded" \
  "Espacio de almacenamiento lleno (Drive o disco local)"

run_test "8. Falla de conexión o DNS" \
  "2026/09/16 16:00:00 CRITICAL: Failed: dial tcp: lookup oauth2.googleapis.com: Temporary failure in name resolution" \
  "Sin conexión a Internet o falla de resolución DNS"

run_test "9. Directorio no encontrado" \
  "2026/09/16 17:00:00 ERROR : Local file system at /home/cesar/Cloud/NonExistent: directory not found" \
  "Directorio local o remoto inaccesible"

run_test "10. Fallo de Bisync (march failed)" \
  "2026/09/16 18:00:00 ERROR : Bisync critical error: march failed with 12 errors. Aborting as it is too dangerous" \
  "Fallo crítico en Bisync (abortado de forma segura)"

run_test "11. Fallback genérico" \
  "2026/09/16 19:00:00 ERROR : unexpected internal failure occurred in engine" \
  "Error en sincronización de Rclone" \
  "unexpected internal failure occurred in engine"

echo ""
echo "Resumen: $passed pasadas, $failed falladas."
if [ "$failed" -gt 0 ]; then
    exit 1
fi
