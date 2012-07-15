%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.14.2"

\header {
  lsrtags = "winds"

%%%    Translation of GIT committish: b482c3e5b56c3841a88d957e0ca12964bd3e64fa

  texidoces = "

Se puede cambiar el tamaño y grosor de las líneas de los diagramas de
posiciones para instrumentos de viento madera.

"

  doctitlees = "Modificar el tamaño de los diagramas de viento madera"
%%%    Translation of GIT committish: ab9e3136d78bfaf15cc6d77ed1975d252c3fe506


  texidocde="
Die Größe und Dicke der Holzbläserdiagramme kann geändert werden.
"
%%%    Translation of GIT committish: ab9e3136d78bfaf15cc6d77ed1975d252c3fe506


  texidocde="
Die Größe und Dicke der Holzbläserdiagramme kann geändert werden.
"

  doctitlede = "Größe von Holzbläserdiagrammen ändern"

%% Translation of GIT committish: 3b125956b08d27ef39cd48bfa3a2f1e1bb2ae8b4
  texidocfr = "
La taille et l'épaisseur des diagrammes de doigté pour bois est modifiable
à souhait.

"
  doctitlefr = "Modification de la taille d'un diagramme pour bois"


  texidoc = "
The size and thickness of woodwind diagrams can be changed.

"
  doctitle = "Changing the size of woodwind diagrams"
} % begin verbatim

\relative c'' {
  \textLengthOn
  c1^\markup
    \woodwind-diagram
      #'piccolo
      #'()

  c^\markup
    \override #'(size . 1.5) {
      \woodwind-diagram
        #'piccolo
        #'()
    }
  c^\markup
    \override #'(thickness . 0.15) {
      \woodwind-diagram
        #'piccolo
        #'()
    }
}
