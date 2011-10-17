\version "2.15.15"

\header {
  lsrtags = "rhythms, tweaks-and-overrides"

%% Translation of GIT committish: 2d548a99cb9dba80f2ff035582009477cd37eceb
  texidoces = "

Se pueden imprimir estilos alternativos del corchete o gancho de las
corcheas y figuras menores, mediante la sobreescritura de la propiedad
@code{stencil} del objeto @code{Flag}.  Son valores válidos
@code{modern-straight-flag} y @code{old-straight-flag}.

"
  doctitlees = "Uso de estilos alternativos para los corchetes"



  texidoc = "
Alternative styles of flag on eighth and shorter notes can be displayed
by overriding the @code{stencil} property of @code{Flag}.  Valid values
are @code{modern-straight-flag} and @code{old-straight-flag}.

"
  doctitle = "Using alternative flag styles"
} % begin verbatim

testnotes = {
  \autoBeamOff
  c8 d16 c32 d64 \acciaccatura { c8 } d64 r4
}

\relative c' {
  \time 2/4
  \testnotes

  \override Flag #'stencil = #modern-straight-flag
  \testnotes

  \override Flag #'stencil = #old-straight-flag
  \testnotes

  \revert Flag #'stencil
  \testnotes
}
