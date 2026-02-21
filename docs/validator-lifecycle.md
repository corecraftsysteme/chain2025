stateDiagram-v2
    [*] --> Registrierung

    Registrierung: Validator wird im Registry-System erfasst
    Registrierung --> Archetyp_Zuweisung

    Archetyp_Zuweisung: Archetyp & Rolle werden vergeben
    Archetyp_Zuweisung --> Aktiv

    Aktiv: Validator ist voll funktionsfähig
    Aktiv --> Ritual_Trigger : löst Ritual aus
    Aktiv --> Signatur : signiert Ereignis
    Aktiv --> Chronik_Bindung : bestätigt Chronik
    Aktiv --> Driftpoint_Registrierung : (falls Drift-Träger)
    Aktiv --> Audit_Export : (falls Archivist)

    Ritual_Trigger: Validator initiiert Genesis/Closure/Echo/Drift/Bridge
    Ritual_Trigger --> Signatur

    Signatur: Validator bestätigt das Ritual
    Signatur --> Chronik_Bindung

    Chronik_Bindung: Ereignis wird narrativ verankert
    Chronik_Bindung --> Audit_Export

    Driftpoint_Registrierung: Drift-Träger erzeugt Bewegung & Echo
    Driftpoint_Registrierung --> Chronik_Bindung

    Audit_Export: Artefakte werden versiegelt
    Audit_Export --> Aktiv

    Aktiv --> Suspendiert : temporär deaktiviert
    Suspendiert --> Aktiv : Reaktivierung

    Aktiv --> Retired : endgültig außer Dienst
    Retired --> [*]
