# language: de

Funktionalität: Inventar

  Grundlage:
    Angenommen ich bin Mike
    Und man öffnet die Liste des Inventars

  @javascript @personas
  Szenario: Inventar anhand eines Suchbegriffs finden
    Angenommen es existiert ein Modell mit folgenden Eigenschaften:
      | Name       | suchbegriff1 |
      | Hersteller | suchbegriff4 |
    Und es existiert ein Gegenstand mit folgenden Eigenschaften:
      | Inventarcode | suchbegriff2 |
    Wenn ich im Inventarbereich nach einer dieser Eigenschaften suche
    Dann es erscheinen alle zutreffenden Modelle
    Und es erscheinen alle zutreffenden Gegenstände

  @javascript @personas
  Szenario: Pakete anhand eines Suchbegriffs finden
    Angenommen es existiert ein Modell mit folgenden Eigenschaften:
      | Name | Package Model |
    Und diese Modell ein Paket ist
    Und es existiert ein Gegenstand mit folgenden Eigenschaften:
      | Inventarcode | P-AVZ40001 |
    Und diese Paket-Gegenstand ist Teil des Pakets-Modells
    Und es existiert ein Modell mit folgenden Eigenschaften:
      | Name | Normal Model |
    Und es existiert ein Gegenstand mit folgenden Eigenschaften:
      | Inventarcode | AVZ40020 |
    Und dieser Gegenstand ist Teil des Paket-Gegenstandes
    Wenn ich im Inventarbereich nach einer dieser Eigenschaften suche
    Dann es erscheinen alle zutreffenden Paket-Modelle
    Und es erscheinen alle zutreffenden Paket-Gegenstände
    Und es erscheinen alle zutreffenden Gegenstände

  @personas @javascript
  Szenario: Modell und Gegenstand eines Pakets in Besitzergerätepark finden
    Angenommen es existiert ein Modell mit folgenden Eigenschaften:
      | Name | Package Model |
    Und diese Modell ein Paket ist
    Und es existiert ein Gegenstand mit folgenden Eigenschaften:
      | Inventarcode                | P-AVZ40001         |
      | Besitzergerätepark          | Anderer Gerätepark |
      | verantwortlicher Gerätepark | Anderer Gerätepark |
    Und diese Paket-Gegenstand ist Teil des Pakets-Modells
    Und es existiert ein Modell mit folgenden Eigenschaften:
      | Name | Normal Model |
    Und es existiert ein Gegenstand mit folgenden Eigenschaften:
      | Inventarcode                | AVZ40020           |
      | Besitzergerätepark          | Mein Gerätepark    |
      | verantwortlicher Gerätepark | Anderer Gerätepark |
    Und dieser Gegenstand ist Teil des Paket-Gegenstandes
    Wenn ich im Inventarbereich nach den folgenden Eigenschaften suche
      | Normal Model |
    Dann erscheint das entsprechende Modell zum Gegenstand
    Und es erscheint der Gegenstand
    Wenn ich im Inventarbereich nach den folgenden Eigenschaften suche
      | AVZ40020 |
    Dann erscheint das entsprechende Modell zum Gegenstand
    Und es erscheint der Gegenstand

  @personas @javascript
  Szenariogrundriss: Modell und Gegenstand eines Pakets in Verantwortlichem Gerätepark finden
    Angenommen es existiert ein Modell mit folgenden Eigenschaften:
      | Name | Package Model |
    Und diese Modell ein Paket ist
    Und es existiert ein Gegenstand mit folgenden Eigenschaften:
      | Inventarcode                | P-AVZ40001      |
      | Besitzergerätepark          | Mein Gerätepark |
      | verantwortlicher Gerätepark | Mein Gerätepark |
    Und diese Paket-Gegenstand ist Teil des Pakets-Modells
    Und es existiert ein Modell mit folgenden Eigenschaften:
      | Name | Normal Model |
    Und es existiert ein Gegenstand mit folgenden Eigenschaften:
      | Inventarcode                | AVZ40020           |
      | Besitzergerätepark          | Anderer Gerätepark |
      | verantwortlicher Gerätepark | Mein Gerätepark    |
    Und dieser Gegenstand ist Teil des Paket-Gegenstandes
    Wenn ich im Inventarbereich nach den folgenden Eigenschaften suche
      | <Eigenschaft> |
    Dann erscheint das entsprechende Modell zum Gegenstand
    Und es erscheint der Gegenstand
    Dann es erscheinen alle zutreffenden Paket-Modelle
    Und es erscheinen alle zutreffenden Paket-Gegenstände
    Und es erscheinen alle zutreffenden Gegenstände
  Beispiele:
    | Eigenschaft  |
    | Normal Model |
    | AVZ40020     |

  @personas @javascript @browser
  Szenario: Auswahlmöglichkeiten: Alle-Tab
    Dann kann man auf ein der folgenden Tabs klicken und dabei die entsprechende Inventargruppe sehen:
      | Auswahlmöglichkeit |
      | Alle               |

  @personas @javascript @browser
  Szenario: Auswahlmöglichkeiten: Modell-Tab
    Dann kann man auf ein der folgenden Tabs klicken und dabei die entsprechende Inventargruppe sehen:
      | Auswahlmöglichkeit |
      | Modelle            |

  @personas @javascript @browser
  Szenario: Auswahlmöglichkeiten: Optionen-Tab
    Dann kann man auf ein der folgenden Tabs klicken und dabei die entsprechende Inventargruppe sehen:
      | Auswahlmöglichkeit |
      | Optionen           |

  @personas @javascript @browser
  Szenario: Auswahlmöglichkeiten: Software-Tab
    Dann kann man auf ein der folgenden Tabs klicken und dabei die entsprechende Inventargruppe sehen:
      | Auswahlmöglichkeit |
      | Software           |

  @personas @javascript @browser
  Szenariogrundriss: Auswahlmöglichkeiten: genutzt & ungenutzt
    Angenommen ich sehe ausgemustertes und nicht ausgemustertes Inventar
    Wenn ich innerhalb des gesamten Inventars als "<Select-Feld>" die Option "<Eigenschaft>" wähle
    Dann wird nur das "<Eigenschaft>" Inventar angezeigt
  Beispiele:
    | Select-Feld         | Eigenschaft   |
    | genutzt & ungenutzt | genutzt       |
    | genutzt & ungenutzt | nicht genutzt |

  @personas @javascript @browser
  Szenariogrundriss: Auswahlmöglichkeiten: ausleihbar & nicht ausleihbar
    Angenommen ich sehe ausgemustertes und nicht ausgemustertes Inventar
    Wenn ich innerhalb des gesamten Inventars als "<Select-Feld>" die Option "<Eigenschaft>" wähle
    Dann wird nur das "<Eigenschaft>" Inventar angezeigt
  Beispiele:
    | Select-Feld                   | Eigenschaft      |
    | ausleihbar & nicht ausleihbar | ausleihbar       |
    | ausleihbar & nicht ausleihbar | nicht ausleihbar |

  @personas @javascript @browser
  Szenariogrundriss: Auswahlmöglichkeiten: ausgemustert & nicht ausgemustert
    Angenommen ich sehe ausgemustertes und nicht ausgemustertes Inventar
    Wenn ich innerhalb des gesamten Inventars als "<Select-Feld>" die Option "<Eigenschaft>" wähle
    Dann wird nur das "<Eigenschaft>" Inventar angezeigt
  Beispiele:
    | Select-Feld                       | Eigenschaft        |
    | ausgemustert & nicht ausgemustert | ausgemustert       |
    | ausgemustert & nicht ausgemustert | nicht ausgemustert |

  @personas @javascript @browser
  Szenariogrundriss: Auswahlmöglichkeiten: Checkboxen
    Angenommen ich sehe ausgemustertes und nicht ausgemustertes Inventar
    Wenn ich innerhalb des gesamten Inventars die "<Filterwahl>" setze
    Dann wird nur das "<Filterwahl>" Inventar angezeigt
  Beispiele:
    | Filterwahl    |
    | Im Besitz     |
    | An Lager      |
    | Unvollständig |
    | Defekt        |

  @personas @javascript @browser
  Szenario: Auswahlmöglichkeiten: verantwortliche Abteilung
    Angenommen ich sehe ausgemustertes und nicht ausgemustertes Inventar
    Wenn ich innerhalb des gesamten Inventars ein bestimmtes verantwortliche Gerätepark wähle
    Dann wird nur das Inventar angezeigt, für welche dieses Gerätepark verantwortlich ist

  @personas @javascript
  Szenario: Default-Filter "nicht ausgemustert"
    Dann ist bei folgenden Inventargruppen der Filter "nicht ausgemustert" per Default eingestellt:
      | Alle     |
      | Modelle  |
      | Software |

  @personas @javascript
  Szenario: Grundeinstellung der Listenansicht
    Dann ist die Auswahl "Alle" aktiviert

  @personas @javascript
  Szenario: Grundeinstellung der Listenansicht
    Dann ist die Auswahl "Alle" aktiviert

  @personas
  Szenario: Inhalt der Auswahl "Software"
    Dann enthält die Auswahl "Software" Software und Software-Lizenzen
    Und der Filter "Nicht Ausgemustert" ist aktiviert

  @personas @javascript
  Szenario: Grundeinstellung der Listenansicht
    Dann ist die Auswahl "Alle" aktiviert

  @personas
  Szenario: Inhalt der Auswahl "Software"
    Dann enthält die Auswahl "Software" Software und Software-Lizenzen
    Und der Filter "Nicht Ausgemustert" ist aktiviert

  @personas @javascript
  Szenario: Grundeinstellung der Listenansicht
    Dann ist die Auswahl "Alle" aktiviert

  @javascript @personas
  Szenario: Aussehen einer Options-Zeile
    Angenommen man befindet sich auf der Liste der Optionen
    Dann enthält die Options-Zeile folgende Informationen
      | information |
      | Barcode     |
      | Name        |
      | Preis       |

  @javascript @personas
  Szenario: Paket-Modelle aufklappen
    Dann kann man jedes Paket-Modell aufklappen
    Und man sieht die Pakete dieses Paket-Modells
    Und so eine Zeile sieht aus wie eine Gegenstands-Zeile
    Und man kann diese Paket-Zeile aufklappen
    Und man sieht die Bestandteile, die zum Paket gehören
    Und so eine Zeile zeigt nur noch Inventarcode und Modellname des Bestandteils

  @javascript @personas
  Szenario: Aussehen einer Modell-Zeile
    Wenn man eine Modell-Zeile sieht
    Dann enthält die Modell-Zeile folgende Informationen:
      | information              |
      | Bild                     |
      | Name des Modells         |
      | Anzahl verfügbar (jetzt) |
      | Anzahl verfügbar (Total) |

  @javascript @personas @browser
  Szenario: Aussehen einer Gegenstands-Zeile
    Wenn ich den Reiter "Modelle" einsehe
    Und der Gegenstand an Lager ist und meine Abteilung für den Gegenstand verantwortlich ist
    Dann enthält die Gegenstands-Zeile folgende Informationen:
      | information      |
      | Gebäudeabkürzung |
      | Raum             |
      | Gestell          |
    Wenn meine Abteilung Besitzer des Gegenstands ist die Verantwortung aber auf eine andere Abteilung abgetreten hat
    Dann enthält die Gegenstands-Zeile folgende Informationen:
      | information               |
      | Verantwortliche Abteilung |
      | Gebäudeabkürzung          |
      | Raum                      |
    Wenn ich den Reiter "Modelle" einsehe
    Und der Gegenstand nicht an Lager ist und eine andere Abteilung für den Gegenstand verantwortlich ist
    Dann enthält die Gegenstands-Zeile folgende Informationen:
      | information               |
      | Verantwortliche Abteilung |
      | Aktueller Ausleihender    |
      | Enddatum der Ausleihe     |

  @javascript @personas @browser
  Szenario: Aussehen einer Software-Lizenz-Zeile
    Angenommen es gibt eine Software-Lizenz
    Und ich sehe ausgemustertes und nicht ausgemustertes Inventar
    Wenn ich diese Lizenz in der Softwareliste anschaue
    Dann enthält die Software-Lizenz-Zeile folgende Informationen:
      | information    |
      | Betriebssystem |
      | Lizenztyp      |
    Angenommen es gibt eine Software-Lizenz mit einem der folgenden Typen:
      | Typ         | technical          |
      | Konkurrent  | concurrent         |
      | Site-Lizenz | site_license       |
      | Mehrplatz   | multiple_workplace |
    Wenn ich diese Lizenz in der Softwareliste anschaue
    Dann enthält die Software-Lizenz-Zeile folgende Informationen:
      | information    |
      | Betriebssystem |
      | Lizenztyp      |
      | Anzahl         |
    Angenommen es gibt eine Software-Lizenz, wo meine Abteilung der Besitzer ist, die Verantwortung aber auf eine andere Abteilung abgetreten hat
    Wenn ich diese Lizenz in der Softwareliste anschaue
    Dann enthält die Software-Lizenz-Zeile folgende Informationen:
      | information               |
      | Verantwortliche Abteilung |
      | Betriebssystem            |
      | Lizenztyp                 |
    Angenommen es gibt eine Software-Lizenz, die nicht an Lager ist und eine andere Abteilung für die Software-Lizenz verantwortlich ist
    Wenn ich diese Lizenz in der Softwareliste anschaue
    Dann enthält die Software-Lizenz-Zeile folgende Informationen:
      | information               |
      | Verantwortliche Abteilung |
      | Aktueller Ausleihender    |
      | Enddatum der Ausleihe     |
      | Betriebssystem            |
      | Lizenztyp                 |

  @javascript @personas
  Szenario: Keine Resultate auf der Liste des Inventars
    Wenn ich eine resultatlose Suche mache
    Dann sehe ich "Kein Eintrag gefunden"

  @javascript @personas @browser
  Szenario: Modell aufklappen
    Dann kann man jedes Modell aufklappen
    Und man sieht die Gegenstände, die zum Modell gehören
    Und so eine Zeile sieht aus wie eine Gegenstands-Zeile

  #73278620
   @personas
  Szenario: Verhalten nach Speichern
    Wenn ich einen Reiter auswähle
    Und ich eine oder mehrere Filtermöglichkeiten verwende
    Wenn ich eine aufgeführte Zeile editiere
    Und ich speichere
    Dann werde ich zur Liste des eben gewählten Reiters mit den eben ausgewählten Filtern zurueckgefuehrt

  @personas @javascript
  Szenariogrundriss: Auszeichnung von defekten, ausgemusterten, unvollständigen oder nicht ausleihbaren Gegenstandszeilen
    Angenommen ich befinde mich auf der Liste eines "<Zustand>"en Inventars
    Wenn ich eine Modellzeile öffne
    Dann ist die Gegenstandszeile mit "<Zustand>" in rot ausgezeichnet
    Beispiele:
      | Zustand          |
      | Defekt           |
      | Ausgemustert     |
      | Unvollständig    |
      | Nicht ausleihbar |

  @personas @javascript @browser
  Szenario: Auszeichnung von mehreren Zuständen auf der Gegenstandszeile
    Angenommen ich sehe ausgemustertes und nicht ausgemustertes Inventar
    Und es exisitert ein Gegenstand mit mehreren Problemen
    Wenn ich nach diesem Gegenstand in der Inventarliste suche
    Und ich öffne die Modellzeile von diesem Gegenstand
    Dann sind die Probleme des Gegestandes komma getrennt aneinander gereiht
