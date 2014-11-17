
Feature: Software suchen

  Grundlage:
    Given I am Mike

  @javascript @personas
  Scenario: Software anhand eines Suchbegriffs finden
    Given es existiert ein Software-Produkt mit folgenden Eigenschaften:
      | Produktname          | suchbegriff1 |
      | Hersteller           | suchbegriff4 |
    And es existiert eine Software-Lizenz mit folgenden Eigenschaften:
      | Inventarcode         | suchbegriff2 |
      | Seriennummer         | suchbegriff3 |
      | Dongle-ID            | suchbegriff5 |
      | Anzahl-Zuteilung     | 1 / Christina Meier |
    And this software license is handed over to somebody
    When ich nach einer dieser Software-Produkt Eigenschaften suche
    Then es erscheinen alle zutreffenden Software-Produkte
    And es erscheinen alle zutreffenden Software-Lizenzen
    And es erscheinen alle zutreffenden Verträge, in denen diese Software-Produkt vorkommt
    When ich nach einer dieser Software-Lizenz Eigenschaften suche
    Then es erscheinen alle zutreffenden Software-Lizenzen
    And es erscheinen alle zutreffenden Verträge, in denen diese Software-Produkt vorkommt

  @javascript @personas
  Scenario: Verträge für Software-Lizenzen anhand des Ausleihenden finden
    Given a software license exists
    And this software license is handed over to somebody
    When I search after the name of that person
    Then it appears the contract of this person in the search results
    And it appears this person in the search results

  @javascript @personas
  Scenario: Aufteilung der Suchresultate
    Given a software product exists
    And there exist licenses for this software product
    When I see these in my search result
    Then I can select to list only software products
    And I can select to list only software licenses
