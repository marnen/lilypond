\header{
filename =	 "standchen.ly";
title    = "St\\\"andchen";
subtitle = "(Serenade)\\\\``Leise flehen meine Lieder''";
opus =	 "D. 957 No. 4";
date = "August 1828";
composer =	 "Franz Schubert (1797-1828)";
poet=	 "Text by Ludwig Rellstab (1799-1860)";
enteredby =	 "JCN";
copyright =	 "public domain";
} 

%{
 Tested Features@ multivoice accents lyrics chords piano music
multiple \paper{}s in one \score 
Note: Original key F.
%}

\version "1.1.52";

vocalVerse = \notes\relative c''{
	\property Voice.dynamicDir=1
	\times 2/3 { [ g8( )as] g } c4. g8 |
	\times 2/3 { [ f8( )g] f } c'4 f,8 r |
	g4.-> f8 \times 2/3 { [ f( )es] d } |
	es2 r4 |
	R2. |
	R2. |
	\times 2/3 { [ g8( )as] g } es'4. g,8 |
	\times 2/3 { [ f8( )g] f } d'4. c8 |
	bes4. as8 \times 2/3 { [ as( )g] f } |
	g2 r4 |
	R2. |
	R2. |
	g8. b16 es4. d8 |
	c8. g16 es4. c8 |
	% \times 2/3 { [ as\grace( bes ] )
	\grace { as'16 bes } \times 2/3 { [ )as8( )g] as } c4. as8 |
	g2. |
	\grace { f16( g } \times 2/3 { [ )f8( )e] f } as4. f8 |
  
	es!2. |
	g8. b16 es4. d8 |
	c8. g16 e4. c8 |
 	\grace { a'16( b } \times 2/3 { [ )a!8( ) gis] a } c4. a8 |
	g!2. |
	% \times 2/3 { [ a\grace( b] )
	\times 2/3 { [ d'8\f cis] d } f4. b,8 |
	c!2. |
}

vocalThrough = \notes\relative c{
	\property Voice.dynamicDir=1
	g''8. g16 b8. b16 d8. d16 |
	c4 b r |
	g4. b8 d8. c16 |
	b2 r4 |
	e4. d8 \times 2/3 { [ d( )c] b } |
	a8. b16 c4-> a8 r |
	R2. |
	R2. |
	\grace { a16( b } \times 2/3 { [ )a!8( ) gis] a } c4. a8 |
	g!2. |
	\times 2/3 { [ d'8\f cis] d } f4. b,8 |
	c!2. ~ |
	c4 r c |
	as2. |
	g |
	e2 r4 |
}

lyricVerse1 = \lyrics{
% 5
	\times 2/3 {  Lei-4 se8 } fleh-4. en8 |
	\times 2/3 {  mei-4 ne8 } Lie-4 der8 " "8 |
	Durch4. die8 \times 2/3 {  Nacht4 zu8 } |
	dir;2 " "4 |
	" "2.*2
%{	" "4 " " " " |
	" " " " " " |%}
% 11
	\times 2/3 {  In4 den8 } stil-4. len8 |
	\times 2/3 {  Hain4 her-8 } nie-4. der8 |
	Lieb-4. chen,8 \times 2/3 {  komm4 zu8 } |
	mir!2 " "4 |
		" "2.*2
%{	" "4 " " " " |
	" " " " " " |%}
% 17
	Fl\"us-8. ternd16 schlan-4. ke8 |
	Wip-8. fel16 rau-4. schen8 |
	\times 2/3 {  In4 des8 } Mon-4. des8 |
	Licht;2. |
	\times 2/3 {  In4 des8 } Mon-4. des8 |
	Licht;2. |
% 23 
	Des8. Ver-16 r\"a-4. thers8 |
	feind-8. lich16 Lau-4. schen8 |
	\times 2/3 {  F\"urch-4 te8 } Hol-4. de8 |
	nicht2. |
	\times 2/3 {  f\"urch-4 te8 } Hol-4. de8 |
	nicht.2. |
}
	
lyricVerse2 = \lyrics{
% 5
	\times 2/3 {  H\"orst4 die8 } Nach-4. ti-8 
	\times 2/3 {  gal-4 len8 } schla-4 gen?8 " "8
	ach!4. sie8 \times 2/3 {  fleh-4 en8 } 
	dich,2 " "4
	" "2.*2
%{	" "4 " " " " 
	" "4" " " "
%}
% 11
	\times 2/3 {  Mit4 der8 } T\"o-4. ne8
 	\times 2/3 {  s\"u-4 "\ss en"8 } Kla-4. gen8
	Fleh-4. en8 \times 2/3 {  sie4 f\"ur8 }
	mich2 " "4
	" "2.*2
%{	" "4" " " " 
	" "4" " " "
%}
% 17
	Sie-8. ver-16 stehn4. des8
	Bus-8. ens16 Seh-4. nen8
	\times 2/3 {  Ken-4 nen8 } Lieb-4. es-8 
	schmerz,2.
	\times 2/3 {  Ken-4 nen8 } Lieb-4. es-8 
	schmerz.2.

% 23
	R\"uh-8. ren16 mit4. den8 
	Sil-8. ber-16 t\"o-4. nen8
	\times 2/3 {  jed-4 es8 } wei-4. che8 
	Herz,2.
	\times 2/3 {  jed-4 es8 } wei-4. che8 
	Herz.2.
}

lyricThrough = \lyrics{
% 37
	La\ss8. auch16 dir8. die16 Brust8. be-16 |
	we-4 gen " " |
	Lieb-4. chen,8 h\"o-8. re16 |
	mich!2 " "4 |
	Be-4. bend8 \times 2/3 {  harr'4 ich8} |
	dir8. ent-16 ge-4 gen!8 " "8 |
	" "2. |
	" "2. |
	\times 2/3 {  Komm4 be-8 } gl\"u4. cke8 |
	mich!2. |
	\times 2/3 {  Komm4 be-8 } gl\"u4. cke8 |
	mich,2. __ |
	" "2 be-4 |
	gl\"u-2. |
	cke2. |
	mich!2 " "4 |
}

trebleIntro = \notes\relative c{
	r8^"\bf m\\\"a\\\ss ig"\pp <g'-. c-.> <c-. es-.> <g-. c-.> <c-. es-.> <g-. c-.> |
	r8 <as-. c-.> <c-. es-.> <as-. c-.> <c-. es-.> <as-. c-.> |
	r8 <as-. c-.> <c-. d-.> <as-. c-.> <c-. d-.> <as-. c-.> |
	r8 <g-. b-.> <b-. d-.> <g-. b-.> <b-. d-.> <g-. b-.> |
	\break
}

trebleVerse1 = \notes\relative c{
	%5
	r8 <g' c> <c es> <g c> <c es> <g c> |
	r8 <f c'> <c' d> <f, c'> <c' d> <f, c'> |
	r8 <f g b> <g b d> <f g b> <g b d> <f g b> |
	r8 <es g c> <g c es> <es g c> <g c es> <es g c> |
	<g''4.( b,> <)f8 d>
	\times 2/3 { < [ f( d> <es c> <)d b] > } |
	%10
	<c2. es> |
	r8 <g, c> <c es> <g c> <c es> <g c> |
	r8 <f c'> <c' d> <f, c'> <c' d> <f, c'> |
	r8 <f as bes> <as bes d> <f g bes> <as bes d> <f g bes> |
	r8 <es g bes> <g bes es> <es g bes> <g bes es> 
	<{ es'( )  d4.() f8}{ c' | bes4.  as8 } > 
	\times 2/3 { < [f( as> <es g> <)d f] > } |
	%16
	<es2. g> |
	r8 <f, g> <g b> <f g> <g b> <f g> |
	r8 <es g> <g c> <es g> <g c> <es g> |
	r8\pp <es as c> <as c es> <es as c> <as c es> <es as c> |
	%20
	r8 <es g bes> <g bes es> <es g bes> <g bes es> <es g bes> |
	\grace { as'16( bes } \times 2/3 { [ )as8( g as] } c4.-> ) as8 |
	g2. |
	r8 <f, g> <g b> <f g> <g b> <f g> |
	r8 <e g> <g c> <e g> <g c> <e g> |
	r8 <f a c> <a c f> <f a c> <a c f> <f a c> |
	r8 <e g c> <g c e> <e g c> <g c e> <e g c> |
	\times 2/3 <
	  { [ f'8\f( e f]  }
	  {  f' e f } >
	< {a4.- > )f8}  { a'4. f8 }  > |
}

trebleEentje = \notes \relative c'{
	\context Voice=one \property Voice.verticalDirection = 0
	<e2 e'> <e4 g>|
	<f2\mf as!(> <as8.->( c> <)f16 )as> |
	<e4. g> <e8-. g-.(> <e-. g-.> <e-. )g-.> |
	<f4. g> <b,8-. g'-.(> <d-. g-.> <f-. )g-.> |
	<e2 g> <e4\pp g> |
	<f2 a(> <a8. c> <f16 )a> |
	<e4. g> <e8-. g-.(> <e-. g-.> <e-. )g-.> |
	<f4. g> <b,8-. g'-.(> <d-. g-.> <f-. )g-.> |
	%60
	<e2. g> |
}

trebleThrough = \notes \relative c'{
	\context Voice=one \property Voice.verticalDirection = 0
	<e2. e'> |
	%61
	R2. |
	[<g,8.\< g'> <g16 g'> <b8. b'> <\! b16\> b'16> <d8. d'> <d16 d'>] |
	< { c4( )b } { c'4( )b } > \!r |

	<g4. g'> <b8 b'> [<d'8.-> d,-> > c16] |
	%65
	< { d,2.\f a'2} { e2. ~ e2 } { b'2. c,2 }> r4 |
	\context Staff < 
		{
			\context Voice=one \property Voice.verticalDirection = 1 
			a8. b16 c4-> () a8 r |
			a8. b16 c4-> () a8 r |
		}
		{ 
			\context Voice=two \property Voice.verticalDirection = -1 
			<d,4 f> <d2 f> |
			<c!4 es> <c2 es> |
		}
	>
	\context Voice=one \property Voice.verticalDirection = 0
	% 4 bars copied from end verse1
	r8 <f, a c> <a c f> <f a c> <a c f> <f a c> |
	%70
	r8 <e g c> <g c e> <e g c> <g c e> <e g c> |
	\times 2/3 < { [ f'8\f( e f] }
	   {  f' e f }>
	< { a4.-> )f8 } { a'4. f8 } > |
	<e2 e'> r4 |
	<es!2 es'! > r4 |
	\property Voice . textStyle =  "italic"
	<d2_"decresc." d'> r4 |
	%75
	<b2 b'> r4 |
	<c2 c'> <e4\pp g> |

	% four copied from begin eentje
	<f2 as!(> <as8.-> c> <f16 )as> |
	<e4. g> <e8-. g-.(> <e-. g-.> <e-. )g-.> |
	<f4. g> <b,8-. g'-.(> <d-. g-.> <f-. )g-.> |
	%80
	\property Voice . textStyle =  "italic"
	<e2._"dim." g> |
	<g,2. e' g> |
	<g2.-\fermata e' g> |
}

bassIntro = \notes\relative c{
	\property Voice.dynamicDir=1
%1
	<c,2 c'> r4 |
	<as2 as'> r4 |
	<f2 f'> r4 |
	<g2 g'> r4 |
}

bassVerse1 = \notes\relative c{
%	\clef bass;
	\property Voice.dynamicDir=1
%5
	<c,2 c'> r4 |
	<as2 as'> r4 |
	<g2 g'> r4 |
	<c2 c'> r4 |
	<g8 g'> [<g'' d'> <d' f> <g, d'> <d' f> <g, d'>] |
%10
	<c,,8 c'> [<g'' c> <c es> <g c> <c es> <g c>] |
	<c,,2 c'> r4 |
	<as2 as'> r4 |
	<bes2 bes'> r4 |
	<es,2 es'> r4 |
%15
	bes'8 [<bes' f'> <f' as> <bes, f'> <f' as> <bes, f'>] |
	es,8 [<bes' es> <es g> <bes es> <es g> <bes es>] |
	<g,2 g'> r4 |
	<c2 c'> r4 |
	<as2 as'> r4 |
	<es2 es'> r4 |
	<bes'8 bes'> [<f'' bes> <bes d> <f bes> <bes d> <f bes>] |
	<es,,8 es'> [<es'' g bes> <g bes es> <es g bes> <g bes es> <es g bes>] |
	<g,,2 g'> r4 |
	<c2 c'> r4 |
	<f,2 f'> r4 |
	<c'2 c'> r4 |
	<g8 g'> [<d'' g> <g b> <d g> <g b> <d g>] |
	c,8 [<c' e g> <e g c> <c e g> <e g c> <c e g>] |
}

bassEentje = \notes\relative c{
	\property Voice.dynamicDir=1
	<c,8 c'> [<c' f as!> <f as c> <c f as> <f as c> <c f as>] |
	c,8 [<c' e g> <e g c> <c e g> <e g c> <c e g>] |
	<g,8 g'> [<d'' g> <g b> <d g> <g b> <d g>] |
	c,8 [<e' g> <g c> <e g> <g c> <e g>] |
	<c,8 c'> [<c' f a> <f a c> <c f a> <f a c> <c f a>] |
	c,8 [<c' e g> <e g c> <c e g> <e g c> <c e g>] |
	<g,8 g'> [<d'' g> <g b> <d g> <g b> <d g>] |
	c,8 [<e' g> <g c> <e g> <g c> <e g>] |
}

bassThrough = \notes\relative c{
	\property Voice.dynamicDir=1
	%61
	<g,8^"cresc." g'> [<g' b d> <b d f> <g b d> <as!-> b-> d->> <b d f>] |
	<g,8 g'> [<g' d'> <d' f> <g, d'> <as-> b-> d->> <b d f>] |
	% copied
	<g,8 g'> [<g' d'> <d' f> <g, d'> <as-> b-> d->> <b d f>] |
	<g,8 g'> [<g' d' e> <d' f> <g, d'> <gis-> b-> d->> <b d f>] |
	%65
	<gis,8 gis'> [<d''\> e> <e b'> <d e> <e b'> <d\! e>] |
	<a,8 a'> [<c' e> <e a> <c e> <e a> <c e>] |
	<a,8 a'> [<a' d f> <d f a> <a d f> <d f a> <a d f>] |
	<a,8 a'> [<a' c e> <c e a> <a c e> <c e a> <a c e>] |
	% 4 bars copied from end verse1
	<f,2\p f'> r4 |
	%70
	<c'2 c'> r4 |
	<g8 g'> [<d'' g> <g b> <d g> <g b> <d g>] |
	c,8\> [<c' e g> < \! e g c> <c e g> <e g c> <c e g>] |

	<c,8 c'> [<c' es! g> <es g c> <c es g> <es g c> <c es g>] |
	<f,,8 f'> [<d'' f> <f as!> <d f> <f as> <d f>] |
	%75
	<g,,8 g'> [<d'' f> <f g> <d f> <f g> <d f>] |
	c,8 [<c' e> <e g> <c e> <e g> <c e>] |
	c,8 [<c' f> <f as> <c f> <f as> <c f>] |
	c,8 [<c' e> <e g> <c e> <e g> <c e>] |
	<g,8 g'> [<g' d'> <d' f> <g, d'> <d' f> <g, d'>] |
	%80
	c,8 [<c' e> <e g> <c e> <e g> <c e>] |
	c,8 [<c' g> <e c> <c g> <e c> <c g>] |
	<c,2._\fermata g' c> |
}
		
global = \notes{
	\time 3/4; 
	\key es;
	\skip 4 * 12;
	\break
	\skip 4 * 234;
	\bar "|.";
}


lyricFour = \lyrics{
	" "2.*4
%{	" "4 " " " "
	" " " " " "
	" " " " " "
	" " " " " "%}
}
 
allLyrics = {
	\time 3/4; 
%	\skip 4 * 12; 
	\lyricFour
	\lyricVerse1
%	\skip 4 * 24; 
	\lyricFour
	\lyricFour
	\lyricVerse2
	\lyricThrough
}

lyricStaff = \context Lyrics = lyric<
	\allLyrics
>
		
vocals = \notes{
	\clef treble;
 	% certainly no auto-beaming for vocals
 	\property Voice.beamAuto=0
 

	\property Voice.dynamicDir = \up
	\skip 4 * 12; 
	\vocalVerse 
	\skip 4 * 24; 
	\vocalVerse
	\vocalThrough
}

vocalStaff = \context Staff = vocal<
	\property Staff.instrument = "alto sax"
	\global
	\vocals
>

treble = {
	\clef treble;
	\property Voice.beamAutoBegin=0
	\trebleIntro 
	\trebleVerse1 
	\trebleEentje
	\trebleVerse1 
	\trebleThrough
}

trebleStaff = \context Staff = treble< 
	\global
	\treble
>

bass = {
	\clef bass;
	\bassIntro 
	\bassVerse1 
	\bassEentje
	\bassVerse1 
	\bassThrough
}

bassStaff = \context Staff = bass<
	\global
	\bass
>

grandStaff = \context PianoStaff <
	\trebleStaff
	\bassStaff
>

\score{
	% Transpose as you like for your voice
	% Range untransposed is c' to f'' (for tenors and sopranos)
	% To get original, \transpose d'
	% \transpose a gives a' to d'' (for basses, who sing an octave down)
	<
% kjoet, but i like the original better -- jcn
%		{ \notes \transpose a { \vocalStaff } }
%		\lyricStaff
%		{ \notes \transpose a { \grandStaff } }
		{ \notes { \vocalStaff } }
		\lyricStaff
		{ \notes { \grandStaff } }
	>
	\paper { 
%		\translator { \OrchestralScoreContext }
%		\translator { \OrchestralPartStaffContext }
		\translator { \HaraKiriStaffContext }
	}
%broken 1.1.51
%	\midi{
%		\tempo 4 = 54;
%	}
}
