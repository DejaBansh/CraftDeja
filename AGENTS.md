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

Übergaberegel: Bei Arbeitsbeginn Branch, Commit, offene Änderungen und CONTINUE.md prüfen. Bei Abschluss CONTINUE.md mit Änderungen, Testnachweisen, offenen Fehlern und nächstem Schritt aktualisieren.

Kontextpflege: tools/Get-ProjectContext.ps1 -AsJson ist der lokale lesende Einstieg; er ersetzt weder Remote-Prüfung noch Live-Test. CONTINUE.md bleibt eine kurze aktuelle Übergabe, PROJECT_STATE.md eine Momentaufnahme, DECISIONS.md enthält geltende Gründe, ROADMAP.md nur nächste Schritte. Offene Fehler/Live-Abnahmen mit festen IDs in docs/OPEN_ITEMS.md, Testnachweise in docs/evidence/index.json pflegen. Keine Statusblöcke mehrfach kopieren; Historie nach docs/archive/ auslagern und klar als historisch kennzeichnen. Fehlende lokale Berichte ausdrücklich nennen. Geprüfte Hashes, Test-Basiscommit, Release-Commit und Arbeits-HEAD nicht gleichsetzen. Bei reinem Dokumentations-/Kontextwerkzeugauftrag keine neue Addoninstallation oder Veröffentlichung ableiten. Orientierung und Pflegeablauf: docs/ARCHITECTURE.md und docs/PROJECT_CONTEXT.md.

Installationswunsch des Nutzers (15.11.2026): Neue, erfolgreich geprüfte CraftDeja-Versionen direkt in die lokale Forever-Installation installieren. Vorher einen klaren Hinweis geben, dass WoW vollständig beendet werden muss; keine zusätzliche Bestätigungsfrage zur bereits erteilten Installationsfreigabe stellen. Vor jedem Ersetzen die vollständige Prozesssicht prüfen (WowUp-CF ist ein Addonmanager, kein Spielclient). Bei laufendem WoW warten, den Client nicht selbst beenden. Vorheriges Addon vollständig sichern und Backup per Dateiprüfsummen verifizieren; danach installierte Version und Builddateien prüfen und automatisch einen lokalen teilbaren Installationsbericht erzeugen. Diese Freigabe umfasst keine Veröffentlichung und keinen Merge nach main.

Spielbetrieb und Uploadpakete ausschließlich mit dem Buildprofil release erstellen/installieren. Vor Übergabe prüfen, dass keine automatische __wl.prof/__wl.mon/__wl.perf-Instrumentierung und keine wowlua-Dev-Runtime im Spielerpaket enthalten sind. Dev-Builds bleiben ausdrücklich bezeichneten Entwicklervergleichen vorbehalten. Die optionale /cdj-perf-Aufnahme bleibt standardmäßig aus. Hintergrund: beta.17-Dev verursachte im Nutzervergleich Freezes, gleicher Release-Code lief flüssig; ein bestimmter GC-/Speichermechanismus ist damit nicht bewiesen. Buildprofil release ist keine automatische stabile Produktfreigabe; Beta-Dateien als Beta kennzeichnen.
