# CraftDeja — Arbeitsregeln

Vor Änderungen PROJECT_STATE.md, DECISIONS.md und ROADMAP.md lesen und mit aktuellem Code abgleichen.
Die Benutzeranweisungen haben Vorrang. Notizen sind Kontext, kein Ersatz für eine Codeprüfung.
Version und Zielpfad prüfen; keine Rückkehr zum veralteten 3.8.0-Projekt.
Nach fachlichen Änderungen passende breite Testsuite ausführen, Ergebnisse versionsbezogen dokumentieren.
Implementierte Funktionen, Entwicklerangaben, beobachtete Live-Fälle und geplante Änderungen sauber unterscheiden.
Während laufender nativer Craft-Serien keine schweren vollständigen Scans wieder einführen.
DE/EN, konkrete CTA und optionale Detailansichten erhalten. Stückzahlregeln und Gift-Sonderfälle beachten.
Bei Code-/Dokumentwiderspruch nicht aus Erinnerung entscheiden: Ursache prüfen, beide konsistent korrigieren.
Vor Übergabe PROJECT_STATE.md und ROADMAP.md aktualisieren. Nichts ungeprüft als erledigt markieren.

Bei allen künftigen Windows-Testläufen tools/Test-CraftDeja.ps1 verwenden: jeder Lauf erzeugt automatisch Bericht, vollständiges Protokoll, Metadaten und eine teilbare ZIP, auch bei Fehlern. Berichte lokal unter reports/tests/ belassen; nicht automatisch veröffentlichen. Isolierte Entwicklerläufe ebenfalls mit Protokoll und klarem Prüfumfang dokumentieren.
