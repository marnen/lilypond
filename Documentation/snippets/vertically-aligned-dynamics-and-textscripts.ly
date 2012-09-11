%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.16.0"

\header {
  lsrtags = "spacing, tweaks-and-overrides, workaround"

  texidoc = "
By setting the @code{'Y-extent} property to a suitable value, all
@code{DynamicLineSpanner} objects (hairpins and dynamic texts) can be
aligned to a common reference point, regardless of their actual extent.
This way, every element will be vertically aligned, thus producing a
more pleasing output.

The same idea is used to align the text scripts along their baseline.

"
  doctitle = "Vertically aligned dynamics and textscripts"
} % begin verbatim


music = \relative c' {
  a'2\p b\f
  e4\p f\f\> g, b\p
  c2^\markup { \huge gorgeous } c^\markup { \huge fantastic }
}

{
  \music
  \break
  \override DynamicLineSpanner #'staff-padding = #2.0
  \override DynamicLineSpanner #'Y-extent = #'(-1.5 . 1.5)
  \override TextScript #'Y-extent = #'(-1.5 . 1.5)
  \music
}
