%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.14.2"

\header {
  lsrtags = "contexts-and-engravers, vocal-music, template"

%% Translation of GIT committish: b482c3e5b56c3841a88d957e0ca12964bd3e64fa

  texidoces = "
Esta plantilla crea una partitura que comienza con una estrofa para
solista y continúa con un estribillo a dos voces.  también muestra el
uso de silencios de separación dentro de la variable @code{\\global}
para definir cambios de compás (y otros elementos que son comunes a
todas las partes) a lo largo de toda la partitura.

"

  doctitlees = "Estrofa para solista y estribillo a dos voces"

%% Translation of GIT committish: 6ae36b6f8a7cf2df5f4e46c3c06820fccd9f35e1
  texidocit = "
Questo modello crea una partitura che inizia con una sezione solistica e
prosegue in un ritornello a due voci.  Illustra anche l'uso delle
pause spaziatrici all'interno della variabile @code{\\global} per definire
i cambi di tempo (e altri elementi comuni a tutte le parti) nel corso di
tutta la partitura.
"
  doctitleit = "Modello per gruppo vocale con strofa e ritornello"

%% Translation of GIT committish: 64feeff58e5ce3397de87188a08ac99f7ef8e37b

  texidocde = "
Diese Vorlage erstellt eine Partitur, die mit Sologesang beginnt und einen
Refrain für zwei Stimmen enthält.  Sie zeigt auch die Benutzung von
Platzhalter-Pausen innerhalb der @code{\\global}-Variable, um Taktwechsel
(und andere Elemente, die für alle Stimmen gleich sind) für das gesamte
Stück zu definieren.

"
  doctitlede = "Sologesang und zweistimmiger Refrain"

%% Translation of GIT committish: d5307870fe0ad47904daba73792c7e17b813737f
  texidocfr = "
Ce canevas illustre la manière d'agencer une œuvre vocale où le couplet
est chanté en solo et le refrain à deux voix.  Vous noterez le recours
aux silences invisibles dans la variable @code{\\global} ; ils
permettent de positionner les changements de métrique et autres éléments
communs à toutes les parties, ce pour l'intégralité du morceau.

"
  doctitlefr = "Ensemble vocal avec couplet et refrain"

  texidoc = "
This template creates a score which starts with a solo verse and
continues into a refrain for two voices.  It also demonstrates the use
of spacer rests within the @code{\\global} variable to define meter
changes (and other elements common to all parts) throughout the entire
score.

"
  doctitle = "Vocal ensemble template with verse and refrain"
} % begin verbatim


global = {
  \key g \major

  % verse
  \time 3/4
  s2.*2
  \break

  % refrain
  \time 2/4
  s2*2
  \bar "|."
}

SoloNotes = \relative g' {
  \clef "treble"

  % verse
  g4 g g |
  b4 b b |

  % refrain
  R2*2 |
}

SoloLyrics = \lyricmode {
  One two three |
  four five six |
}

SopranoNotes = \relative c'' {
  \clef "treble"

  % verse
  R2.*2 |

  % refrain
  c4 c |
  g4 g |
}

SopranoLyrics = \lyricmode {
  la la |
  la la |
}

BassNotes = \relative c {
  \clef "bass"

  % verse
  R2.*2 |

  % refrain
  c4 e |
  d4 d |
}

BassLyrics = \lyricmode {
  dum dum |
  dum dum |
}

\score {
  <<
    \new Voice = "SoloVoice" << \global \SoloNotes >>
    \new Lyrics \lyricsto "SoloVoice" \SoloLyrics

    \new ChoirStaff <<
      \new Voice = "SopranoVoice" << \global \SopranoNotes >>
      \new Lyrics \lyricsto "SopranoVoice" \SopranoLyrics

      \new Voice = "BassVoice" << \global \BassNotes >>
      \new Lyrics \lyricsto "BassVoice" \BassLyrics
    >>
  >>
  \layout {
    ragged-right = ##t
    \context { \Staff
      % these lines prevent empty staves from being printed
      \RemoveEmptyStaves
      \override VerticalAxisGroup #'remove-first = ##t
    }
  }
}

