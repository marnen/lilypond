
\header {
  texidoc = "Beams can be printed across line breaks, if forced.
"

}
\version "2.14.0"
\layout { ragged-right= ##t }

\relative c''  {
  \override Score.Beam #'breakable = ##t
  \time 3/16 c16-[ d e \break f-] 
}
