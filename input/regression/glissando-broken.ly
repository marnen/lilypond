\header {
  texidoc = "If broken, Glissandi anticipate on the pitch of the next line."
  
}
\version "2.14.0"
\paper {
  ragged-right = ##T }

\relative c'' {
  \override Glissando #'breakable = ##t 
  d1 \glissando |
  \break
  c,1
}
