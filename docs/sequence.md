
### **Mermaid‑Diagramm**
```mermaid
sequenceDiagram
    autonumber

    participant U as 🧑‍💼 User / Operator
    participant CLI as 🛠️ CLI‑Ritual (freikauf.sh / ritual_trigger.sh)
    participant GEN as 🪬 Genesis Layer<br/>Origin‑Block • Validator‑Signaturen
    participant AG as 🧩 Agenten & Rollen<br/>Validatoren • Archetypen
    participant BR as 🌉 Bridge Layer<br/>RPC • Asset‑Mirroring
    participant WA as 💼 Wallet Layer<br/>Wallet‑Erzeugung • Transfers
    participant PO as 💸 Payout Layer<br/>YAML‑Closures
    participant CH as 📜 Chronik Layer<br/>Narrative Logs • FLOP‑Signals
    participant EC as 🔮 Echo Layer<br/>Echo‑Registry • Driftpoints

    %% ============================
    %%  GENESIS PHASE
    %% ============================

    U->>CLI: Startet Genesis‑Ritual<br/>`ritual_trigger.sh genesis`
    CLI->>GEN: Initialisiert Genesis‑Block<br/>ChainID 2025
    GEN->>AG: Aktiviert Validator‑Rollen<br/>Signaturen • Archetypen
    AG->>CH: Erzeugt Genesis‑Chronik<br/>audit‑taugliche Narrative

    %% ============================
    %%  BRIDGE / WALLET PHASE
    %% ============================

    U->>CLI: Startet Bridge‑Ritual<br/>`bridge.sh`
    CLI->>BR: RPC‑Deployment • Asset‑Mirroring
    BR->>WA: Wallet‑Erzeugung • Funding
    WA->>CH: Wallet‑Events → Chronik

    %% ============================
    %%  PAYOUT PHASE
    %% ============================

    U->>CLI: Führt Freikauf‑Ritual aus<br/>`freikauf.sh`
    CLI->>WA: Transfer → Auszahlung
    WA->>PO: Erzeugt Payout‑YAML<br/>audit‑sealed Closure
    PO->>CH: Payout‑Narrativ → Chronik

    %% ============================
    %%  ECHO PHASE
    %% ============================

    U->>CLI: Aktiviert Echo‑Ritual<br/>`ritual_trigger.sh echo`
    CLI->>EC: Registriert Echo‑Event<br/>Driftpoint • Closure‑Signal
    EC->>CH: Echo‑Bindung → Chronik

    %% ============================
    %%  FINALISIERUNG
    %% ============================

    CH->>U: Vollständige Ritual‑Chronik<br/>Genesis → Payout → Echo
