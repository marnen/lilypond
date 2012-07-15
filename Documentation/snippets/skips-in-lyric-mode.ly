%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.14.2"

\header {
%% Translation of GIT committish: 28097cf54698db364afeb75658e4c8e0e0ccd716
  texidocfr = "
La syntaxe @code{s} qui permet de « faire un saut dans le temps » n'est
disponible qu'en mode notes et en mode accords.  Dans les autres
situations, comme en mode paroles par exemple, la commande @code{\\skip}
produit les mêmes effets.

"
  doctitlefr = "Sauts de notes en mode paroles"

  lsrtags = "really-simple, rhythms, vocal-music"

  texidoc = "
The @code{s} syntax for skips is only available in note mode and chord
mode. In other situations, for example, when entering lyrics, using the
@code{\\skip} command is recommended.

"
  doctitle = "Skips in lyric mode"
} % begin verbatim


<<
  \relative c'' { a1 | a }
  \new Lyrics \lyricmode { \skip 1 bla1 }
>>

