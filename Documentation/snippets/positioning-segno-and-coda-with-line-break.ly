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
Le code ci-dessous permet d'adjoindre à un signe @emph{segno} un texte
@emph{D.S. al Coda}, là où se trouverait normalement un bout de portée.
La @emph{coda} entamera une nouvelle ligne.  Une variante, indiquée ici
même, permet de laisser la @emph{coda} sur la même ligne.

"
  doctitlefr = "Positionnement des segno et coda (avec saut de ligne)"

  lsrtags = "breaks, workaround, repeats, symbols-and-glyphs"

  texidoc = "
If you want to place an exiting segno sign and add text like @qq{D.S.
al Coda} next to it where usually the staff lines are you can use this
snippet. The coda will resume in a new line. There is a variation
documented in this snippet, where the coda will remain on the same
line.

"
  doctitle = "Positioning segno and coda (with line break)"
} % begin verbatim


{
  \clef treble
  \key g \major
  \time 4/4
  \relative c'' {
    \repeat unfold 2 {
      | c4 c c c
    }

    % Set segno sign as rehearsal mark and adjust size if needed
    % \once \override Score.RehearsalMark #'font-size = #3
    \mark \markup { \musicglyph #"scripts.segno" }
    \repeat unfold 2 {
      | c4 c c c
    }

    % Set coda sign as rehearsal mark and adjust size if needed
    \once \override Score.RehearsalMark #'font-size = #4
    \mark \markup { \musicglyph #"scripts.coda" }
    \repeat unfold 2 {
      | c4 c c c
    }

    % Should Coda be on anew line?
    % Coda NOT on new line: use \nobreak
    % Coda on new line: DON'T use \nobreak
    % \noBreak

    \bar "||"

    % Set segno sign as rehearsal mark and adjust size if needed
    \once \override Score.RehearsalMark #'break-visibility = #begin-of-line-invisible
    % \once \override Score.RehearsalMark #'font-size = #3
    \mark \markup { \musicglyph #"scripts.segno" }

    % Here begins the trickery!
    % \cadenzaOn will suppress the bar count and \stopStaff removes the staff lines.
    \cadenzaOn
      \stopStaff
        % Some examples of possible text-displays

        % text line-aligned
        % ==================
        % Move text to the desired position
        % \once \override TextScript #'extra-offset = #'( 2 . -3.5 )
        % | s1*0^\markup { D.S. al Coda } }

        % text center-aligned
        % ====================
        % Move text to the desired position
        % \once \override TextScript #'extra-offset = #'( 6 . -5.0 )
        % | s1*0^\markup { \center-column { D.S. "al Coda" } }

        % text and symbols center-aligned
        % ===============================
        % Move text to the desired position and tweak spacing for optimum text alignment
        %\once \override TextScript #'extra-offset = #'( 8 . -5.5 )
        \once \override TextScript #'word-space = #1.5
        \once \override TextScript #'X-offset = #8
        \once \override TextScript #'Y-offset = #1.5
        | s1*0^\markup { \center-column { "D.S. al Coda" \line { \musicglyph #"scripts.coda" \musicglyph #"scripts.tenuto" \musicglyph #"scripts.coda"} } }

        % Increasing the unfold counter will expand the staff-free space
        \repeat unfold 4 {
          s4 s4 s4 s4
          \bar ""
        }
        % Resume bar count and show staff lines again
     \startStaff
   \cadenzaOff

   % Should Coda be on new line?
   % Coda NOT on new line: DON'T use \break
   % Coda on new line: use \break
   \break

   % Show up, you clef and key!
   \once \override Staff.KeySignature #'break-visibility = #end-of-line-invisible
   \once \override Staff.Clef #'break-visibility = #end-of-line-invisible

   % Set coda sign as rehearsal mark and adjust size and position

   % Put the coda sign ontop of the (treble-)clef dependend on coda's line-position

     % Coda NOT on new line, use this:
     % \once \override Score.RehearsalMark #'extra-offset = #'( -2 . 1.75 )

     % Coda on new line, use this:
     \once \override Score.RehearsalMark #'extra-offset = #'( -8.42 . 1.75 )

   \once \override Score.RehearsalMark #'font-size = #5
   \mark \markup { \musicglyph #"scripts.coda" }

   % The coda
   \repeat unfold 5 {
      | c4 c c c
    }
    \bar"|."
  }
}

