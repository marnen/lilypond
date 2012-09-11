%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.16.0"

\header {
  lsrtags = "staff-notation, workaround"

  texidoc = "
By default, metronome marks do not influence horizontal spacing.  This
has one downside: when using compressed rests, some metronome marks may
be too close and therefore are printed vertically stacked, as
demonstrated in the first part of this example.  This can be solved
through a simple override, as shown in the second half of the example.

"
  doctitle = "Forcing measure width to adapt to MetronomeMark's width"
} % begin verbatim


example = {
  \tempo "Allegro"
  R1*6
  \tempo "Rall."
  R1*2
  \tempo "A tempo"
  R1*8
}

{
  \compressFullBarRests

  \example

  R1
  R1

  \override Score.MetronomeMark #'extra-spacing-width = #'(0 . 0)
  \example
}
