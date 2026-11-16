# beta.21 — Händleranzeige und bestätigte Bankbewegungen

## Tatsächlicher Ausgangsstand und Ursache

Basis: sauberer lokaler Branch codex/route-checkpoints, Commit d57fe6875ce81cf35a88b80ec5c755219d04d168. Neuer Branch codex/bank-flow. Originalauftrag: docs/tasks/BANK_FLOW_REQUEST.md. Keine offenen Voränderungen verworfen.

Der beta.20-Log zeigt `route_bank` (#2176, 18:00:03), danach `BANKFRAME_OPENED` (#2179, 18:00:17) und später Bank schließen (#2227). Das Foto zeigt die konkrete Empfehlung für einen Leinenstoff. Im damaligen Code existierte ausschließlich eine dynamische Empfehlung mit „Bankmaterialien anzeigen“: Der generische Route-Knopf öffnete die Routenansicht, **keine Verschiebung wurde angefordert**. Es fehlte also ein ausführender Zustandsübergang; das war kein belegter verlorener Bank-Bestätigungsreply. Erst manuelles Verschieben oder Zurückstellen konnte die Empfehlung beseitigen.

Beim Händler erzwingt UnifiedUI.vendorBuyEvent nach MERCHANT_SHOW `refreshNextStep(true)`. Der Force-Pfad löst die Guide-Ausblendung und kann ihn wieder anzeigen. Weitere Waren-/Giftmeldungen aktualisieren denselben Guide. Separat führt der tatsächliche TRADE_SKILL_SHOW-Aufruf über onProfessionOpened zu Einlesen/Guide-Anzeige. Diese Funktion erzeugt keinen neuen Routenauftrag; der bestehende Auftrag bleibt bei Berufsaufrufen erhalten.

## Gespeicherte Händleroption

Einstellungen → Allgemein: **Beim Händler automatisch öffnen / Automatically open at merchants**. Standard an erhält bisheriges Verhalten. Aus hält einen geschlossenen Guide bei Besuchen, Warenupdates und nach dem anschließenden Schließen des Händlers geschlossen. Ein bloß durch Force zurückgesetzter Dismiss-Status darf ihn nicht beim nächsten Sekundenpoll öffnen.

Die Sperre betrifft die automatische Anzeige, nicht Händlererkennung, Preisbeobachtung, Auftrags-/Inventarfortschritt oder erlaubte Einkäufe. `/cdj`, manuelles Öffnen der Einstellungen und das echte Öffnen des Berufs sind ausdrückliche Anzeigewege. Sie heben die Sitzungssperre auf und setzen denselben Auftrag fort. Der Schalter liegt in den vorhandenen gespeicherten Optionen und überlebt Initialisierung/Reload.

## Bankablauf

Bei passender geöffneter persönlicher Bank: **Bankmaterialien einlagern**. Ein Nutzerklick startet den geplanten Stapelauftrag. Nach jeder bestätigten Bewegung wird die nächste passende Bewegung verarbeitet, soweit der Client dies erlaubt. Unterstützt der Client weitere programmgesteuerte Schritte nicht, bleibt eine klare Ablehnungs-/Klickanweisung; es wird kein Schutz umgangen.

1. Aktiven eigenen Routenauftrag und aktuellen Bedarf prüfen; nur echten Überschuss für spätere Abschnitte verwenden. Bank-/Kauf-/Craft-Sperren erhalten.
2. Persönliche Container über C_Bank.FetchPurchasedBankTabData(Character) bestimmen; bei älterer Bankdarstellung abgesicherte Bankcontainergrenzen verwenden. Keine Gilden- oder Accountbank als Ausweichziel verwenden.
3. Ziel bevorzugt passender vorhandener Stapel, dann freier kompatibler Platz. Item-ID/Link, Maximalstapel, Sperre und Taschenfamilie beachten. Wenn ein Material keinen Platz hat, andere noch passende Materialien trotzdem verarbeiten.
4. Bei Bedarf genau die Teilmenge aufnehmen. Nach dem Aufnehmen das Ziel erneut prüfen: Ein durch TSM oder andere Aktionen geänderter Zielplatz darf keinen fremden Gegenstand auf den Cursor tauschen.
5. Eine Bewegung erst abschließen, wenn die angeforderte Menge im Quellbestand fehlt **und** im Zielbestand hinzugekommen ist. Ereignisse sind Benachrichtigungen, kein Mengenbeweis. Teil-/Doppel-/verspätete Meldungen dürfen den Auftrag nicht duplizieren.
6. Danach aktuelle Bestände einlesen und den Guide fortsetzen. Bei vorhandenen Craftzutaten direkt Herstellung. Benötigt ein späterer Abschnitt Bankmaterial, dieselbe Verarbeitung in Gegenrichtung mit **Bankmaterialien entnehmen** verwenden.

Belegfall: Acht Leinenstoff in Taschen, sieben aktueller Bedarf, einer späterer Bedarf → exakt einen verschieben, sieben bleiben. Bereits vorhandener Bankbestand wird abgezogen. Keine Einkäufe oder Crafts aus geschätzten Bewegungen ableiten.

## Status und Unterbrechungen

- **Bank voll:** alle noch zulässigen Stapel-/Leerplätze geprüft; mögliche Teilmenge wurde verarbeitet. Konkrete Restmengen bleiben im Auftrag. Nach Freimachen kann derselbe autorisierte Auftrag auf dem nächsten Bestandsereignis fortsetzen. Für Entnahme entsprechend **Taschen voll**.
- **Bank geschlossen / falsche Bank:** keine weiteren Bewegungen. Offener Bewegungsnachweis bleibt erhalten; nach Öffnen erst prüfen, dann auf Nutzerklick bei tatsächlichem Rest fortfahren.
- **Gesperrt / Daten fehlen:** nicht als volle Bank ausgeben.
- **Abgelehnt / weiterer Klick nötig:** keinen Erfolg behaupten. Nur den selbst aufgenommenen Gegenstand an unveränderte Quelle zurücklegen; einen vorher belegten Cursor überhaupt nicht übernehmen.
- **Unbestätigt nach fünf Sekunden:** keine automatische Wiederholung derselben Menge. Erst spätere tatsächliche Bestandsbelege können den offenen Schritt bestätigen. Ein unbekannter Serverzustand wird nicht allein durch einen Timeout als abgelehnt angenommen.
- Reload initialisiert keine alte automatische Klickfreigabe neu. Offene Nachweise bleiben im charakterbezogenen Zustand erhalten.

Während einer ausstehenden Bewegung prüft OnUpdate nur die Deadline; Inventarbestätigungen erfolgen ereignisgetrieben. Keine wiederholten vollen Bankslot-Scans pro Frame. Falls eine verspätete Bestätigung während einer nativen Craftserie eintrifft, wird der schwere Inventarcapture bis nach der Serie zurückgestellt.

## API-/TSM-Prüfung

Lokale primäre Clientquellen (Blizzard-UI 1.60.1.70938):

- Blizzard_APIDocumentationGenerated/ContainerDocumentation.lua: C_Container.PickupContainerItem, SplitContainerItem, GetContainerItemInfo und GetContainerNumFreeSlots.
- Blizzard_APIDocumentationGenerated/BankDocumentation.lua: C_Bank.CanUseBank, FetchPurchasedBankTabData und Character-Banktyp.
- Blizzard_UIPanels_Game/Camelot/BankFrame.lua: Bankcontainer aus tabData.ID, bankType und Container-Slots.

Die lokale TSM-Containerabstraktion behandelt Forever mit zusätzlichem Reagenzbeutel und eigenen Character-Bank-Slotgrenzen; TSM kann die native Bankansicht verlagern. CraftDeja verwendet deshalb Bankereignisse, persönliche Bankberechtigung und Containerdaten, **keine BankFrame:IsShown()-Bedingung** und keine TSM-Gruppen-/Automove-Interna. Es wurde kein TSM-Code übernommen. Diese Quellprüfung und die kontrollierte Schnittstellensimulation sind noch keine Live-Zusicherung für jede TSM-Konfiguration.

## Automatisierte Abnahme

tests/BankFlowSuite/bank-flow.test.wowlua verwendet die echten CraftDeja-Module. Simuliert werden Client-APIs, Slot-/Cursorantworten, Warenangebot, native UI-Schaltfläche, Zeit und Ereignisse. Der vorbereitete gespeicherte Routenauftrag und Markt-/Clientdaten sind explizite Fixtures, keine aufgenommenen echten Serverantworten.

17 gezielte Prüfungen umfassen Händler an/aus/Reload/Besuche/Updates/manuelles Öffnen, Berufsaufruf während und nach Bankbewegungen, Leinenstoff 8→7+1, mehrere Materialien, Aufteilen, Zusammenlegen, Teilkapazität, volle Bank/Taschen, Schließen/Reopen, verzögerte/doppelte Antworten, fremden Cursor, Ablehnung, unbestätigten Schritt, verändertes Ziel und schweren Capture während Crafting. UI-Texte DE/EN werden geprüft und gerendert.

Drei vollständige Durchläufe prüfen nach jeder Phase den Guide und Mengen: Beruf → bestehender Auftrag → bestätigter Händlerkauf mit Packungsrundung auf acht Stoff → Bank → aktuelle native Craftserie → späteres Material aus Bank → nächste native Herstellung → Ziel erreicht. Je ein Durchlauf mit Option an und aus; dritter Durchlauf mit Teilentnahme bei vollen Taschen und Fortsetzung nach Platzgewinn. Die Auftrags-ID bleibt gleich; aktueller Skill und Bestände treiben die Fortsetzung.

Der abschließende breite Windows/Camelot-Nachweis steht in TEST_RESULTS.md. Zwischenberichte mit Fixture-Typ-/Ereignisfehlern sind keine Freigabe. Source-Emulation führt das kompilierte Release-Paket nicht direkt aus.

## Konkreter Live-Test mit Forever und TSM

1. Schalter aus, CraftDeja schließen, Händler öffnen/aktualisieren/erneut besuchen: bleibt geschlossen. `/reload` und wiederholen. Manuell `/cdj` öffnen und nötiges Material kaufen. Schalter an: neuer Händlerbesuch öffnet wie bisher.
2. Beruf vor und nach Bankschritt anklicken: gleiche Route, tatsächlicher Skill, gleiche offenen Mengen. Kein neuer Auftrag und kein Verlust der bereits bestätigten Beschaffung.
3. Persönliche Bank mit TSM öffnen. Einlagerung starten: exakt angezeigte Mengen, aktueller Bedarf bleibt in Taschen. Vorhandenen Stapel auffüllen, weitere Materialien einlagern. Nach letzter Bestätigung muss der Guide automatisch Herstellung zeigen.
4. Teilweise volle Bank, volle Bank und freien Platz nachträglich prüfen. Bank während einer ausstehenden Bewegung schließen/reopen. Status und Rest müssen passen; kein doppeltes Einlagern. Bei Klickanforderung weiteren Spieler-Klick verwenden und Diagnose prüfen.
5. Aktuelle Serie selbst am nativen Knopf starten. Späteren Abschnitt erreichen, Bankentnahme starten, danach Herstellung fortsetzen. Volle Taschen entsprechend freimachen. Erzeugt der reale Client eine Schutz-/TSM-Meldung, diesen konkreten Ablauf und frischen Log liefern; keine erfolgreiche Live-Abnahme vorwegnehmen.


Finaler Nachweis: reports/tests/20261116-183835-968304.zip, 589/0/0, 290.54s. Unveränderte beta.20: reports/bank-flow-baseline/beta20/reports/tests/20261116-183822-0efa7f.zip, 0/1/0, erwarteter Bank-Aktionsfehler. 374 Quell-/Test-/Inputprüfsummen mit finalem Stand identisch. UI-Belege: reports/tests/20261116-183335-c8011c.zip (16 Fälle vor letzter direkter Aktionsregression).
