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

Las barras de semicorchea, o de figuras más breves, no se subdividen
de forma predeterminada.  Esto es, las tres (o más) barras se amplían
sin romperse sobre grupos completos de notas.  Este comportamiento se
puede modificar para subdividir las barras en subgrupos mediante el
establecimiento de la propiedad @code{subdivideBeams}.  Cuando está
activada, las barras se subdividen a intervalos definidos por el valor
actual de @code{baseMoment} mediante la reducción de las barras
repetidas a una sola entre los subgrupos.  Observe que el valor
predeterminado de @code{baseMoment} es uno más que el denominador del
tipo de compás actual, si no se fija explícitamente.  Se debe ajustar
a una fracción que da la duración del subgrupo de barras utilizando la
función @code{ly:make-moment}, como se ve en este fragmento de código.
Asimismo, cuando se modifica @code{baseMoment}, se debería cambiar
también @code{beatStructure} para que corresponda al @code{baseMoment}
nuevo:

"
  doctitlees = "Subdivisión de barras"

%% Translation of GIT committish: 190a067275167c6dc9dd0afef683d14d392b7033
  texidocfr = "
Les ligatures d'une succession de notes de durée inférieure à la croche
ne sont pas subdivisées par défaut.  Autrement dit, tous les traits de
ligature ( deux ou plus) seront continus.  Ce comportement peut être
modifié afin de diviser la ligature en sous-groupes grâce à la propriété
@code{subdivideBeams}.  Lorsqu'elle est activée, les ligatures seront
subdivisées selon un intervalle défini par @code{baseMoment}@tie{}; il n'y
aura alors plus qu'un seul trait de ligature entre chaque sous-groupe.
Par défaut, @code{baseMoment} fixe la valeur de référence par rapport à
la métrique en vigueur.  Il faudra donc lui fournir, à l'aide de la
fonction @code{ly:make-moment}, une fraction correspondant à la durée du
sous-groupe désiré comme dans l'exemple ci-dessous.  Gardez à l'esprit
que, si vous venez à modifier @code{baseMoment}, vous devrez
probablement adapter @code{beatStrusture} afin qu'il reste en adéquation
avec les nouvelles valeurs de @code{baseMoment}.

"
  doctitlefr = "Subdivision des ligatures"

  lsrtags = "rhythms"

  texidoc = "
The beams of consecutive 16th (or shorter) notes are, by default, not
subdivided.  That is, the three (or more) beams stretch unbroken over
entire groups of notes.  This behavior can be modified to subdivide
the beams into sub-groups by setting the property
@code{subdivideBeams}. When set, multiple beams will be subdivided at
intervals defined by the current value of @code{baseMoment} by reducing
the multiple beams to just one beam between the sub-groups. Note that
@code{baseMoment} defaults to one over the denominator of the current
time signature if not set explicitly. It must be set to a fraction
giving the duration of the beam sub-group using the
@code{ly:make-moment} function, as shown in this snippet. Also, when
@code{baseMoment} is changed, @code{beatStructure} should also be changed
to match the new @code{baseMoment}:

"
  doctitle = "Subdividing beams"
} % begin verbatim


\relative c'' {
  c32[ c c c c c c c]
  \set subdivideBeams = ##t
  c32[ c c c c c c c]

  % Set beam sub-group length to an eighth note
  \set baseMoment = #(ly:make-moment 1 8)
  \set beatStructure = #'(2 2 2 2)
  c32[ c c c c c c c]

  % Set beam sub-group length to a sixteenth note
  \set baseMoment = #(ly:make-moment 1 16)
  \set beatStructure = #'(4 4 4 4)
  c32[ c c c c c c c]
}

