# SECURITY.md  
**Chain2025 – Genesis Liberation Protocol**  
Technische Sicherheitsrichtlinien & Audit‑Mechanismen  
Autor: Daniel Aecherli (M.O.D.S.)  
Version: v1.0.0

---

## 1. Zweck  
Dieses Dokument definiert die technische Sicherheitsarchitektur von Chain2025.  
Es stellt sicher, dass alle Module, Wallets, Validatoren und Ritual‑Trigger audit‑tauglich, deterministisch und reproduzierbar bleiben.

---

## 2. Sicherheitsprinzipien  
- **Determinismus** – alle Abläufe sind reproduzierbar  
- **Audit‑Transparenz** – jede Aktion erzeugt ein prüfbares Artefakt  
- **Schlüssel‑Souveränität** – Private Keys verlassen nie das lokale System  
- **Modularität** – jedes Modul ist isoliert und signaturgebunden  
- **Ritual‑Bindung** – kritische Aktionen sind an rituelle Trigger gekoppelt  

---

## 3. Sicherheitsmechanismen  

### Validator‑Signaturen  
Alle Genesis‑, Closure‑ und Ritual‑Aktionen benötigen gültige Signaturen.

### Audit‑versiegelte Artefakte  
`audit.sh` erzeugt:  
- Release‑Hash  
- Artefakt‑Hashes  
- Audit‑Export  
- Signatur‑Protokolle  

### Wallet‑Sicherheit  
- lokale Schlüsselgenerierung  
- signaturgebundene Transfers  
- deterministische Receipt‑Verifikation  

### Ritual‑Framework  
- signaturgebundene Ritual‑Trigger  
- versionierte Echo‑Registry  
- unveränderliche Genesis‑Rituale  

### Payout‑Integrität  
- unveränderliche YAML‑Logs  
- audit‑taugliche Closure‑Dokumente  
- Chronik‑Einträge für jede Auszahlung  

---

## 4. Vulnerability Disclosure  
Bitte melde Sicherheitsprobleme **nicht öffentlich**.

Vertraulicher Kontakt:  
- 📧 security@corecraft.systems  
- 🔐 PGP Key: `security.asc`  
- ⏱ Antwortzeit: 72 Stunden  

Bitte angeben:  
- Beschreibung  
- betroffene Module  
- Reproduktion  
- potenzieller Impact  

---

## 5. Rechtlicher Rahmen  
- Swiss DLT Law  
- DSGVO / revDSG  
- FLOPS sind keine Finanzinstrumente  

---

## 6. Haftungsausschluss  
Der Betreiber übernimmt keine Haftung für externe Angriffe außerhalb der Chain‑Infrastruktur.

---

## 7. Symbolische Fußnote  
> *Sicherheit ist Struktur, nicht Kontrolle.*
