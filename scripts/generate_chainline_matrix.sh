#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Chain-Line – Matrix Generator
# Erzeugt:
#   docs/products/chainline-matrix.yaml
#   docs/products/chainline-matrix.json
#   docs/products/chainline-matrix.md
# Baseline:
#   Startwert: 178'000'000'000 CHF
#   Multiplikator: 1.2 pro Jahr
#   Jahre: 2025–2050
# ============================================================

BASE_VALUE=178000000000
MULTIPLIER=1.2
START_YEAR=2025
END_YEAR=2050

OUT_DIR="docs/products"
YAML_FILE="${OUT_DIR}/chainline-matrix.yaml"
JSON_FILE="${OUT_DIR}/chainline-matrix.json"
MD_FILE="${OUT_DIR}/chainline-matrix.md"

mkdir -p "${OUT_DIR}"

# -----------------------------
# Hilfsfunktion: Modell & Bedeutung
# -----------------------------
get_model_and_meaning() {
  local year="$1"
  case "${year}" in
    2025) echo "Genesis-Baseline|Ursprung, Fundament" ;;
    2026) echo "Baseline-Projektion|Reife, Stabilisierung" ;;
    2027) echo "Adoption Layer|Frühe Massenadoption" ;;
    2028) echo "Expansion Layer|Globale Expansion" ;;
    2029) echo "Skalierungs-Layer|Beschleunigte Skalierung" ;;
    2030) echo "Institutionelle Dominanz|Globale Etablierung" ;;
    2031) echo "Global Integration|Tiefe Marktintegration" ;;
    2032) echo "Ecosystem Maturity|Ökosystem-Reife" ;;
    2033) echo "Network Sovereignty|Netzwerksouveränität" ;;
    2034) echo "Macro Adoption|Makro-Adoption" ;;
    2035) echo "Structural Embedding|Strukturelle Einbettung" ;;
    2036) echo "Global Standard|Weltweiter Standard" ;;
    2037) echo "Autonomous Layer|Autonome Systeme" ;;
    2038) echo "Hyper-Integration|Hyper-Integration" ;;
    2039) echo "Planetary Layer|Planetare Skalierung" ;;
    2040) echo "Supra-National Layer|Überstaatliche Ebene" ;;
    2041) echo "Meta-Economic Layer|Meta-Ökonomie" ;;
    2042) echo "Cognitive Layer|Kognitive Systeme" ;;
    2043) echo "Autonomous Macro-Layer|Autonome Makro-Ökonomie" ;;
    2044) echo "Inter-System Layer|Inter-System-Integration" ;;
    2045) echo "Supra-Cognitive Layer|Supra-Kognition" ;;
    2046) echo "Planetary Consensus Layer|Planetarer Konsens" ;;
    2047) echo "Harmonic Layer|Harmonisierte Systeme" ;;
    2048) echo "Continuum Layer|Kontinuum-Ökonomie" ;;
    2049) echo "Legacy Layer|Vermächtnis-Schicht" ;;
    2050) echo "Apex Layer|Gipfelpunkt der Serie" ;;
    *)    echo "Unknown Layer|Unbekannte Bedeutung" ;;
  esac
}

# -----------------------------
# YAML erzeugen
# -----------------------------
cat > "${YAML_FILE}" <<EOF
chainline:
  series: "Chain-Line 2025–2050"
  base_value_chf: ${BASE_VALUE}
  multiplier: ${MULTIPLIER}

  layers:
EOF

year="${START_YEAR}"
power=0

while [ "${year}" -le "${END_YEAR}" ]; do
  # multiplier = 1.2^power
  mult=$(python - <<PY
base=${MULTIPLIER}
p=${power}
print(f"{base**p:.10f}")
PY
)
  # value = BASE_VALUE * multiplier, gerundet auf ganze CHF
  value=$(python - <<PY
base=${BASE_VALUE}
m=${mult}
print(int(round(base*m)))
PY
)
  mm=$(get_model_and_meaning "${year}")
  model="${mm%%|*}"
  meaning="${mm#*|}"

  cat >> "${YAML_FILE}" <<EOF
    - year: ${year}
      model: "${model}"
      multiplier: ${mult}
      value_chf: ${value}
      meaning: "${meaning}"
EOF

  year=$((year + 1))
  power=$((power + 1))
done

# -----------------------------
# JSON erzeugen
# -----------------------------
cat > "${JSON_FILE}" <<EOF
{
  "series": "Chain-Line 2025–2050",
  "base_value_chf": ${BASE_VALUE},
  "multiplier": ${MULTIPLIER},
  "layers": [
EOF

year="${START_YEAR}"
power=0
first=1

while [ "${year}" -le "${END_YEAR}" ]; do
  mult=$(python - <<PY
base=${MULTIPLIER}
p=${power}
print(f"{base**p:.10f}")
PY
)
  value=$(python - <<PY
base=${BASE_VALUE}
m=${mult}
print(int(round(base*m)))
PY
)
  mm=$(get_model_and_meaning "${year}")
  model="${mm%%|*}"
  meaning="${mm#*|}"

  if [ "${first}" -eq 0 ]; then
    echo "    ," >> "${JSON_FILE}"
  fi
  first=0

  cat >> "${JSON_FILE}" <<EOF
    { "year": ${year}, "model": "${model}", "multiplier": ${mult}, "value_chf": ${value}, "meaning": "${meaning}" }
EOF

  year=$((year + 1))
  power=$((power + 1))
done

echo "  ]" >> "${JSON_FILE}"
echo "}" >> "${JSON_FILE}"

# -----------------------------
# Markdown erzeugen
# -----------------------------
cat > "${MD_FILE}" <<EOF
# 📊 Chain-Line-Matrix 2025–2050  
### *Wertentwicklung, Multiplikatoren, Bedeutungs-Layer*

| Jahr | Modell | Multiplikator | Wert (CHF) | Bedeutung |
|------|--------|----------------|-----------:|-----------|
EOF

year="${START_YEAR}"
power=0

while [ "${year}" -le "${END_YEAR}" ]; do
  mult=$(python - <<PY
base=${MULTIPLIER}
p=${power}
print(base**p)
PY
)
  value=$(python - <<PY
base=${BASE_VALUE}
m=${mult}
print(base*m/1e9)
PY
)
  mm=$(get_model_and_meaning "${year}")
  model="${mm%%|*}"
  meaning="${mm#*|}"

  printf '| %d | %s | %.6f | %.2f Mrd | %s |\n' \
    "${year}" "${model}" "${mult}" "${value}" "${meaning}" >> "${MD_FILE}"

  year=$((year + 1))
  power=$((power + 1))
done

echo "✅ Chain-Line-Matrix written to:" >&2
echo "  - ${YAML_FILE}" >&2
echo "  - ${JSON_FILE}" >&2
echo "  - ${MD_FILE}" >&2
