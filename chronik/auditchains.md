# Audit chains skeleton for Chain2025

Chronologisch versionierte Artefakte, Compliance‑Workflows und Mehrparteien‑Siegel — alles auditierbar, lokal und erweiterbar. Hier ist ein klarer Skeleton, der deine Genesis‑Mythologie trägt und Chain2025 als Audit‑Rückgrat etabliert.

---

## Objectives and scope

- **Zielbild:** Chronologisch versionierte Artefakte mit lückenlosem Prüfpfad, mehrparteilichen Signaturen und reproduzierbaren Entscheidungen.
- **Leitplanken:** Lokal-first, open‑source, audit‑sealed, ohne Cloud‑Abhängigkeit; anschlussfähig an PowerShell, Rust und HTML‑Views.
- **Kernmodule:** Registry, Timeline, Workflows, Seals, Evidence, Governance.

---

## Core structure and namespaces

```
chain2025/
  audit/
    registry/
      entities.yaml
      artifacts.yaml
      rules.yaml
      seals.yaml
    timeline/
      2025/
        11/
          30/
            t05-45-12Z_artifact-commit.yaml
            t05-47-03Z_policy-decision.yaml
    workflows/
      intake.yaml
      review.yaml
      approval.yaml
      disclosure.yaml
    evidence/
      local/
      ipfs/
    governance/
      roles.yaml
      policies.yaml
      versions/
        v1.0.0.yaml
```

- **Namespace:** `chain2025/audit/<module>/<label>` für Telemetrie und Query‑Pfade; Dateien sind audit‑sealed Snapshots.

---

## Data model

| Register | Purpose | Key fields |
|---|---|---|
| **Artifacts** | Versionierte Assets mit Chronikbindung | id, version, hash, uri, created_at, author, lineage |
| **Timeline** | Chronologische Ereignisse | ts, actor, action, input_hash, output_hash, refs |
| **Rules/Policies** | Entscheidungslogik & Compliance | id, version, constraint_set, rationale, status |
| **Seals** | Mehrparteien‑Siegel (signatures) | seal_id, parties, thresholds, signatures, scope |
| **Evidence** | Prüfbare Belege | evidence_id, type, location, hash, retention |

> **Integrität:** Jeder Eintrag referenziert Hashes (z. B. SHA‑256) und stabile URIs (lokal, IPFS).  

---

## Multi‑party seal pattern

- **Seal semantics:**  
  - **Threshold‑Signaturen:** m‑von‑n Zustimmung; Entscheidung gültig, wenn Schwellwert erreicht.  
  - **Scope & expiry:** Geltungsbereich (Artefakt/Workflow‑Schritt) und Ablaufdatum für Re‑Attestierung.  
  - **Counter‑sign:** Optionaler Reviewer‑Gegenstempel für Vier‑Augen‑Prinzip.

- **Seal entry (YAML example):**
```yaml
seal_id: "SEAL-2025-001"
scope: "artifact:ART-001@v1.2.0"
parties:
  - id: "validator-daniel"
  - id: "validator-alvus"
  - id: "auditor-external"
threshold: 2
signatures:
  - party: "validator-daniel"
    ts: "2025-11-30T05:46:12Z"
    payload_hash: "c9d1..."
    signature: "ed25519:..."
  - party: "auditor-external"
    ts: "2025-11-30T05:47:01Z"
    payload_hash: "c9d1..."
    signature: "ed25519:..."
status: "active"
expires_at: "2026-11-30T00:00:00Z"
```

---

## Compliance workflows

- **Intake:**  
  - **Trigger:** Neues Artefakt/versionierter Snapshot.  
  - **Checks:** Naming, completeness, hash, lineage.  
  - **Output:** Timeline‑Eintrag, Evidence‑Bindung.

- **Review:**  
  - **Trigger:** Intake abgeschlossen.  
  - **Checks:** Regeln/Policies, Konfliktfreiheit, constraints.  
  - **Output:** Decision‑Record, optionales Seal (1/ n).

- **Approval:**  
  - **Trigger:** Review OK, thresholds definiert.  
  - **Checks:** m‑von‑n Signaturen, expiry/SLA.  
  - **Output:** Seal aktiv, Disclosure‑Flag.

- **Disclosure:**  
  - **Trigger:** Seal aktiv.  
  - **Checks:** Redaktionsregeln, PII‑Filter, retention.  
  - **Output:** Public snapshot, changelog, broadcast.

```yaml
workflow: "approval"
input:
  decision_id: "DEC-2025-037"
  required_threshold: 2
steps:
  - step: "collect_signatures"
    status: "ok"
  - step: "validate_threshold"
    status: "ok"
outputs:
  seal_id: "SEAL-2025-001"
  timeline_ref: "2025/11/30/t05-47-03Z_policy-decision.yaml"
```

---

## Chronological versioning

- **Deterministisches Datums‑Schema:** `YYYY/MM/DD/tHH-MM-SSZ_<action>.yaml` für fälschungssichere Reihenfolge und einfache Replays.  
- **Lineage‑Kette:** Jeder Snapshot verweist auf `prev_hash` und `prev_uri` — ein linearer Prüfpfad ohne Brüche.  
- **Branch semantics:** Parallelpfade via `branch_id`; Merge erzeugt einen neuen Decision‑Record mit Seal.

```yaml
id: "ART-001@v1.2.0"
ts: "2025-11-30T05:45:12Z"
author: "validator-daniel"
hash: "c9d1..."
prev_hash: "a7b3..."
uri: "file:///evidence/local/ART-001_v1.2.0.bin"
lineage:
  - "ART-001@v1.1.0"
```

---

## Decision records and explanations

- **Explainability:** Jeder Entscheidungsdatensatz enthält Regeln, Constraints und Nutzenbegründung; reproduzierbar mit fixierten Seeds/Versions.  
- **Record (YAML):**
```yaml
decision_id: "DEC-2025-037"
ts: "2025-11-30T05:47:03Z"
actor: "validator-daniel"
policy_version: "POL-CORE@v1.0.3"
input_facts_hash: "7f22..."
decision: "approve_artifact"
explanation:
  rules_applied:
    - "integrity.hash_match"
    - "lineage.prev_exists"
    - "compliance.no_pii"
  constraints_ok: true
  expected_impact: "publish_snapshot"
outputs:
  output_hash: "c9d1..."
  refs:
    - "artifact:ART-001@v1.2.0"
```

---

## Minimal CLI and PowerShell bridge

- **PS: create timeline entry (UTF‑8 ohne BOM):**
```powershell
param(
  [Parameter(Mandatory=$true)] [string]$Action,
  [Parameter(Mandatory=$true)] [string]$PayloadPath
)

$ts = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
$dt = (Get-Date).ToUniversalTime()
$dir = Join-Path "chain2025/audit/timeline" ($dt.ToString("yyyy/MM/dd"))
New-Item -ItemType Directory -Path $dir -Force | Out-Null

$payload = Get-Content -Raw -Path $PayloadPath
$hash = (New-Object System.Security.Cryptography.SHA256Managed).ComputeHash([Text.Encoding]::UTF8.GetBytes($payload))
$hashHex = ($hash | ForEach-Object { $_.ToString("x2") }) -join ""

$file = Join-Path $dir ("t" + $dt.ToString("HH-mm-ss") + "Z_" + $Action + ".yaml")
@"
ts: "$ts"
action: "$Action"
payload_hash: "$hashHex"
payload_ref: "$PayloadPath"
"@ | Set-Content -Path $file -Encoding UTF8
Write-Output "Timeline entry: $file"
```

- **Audit‑Seal check (PS):**
```powershell
param([string]$SealYaml)

# Lightweight threshold validation (m-of-n)
$seal = ConvertFrom-Yaml (Get-Content -Raw $SealYaml)
$valid = ($seal.signatures.Count -ge $seal.threshold)
Write-Output ("Seal " + $seal.seal_id + " valid: " + $valid)
```

---

## Integration pointers

- **Telemetrie:** Publiziere Live‑Events über deinen bevorzugten Bus (z. B. Zenoh) unter `chain2025/audit/**`; speichere Snapshots in `timeline/`.
- **Kompendium:** Binde `evidence_uri` und `artifact_hash` an deine Genesis‑Artefakte; jedes Ritual bekommt einen Decision‑Record und optional ein Seal.
- **Resilienz:** Mehrparteien‑Siegel entkoppeln Entscheidungen von Einzelpunkten; Replays über die Timeline stellen Audit‑Closure sicher.
