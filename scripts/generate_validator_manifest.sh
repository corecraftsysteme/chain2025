#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Chain2025 – Validator Manifest Generator
# Erzeugt validator_manifest_<ID>.yaml im docs/ Ordner
# ============================================================

DOCS_DIR="docs"

usage() {
  echo "Usage:"
  echo "  $0 <ID> <NAME> <ARCHETYPE> <ROLE>"
  echo
  echo "Example:"
  echo "  $0 VAL-010 \"Hüter der Schwelle\" \"Hüter\" \"Genesis-Validator\""
  exit 1
}

if [ "$#" -ne 4 ]; then
  usage
fi

ID="$1"
NAME="$2"
ARCHETYPE="$3"
ROLE="$4"

MANIFEST_PATH="${DOCS_DIR}/validator_manifest_${ID}.yaml"

mkdir -p "${DOCS_DIR}"

DATE_CREATED="$(date +'%Y-%m-%d')"
DATE_UPDATED="${DATE_CREATED}"

cat > "${MANIFEST_PATH}" <<EOF
# ============================================================
# Chain2025 – Validator Manifest (${ID})
# Archetyp • Rolle • Berechtigungen • Signaturen • Historie
# ============================================================

validator:
  id: "${ID}"
  name: "${NAME}"
  archetype: "${ARCHETYPE}"
  role: "${ROLE}"

metadata:
  version: "1.0"
  chain: "Chain2025"
  created_at: "${DATE_CREATED}"
  updated_at: "${DATE_UPDATED}"
  status: "active"

permissions:
  can_trigger: []
  can_sign: []
  can_write_chronik: false
  can_register_driftpoints: false
  can_export_audit: false

archetype_traits:
  symbolism: "<Symbolische Bedeutung des Archetyps>"
  function: "<Funktion im rituellen System>"
  strengths:
    - "<Stärke 1>"
    - "<Stärke 2>"
  limitations:
    - "<Limitation 1>"

signature:
  public_key: "PUBKEY-${ID}-PLACEHOLDER"
  signature_algorithm: "ed25519"
  last_signature:
    ritual: "<genesis | closure | echo | drift | bridge | chronik | audit>"
    timestamp: "${DATE_CREATED} 00:00:00"
    artifact: "<Pfad zum erzeugten Artefakt>"

ritual_history: []

audit:
  last_export:
    timestamp: "${DATE_CREATED} 00:00:00"
    exported_by: "${ID}"
    artifacts:
      - "validator_manifest_${ID}.yaml"
EOF

echo "✅ Validator Manifest generated: ${MANIFEST_PATH}"
