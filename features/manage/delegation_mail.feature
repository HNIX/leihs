# language: de

Funktionalität: Mailversand bei Delegationsbestellungen und -besuchen

  @javascript @personas
  Szenario: Handhabung der Genehmigungsmails
    Angenommen ich bin Pius
    Und es existiert eine Bestellung von einer Delegation die nicht von einem Delegationsverantwortlichen erstellt wurde
    Wenn I edit the order
    Und die Bestellung genehmige
    Dann ich erhalte eine Erfolgsmeldung
    Und wird das Genehmigungsmail an den Besteller versendet
    Und das Genehmigungsmail wird nicht an den Delegationsverantwortlichen versendet

  @javascript @personas
  Szenario: Handhabung der Erinnerungsmails
    Angenommen ich bin Pius
    Und es existiert eine Rücknahme von einer Delegation
    Wenn ich bei dieser Rücknahme eine Erinnerung sende
    Dann wird das Erinnerungsmail an den Abholenden versendet
    Und das Erinnerungsmail wird nicht an den Delegationsverantwortlichen versendet

  @javascript @personas
  Szenario: Mail an Delegation senden
    Angenommen ich bin Pius
    Wenn ich nach einer Delegation suche
    Und ich die Mailfunktion wähle
    Dann wird das Mail an den Delegationsverantwrotlichen verschickt
