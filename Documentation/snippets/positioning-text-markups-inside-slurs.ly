%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.16.0"

\header {
  lsrtags = "editorial-annotations, expressive-marks, tweaks-and-overrides"

  texidoc = "
Text markups need to have the @code{outside-staff-priority} property
set to false in order to be printed inside slurs.

"
  doctitle = "Positioning text markups inside slurs"
} % begin verbatim


\relative c'' {
  \override TextScript #'avoid-slur = #'inside
  \override TextScript #'outside-staff-priority = ##f
  c2(^\markup { \halign #-10 \natural } d4.) c8
}
