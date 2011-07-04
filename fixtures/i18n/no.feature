# language: no
@i18n
Egenskap: Summering
  For å unngå at firmaet går konkurs
  Må regnskapsførerere bruke en regnemaskin for å legge sammen tall

  Scenario: to tall
    Gitt at jeg har tastet inn 5
    Og at jeg har tastet inn 7
    Når jeg summerer
    Så skal resultatet være 12

  @troll
  Abstrakt Scenario: eep oop ap
    Gitt at <oop> har tastet in <nerf>
    Og at jeg har tastet inn 7
    Når jeg summerer
    
    Eksempler:  wee wee wee
      | oop | nerf |
      | nnn | mmm  |
      | lok | frey |
      | drf | mmm  |

  @wip
  Scenario: tre tall
    Gitt at jeg har tastet inn 5
    Og at jeg har tastet inn 7
    Og at jeg har tastet inn 1
    Når jeg summerer
    Så skal resultatet være 13
