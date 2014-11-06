# language: de

Funktionalität: Passwörter von Benutzern

  Als Ausleihe-Verwalter, Inventar-Verwalter oder Administrator,
  möchte ich eine Benutzer ein Login und Passwort zuteilen

  @personas
  Szenariogrundriss: Benutzer mit Benutzernamen und Passwort erstellen
    Angenommen ich bin <Person>
    Und man befindet sich auf der Benutzerliste
    Wenn ich einen Benutzer mit Login "username" und Passwort "password" erstellt habe
    Und der Benutzer hat Zugriff auf ein Inventarpool
    Dann kann sich der Benutzer "username" mit "password" anmelden

    Beispiele:
      | Person |
      | Mike   |
      | Pius   |
      | Gino   |

  @personas
  Szenariogrundriss: Benutzernamen und Passwort ändern
    Angenommen ich bin <Person>
    Und man befindet sich auf der Benutzereditieransicht von "Normin"
    Wenn ich den Benutzernamen auf "newnorminusername" und das Passwort auf "newnorminpassword" ändere
    Und der Benutzer hat Zugriff auf ein Inventarpool
    Dann kann sich der Benutzer "newnorminusername" mit "newnorminpassword" anmelden

    Beispiele:
      | Person |
      | Mike   |
      | Pius   |
      | Gino   |

  @personas
  Szenariogrundriss: Benutzer mit falscher Passwort-Bestätigung erstellen
    Angenommen ich bin <Person>
    Und man befindet sich auf der Benutzerliste
    Wenn ich einen Benutzer mit falscher Passwort-Bestätigung erstellen probiere
    Dann I see an error message

    Beispiele:
      | Person |
      | Mike   |
      | Pius   |
      | Gino   |

  @personas
  Szenariogrundriss: Benutzer mit fehlenden Passwortangaben editieren
    Angenommen ich bin <Person>
    Und man befindet sich auf der Benutzereditieransicht von "Normin"
    Wenn ich die Passwort-Angaben nicht eingebe und speichere
    Dann I see an error message

    Beispiele:
      | Person |
      | Mike   |
      | Pius   |
      | Gino   |

  @personas
  Szenariogrundriss: Benutzer ohne Loginnamen erstellen
    Angenommen ich bin <Person>
    Und man befindet sich auf der Benutzerliste
    Wenn ich einen Benutzer ohne Loginnamen erstellen probiere
    Dann I see an error message

    Beispiele:
      | Person |
      | Mike   |
      | Pius   |
      | Gino   |

  @personas
  Szenariogrundriss: Passwort ändern
    Angenommen ich bin <Person>
    Und man befindet sich auf der Benutzereditieransicht von "Normin"
    Wenn ich das Passwort von "Normin" auf "newnorminpassword" ändere
    Und der Benutzer hat Zugriff auf ein Inventarpool
    Dann kann sich der Benutzer "normin" mit "newnorminpassword" anmelden

    Beispiele:
      | Person |
      | Mike   |
      | Pius   |
      | Gino   |

  @personas
  Szenariogrundriss: Benutzer mit fehlenden Passwortangaben erstellen
    Angenommen ich bin <Person>
    Und man befindet sich auf der Benutzerliste
    Wenn ich einen Benutzer mit fehlenden Passwortangaben erstellen probiere
    Dann I see an error message

    Beispiele:
      | Person |
      | Mike   |
      | Pius   |
      | Gino   |

  @personas
  Szenariogrundriss: Benutzer ohne Loginnamen editieren
    Angenommen ich bin <Person>
    Und man befindet sich auf der Benutzereditieransicht von "Normin"
    Wenn ich den Benutzernamen von nicht ausfülle und speichere
    Dann I see an error message

    Beispiele:
      | Person |
      | Mike   |
      | Pius   |
      | Gino   |

  @personas
  Szenariogrundriss: Benutzer mit falscher Passwort-Bestätigung editieren
    Angenommen ich bin <Person>
    Und man befindet sich auf der Benutzereditieransicht von "Normin"
    Wenn ich eine falsche Passwort-Bestägigung eingebe und speichere
    Dann I see an error message

    Beispiele:
      | Person |
      | Mike   |
      | Pius   |
      | Gino   |

  @personas
  Szenariogrundriss: Benutzernamen ändern
    Angenommen ich bin <Person>
    Und man befindet sich auf der Benutzereditieransicht von "Normin"
    Wenn ich den Benutzernamen von "Normin" auf "username" ändere
    Und der Benutzer hat Zugriff auf ein Inventarpool
    Dann kann sich der Benutzer "username" mit "password" anmelden

    Beispiele:
      | Person |
      | Mike   |
      | Pius   |
      | Gino   |
