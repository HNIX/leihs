# language: de

Funktionalität: Anzeige von Problemen

  Grundlage:
    Angenommen ich bin Pius

  @javascript @browser @personas
  Szenario: Problemanzeige wenn Modell nicht verfügbar bei Bestellungen
    Angenommen ich editiere eine Bestellung die nicht in der Vergangenheit liegt
     Und ein Modell ist nichtmehr verfügbar
     Dann sehe ich auf den beteiligten Linien die Auszeichnung von Problemen
     Und das Problem wird wie folgt dargestellt: "Nicht verfügbar 2(3)/7"
     Und "2" sind verfügbar für den Kunden inklusive seinen Gruppenzugehörigen
     Und "3" sind insgesamt verfügbar inklusive diejenigen Gruppen, welchen der Kunde nicht angehört
     Und "7" sind total im Pool bekannt (ausleihbar)

  @javascript @browser @personas
  Szenario: Problemanzeige bei Rücknahme wenn Gegenstand defekt
    Angenommen I take back an item
     Und eine Gegenstand ist defekt
     Dann sehe ich auf der Linie des betroffenen Gegenstandes die Auszeichnung von Problemen
     Und das Problem wird wie folgt dargestellt: "Gegenstand ist defekt"

  @javascript @personas @browser
  Szenario: Problemanzeige bei Aushändigung wenn Gegenstand defekt
    Angenommen I am doing a hand over
     Und eine Gegenstand ist defekt
     Dann sehe ich auf der Linie des betroffenen Gegenstandes die Auszeichnung von Problemen
     Und das Problem wird wie folgt dargestellt: "Gegenstand ist defekt"

  @javascript @browser @personas
  Szenario: Problemanzeige bei Rücknahme wenn Gegenstand unvollständig
    Angenommen I take back an item
     Und eine Gegenstand ist unvollständig
     Dann sehe ich auf der Linie des betroffenen Gegenstandes die Auszeichnung von Problemen
     Und das Problem wird wie folgt dargestellt: "Gegenstand ist unvollständig"

  @javascript @personas
  Szenario: Problemanzeige bei Aushändigung wenn Gegenstand nicht ausleihbar
    Angenommen I am doing a hand over
     Und eine Gegenstand ist nicht ausleihbar
     Dann sehe ich auf der Linie des betroffenen Gegenstandes die Auszeichnung von Problemen
     Und das Problem wird wie folgt dargestellt: "Gegenstand nicht ausleihbar"

  @javascript @browser @personas
  Szenario: Problemanzeige bei Rücknahme wenn Gegenstand nicht ausleihbar
    Angenommen I take back an item
    Und eine Gegenstand ist nicht ausleihbar
    Dann sehe ich auf der Linie des betroffenen Gegenstandes die Auszeichnung von Problemen
    Und das Problem wird wie folgt dargestellt: "Gegenstand nicht ausleihbar"

  @personas @javascript
  Szenario: Problemanzeige wenn Modell nicht verfügbar bei Aushändigung
    Angenommen I am doing a hand over
     Und eine Model ist nichtmehr verfügbar
     Dann sehe ich auf den beteiligten Linien die Auszeichnung von Problemen
     Und das Problem wird wie folgt dargestellt: "Nicht verfügbar 2(3)/7"
     Und "2" sind verfügbar für den Kunden inklusive seinen Gruppenzugehörigen
     Und "3" sind insgesamt verfügbar inklusive diejenigen Gruppen, welchen der Kunde nicht angehört
     Und "7" sind total im Pool bekannt (ausleihbar)

  @personas
  Szenario: Problemanzeige wenn Modell nicht verfügbar bei Rücknahmen
    Angenommen ich mache eine Rücknahme, die nicht überfällig ist
     Und eine Model ist nichtmehr verfügbar
     Dann sehe ich auf den beteiligten Linien die Auszeichnung von Problemen
     Und das Problem wird wie folgt dargestellt: "Nicht verfügbar 2(3)/7"
     Und "2" sind verfügbar für den Kunden inklusive seinen Gruppenzugehörigen
     Und "3" sind insgesamt verfügbar inklusive diejenigen Gruppen, welchen der Kunde nicht angehört
     Und "7" sind total im Pool bekannt (ausleihbar)

  @javascript @personas @browser
  Szenario: Problemanzeige bei Aushändigung wenn Gegenstand unvollständig
    Angenommen I am doing a hand over
     Und eine Gegenstand ist unvollständig
     Dann sehe ich auf der Linie des betroffenen Gegenstandes die Auszeichnung von Problemen
     Und das Problem wird wie folgt dargestellt: "Gegenstand ist unvollständig"

  @javascript @personas
  Szenario: Problemanzeige bei Rücknahme wenn verspätet
    Angenommen I take back a late item
     Dann sehe ich auf der Linie des betroffenen Gegenstandes die Auszeichnung von Problemen
     Und das Problem wird wie folgt dargestellt: "Überfällig seit 6 Tagen"
