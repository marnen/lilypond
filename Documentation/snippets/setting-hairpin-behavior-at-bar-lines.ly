%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.16.0"

\header {
  lsrtags = "expressive-marks, tweaks-and-overrides"

  texidoc = "
If the note which ends a hairpin falls on a downbeat, the hairpin stops
at the bar line immediately preceding.  This behavior can be controlled
by overriding the @code{'to-barline} property.

"
  doctitle = "Setting hairpin behavior at bar lines"
} % begin verbatim


\relative c'' {
  e4\< e2.
  e1\!
  \override Hairpin #'to-barline = ##f
  e4\< e2.
  e1\!
}
