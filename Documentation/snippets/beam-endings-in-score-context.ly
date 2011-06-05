% DO NOT EDIT this file manually; it is automatically
% generated from Documentation/snippets/new
% Make any changes in Documentation/snippets/new/
% and then run scripts/auxiliar/makelsr.py
%
% This file is in the public domain.
%% Note: this file works from version 2.13.36
\version "2.14.0"

\header {
%% Translation of GIT committish: 59caa3adce63114ca7972d18f95d4aadc528ec3d
  texidoces = "
Las reglas de final de barra especificadas en el contexto
@code{Score} se aplican a todos los pentagramas, pero se pueden
modificar tanto en los niveles de @code{Staff} como de
@code{Voice}:

"
  doctitlees = "Finales de barra en el contexto Score"


%% Translation of GIT committish: 0a868be38a775ecb1ef935b079000cebbc64de40
  texidocde = "
Balkenenderegeln, die im @code{Score}-Kontext definiert werden, wirken
sich auf alle Systeme aus, können aber auf @code{Staff}- und
@code{Voice}-Ebene neu verändert werden:

"
  doctitlede = "Balkenenden auf Score-Ebene"



%% Translation of GIT committish: 190a067275167c6dc9dd0afef683d14d392b7033
  texidocfr = "
Les règles de ligatures définies au niveau du contexte @code{Score}
s'appliqueront à toutes les portées.  Il est toutefois possible de
moduler au niveau @code{Staff} ou @code{Voice}@tie{}:

"
  doctitlefr = "Définition de règles de ligature pour la partition"

  lsrtags = "rhythms"
  texidoc = "
Beat structure rules specified in the @code{Score} context apply to all
staves, but can be modified at both @code{Staff} and @code{Voice}
levels:
"
  doctitle = "Beam endings in Score context"
} % begin verbatim


\relative c'' {
  \time 5/4
  % Set default beaming for all staves
  \set Score.baseMoment = #(ly:make-moment 1 8)
  \set Score.beatStructure = #'(3 4 3)
  <<
    \new Staff {
      c8 c c c c c c c c c
    }
    \new Staff {
      % Modify beaming for just this staff
      \set Staff.beatStructure = #'(6 4)
      c8 c c c c c c c c c
    }
    \new Staff {
      % Inherit beaming from Score context
      <<
        {
          \voiceOne
          c8 c c c c c c c c c
        }
        % Modify beaming for this voice only
        \new Voice {
          \voiceTwo
          \set Voice.beatStructure = #'(6 4)
          a8 a a a a a a a a a
        }
      >>
    }
  >>
}
