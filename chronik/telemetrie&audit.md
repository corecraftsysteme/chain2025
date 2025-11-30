# Chain2025 – Telemetrie & Audit (Kurzfassung)

## Ziel
Ein verteiltes Telemetrie‑Gewebe für Chain2025, das Node‑Status, RPC‑Checks, Payouts und Ritual‑Logs transparent und audit‑sealed erfasst.

## Architektur
- **Paradigmen:** Pub/Sub für Live‑Telemetrie, Query/Reply für Audit‑Register  
- **Topologie:** Peers, Router, Clients – flexibel als Mesh, Stern oder Hybrid  
- **Namespace:** `chain2025/<domain>/<topic>/<label>` mit Wildcards (`**`) für breite Abdeckung  

## Komponenten
- **Telemetrie‑Publisher:** Live‑Samples (Sync, Fehler, Events)  
- **Audit‑Register (Queryable):** persistente YAML/JSON‑Register, lokal + Zenoh Storage  
- **Liveliness‑Monitor:** meldet Auftauchen/Verschwinden von Ressourcen  
- **Matching API:** sendet nur bei aktiven Abnehmern  

## Datenmodell
- **Audit‑Logs:** `timestamp`, `agent`, `artifact_hash`, `verdict`, `evidence_uri`  
- **Telemetry‑Samples:** `sample_id`, `key`, `payload`, `signature`, `chain_context`  
- **Integrität:** Signaturen & Hashes sichern Daten, Register referenzieren Artefakte  

## Implementierung (Rust + Zenoh)
- Publisher/Subscriber für Telemetrie  
- Queryable für Audit‑Register  
- Optional: uProtocol‑Transport für RPC‑Muster  

## Resilienz
- Mesh/Stern‑Topologien für Stabilität  
- Liveliness‑Monitoring für Verfügbarkeit  
- Matching API gegen Backpressure  
- Geo‑Storage + Queries für Wiederholungen und Rekonstruktionen  

## Integration mit Kompendium
- **Namespaces:** deterministisch (`chain2025/chronik/events`, `chain2025/audit/registers`)  
- **Audit‑Sealing:** Artefakt‑Hashes und Signaturen sichern Nachweise  
- **PowerShell‑Brücken:** lokale Beweise sammeln, UTF‑8 ohne BOM  
- **Driftpunkt‑Erweiterung:** neue Module (`syncmonitor`, `rpc-health`, `payout-ledger`, `chronik`) schrittweise ergänzen  

---
