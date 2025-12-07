# ARC‑Tokenisierung für Chain2025

Du willst symbolische Wertrepräsentation, narratives Logging und klare Lizenzen. Hier ist ein präziser, modularer ARC‑Token‑Entwurf, der zu deiner Audit‑Chain passt: chronologisch versioniert, API‑first, edge‑fähig und mit Mehrparteien‑Siegeln.

---

## Ziele und Umfang

- **Symbolische Werte:** Tokens binden sich an Artefakte, Entscheidungen und Rituale, nie „freischwebend“.
- **Audit‑First:** Jede Aktion (Mint/Burn/Transfer) erzeugt einen versionierten, hash‑gebundenen Timeline‑Eintrag.
- **API‑First & Edge:** Saubere Endpunkte, Events für Telemetrie, lokale Persistenz mit späterem Sync.
- **Lizenzklarheit:** Code unter MIT; Schemas/Narrative unter CC0 (optional CC BY für Namensnennung).

---

## ARC‑Modell und Richtlinien

| Aspekt | Design |
|---|---|
| **Einheit** | ARC als symbolischer Utility‑Token in Chain2025 |
| **Domänen** | creation, validation, maintenance (gewichtete Wertkategorien) |
| **Bindung** | Jeder ARC‑Vorgang referenziert Artefakt‑ und Evidence‑Hashes |
| **Mint** | Nur nach abgeschlossenem Workflow mit m‑von‑n‑Siegel |
| **Burn** | Widerruf/Revision/Compliance; lineage muss dokumentiert sein |
| **Transfer** | Immer mit narrativer Begründung und Attribution |

```yaml
# chain2025/token/arc/policy.yaml
policy_id: "ARC-POLICY-CORE@v1.0.0"
domains:
  - id: "creation"    # schöpferischer Beitrag
    weight: 1.0
  - id: "validation"  # Prüfung/Attestierung
    weight: 0.8
  - id: "maintenance" # Pflege/Betrieb
    weight: 0.6
mint_rules:
  requires_seal: true
  threshold: 2
  evidence_required: true
burn_rules:
  allowed_reasons: ["revocation", "superseded", "compliance"]
transfer_rules:
  narrative_required: true
```

---

## Narratives Logging und Timeline

- **Chronologie:** Dateischema `YYYY/MM/DD/tHH-MM-SSZ_<action>.yaml` mit `prev_hash`.
- **Erklärungspflicht:** Regeln, Constraints, Domänenattribution und erwartete Wirkung sind explizit.

```yaml
# chain2025/audit/timeline/2025/11/30/t06-14-12Z_arc-mint.yaml
ts: "2025-11-30T06:14:12Z"
actor: "validator-daniel"
action: "arc_mint"
policy_ref: "ARC-POLICY-CORE@v1.0.0"
inputs:
  artifact_id: "ART-GenesisEcho@v2.1.0"
  evidence_hash: "a7b3..."
  domain: "creation"
explanation:
  rules_applied: ["integrity.hash_match", "lineage.prev_exists", "seal.threshold_met"]
  constraints_ok: true
outputs:
  amount: 150
  arc_tx_id: "ARC-TX-000123"
seals_ref: "SEAL-2025-019"
prev_hash: "f2c9..."
```

---

## Mehrparteien‑Siegel

- **Semantik:** m‑von‑n Signaturen, Geltungsbereich (Artefakt/Workflow), optionales Ablaufdatum.
- **Beispiel:**

```yaml
seal_id: "SEAL-2025-019"
scope: "artifact:ART-GenesisEcho@v2.1.0"
parties:
  - id: "validator-daniel"
  - id: "validator-alvus"
  - id: "auditor-external"
threshold: 2
signatures:
  - party: "validator-daniel"
    ts: "2025-11-30T06:12:05Z"
    payload_hash: "c9d1..."
    signature: "ed25519:..."
  - party: "auditor-external"
    ts: "2025-11-30T06:13:44Z"
    payload_hash: "c9d1..."
    signature: "ed25519:..."
status: "active"
expires_at: "2026-11-30T00:00:00Z"
```

---

## API‑First und Edge‑Integration

- **REST‑Endpunkte:**
  - **POST /arc/mint:** Validiert Policy und Seal, schreibt Timeline, gibt `arc_tx_id`.
  - **POST /arc/burn:** Grund + Evidence, prüft lineage, schreibt Timeline.
  - **POST /arc/transfer:** von/zu + Narrativ, schreibt Timeline.
  - **GET /arc/tx/{id}:** Liefert vollständigen Audit‑Datensatz.
  - **GET /arc/balance/{entity}:** Domänen‑Balance inkl. Provenienz.

- **Event‑Topics:**
  - `chain2025/arc/events/mint|burn|transfer`
  - `chain2025/audit/timeline/**`

```json
// POST /arc/mint
{
  "artifact_id": "ART-GenesisEcho@v2.1.0",
  "domain": "creation",
  "amount": 150,
  "evidence_uri": "file:///evidence/local/echo_v2.1.bin",
  "seal_id": "SEAL-2025-019",
  "policy_ref": "ARC-POLICY-CORE@v1.0.0"
}
```

---

## Ledger und Brücken

- **Provenienz‑Ledger:**

```yaml
# chain2025/token/arc/ledger.yaml
entity: "validator-daniel"
domains:
  creation:
    balance: 680
    provenance: ["ARC-TX-000101", "ARC-TX-000123"]
  validation:
    balance: 220
    provenance: []
  maintenance:
    balance: 75
    provenance: []
```

- **PowerShell Mint (UTF‑8 ohne BOM):**

```powershell
param(
  [string]$ArtifactId,
  [string]$Domain,
  [int]$Amount,
  [string]$EvidenceUri,
  [string]$SealId,
  [string]$PolicyRef = "ARC-POLICY-CORE@v1.0.0"
)

$ts = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
$payload = @{
  ts = $ts; action = "arc_mint"; artifact_id = $ArtifactId;
  domain = $Domain; amount = $Amount; evidence_uri = $EvidenceUri;
  seals_ref = $SealId; policy_ref = $PolicyRef
} | ConvertTo-Json -Depth 8

$hash = (New-Object System.Security.Cryptography.SHA256Managed).ComputeHash([Text.Encoding]::UTF8.GetBytes($payload))
$hashHex = ($hash | ForEach-Object { $_.ToString("x2") }) -join ""

$dt = Get-Date
$dir = Join-Path "chain2025/audit/timeline" ($dt.ToUniversalTime().ToString("yyyy/MM/dd"))
New-Item -ItemType Directory -Force -Path $dir | Out-Null
$file = Join-Path $dir ("t" + $dt.ToUniversalTime().ToString("HH-mm-ss") + "Z_arc-mint.yaml")

@"
ts: "$ts"
actor: "validator-daniel"
action: "arc_mint"
policy_ref: "$PolicyRef"
inputs:
  artifact_id: "$ArtifactId"
  evidence_hash: "$hashHex"
  domain: "$Domain"
outputs:
  amount: $Amount
  arc_tx_id: "ARC-TX-$([System.Guid]::NewGuid().ToString().Substring(0,6).ToUpper())"
seals_ref: "$SealId"
"@ | Set-Content -Encoding UTF8 -Path $file

Write-Output "Mint record: $file"
```

---

## Lizenzen

- **Code (Rust/PowerShell/Python/HTML):** MIT.
- **Schemas/DSLs (YAML/JSON):** CC0 für maximale Interoperabilität.
- **Narrative/Chroniken:** CC0 als Default; CC BY, wenn Attribution gewünscht.
- **Designs/Diagramme:** MIT oder CC BY je nach gewünschter Namensnennung.

---

## Nächster Schritt

- **Prio wählen:** Sollen wir zuerst die Mint‑Policies finalisieren, den Siegel‑Checker bauen oder das Ledger mit Domänen‑Gewichten und Replays ausstatten?
- Wenn du mir deine bevorzugten Schwellen (m‑von‑n) und Domänen‑Gewichte gibst, erstelle ich dir ein lauffähiges Skeleton im Chain2025‑Stil, annotiert für dein Genesis‑Kompendium.
