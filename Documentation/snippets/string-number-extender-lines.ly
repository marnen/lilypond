% DO NOT EDIT this file manually; it is automatically
% generated from Documentation/snippets/new
% Make any changes in Documentation/snippets/new/
% and then run scripts/auxiliar/makelsr.py
%
% This file is in the public domain.
%% Note: this file works from version 2.15.20
\version "2.15.20"

\header {
%% Translation of GIT committish: 28097cf54698db364afeb75658e4c8e0e0ccd716
  texidocfr = "
Voici comment ajouter une ligne de prolongation à une indication de
numéro de corde, afin de stipuler que les notes qui suivent doivent être
jouées sur la corde en question.

"
  doctitlefr = "Ligne de prolongation pour numéro de corde"

  lsrtags = "editorial-annotations, text, fretted-strings, tweaks-and-overrides"

  texidoc = "
Make an extender line for string number indications, showing that a
series of notes is supposed to be played all on the same string.

"
  doctitle = "String number extender lines"
} % begin verbatim


stringNumberSpanner =
#(define-music-function (parser location StringNumber) (string?)
  #{
    \override TextSpanner #'style = #'solid
    \override TextSpanner #'font-size = #-5
    \override TextSpanner #'(bound-details left stencil-align-dir-y) = #CENTER
    \override TextSpanner #'(bound-details left text) = \markup { \circle \number #StringNumber }
  #})


\relative c {
  \clef "treble_8"
  \stringNumberSpanner "5"
  \textSpannerDown
  a8\startTextSpan
  b c d e f\stopTextSpan
  \stringNumberSpanner "4"
  g\startTextSpan a
  bes4 a g2\stopTextSpan
}

