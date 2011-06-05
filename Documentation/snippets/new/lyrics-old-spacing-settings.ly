\version "2.14.0"

\header {
  lsrtags = "vocal-music"

  doctitle = "Obtaining 2.12 lyrics spacing in newer versions"

  texidoc = "
The vertical spacing engine changed for version 2.14.  This can
cause lyrics to be spaced differently.  It is possible to set
properties for @code{Lyric} and @code{Staff} contexts to get the
spacing engine to behave as it did in version 2.12.
"
}

global = {
  \key d \major
  \time 3/4
}

sopMusic = \relative c' {
  % VERSE ONE
  fis4 fis fis | \break
  fis4. e8 e4
}

altoMusic = \relative c' {
  % VERSE ONE
  d4 d d |
  d4. b8 b4 |
}

tenorMusic = \relative c' {
  a4 a a |
  b4. g8 g4 |
}

bassMusic = \relative c {
  d4 d d |
  g,4. g8 g4 |
}

words = \lyricmode {
  Great is Thy faith- ful- ness,
}

\score {
  \new ChoirStaff <<
    \new Lyrics = sopranos
    \new Staff = women <<
      \new Voice = "sopranos" {
        \voiceOne
        \global \sopMusic
      }
      \new Voice = "altos" {
        \voiceTwo
        \global \altoMusic
      }
    >>
    \new Lyrics = "altos"
    \new Lyrics = "tenors"
    \new Staff = men <<
      \clef bass
      \new Voice = "tenors" {
        \voiceOne
        \global \tenorMusic
      }
      \new Voice = "basses" {
        \voiceTwo  \global \bassMusic
      }
    >>
    \new Lyrics = basses
    \context Lyrics = sopranos \lyricsto sopranos \words
    \context Lyrics = altos \lyricsto altos \words
    \context Lyrics = tenors \lyricsto tenors \words
    \context Lyrics = basses \lyricsto basses \words
  >>
  \layout {
    \context {
      \Lyrics
      \override VerticalAxisGroup #'staff-affinity = ##f
      \override VerticalAxisGroup #'staff-staff-spacing =
        #'((basic-distance . 0)
	   (minimum-distance . 2)
	   (padding . 2))
    }
    \context {
      \Staff
      \override VerticalAxisGroup #'staff-staff-spacing =
        #'((basic-distance . 0)
	   (minimum-distance . 2)
	   (padding . 2))
    }
  }
}

