%%  Do not edit this file; it is auto-generated from LSR!
\version "2.10.12"

\header { texidoc = "
Individual noteheads in a chord can be modified with the @code{\\tweak}
command inside a chord, by altering the @code{'font-size} property.


Inside the chord (within the brackets @code{< >}), before the note to
be altered, place the @code{\\tweak} command, followed by
@code{#'font-size} and define the proper size like @code{#-2} (a tiny
notehead).


The code for the chord example shown: @code{} 
" }

\header{
  title = "Modify an individual notehead's size in a chord"
}

Notes = \relative {
  <\tweak #'font-size #+2 c e g c \tweak #'font-size #-2 e>1^\markup{A tiny e}_\markup{A big c}
}

\score{
  \Notes
}
