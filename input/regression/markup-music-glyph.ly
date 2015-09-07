\version "2.16.0"

#(ly:set-option 'warning-as-error #f)
#(ly:expect-warning (_ "Cannot find glyph ~a") "UNKNOWN-GLYPH")

\header {
  texidoc = "Reset fontname for musicglyph.
For unknown glyphs, we print a warning."

}

{
  c'^\markup {
    \override #'(font-name . "LilyPond Sans Serif") {
      c'est un B \flat \musicglyph #"UNKNOWN-GLYPH"
    }
    % to get \flat, do:
    %  \normal-text \flat
  }
}
