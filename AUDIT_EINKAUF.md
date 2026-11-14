# Prüfung des AH-Kaufablaufs — 3.4.0-beta.4

## Was im bisherigen Code schiefgehen konnte

1. Die Restmenge wurde nach Käufen bei einer neuen Kalkulation erneut aus der
   sichtbaren Fehlmenge aufgebaut. Bei verspätetem Bestands-/Postabgleich konnte
   dadurch derselbe Bedarf wieder freigegeben werden.
2. Nur COMMODITY_PURCHASED führte zum Mengeneingang. Ein Client, der lediglich
   COMMODITY_PURCHASE_SUCCEEDED meldet, konnte damit ohne bestätigten Zähler bleiben.
   Ob genau diese Eventfolge bei den vier gemeldeten Käufen auftrat, ist ohne
   damaliges Spiellog nicht rückwirkend feststellbar.
3. Eine Bestätigung reservierte die Menge nicht vor dem API-Aufruf. Zwischen Klick
   und Serverantwort durfte daher kein verlässlicher neuer Kauf angeboten werden.
4. Der native Kaufdialog konnte die alte Zweiermenge nach Erledigung beibehalten.
5. Ein beliebiger Taschenzugang konnte bestätigte Postbestände fälschlich abbauen.
   Bankabhebungen oder Beute sind jedoch kein Nachweis einer Postentnahme. Das
   wurde auf Postentnahmen und das direkte Lieferfenster nach einem Kauf begrenzt.
6. Die Preisgrenze und Rezeptbewertung verwendeten weiterhin das Vollscan-Minimum,
   obwohl im Kaufdialog bereits neue Angebote oder ein neues Preisangebot vorlagen.

## Korrigierter Ablauf

Plan und Fehlmengen berechnen -> Budget einmal freigeben -> aktuelle Angebote laden
-> Livepreise/Route neu bewerten -> Menge/Preis anzeigen -> explizit bestätigen
-> Menge bis zum Ergebnis reservieren -> tatsächlichen Erfolg/Fehler verbuchen
-> Restmenge reduzieren bzw. bei bestätigtem Fehler wieder freigeben.

Ein ausgelaufener, unbestätigter Vorgang wird NICHT automatisch wiederholt. Nach
acht Sekunden steht er auf unbestätigt; Kaufdiagnose nennt Zustand und letzte
Ereignisse. Der reservierte Zustand bleibt über einen Reload erhalten. Ein
bekannter, nicht mehr benötigter Kauf darf nicht blind als fehlgeschlagen gelten.

Die Kaufmenge bleibt für denselben Skill-/Craft-Plan begrenzt. Preisupdates allein
vergrößern sie nicht. Neue Materialien/Rezepte oder ein tatsächlich abgeschlossener
Craft können einen neuen Bedarf erzeugen. Die Einstellung Weitere Suche erlauben
ist eine bewusste neue Freigabe und bleibt bei einem ungeklärten Kauf gesperrt.

Die Stückpreisgrenze bezieht sich auf den zuletzt beobachteten Live-/Scanpreis plus
gewählte Toleranz. Neue Angebote/Quotes werden in die Kostenentscheidung übernommen;
das ist keine automatische Zustimmung zu einem höheren Gesamtpreis. Vor dem Kauf
wird der sichtbare Betrag geprüft und ein Klick bleibt erforderlich.

## Gezielte Prüfungen

- Zweierauftrag bestätigen, viermal dieselbe Nachfrage neu anlegen: bleibt erledigt.
- AH schließen/öffnen oder erneut scannen: erledigtes Budget bleibt bei null.
- Allgemeiner Erfolg während ConfirmPurchase, noch vor dessen Rückkehr: korrekt
  mit dem zugehörigen bestätigten Quote verbunden.
- Allgemeiner Erfolg ohne Bestätigungsabsicht: noch kein Kauf.
- Beide Erfolgsereignisse für einen Kauf: nur eine Buchung.
- Fehlende Antwort: kein neuer Kauf; bestätigter Fehler: Restmenge wieder verfügbar.
- Livepreis 14 -> 15 Kupfer: Preis/Deckel neu bewertet, Budget nicht zurückgesetzt.
- Native verwaltete Kaufmenge nach Abschluss null; Null-Kaufknopf bleibt deaktiviert.
- Nach echtem Craft neuer Bedarf möglich; bloßer Bestandsverlust reicht dafür nicht.
- Echter Auctionator-344-Code für Quote, Mengenbestätigung und Kaufereignis ausgeführt.

Dies sind lokale API-/UI-Simulationen und Quellcode-Vertragsprüfungen, keine
rückwirkende Aufzeichnung der gemeldeten vier Käufe und kein Live-Test im Spiel.

## Test im Spiel

Vorher bereits gekaufte Materialien aus der Post abholen. Dann Beruf öffnen, AH
besuchen und den kleinen Plan prüfen. Einen Kauf bestätigen: bis zum Erfolg muss
Im Kauf erscheinen; danach muss der Auftrag weniger Restmenge oder den passenden
Post-/Craft-Schritt zeigen. Ohne Craft darf derselbe erledigte Bedarf nicht erneut
freigegeben werden. Bei Abweichungen /cdj diagnose öffnen und den Text kopieren.

Nach einem Reload werden allgemeine Erfolgsmeldungen ohne erhaltenen aktiven
Bestätigungskontext nicht blind einem alten unklaren Kauf zugeordnet. Die Sperre
bleibt dann für die Diagnose bestehen, statt automatisch nochmals zu kaufen.
