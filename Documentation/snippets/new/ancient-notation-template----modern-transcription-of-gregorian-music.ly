\version "2.15.15"

\header {
  lsrtags = "vocal-music, ancient-notation, template"

%% Translation of GIT committish: 2d548a99cb9dba80f2ff035582009477cd37eceb
  texidoces = "
Este ejemplo muestra cómo hacer una transcripción moderna de canto
gregoriano. El canto gregoriano no tiene compás ni plicas; utiliza
solamente cabezas de nota de blanca y de negra, y unas marcas
especiales que indican silencios de distintas longitudes.

"

  doctitlees = "Plantilla para notación de música antigua (transcripción moderna de canto gregoriano)"

%% Translation of GIT committish: 514674cb00c18629242dfcde0c1a4976758adc56
  texidocit = "
Questo esempio mostra come realizzare una trascrizione moderna di musica
gregoriana. La musica gregoriana non presenta suddivisione in misure né gambi;
utilizza soltanto le teste della minima e della semiminima, e dei segni
appositi che indicano pause di diversa lunghezza.

"
  doctitleit = "Modello per notazione antica -- trascrizione moderna di musica gregoriana"

%% Translation of GIT committish: 0a868be38a775ecb1ef935b079000cebbc64de40

  texidocde = "
Dieses Beispiel zeigt eine moderne Transkription des Gregorianischen
Chorals. Hier gibt es keine Takte, keine Notenhälse und es werden nur
halbe und Viertelnoten verwendet. Zusätzliche Zeichen zeigen die
Länge von Pausen an.
"

 doctitlede = "Vorlage für Alte Notation -- moderne Transkription des gregorianischen Chorals"

%% Translation of GIT committish: bdfe3dc8175a2d7e9ea0800b5b04cfb68fe58a7a
  texidocfr = "
Voici comment vous pourriez transcrire du grégorien.  Pour mémoire, il
n'y a en grégorien ni de découpage en mesure, ni de hampe ; seules
sont utilisées des têtes de note blanches ou noires, ainsi que des
signes spécifiques permettant d'indiquer des silences de différentes durées.

"
  doctitlefr = "Exemples de notation ancienne -- transcription moderne de musique grégorienne"

  texidoc = "
This example demonstrates how to do modern transcription of Gregorian
music. Gregorian music has no measure, no stems; it uses only half and
quarter note heads, and special marks, indicating rests of different
length.

"
  doctitle = "Ancient notation template -- modern transcription of gregorian music"
} % begin verbatim

\include "gregorian.ly"

chant = \relative c' {
  \set Score.timing = ##f
  f4 a2 \divisioMinima
  g4 b a2 f2 \divisioMaior
  g4( f) f( g) a2 \finalis
}

verba = \lyricmode {
  Lo -- rem ip -- sum do -- lor sit a -- met
}

\score {
  \new Staff <<
    \new Voice = "melody" \chant
    \new Lyrics = "one" \lyricsto melody \verba
  >>
  \layout {
    \context {
      \Staff
      \remove "Time_signature_engraver"
      \remove "Bar_engraver"
      \override Stem #'transparent = ##t
      \override Flag #'transparent = ##t
    }
    \context {
      \Voice
      \override Stem #'length = #0
    }
    \context {
      \Score
      barAlways = ##t
    }
  }
}
