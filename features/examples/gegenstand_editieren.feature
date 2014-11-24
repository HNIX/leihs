Feature: Editing an item

  Background:
    Given I am Matti

  @javascript @personas
  Scenario: Order of the fields
    Given I edit an item that belongs to the current inventory pool
    When I select "Yes" from "item[retired]"
    When I choose "Investment"
    Then I see form fields in the following order:
      | field                      |
      | Inventory Code             |
      | Model                      |
      | - Status -                 |
      | Retirement                 |
      | Reason for Retirement      |
      | Working order              |
      | Completeness               |
      | Borrowable                 |
      | - Inventory -              |
      | Relevant for inventory     |
      | Supply Category            |
      | Owner                      |
      | Last Checked               |
      | Responsible department     |
      | Responsible person         |
      | User/Typical usage         |
      | - Move -                   |
      | Move                       |
      | Target area                |
      | - Toni Ankunftskontrolle - |
      | Check-In Date              |
      | Check-In State             |
      | Check-In Note              |
      | - General Information -    |
      | Serial Number              |
      | MAC-Address                |
      | IMEI-Number                |
      | Name                       |
      | Note                       |
      | - Location -               |
      | Building                   |
      | Room                       |
      | Shelf                      |
      | - Invoice Information -    |
      | Reference                  |
      | Project Number             |
      | Invoice Number             |
      | Invoice Date               |
      | Initial Price              |
      | Supplier                   |
      | Warranty expiration        |
      | Contract expiration        |

  @javascript @personas
  Scenario: Delete supplier
    Given I edit an item that belongs to the current inventory pool
    And I navigate to the edit page of an item that has a supplier
    When I delete the supplier
    And I save
    Then the item has no supplier

  @javascript @personas @browser
  Scenario: Edit all an item's information
    Given I edit an item that belongs to the current inventory pool and is in stock and is not part of any contract
    When I enter the following item information
      | field                  | type         | value               |

      | Inventory Code         |              | Test Inventory Code |
      | Model                  | autocomplete | Sharp Beamer 456    |

      | Retirement             | select       | Yes                 |
      | Reason for Retirement  |              | Some reason         |
      | Working order          | radio        | OK                  |
      | Completeness           | radio        | OK                  |
      | Borrowable             | radio        | OK                  |

      | Relevant for inventory | select       | Yes                 |
      | Supply Category        | select       | Workshop Technology |
    And I save
    Then I am redirected to the inventory list
    And the item is saved with all the entered information

  @javascript @personas
  Scenario: Choosing a model without a version
    Given I edit an item that belongs to the current inventory pool
    And there is a model without a version
    When I assign this model to the item
    Then there is only product name in the input field of the model

  @javascript @personas
  Scenario: Change supplier
    Given I edit an item that belongs to the current inventory pool
    When I change the supplier
    And I save
    Then the edited item has the new supplier

  @javascript @personas
  Scenario: You can't change the responsible department for items that are not in stock
    Given I edit an item that belongs to the current inventory pool and is not in stock
    When I change the responsible department
    And I save
    Then I see an error message that I can't change the responsible inventory pool for items that are not in stock

  @javascript @personas @browser
  Scenario: Editing an item an all its information
    Given I edit an item that belongs to the current inventory pool and is in stock and is not part of any contract
    When I enter the following item information
      | field                  | type         | value               |
      | Inventory Code         |              | Test Inventory Code |
      | Model                  | autocomplete | Sharp Beamer 456    |
      | Relevant for inventory | select       | Yes                |
      | Supply Category        | select       | Workshop Technology |
      | Move                   | select       | sofort entsorgen    |
      | Target area            |              | Test room           |
      | Check-In Date          |              | 01/01/2013          |
      | Check-In State         | select       | transportschaden    |
      | Check-In Note          |              | Test note           |
      | Serial Number          |              | Test serial number  |
      | MAC-Address            |              | Test MAC address    |
      | IMEI-Number            |              | Test IMEI number    |
      | Name                   |              | Test name           |
      | Note                   |              | Test note           |
      | Building               | autocomplete | None                |
      | Room                   |              | Test room           |
      | Shelf                  |              | Test shelf          |
    And I save
    Then I am redirected to the inventory list
    And the item is saved with all the entered information

  @javascript @personas
  Scenario: Pflichtfelder
    Given man editiert einen Gegenstand, wo man der Besitzer ist
    Then muss der "Bezug" unter "Rechnungsinformationen" ausgewählt werden
    When "Investition" bei "Bezug" ausgewählt ist muss auch "Projektnummer" angegeben werden
    When "Ja" bei "Inventarrelevant" ausgewählt ist muss auch "Anschaffungskategorie" ausgewählt werden
    When "Ja" bei "Ausmusterung" ausgewählt ist muss auch "Grund der Ausmusterung" angegeben werden
    Then sind alle Pflichtfelder mit einem Stern gekenzeichnet
    When ein Pflichtfeld nicht ausgefüllt/ausgewählt ist, dann lässt sich der Gegenstand nicht speichern
    And I see an error message
    And die nicht ausgefüllten/ausgewählten Pflichtfelder sind rot markiert

  @javascript @personas
  Scenario: Neuen Lieferanten erstellen falls nicht vorhanden
    Given man editiert einen Gegenstand, wo man der Besitzer ist
    When ich einen nicht existierenen Lieferanten angebe
    And I save
    Then wird der neue Lieferant erstellt
    And bei dem bearbeiteten Gegestand ist der neue Lieferant eingetragen

  @javascript @personas
  Scenario: Neuen Lieferanten nicht erstellen falls einer mit gleichem Namen schon vorhanden
    Given man editiert einen Gegenstand, wo man der Besitzer ist
    When ich einen existierenen Lieferanten angebe
    And I save
    Then wird kein neuer Lieferant erstellt
    And bei dem bearbeiteten Gegestand ist der bereits vorhandenen Lieferant eingetragen
  

  @javascript @personas
  Scenario: Bei Gegenständen, die in Verträgen vorhanden sind, kann man das Modell nicht ändern
    Given man navigiert zur Bearbeitungsseite eines Gegenstandes, der in einem Vertrag vorhanden ist
    When ich das Modell ändere
    And I save
    Then erhält man eine Fehlermeldung, dass man diese Eigenschaft nicht editieren kann, da das Gerät in einem Vortrag vorhanden ist

  @javascript @personas
  Scenario: Einen Gegenstand, der ausgeliehen ist, kann man nicht ausmustern
    Given man navigiert zur Bearbeitungsseite eines Gegenstandes, der ausgeliehen ist und wo man Besitzer ist
    When ich den Gegenstand ausmustere
    And I save
    Then erhält man eine Fehlermeldung, dass man den Gegenstand nicht ausmustern kann, da das Gerät bereits ausgeliehen oder einer Vertragslinie zugewiesen ist

  @javascript @personas @browser
  Scenario: Einen Gegenstand mit allen Informationen editieren
    Given man editiert einen Gegenstand, wo man der Besitzer ist, der am Lager und in keinem Vertrag vorhanden ist
    When ich die folgenden Informationen erfasse
      | Feldname              | Type         | Wert                |

      | Inventarcode          |              | Test Inventory Code |
      | Modell                | autocomplete | Sharp Beamer 456    |

      | Inventarrelevant      | select       | Ja                  |
      | Anschaffungskategorie | select       | Werkstatt-Technik   |

      | Bezug                 | radio must   | Investition         |
      | Projektnummer         |              | Test Nummer         |
      | Rechnungsnummer       |              | Test Nummer         |
      | Rechnungsdatum        |              | 01.01.2013          |
      | Anschaffungswert      |              | 50.00               |
      | Garantieablaufdatum   |              | 01.01.2013          |
      | Vertragsablaufdatum   |              | 01.01.2013          |

    And I save
    Then man wird zur Liste des Inventars zurueckgefuehrt
    And ist der Gegenstand mit all den angegebenen Informationen gespeichert

  @javascript @personas @browser
  Scenario: Einen Gegenstand mit allen Informationen editieren
    Given man editiert einen Gegenstand, wo man der Besitzer ist, der am Lager und in keinem Vertrag vorhanden ist
    When ich die folgenden Informationen erfasse
      | Feldname                  | Type         | Wert                |

      | Inventarcode              |              | Test Inventory Code |
      | Modell                    | autocomplete | Sharp Beamer 456    |

      | Inventarrelevant          | select       | Ja                  |
      | Anschaffungskategorie     | select       | Werkstatt-Technik   |
      | Letzte Inventur           |              | 01.01.2013          |
      | Verantwortliche Abteilung | autocomplete | A-Ausleihe          |
      | Verantwortliche Person    |              | Matus Kmit          |
      | Benutzer/Verwendung       |              | Test Verwendung     |

    And I save
    Then man wird zur Liste des Inventars zurueckgefuehrt
    And ist der Gegenstand mit all den angegebenen Informationen gespeichert
