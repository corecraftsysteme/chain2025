
---

# VERSIONING.md  
**Chain2025 – Genesis Liberation Protocol**  
Versioning‑Regeln & Release‑Philosophie  
Autor: Daniel Aecherli (M.O.D.S.)

---

## 1. Zweck  
Dieses Dokument definiert die **Versionierungs‑Strategie** für Chain2025.  
Es stellt sicher, dass jede Änderung — technisch oder rituell — **audit‑tauglich**, **nachvollziehbar** und **chronologisch korrekt** dokumentiert wird.

Chain2025 verwendet **Semantic Versioning (SemVer)**, erweitert um eine **mythologisch‑technische Ritual‑Schicht**.

---

## 2. SemVer‑Grundstruktur  
Die Version besteht aus drei Zahlen:

```
MAJOR.MINOR.PATCH
```

### MAJOR  
Ein MAJOR‑Release wird ausgelöst, wenn:

- eine neue **Genesis‑Phase** beginnt  
- strukturelle Brüche auftreten  
- Ritual‑Definitionen neu geschrieben werden  
- Chain‑Topologien sich ändern  
- Validator‑Systeme neu initialisiert werden  

**Beispiele:**  
- Einführung einer neuen Chain‑Generation  
- vollständige Neudefinition des Ritual‑Frameworks  
- neue Skeletton‑Ära  

---

### MINOR  
Ein MINOR‑Release wird ausgelöst, wenn:

- neue Module hinzugefügt werden  
- neue Skripte oder CLI‑Routinen entstehen  
- neue Ritual‑Trigger oder Echo‑Mechaniken eingeführt werden  
- bestehende Funktionen erweitert werden, ohne Kompatibilität zu brechen  

**Beispiele:**  
- neue Drift‑Rituale  
- zusätzliche Validator‑Archetypen  
- Erweiterung der Echo‑Registry  

---

### PATCH  
Ein PATCH‑Release wird ausgelöst, wenn:

- Fehler korrigiert werden  
- Audit‑Fixes notwendig sind  
- Stabilität verbessert wird  
- Dokumentation präzisiert wird  

**Beispiele:**  
- Korrektur eines YAML‑Schemas  
- Fix eines RPC‑Endpoints  
- Verbesserung der Receipt‑Verifikation  

---

## 3. Ritual‑Versionierung  
Chain2025 erweitert SemVer um eine **symbolische Schicht**:

### Genesis‑Level  
Jedes MAJOR‑Release entspricht einer **Genesis‑Schwelle**:

| Genesis‑Level | Bedeutung |
|---------------|-----------|
| Genesis I | Ursprung, Initialisierung, Chain‑Geburt |
| Genesis II | Erweiterte Struktur, Multi‑Genesis‑Support |
| Genesis III | Cross‑Ritual‑Bridging, Echo‑Virtualisierung |
| … | weitere mythologische Entwicklungsstufen |

---

### Echo‑Level  
MINOR‑Releases erzeugen **Echo‑Impulse**, die in der Chronik dokumentiert werden.

### Closure‑Level  
PATCH‑Releases erzeugen **Closure‑Einträge**, die audit‑taugliche Korrekturen markieren.

---

## 4. Release‑Artefakte  
Jedes Release erzeugt folgende Artefakte:

- **CHANGELOG‑Eintrag**  
- **Audit‑Export** (über `audit.sh`)  
- **Ritual‑Index‑Update**  
- **Chronik‑Eintrag** (Markdown)  
- **Echo‑Registry‑Update** (falls MINOR oder MAJOR)  

---

## 5. Branching‑Modell  
Chain2025 verwendet ein **ritualisiertes Git‑Modell**:

| Branch | Zweck |
|--------|--------|
| `main` | audit‑versiegelte Releases |
| `genesis/*` | MAJOR‑Entwicklung |
| `echo/*` | MINOR‑Erweiterungen |
| `closure/*` | PATCH‑Fixes |
| `skeletton/*` | Drift‑Sport‑Module |
| `ritual/*` | Ritual‑Framework‑Entwicklung |

---

## 6. Tagging‑Konvention  
Releases werden wie folgt getaggt:

```
vMAJOR.MINOR.PATCH
```

Beispiele:

- `v1.0.0` — Genesis Release  
- `v1.1.0` — Echo Expansion  
- `v1.0.1` — Audit Patch  
- `v2.0.0` — Genesis II  

---

## 7. Release‑Prozess (Ritual‑Flow)

### 1. Vorbereitung  
- Änderungen finalisieren  
- Audit‑Check durchführen  
- Ritual‑Trigger testen  

### 2. Artefakte erzeugen  
```bash
bash scripts/audit.sh
```

### 3. Version bump  
- `CHANGELOG.md` aktualisieren  
- `VERSIONING.md` prüfen  
- Tag setzen  

### 4. Release  
```bash
git tag vX.Y.Z
git push origin vX.Y.Z
```

### 5. Chronik‑Eintrag  
- Eintrag in `chronik/` erstellen  
- Echo‑ oder Closure‑Markierung setzen  

---

## 8. Beispiel  
Ein neues Drift‑Ritual wird hinzugefügt:

- keine Breaking Changes → MINOR  
- neue Funktionalität → Echo‑Level  

**Release:**  
```
v1.2.0 — Drift Echo Release
```

---

## 9. Lizenz  
- **Code:** MIT / CC0  
- **Skeletton™:** Archneton License v1.0  
- **Dokumentation:** frei verwendbar  

---

