
Feature: Modell mit Paketen erstellen

  Grundlage:
    Given ich bin Mike
    And man öffnet die Liste des Inventars

  @javascript @browser @personas
  Scenario: Modell mit Paketzuteilung erstellen
    When ich ein neues Modell hinzufüge
    And ich mindestens die Pflichtfelder ausfülle
    And ich eines oder mehrere Pakete hinzufüge
    And ich diesem Paket eines oder mehrere Gegenstände hinzufügen
    And ich das Paket und das Modell speichere
    Then ist das Modell erstellt und die Pakete und dessen zugeteilten Gegenstände gespeichert
    And den Paketen wird ein Inventarcode zugewiesen

  @javascript @browser @personas
  Scenario: Modell mit bereits vorhandenen Gegenständen kann kein Paket zugewiesen werden
    When ich ein Modell editiere, welches bereits Gegenstände hat
    Then kann ich diesem Modell keine Pakete mehr zuweisen

  @javascript @browser @personas
  Scenario: Pakete nicht ohne Gegenstände erstellen
    When ich einem Modell ein Paket hinzufüge
    Then kann ich dieses Paket nur speichern, wenn dem Paket auch Gegenstände zugeteilt sind

  @javascript @browser @personas
  Scenario: Einzelnen Gegenstand aus Paket entfernen
    When ich ein Paket editiere
    Then kann ich einen Gegenstand aus dem Paket entfernen
    And dieser Gegenstand ist nicht mehr dem Paket zugeteilt

  @javascript @browser @personas
  Scenario: Paketeigenschaften abfüllen bei existierendem Modell
    When ich ein Modell editiere, welches bereits Pakete hat
    And ich ein bestehendes Paket editiere
    And ich die folgenden Informationen erfasse
    | Feldname                     | Type         | Wert                          |
    | Zustand                      | radio        | OK                            |
    | Vollständigkeit              | radio        | OK                            |
    | Ausleihbar                   | radio        | OK                            |
    | Inventarrelevant             | select       | Ja                            |
    | Verantwortliche Abteilung    | autocomplete | A-Ausleihe                    |
    | Verantwortliche Person       |              | Matus Kmit                    |
    | Benutzer/Verwendung          |              | Test Verwendung               |
    | Name                         |              | Test Name                     |
    | Notiz                        |              | Test Notiz                    |
    | Gebäude                      | autocomplete | Keine/r                       |
    | Raum                         |              | Test Raum                     |
    | Gestell                      |              | Test Gestell                  |
    | Anschaffungswert             |              | 50.00                         |
    | Letzte Inventur              |              | 01.01.2013                    |
    And ich das Paket und das Modell speichere
    Then besitzt das Paket alle angegebenen Informationen

  @javascript @browser @personas
  Scenario: Modell mit Paketzuteilung erstellen und wieder editieren
    When ich ein neues Modell hinzufüge
    And ich mindestens die Pflichtfelder ausfülle
    And ich eine Paket hinzufüge
    And ich die Paketeigenschaften eintrage
    And ich diesem Paket eines oder mehrere Gegenstände hinzufügen
    And ich dieses Paket speichere
    And ich dieses Paket wieder editiere
    Then kann ich die Paketeigenschaften erneut bearbeiten
    And ich kann diesem Paket eines oder mehrere Gegenstände hinzufügen

  #74210792
  @javascript @browser @personas
  Scenario: Paketeigenschaften abfüllen bei neu erstelltem Modell
    When ich einem Modell ein Paket hinzufüge
    And ich diesem Paket eines oder mehrere Gegenstände hinzufügen
    And ich die folgenden Informationen erfasse
    | Feldname                     | Type         | Wert                          |
    | Zustand                      | radio        | OK                            |
    | Vollständigkeit              | radio        | OK                            |
    | Ausleihbar                   | radio        | OK                            |
    | Inventarrelevant             | select       | Ja                            |
    | Letzte Inventur              |              | 01.01.2013                    |
    | Verantwortliche Abteilung    | autocomplete | A-Ausleihe                    |
    | Verantwortliche Person       |              | Matus Kmit                    |
    | Benutzer/Verwendung          |              | Test Verwendung               |
    | Name                         |              | Test Name                     |
    | Notiz                        |              | Test Notiz                    |
    | Gebäude                      | autocomplete | Keine/r                       |
    | Raum                         |              | Test Raum                     |
    | Gestell                      |              | Test Gestell                  |
    | Anschaffungswert             |              | 50.00                         |
    And ich das Paket und das Modell speichere
    Then sehe ich die Meldung "Modell gespeichert / Pakete erstellt"
    And besitzt das Paket alle angegebenen Informationen
    And alle die zugeteilten Gegenstände erhalten dieselben Werte, die auf diesem Paket erfasst sind
    | Feldname                   |
    | Verantwortliche Abteilung  |
    | Verantwortliche Person     |
    | Gebäude                    |
    | Raum                       |
    | Gestell                    |
    | Toni-Ankunftsdatum         |
    | Letzte Inventur            |


  @javascript @personas
  Scenario: Paket löschen
    When das Paket zurzeit nicht ausgeliehen ist 
    Then kann ich das Paket löschen und die Gegenstände sind nicht mehr dem Paket zugeteilt

  @personas
  Scenario: Paket löschen schlägt fehl wenn das Paket gerade ausgeliehen ist
    When das Paket zurzeit ausgeliehen ist 
    Then kann ich das Paket nicht löschen

  @personas @javascript @browser
  Scenario: Nur meine Pakete werden im Modell angezeigt
    When ich ein Modell editiere, welches bereits Pakete in meine und andere Gerätepark hat
    Then sehe ich nur diejenigen Pakete, für welche ich verantwortlich bin
