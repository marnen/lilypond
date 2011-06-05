%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.14.0"

\header {
  lsrtags = "vocal-music, template"

%% Translation of GIT committish: 59caa3adce63114ca7972d18f95d4aadc528ec3d
  texidoces = "
Esta pequeña plantilla muestra una melodía sencilla con letra. Córtela
y péguela, escriba las notas y luego la letra. Este ejemplo desactiva
el barrado automático, que es lo más frecuente en las partes vocales
antiguas. Para usar el barrado automático modifique o marque como un
comentario la línea correspondiente.

"
  doctitlees = "Plantilla de pentagrama único don notas y letra"


%% Translation of GIT committish: fa1aa6efe68346f465cfdb9565ffe35083797b86
  texidocja = "
この小さなテンプレートは歌詞を持つ簡単な旋律を表しています。カット＆ペーストして、音符@c
を付け加えて、それから歌詞の単語を付け加えてください。この例は自動ビームを off にして@c
います。これはボーカル パートでは一般的なことです。自動ビームを使用するには、対応する@c
行を変更するか、コメント アウトしてください。
"


%% Translation of GIT committish: 0a868be38a775ecb1ef935b079000cebbc64de40
  texidocde = "
Das nächste Beispiel zeigt eine einfache Melodie mit Text. Kopieren
Sie es in Ihre Datei, fügen Sie Noten und Text hinzu und übersetzen
Sie es mit LilyPond. In dem Beispiel wird die automatische
Balkenverbindung ausgeschaltet (mit dem Befehl @code{\\autoBeamOff}),
wie es für Vokalmusik üblich ist.
Wenn Sie die Balken wieder einschalten wollen, müssen Sie die
entsprechende Zeile entweder ändern oder auskommentieren.
"

  doctitlede = "Vorlage für ein Notensystem mit Noten und Gesangstext"


%% Translation of GIT committish: bdfe3dc8175a2d7e9ea0800b5b04cfb68fe58a7a

  texidocfr = "
Ce canevas comporte une simple ligne mélodique agrémentée de paroles.
Recopiez-le, ajoutez-y d'autres notes et paroles.  Les ligatures
automatiques sont ici désactivées, comme il est d'usage en matière de
musique vocale.  Pour activer la fonction de ligature automatique,
modifiez ou commentez la ligne en question.

"
  doctitlefr = "Portée unique et paroles"

  texidoc = "
This small template demonstrates a simple melody with lyrics. Cut and
paste, add notes, then words for the lyrics. This example turns off
automatic beaming, which is common for vocal parts. To use automatic
beaming, change or comment out the relevant line.

"
  doctitle = "Single staff template with notes and lyrics"
} % begin verbatim

melody = \relative c' {
  \clef treble
  \key c \major
  \time 4/4

  a4 b c d
}

text = \lyricmode {
  Aaa Bee Cee Dee
}

\score{
  <<
    \new Voice = "one" {
      \autoBeamOff
      \melody
    }
    \new Lyrics \lyricsto "one" \text
  >>
  \layout { }
  \midi { }
}

