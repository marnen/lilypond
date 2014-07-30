%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.di.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.18.0"

\header {
  lsrtags = "pitches, staff-notation, tweaks-and-overrides"

  texidoc = "
The command @code{\\clef \"treble_8\"} is equivalent to setting
@code{clefGlyph}, @code{clefPosition} (which controls the vertical
position of the clef), @code{middleCPosition} and
@code{clefOctavation}. A clef is printed when any of the properties
except @code{middleCPosition} are changed.


Note that changing the glyph, the position of the clef, or the
octavation does not in itself change the position of subsequent notes
on the staff: the position of middle C must also be specified to do
this. In order to get key signatures on the correct staff lines,
@code{middleCClefPosition} must also be set.  The positional parameters
are relative to the staff center line, positive numbers displacing
upwards, counting one for each line and space. The
@code{clefOctavation} value would normally be set to 7, -7, 15 or -15,
but other values are valid.


When a clef change takes place at a line break the new clef symbol is
printed at both the end of the previous line and the beginning of the
new line by default. If the warning clef at the end of the previous
line is not required it can be suppressed by setting the @code{Staff}
property @code{explicitClefVisibility} to the value
@code{end-of-line-invisible}. The default behavior can be recovered
with  @code{\\unset Staff.explicitClefVisibility}.

The following examples show the possibilities when setting these
properties manually. On the first line, the manual changes preserve the
standard relative positioning of clefs and notes, whereas on the second
line, they do not.

"
  doctitle = "Tweaking clef properties"
} % begin verbatim

\layout {
  indent = 0
  ragged-right = ##t
}
{
  % The default treble clef
  \key f \major
  c'1
  % The standard bass clef
  \set Staff.clefGlyph = #"clefs.F"
  \set Staff.clefPosition = #2
  \set Staff.middleCPosition = #6
  \set Staff.middleCClefPosition = #6
  \key g \major
  c'1
  % The baritone clef
  \set Staff.clefGlyph = #"clefs.C"
  \set Staff.clefPosition = #4
  \set Staff.middleCPosition = #4
  \set Staff.middleCClefPosition = #4
  \key f \major
  c'1
  % The standard choral tenor clef
  \set Staff.clefGlyph = #"clefs.G"
  \set Staff.clefPosition = #-2
  \set Staff.clefTransposition = #-7
  \set Staff.middleCPosition = #1
  \set Staff.middleCClefPosition = #1
  \key f \major
  c'1
  % A non-standard clef
  \set Staff.clefPosition = #0
  \set Staff.clefTransposition = #0
  \set Staff.middleCPosition = #-4
  \set Staff.middleCClefPosition = #-4
  \key g \major
  c'1 \break

  % The following clef changes do not preserve
  % the normal relationship between notes, key signatures
  % and clefs:

  \set Staff.clefGlyph = #"clefs.F"
  \set Staff.clefPosition = #2
  c'1
  \set Staff.clefGlyph = #"clefs.G"
  c'1
  \set Staff.clefGlyph = #"clefs.C"
  c'1
  \set Staff.clefTransposition = #7
  c'1
  \set Staff.clefTransposition = #0
  \set Staff.clefPosition = #0
  c'1

  % Return to the normal clef:

  \set Staff.middleCPosition = #0
  c'1
}
