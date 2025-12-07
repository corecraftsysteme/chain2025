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
# Telemetrie und Audit für Chain2025 mit Zenoh (Rust)

Du willst verteilte Telemetrie, auditierbare Register und Resilienz — alles lokal, modular, und audit-sealed. Hier ist ein kompakter, erweiterbarer Bauplan, der zu deiner Genesis-Mythologie passt und Chain2025 als auditierbares, verteiltes Telemetriegewebe verankert.

---

## Architekturüberblick für verteilte Telemetrie

- **Ziel:** Veröffentlichen, abfragen und archivieren von Chain2025-Events (Node-Status, RPC-Checks, Payouts, Ritual-Logs) über ein verteiltes Zenoh-Netz, mit auditierbaren Registern und lokaler Persistenz.  
- **Paradigmen:** Pub/Sub für Live-Telemetrie; Query/Reply für Audit-Register-Abfragen und punktuelle Prüfungen. Zenoh vereint „data in motion“, „data at rest“ und „computations“ in einem Stack.

#### Topologie und Rollen

- **Rollen:** Peer, Router oder Client; wähle pro Knoten die Rolle über die Konfiguration (WhatAmI) je nach Netzlayout (Mesh, Star, Clique).  
- **Session:** Wurzelelement der API; via `open(config)` gestartet, deklariert Publisher, Subscriber, Querier, Queryable.

#### Schlüsselräume (Key Expressions)

- **Namensraum:** `chain2025/<domain>/<topic>/<label>` mit Wildcards wie `**` für Bereichsabdeckung (z. B. `chain2025/node/**`).  
- **Beispielkanäle:**  
  - `chain2025/node/sync/progress`  
  - `chain2025/rpc/health`  
  - `chain2025/audit/registers/<module>`  
  - `chain2025/chronik/events`  
  Zenoh adressiert Daten über Key Expressions, unterstützt Wildcards und liefert Samples mit Payload und Metadaten.

---

## Komponenten und Register

| Komponente | Zweck | Datenfluss |
|---|---|---|
| Telemetrie-Publisher | Sendet Live-Samples (Sync-Fortschritt, Fehler, Kompendium-Events) | Pub/Sub zu Subscribers |
| Audit-Register (Queryable) | Persistentes, auditierbares Register (YAML/JSON, lokal + Zenoh Storage) | Query/Reply |
| Liveliness-Monitor | Meldet Auftauchen/Verschwinden von Ressourcen | Events an `chain2025/monitor/liveliness` |
| Matching API-Nutzung | Bandbreite sparen: publiziere nur bei interessierten Abnehmern | Vor Publishes prüfen |
| Router/Peers | Verbindungsgewebe für resiliente Topologien | Mesh/Star/Hybrid |

> Sources: 

---

## Datenmodell und Auditierbarkeit

- **Register-Formate:**  
  - **Audit-Logs (YAML/JSON):** `timestamp`, `agent`, `ritual`, `artifact_hash`, `verdict`, `evidence_uri`.  
  - **Telemetry Samples:** `sample_id`, `key`, `payload_bytes`, `content_type`, `signature`, `chain_context`.  
- **Signaturen & Hashing:**  
  - **Lead-in:** **Integrity:** Jede Telemetrie kann optional signiert werden; Audit-Register referenzieren Artefakt-Hashes für Kompendium-Closure.  
- **Speicher:**  
  - **Lead-in:** **Geo-distributed storage:** Zenoh bietet verteilte Ablage und Abfragen; Queryables liefern registrierte Inhalte auf Anfrage.

---

## Rust-Implementierung mit Zenoh

#### Publisher: Live-Telemetrie senden

```rust
use zenoh::prelude::r#async::*;
use zenoh::Config;

#[tokio::main]
async fn main() -> zResult<()> {
    // Konfiguration: Peer/Router/Client je nach Topologie
    let mut config = Config::default();
    config.set_mode(Some(zenoh::WhatAmI::Peer));

    let session = zenoh::open(config).await?;
    let publisher = session.declare_publisher("chain2025/node/sync/progress").await?;

    // Beispielpayload (JSON)
    let payload = r#"{"height": 856123, "pct": 62.7, "peer_count": 12}"#;

    // Optional: Matching API — nur senden, wenn jemand lauscht
    if publisher.matching().await?.is_matched() {
        publisher.put(payload).await?;
    }
    Ok(())
}
```

- **Lead-in:** **Hinweis:** Publisher/Subscriber werden über die Session deklariert; Matching API kann Abnehmer prüfen und Ressourcen sparen. Zenoh vereint Pub/Sub und Query/Reply in einer Session.

#### Subscriber: Telemetrie empfangen

```rust
use zenoh::prelude::r#async::*;
use zenoh::Config;

#[tokio::main]
async fn main() -> zResult<()> {
    let session = zenoh::open(Config::default()).await?;
    let subscriber = session.declare_subscriber("chain2025/node/**").await?;

    loop {
        if let Some(sample) = subscriber.recv_async().await {
            let key = sample.key_expr().to_string();
            let data = String::from_utf8_lossy(sample.payload().to_vec().as_ref());
            println!("[{}] {}", key, data);
        }
    }
}
```

- **Lead-in:** **Wildcard-Flexibilität:** Key Expressions unterstützen Wildcards wie `**` für breite Themenräume; Samples tragen Payload und Metadaten.

#### Queryable: Audit-Register beantworten

```rust
use zenoh::prelude::r#async::*;
use zenoh::{Config, Sample};

#[tokio::main]
async fn main() -> zResult<()> {
    let session = zenoh::open(Config::default()).await?;
    // Registriere einen Queryable Endpunkt
    let _q = session.declare_queryable("chain2025/audit/registers/syncmonitor").await?
        .callback(|query| async move {
            // Lade auditierbares Register (z. B. aus lokaler Datei)
            let register = r#"{"module":"syncmonitor","entries":[{"ts":"2025-11-30T05:19Z","verdict":"ok"}]}"#;
            query.reply(Sample::new(query.key_expr().clone(), register)).await.ok();
        });
    futures::future::pending::<()>().await;
    Ok(())
}
```

- **Lead-in:** **Query/Reply:** Queryables veröffentlichen Daten on-demand; Querier kann gezielt Audit-Register abfragen.

#### Optional: uProtocol-Transport über Zenoh

- **Lead-in:** **uProtocol-Integration:** Wenn du standardisierte Serviceklassen und Transport-Semantik bevorzugst, existiert eine Rust-Transportbibliothek für uProtocol über Zenoh mit Beispielen für Publisher/Subscriber und RPC-Muster.

---

## Resilienz gegen Fehlerquellen

- **Topologie-Resilienz:**  
  - **Lead-in:** **Peers & Router:** Baue Mesh- oder Stern-Topologien; Router stabilisieren Weitverkehrsverbindungen, Peers sichern lokale Resilienz. Konfiguration über WhatAmI.  
- **Liveliness-Monitoring:**  
  - **Lead-in:** **Verfügbarkeit:** Nutze Liveliness, um Auftauchen/Verschwinden von Ressourcen zu erkennen und Reaktionspfade zu triggern (Fallbacks, Replays).  
- **Matching API:**  
  - **Lead-in:** **Backpressure-Avoidance:** Prüfe Zuhörer, bevor du sendest, und reduziere Last bei Netzkanten.  
- **Storage & Queries:**  
  - **Lead-in:** **Retry-friendly:** Geo-distributed Storage + Query/Reply unterstützen Wiederholungen und On-demand Rekonstruktionen von auditierten Zuständen.

---

## Chain2025-Integration und Kompendium-Anschluss

- **Namespace-Design:**  
  - **Lead-in:** **Deterministisch:** Verwende `chain2025/<module>/<topic>/<label>`; z. B. `chain2025/chronik/events/<agent>` und `chain2025/audit/registers/<module>`.  
- **Audit-Sealing:**  
  - **Lead-in:** **Artefakt-Hash:** Jede Publikation referenziert einen Artefakt-Hash im Kompendium; Register führen `evidence_uri` (lokal/IPFS), `signature`, `ritual_id`.  
- **Ritualisierte CLI-Brücken:**  
  - **Lead-in:** **PowerShell + Rust:** PowerShell sammelt lokale Beweise (Logs, Snapshots) und publiziert via Rust-Zenoh; beide Pfade sind annotiert und UTF-8 ohne BOM.  
- **Driftpunkt-Erweiterung:**  
  - **Lead-in:** **Offene Schleife:** Ergänze neue Module schrittweise: `syncmonitor`, `rpc-health`, `payout-ledger`, `chronik`. Jeder Schritt erzeugt ein auditierbares Register und eine Telemetrie-Leitung.
