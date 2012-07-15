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
Les barres de mesure des regroupements @code{StaffGroup},
@code{PianoStaff} et @code{GrandStaff} sont par défaut d'un seul tenant.
La portion entre les portées peut néanmoins être supprimée, portée par
portée.

"
  doctitlefr = "Suppression de la partie inter-portée des barres de mesure d'un regroupement autre que ChoirStaff"

  lsrtags = "tweaks-and-overrides, rhythms"


%% Translation of GIT committish: b482c3e5b56c3841a88d957e0ca12964bd3e64fa
  texidoces = "
De forma predeterminada, las líneas divisorias en los grupos
StaffGroup, PianoStaff o GrandStaff se conectan entre los pentagramas.
Se puede alterar este comportamiento pentagrama a pentagrama.

"
  doctitlees = "Quitar las barras de compás entre los pentagramas de un StaffGroup PianoStaff o GrandStaff"



  texidoc = "
By default, bar lines in StaffGroup, PianoStaff, or GrandStaff groups
are connected between the staves.  This behaviour can be overridden on
a staff-by-staff basis.

"
  doctitle = "Removing connecting bar lines on StaffGroup PianoStaff or GrandStaff"
} % begin verbatim


\relative c' {
  \new StaffGroup <<
    \new Staff {
      e1 | e
      \once \override Staff.BarLine #'allow-span-bar = ##f
      e1 | e | e
    }
    \new Staff {
      c1 | c | c
      \once \override Staff.BarLine #'allow-span-bar = ##f
      c1 | c
    }
    \new Staff {
      a1 | a | a | a | a
    }
  >>
}

