\version "2.14.0"

\header {
  texidoc="
A fingering indication of zero counts as an open string for fret
calculations.  An inappropriate request for an open string will generate
a warning message and set the requested pitch in the tablature.
"
}

mymusic = \relative c {
  \set minimumFret = #1
  <d-0 d'-2 f-3 a-1>1
  <f-0>
}

\score {
  <<
    \new Staff {
      \clef "treble_8"
      \mymusic
    }
    \new TabStaff {
      \mymusic
    }
  >>
}
