\version "1.9.4"
\header {
texidoc = "Stanza numbers may differ for the first and following systems."
}

\score {
<<
    \context LyricsVoice
    \lyrics {
	\property LyricsVoice . stanza = "first"
	\property LyricsVoice . stz =  \markup { "32" \super "nd"  }
	Foo1 Bar1
    }
    \notes { c''1 \break c''1 }
>>

\paper { raggedright = ##t } 
} 


