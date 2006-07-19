/*
  parser.yy -- Bison/C++ parser for LilyPond

  source file of the GNU LilyPond music typesetter

  (c) 1997--2006 Han-Wen Nienhuys <hanwen@xs4all.nl>
                 Jan Nieuwenhuizen <janneke@gnu.org>
*/

%{

#define YYERROR_VERBOSE 1
#define YYPARSE_PARAM my_lily_parser
#define YYLEX_PARAM my_lily_parser
#define PARSER ((Lily_parser *) my_lily_parser)

#define yyerror PARSER->parser_error

/* We use custom location type: Input objects */
#define YYLTYPE Input
#define YYLLOC_DEFAULT(Current,Rhs,N) \
	((Current).set_location ((Rhs)[1], (Rhs)[N]))


%}

/* We use SCMs to do strings, because it saves us the trouble of
deleting them.  Let's hope that a stack overflow doesnt trigger a move
of the parse stack onto the heap. */

%left PREC_TOP
%left ADDLYRICS
%left PREC_BOT

%expect 1

/* One shift/reduce problem

1.  \repeat
	\repeat .. \alternative

    \repeat { \repeat .. \alternative }

or

    \repeat { \repeat } \alternative 
*/


%pure_parser
%locations



%{ // -*-Fundamental-*-

/*
FIXME:

   * The rules for who is protecting what are very shady.  Uniformise
     this.

   * There are too many lexical modes?
*/

#include "config.hh"

#include <cctype>
#include <cstdlib>
#include <cstdio>
using namespace std;

#include "book.hh"
#include "context-def.hh"
#include "dimensions.hh"
#include "file-path.hh"
#include "input-smob.hh"
#include "input.hh"
#include "international.hh"
#include "lily-guile.hh"
#include "lily-lexer.hh"
#include "lily-parser.hh"
#include "lilypond-input-version.hh"
#include "main.hh"
#include "misc.hh"
#include "music.hh"
#include "music.hh"
#include "output-def.hh"
#include "paper-book.hh"
#include "program-option.hh"
#include "scm-hash.hh"
#include "score.hh"
#include "text-interface.hh"
#include "warn.hh"

%}


%union {
	Book *book;
	Output_def *outputdef;
	SCM scm;
	std::string *string;
 	Music *music;
 	Score *score;
 	int i;
}

%{

#define MY_MAKE_MUSIC(x)  make_music_by_name (ly_symbol2scm (x))

/* ES TODO:
- Don't use lily module, create a new module instead.
- delay application of the function
*/
#define LOWLEVEL_MAKE_SYNTAX(proc, args)	\
  scm_apply_0 (proc, args)
/* Syntactic Sugar. */
#define MAKE_SYNTAX(name, location, ...)	\
  LOWLEVEL_MAKE_SYNTAX (ly_lily_module_constant (name), scm_list_n (PARSER->self_scm (), make_input (location), __VA_ARGS__, SCM_UNDEFINED));

SCM get_next_unique_context_id ();
SCM get_next_unique_lyrics_context_id ();

#undef _
#if !HAVE_GETTEXT
#define _(x) x
#else
#include <libintl.h>
#define _(x) gettext (x)
#endif



SCM make_music_relative (Pitch start, SCM music);
SCM run_music_function (Lily_parser *, SCM expr);
SCM get_first_context_id (SCM type, Music *m);
SCM make_chord_elements (SCM pitch, SCM dur, SCM modification_list);
SCM make_chord_step (int step, int alter);
SCM make_simple_markup (SCM a);
bool is_duration (int t);
bool is_regular_identifier (SCM id);
bool ly_input_procedure_p (SCM x);
int yylex (YYSTYPE *s, YYLTYPE *loc, void *v);
void set_music_properties (Music *p, SCM a);

%}

/* The third option is an alias that will be used to display the
   syntax error.  Bison CVS now correctly handles backslash escapes.

   FIXME: Bison needs to translate some of these, eg, STRING.

*/	
   
/* Keyword tokens with plain escaped name.  */
%token ACCEPTS "\\accepts"
%token ADDLYRICS "\\addlyrics"
%token ADDQUOTE "\\addquote"
%token ALIAS "\\alias"
%token ALTERNATIVE "\\alternative"
%token BOOK "\\book"
%token CHANGE "\\change"
%token CHORDMODE "\\chordmode"
%token CHORDS "\\chords"
%token CONSISTS "\\consists"
%token CONTEXT "\\context"
%token DEFAULT "\\default"
%token DEFAULTCHILD "\\defaultchild"
%token DENIES "\\denies"
%token DESCRIPTION "\\description"
%token DRUMMODE "\\drummode"
%token DRUMS "\\drums"
%token FIGUREMODE "\\figuremode"
%token FIGURES "\\figures"
%token GROBDESCRIPTIONS "\\grobdescriptions"
%token HEADER "\\header"
%token INVALID "\\invalid"
%token KEY "\\key"
%token LAYOUT "\\layout"
%token LYRICMODE "\\lyricmode"
%token LYRICS "\\lyrics"
%token LYRICSTO "\\lyricsto"
%token MARK "\\mark"
%token MARKUP "\\markup"
%token MIDI "\\midi"
%token NAME "\\name"
%token NOTEMODE "\\notemode"
%token OBJECTID "\\objectid"	
%token OCTAVE "\\octave"
%token ONCE "\\once"
%token OVERRIDE "\\override"
%token PAPER "\\paper"
%token PARTIAL "\\partial"
%token RELATIVE "\\relative"
%token REMOVE "\\remove"
%token REPEAT "\\repeat"
%token REST "\\rest"
%token REVERT "\\revert"
%token SCORE "\\score"
%token SEQUENTIAL "\\sequential"
%token SET "\\set"
%token SIMULTANEOUS "\\simultaneous"
%token SKIP "\\skip"
%token TEMPO "\\tempo"
%token TIMES "\\times"
%token TRANSPOSE "\\transpose"
%token TRANSPOSITION "\\transposition"
%token TYPE "\\type"
%token UNSET "\\unset"
%token WITH "\\with"

/* Keyword token exceptions.  */
%token TIME_T "\\time"
%token NEWCONTEXT "\\new"


/* Other string tokens.  */

%token CHORD_BASS "/+"
%token CHORD_CARET "^"
%token CHORD_COLON ":"
%token CHORD_MINUS "-"
%token CHORD_SLASH "/"
%token ANGLE_OPEN "<"
%token ANGLE_CLOSE ">"
%token DOUBLE_ANGLE_OPEN "<<"
%token DOUBLE_ANGLE_CLOSE ">>"
%token E_BACKSLASH "\\"
%token E_ANGLE_CLOSE "\\>"
%token E_CHAR "\\C[haracter]"
%token E_CLOSE "\\)"
%token E_EXCLAMATION "\\!"
%token E_BRACKET_OPEN "\\["
%token E_OPEN "\\("
%token E_BRACKET_CLOSE "\\]"
%token E_ANGLE_OPEN "\\<"
%token E_PLUS "\\+"
%token E_TILDE "\\~"
%token EXTENDER "__"

/*
If we give names, Bison complains.
*/
%token FIGURE_CLOSE /* "\\>" */
%token FIGURE_OPEN /* "\\<" */
%token FIGURE_SPACE "_"
%token HYPHEN "--"

%token CHORDMODIFIERS
%token LYRIC_MARKUP
%token MULTI_MEASURE_REST
%token SCM_T


%token <i> DIGIT
%token <i> E_UNSIGNED
%token <i> UNSIGNED

%token <scm> BOOK_IDENTIFIER
%token <scm> CHORDMODIFIER_PITCH
%token <scm> CHORD_MODIFIER
%token <scm> CONTEXT_DEF_IDENTIFIER
%token <scm> DRUM_PITCH
%token <scm> DURATION_IDENTIFIER
%token <scm> EVENT_IDENTIFIER
%token <scm> FRACTION
%token <scm> LYRICS_STRING
%token <scm> LYRIC_MARKUP_IDENTIFIER
%token <scm> MARKUP_HEAD_EMPTY
%token <scm> MARKUP_HEAD_LIST0
%token <scm> MARKUP_HEAD_MARKUP0
%token <scm> MARKUP_HEAD_MARKUP0_MARKUP1
%token <scm> MARKUP_HEAD_SCM0
%token <scm> MARKUP_HEAD_SCM0_MARKUP1
%token <scm> MARKUP_HEAD_SCM0_SCM1
%token <scm> MARKUP_HEAD_SCM0_SCM1_MARKUP2
%token <scm> MARKUP_HEAD_SCM0_SCM1_SCM2
%token <scm> MARKUP_IDENTIFIER
%token <scm> MUSIC_FUNCTION
%token <scm> MUSIC_FUNCTION_MARKUP 
%token <scm> MUSIC_FUNCTION_MARKUP_MARKUP 
%token <scm> MUSIC_FUNCTION_MARKUP_MARKUP_MUSIC 
%token <scm> MUSIC_FUNCTION_MARKUP_MUSIC 
%token <scm> MUSIC_FUNCTION_MARKUP_MUSIC_MUSIC 
%token <scm> MUSIC_FUNCTION_MUSIC 
%token <scm> MUSIC_FUNCTION_MUSIC_MUSIC 
%token <scm> MUSIC_FUNCTION_SCM 
%token <scm> MUSIC_FUNCTION_SCM_MUSIC 
%token <scm> MUSIC_FUNCTION_SCM_MUSIC_MUSIC 
%token <scm> MUSIC_FUNCTION_SCM_SCM_MUSIC_MUSIC 
%token <scm> MUSIC_FUNCTION_SCM_SCM 
%token <scm> MUSIC_FUNCTION_SCM_SCM_MUSIC 
%token <scm> MUSIC_FUNCTION_SCM_SCM_SCM 
%token <scm> MUSIC_FUNCTION_SCM_SCM_SCM_MUSIC 
%token <scm> MUSIC_FUNCTION_SCM_SCM_SCM_SCM_MUSIC 
%token <scm> MUSIC_IDENTIFIER
%token <scm> NOTENAME_PITCH
%token <scm> NUMBER_IDENTIFIER
%token <scm> OUTPUT_DEF_IDENTIFIER
%token <scm> REAL
%token <scm> RESTNAME
%token <scm> SCM_IDENTIFIER
%token <scm> SCM_T
%token <scm> SCORE_IDENTIFIER
%token <scm> STRING
%token <scm> STRING_IDENTIFIER
%token <scm> TONICNAME_PITCH


%type <book> book_block
%type <book> book_body

%type <i> bare_unsigned
%type <i> figured_bass_alteration
%type <i> dots
%type <i> exclamations
%type <i> optional_rest
%type <i> questions
%type <i> script_dir
%type <i> sub_quotes
%type <i> sup_quotes
%type <i> tremolo_type

/* Music */
%type <scm> composite_music
%type <scm> grouped_music_list
%type <scm> music
%type <scm> prefix_composite_music
%type <scm> repeated_music
%type <scm> sequential_music
%type <scm> simple_music
%type <scm> simultaneous_music
%type <scm> chord_body
%type <scm> chord_body_element
%type <scm> command_element
%type <scm> command_event
%type <scm> context_change
%type <scm> direction_less_event
%type <scm> direction_reqd_event
%type <scm> event_chord
%type <scm> gen_text_def
%type <scm> music_property_def
%type <scm> note_chord_element
%type <scm> post_event
%type <scm> re_rhythmed_music
%type <scm> relative_music
%type <scm> simple_element
%type <scm> simple_music_property_def
%type <scm> string_number_event
%type <scm> tempo_event

%type <outputdef> output_def_body
%type <outputdef> output_def_head
%type <outputdef> output_def_head_with_mode_switch
%type <outputdef> output_def
%type <outputdef> paper_block 

%type <scm> alternative_music
%type <scm> generic_prefix_music_scm 
%type <scm> music_list
%type <scm> absolute_pitch
%type <scm> assignment_id
%type <scm> bare_number
%type <scm> music_function_event
%type <scm> music_function_chord_body
%type <scm> music_function_musicless_prefix
%type <scm> music_function_musicless_function
%type <scm> bass_figure
%type <scm> figured_bass_modification
%type <scm> br_bass_figure
%type <scm> bass_number
%type <scm> chord_body_elements
%type <scm> chord_item
%type <scm> chord_items
%type <scm> chord_separator
%type <scm> context_def_mod
%type <scm> context_def_spec_block
%type <scm> context_def_spec_body
%type <scm> context_mod
%type <scm> context_mod_list
%type <scm> context_prop_spec
%type <scm> direction_less_char
%type <scm> duration_length
%type <scm> embedded_scm
%type <scm> figure_list
%type <scm> figure_spec
%type <scm> fraction
%type <scm> full_markup
%type <scm> identifier_init
%type <scm> lilypond_header
%type <scm> lilypond_header_body
%type <scm> lyric_element
%type <scm> lyric_markup
%type <scm> markup
%type <scm> markup_braced_list
%type <scm> markup_braced_list_body 
%type <scm> markup_composed_list
%type <scm> markup_head_1_item
%type <scm> markup_head_1_list
%type <scm> markup_list
%type <scm> markup_top
%type <scm> mode_changing_head
%type <scm> mode_changing_head_with_context
%type <scm> multiplied_duration
%type <scm> new_chord
%type <scm> new_lyrics
%type <scm> number_expression
%type <scm> number_factor
%type <scm> number_term
%type <scm> object_id_setting
%type <scm> octave_check
%type <scm> optional_context_mod
%type <scm> optional_id
%type <scm> optional_notemode_duration
%type <scm> pitch
%type <scm> pitch_also_in_chords
%type <scm> post_events
%type <scm> property_operation
%type <scm> scalar
%type <scm> script_abbreviation
%type <scm> simple_chord_elements
%type <scm> simple_markup
%type <scm> simple_string
%type <scm> steno_duration
%type <scm> steno_pitch
%type <scm> steno_tonic_pitch
%type <scm> step_number
%type <scm> step_numbers 
%type <scm> string
%type <scm> function_scm_argument

%type <score> score_block
%type <score> score_body


%left '-' '+'

/* We don't assign precedence to / and *, because we might need varied
prec levels in different prods */

%left UNARY_MINUS

%%

lilypond:	/* empty */
	| lilypond toplevel_expression {
	}
	| lilypond assignment {
	}
	| lilypond error {
		PARSER->error_level_ = 1;
	}
	| lilypond INVALID	{
		PARSER->error_level_ = 1;
	}
	;


object_id_setting:
	OBJECTID STRING { $$ = $2; } 
	;

toplevel_expression:
	lilypond_header {
		PARSER->lexer_->set_identifier (ly_symbol2scm ("$defaultheader"), $1);
	}
	| book_block {
		Book *book = $1;
		SCM proc = PARSER->lexer_->lookup_identifier ("toplevel-book-handler");
		scm_call_2 (proc, PARSER->self_scm (), book->self_scm ());
		book->unprotect ();
	}
	| score_block {
		Score *score = $1;
		
		SCM proc = PARSER->lexer_->lookup_identifier ("toplevel-score-handler");
		scm_call_2 (proc, PARSER->self_scm (), score->self_scm ());
		score->unprotect ();
	}
	| composite_music {
		Music *music = unsmob_music ($1);
		SCM proc = PARSER->lexer_->lookup_identifier ("toplevel-music-handler");
		scm_call_2 (proc, PARSER->self_scm (), music->self_scm ());
	}
	| full_markup {
		SCM proc = PARSER->lexer_->lookup_identifier ("toplevel-text-handler");
		scm_call_2 (proc, PARSER->self_scm (), $1);
	}
	| output_def {
		SCM id = SCM_EOL;
		Output_def * od = $1;

		if ($1->c_variable ("is-paper") == SCM_BOOL_T)
			id = ly_symbol2scm ("$defaultpaper");
		else if ($1->c_variable ("is-midi") == SCM_BOOL_T)
			id = ly_symbol2scm ("$defaultmidi");
		else if ($1->c_variable ("is-layout") == SCM_BOOL_T)
			id = ly_symbol2scm ("$defaultlayout");

		PARSER->lexer_->set_identifier (id, od->self_scm ());
		od->unprotect();
	}
	;

embedded_scm:
	SCM_T
	| SCM_IDENTIFIER
	;


lilypond_header_body:
	{
		$$ = get_header(PARSER);
		PARSER->lexer_->add_scope ($$);
	}
	| lilypond_header_body assignment  {
		
	}
	;

lilypond_header:
	HEADER '{' lilypond_header_body '}'	{
		$$ = PARSER->lexer_->remove_scope ();
	}
	;

/*
	DECLARATIONS
*/
assignment_id:
	STRING		{ $$ = $1; }
	| LYRICS_STRING { $$ = $1; }
	;

assignment:
	assignment_id '=' identifier_init  {
		if (! is_regular_identifier ($1))
		{
#if 0
			/* no longer valid with dashes in \paper{} block. */ 
			@1.warning (_ ("identifier should have alphabetic characters only"));
#endif
		}


	        PARSER->lexer_->set_identifier ($1, $3);

/*
 TODO: devise standard for protection in parser.

  The parser stack lives on the C-stack, which means that
all objects can be unprotected as soon as they're here.

*/
	}
	| embedded_scm { }
	;


identifier_init:
	score_block {
		$$ = $1->self_scm ();
		$1->unprotect ();
	}
	| book_block {
		$$ = $1->self_scm ();
		$1->unprotect ();
	}
	| output_def {
		$$ = $1->self_scm ();
		$1->unprotect ();
	}
	| context_def_spec_block {
		$$ = $1;
	}
	| music  {
		/* Hack: Create event-chord around standalone events.
		   Prevents the identifier from being interpreted as a post-event. */
		Music *mus = unsmob_music ($1);
		bool is_event = mus &&
			(scm_memq (ly_symbol2scm ("event"), mus->get_property ("types"))
				!= SCM_BOOL_F);
		if (!is_event)
			$$ = $1;
		else
			$$ = MAKE_SYNTAX ("event-chord", @$, scm_list_1 ($1));
	}
	| post_event {
		$$ = $1;
	}
	| number_expression {
 		$$ = $1;
	}
	| string {
		$$ = $1;
	}
        | embedded_scm {
		$$ = $1;
	}
	| full_markup {
		$$ = $1;
	}
	| DIGIT {
		$$ = scm_from_int ($1);
	}
	;

context_def_spec_block:
	CONTEXT '{' context_def_spec_body '}'
		{
		$$ = $3;
	}
	;

context_def_spec_body:
	/**/ {
		$$ = Context_def::make_scm ();
		unsmob_context_def ($$)->set_spot (@$);
	}
	| CONTEXT_DEF_IDENTIFIER {
		$$ = $1;
		unsmob_context_def ($$)->set_spot (@$);
	}
	| context_def_spec_body GROBDESCRIPTIONS embedded_scm {
		Context_def*td = unsmob_context_def ($$);

		for (SCM p = $3; scm_is_pair (p); p = scm_cdr (p)) {
			SCM tag = scm_caar (p);

			/* TODO: should make new tag "grob-definition" ? */
			td->add_context_mod (scm_list_3 (ly_symbol2scm ("assign"),
							tag, scm_cons (scm_cdar (p), SCM_EOL)));
		}
	}
	| context_def_spec_body context_mod {
		unsmob_context_def ($$)->add_context_mod ($2);		
	}
	;



book_block:
	BOOK '{' book_body '}' 	{
		$$ = $3;
	}
	;

/* FIXME:
   * Use 'handlers' like for toplevel-* stuff?
   * grok \layout and \midi?  */
book_body:
	{
		$$ = new Book;
		$$->set_spot (@$);
		$$->paper_ = dynamic_cast<Output_def*> (unsmob_output_def (PARSER->lexer_->lookup_identifier ("$defaultpaper"))->clone ());
		$$->paper_->unprotect ();
		$$->header_ = PARSER->lexer_->lookup_identifier ("$defaultheader"); 
	}
	| BOOK_IDENTIFIER {
		$$ = unsmob_book ($1);
		$$->set_spot (@$);
	}
	| book_body paper_block {
		$$->paper_ = $2;
		$2->unprotect ();
	}
	| book_body score_block {
		SCM s = $2->self_scm ();
		$$->add_score (s);
		$2->unprotect();
	}
	| book_body full_markup {
		$$->add_score ($2);
	}
	| book_body lilypond_header {
		$$->header_ = $2;
	}
	| book_body error {
		$$->paper_ = 0;
		$$->scores_ = SCM_EOL;
	}
	| book_body object_id_setting {
		$$->user_key_ = ly_scm2string ($2);
	}
	;

score_block:
	SCORE '{' score_body '}' 	{
		$$ = $3;
	}
	;

score_body:
	music {
		SCM m = $1;
		SCM scorify = ly_lily_module_constant ("scorify-music");
		SCM score = scm_call_2 (scorify, m, PARSER->self_scm ());

		// pass ownernship to C++ again.
		$$ = unsmob_score (score);
		$$->protect ();
		$$->set_spot (@$);
	}
	| SCORE_IDENTIFIER {
		$$ = unsmob_score ($1);
		$$->set_spot (@$);
	}
	| score_body object_id_setting {
		$$->user_key_ = ly_scm2string ($2);
	}
	| score_body lilypond_header 	{
		$$->header_ = $2;
	}
	| score_body output_def {
		if ($2->lookup_variable (ly_symbol2scm ("is-paper")) == SCM_BOOL_T)
		{
			PARSER->parser_error (@2, _("\\paper cannot be used in \\score, use \\layout instead"));
		
		}
		else
		{
			$$->add_output_def ($2);
		}
		$2->unprotect ();
	}
	| score_body error {
		$$->error_found_ = true;
	}
	;


/*
	OUTPUT DEF
*/

paper_block:
	output_def {
		$$ = $1;
		if ($$->lookup_variable (ly_symbol2scm ("is-paper")) != SCM_BOOL_T)
		{
			PARSER->parser_error (@1, _ ("need \\paper for paper block"));
			$$ = get_paper (PARSER);
		}
	}
	;


output_def:
	output_def_body '}' {
		$$ = $1;

		PARSER->lexer_->remove_scope ();
		PARSER->lexer_->pop_state ();
	}
	;

output_def_head:
	PAPER {
		$$ = get_paper (PARSER);
		$$->input_origin_ = @$;
		PARSER->lexer_->add_scope ($$->scope_);
	}
	| MIDI    {
		Output_def *p = get_midi (PARSER);
		$$ = p;
		PARSER->lexer_->add_scope (p->scope_);
	}
	| LAYOUT 	{
		Output_def *p = get_layout (PARSER);

		PARSER->lexer_->add_scope (p->scope_);
		$$ = p;
	}
	;

output_def_head_with_mode_switch:
	output_def_head {
		PARSER->lexer_->push_initial_state ();
		$$ = $1;
	}
	;

output_def_body:
	output_def_head_with_mode_switch '{' {
		$$ = $1;
		$$->input_origin_.set_spot (@$);
	}
	| output_def_head_with_mode_switch '{' OUTPUT_DEF_IDENTIFIER 	{
		$1->unprotect ();
		Output_def *o = unsmob_output_def ($3);
		o->input_origin_.set_spot (@$);
		$$ = o;
		PARSER->lexer_->remove_scope ();
		PARSER->lexer_->add_scope (o->scope_);
	}
	| output_def_body assignment  {

	}
	| output_def_body context_def_spec_block	{
		assign_context_def ($$, $2);
	}
	| output_def_body tempo_event  {
		/*
			junk this ? there already is tempo stuff in
			music.
		*/
		int m = scm_to_int (unsmob_music($2)->get_property ("metronome-count"));
		Duration *d = unsmob_duration (unsmob_music($2)->get_property ("tempo-unit"));
		set_tempo ($$, d->get_length (), m);
	}
	| output_def_body error {

	}
	;

tempo_event:
	TEMPO steno_duration '=' bare_unsigned	{
		Music *m = MY_MAKE_MUSIC ("MetronomeChangeEvent");
		m->set_property ("tempo-unit", $2);
		m->set_property ("metronome-count", scm_from_int ( $4));
		$$ = m->unprotect ();
	}
	;

/*
The representation of a  list is the

  (LIST . LAST-CONS)

 to have efficient append.  */

music_list:
	/* empty */ {
		$$ = scm_cons (SCM_EOL, SCM_EOL);
	}
	| music_list music {
		SCM s = $$;
 		SCM c = scm_cons ($2, SCM_EOL);

		if (scm_is_pair (scm_cdr (s)))
			scm_set_cdr_x (scm_cdr (s), c); /* append */
		else
			scm_set_car_x (s, c); /* set first cons */
		scm_set_cdr_x (s, c);  /* remember last cell */
	}
	| music_list embedded_scm {

	}
	| music_list error {
		Music *m = MY_MAKE_MUSIC("Music");
		// ugh. code dup 
		m->set_property ("error-found", SCM_BOOL_T);
		SCM s = $$;
 		SCM c = scm_cons (m->self_scm (), SCM_EOL);
		m->unprotect (); /* UGH */

		if (scm_is_pair (scm_cdr (s)))
			scm_set_cdr_x (scm_cdr (s), c); /* append */
		else
			scm_set_car_x (s, c); /* set first cons */
		scm_set_cdr_x (s, c);  /* remember last cell */
	}
	;

music:
	simple_music
	| composite_music
	;

alternative_music:
	/* empty */ {
		$$ = SCM_EOL;
	}
	| ALTERNATIVE '{' music_list '}' {
		$$ = scm_car ($3);
	}
	;


repeated_music:
	REPEAT simple_string bare_unsigned music alternative_music
	{
		$$ = MAKE_SYNTAX ("repeat", @$, $2, scm_int2num ($3), $4, $5);
	}
	;

sequential_music:
	SEQUENTIAL '{' music_list '}'		{
		$$ = MAKE_SYNTAX ("sequential-music", @$, scm_car ($3));
	}
	| '{' music_list '}'		{
		$$ = MAKE_SYNTAX ("sequential-music", @$, scm_car ($2));
	}
	;

simultaneous_music:
	SIMULTANEOUS '{' music_list '}'{
		$$ = MAKE_SYNTAX ("simultaneous-music", @$, scm_car ($3));
	}
	| DOUBLE_ANGLE_OPEN music_list DOUBLE_ANGLE_CLOSE	{
		$$ = MAKE_SYNTAX ("simultaneous-music", @$, scm_car ($2));
	}
	;

simple_music:
	event_chord
	| MUSIC_IDENTIFIER
	| music_property_def
	| context_change
	;

optional_context_mod:
	/**/ { $$ = SCM_EOL; }
	| WITH { PARSER->lexer_->push_initial_state (); }
	'{' context_mod_list '}'
	{
		PARSER->lexer_->pop_state ();
		$$ = $4;
	}
	;

context_mod_list:
	/* */  { $$ = SCM_EOL; }
	| context_mod_list context_mod  {
		 $$ = scm_cons ($2, $1);
	}
	;

composite_music:
	prefix_composite_music { $$ = $1; }
	| grouped_music_list { $$ = $1; }
	;

grouped_music_list:
	simultaneous_music		{ $$ = $1; }
	| sequential_music		{ $$ = $1; }
	;

function_scm_argument:
	embedded_scm  
	| simple_string
	;

/*
TODO: use code generation for this
*/
music_function_musicless_function:
	MUSIC_FUNCTION {
		$$ = scm_list_2 ($1, make_input (@$));
	}
	| MUSIC_FUNCTION_SCM function_scm_argument {
		$$ = scm_list_3 ($1, make_input (@$), $2);
	}
	| MUSIC_FUNCTION_MARKUP full_markup {
		$$ = scm_list_3 ($1, make_input (@$), $2);
	}
	| MUSIC_FUNCTION_SCM_SCM function_scm_argument function_scm_argument {
		$$ = scm_list_4 ($1, make_input (@$), $2, $3);
	}
	| MUSIC_FUNCTION_SCM_SCM_SCM function_scm_argument function_scm_argument function_scm_argument {
		$$ = scm_list_5 ($1, make_input (@$), $2, $3, $4);
	}
	| MUSIC_FUNCTION_MARKUP_MARKUP full_markup full_markup {
		$$ = scm_list_4 ($1, make_input (@$), $2, $3);
	}
	;

/*
TODO: use code generation for this
*/
music_function_musicless_prefix:
	MUSIC_FUNCTION_MUSIC {
		$$ = scm_list_2 ($1, make_input (@$));
	}
	| MUSIC_FUNCTION_SCM_MUSIC function_scm_argument { 
		$$ = scm_list_3 ($1, make_input (@$), $2);
	}
	| MUSIC_FUNCTION_SCM_SCM_MUSIC function_scm_argument function_scm_argument {
		$$ = scm_list_4 ($1, make_input (@$), $2, $3);
	}
	| MUSIC_FUNCTION_SCM_SCM_SCM_MUSIC function_scm_argument function_scm_argument function_scm_argument {
		$$ = scm_list_5 ($1, make_input (@$), $2, $3, $4);
	}
	| MUSIC_FUNCTION_SCM_SCM_SCM_SCM_MUSIC function_scm_argument function_scm_argument function_scm_argument function_scm_argument {
		$$ = scm_list_n ($1, make_input (@$), $2, $3, $4, $5, SCM_UNDEFINED);
	}
	| MUSIC_FUNCTION_MARKUP_MUSIC full_markup {
		$$ = scm_list_3 ($1, make_input (@$), $2);
	}
	;

generic_prefix_music_scm:
	music_function_musicless_function {
		$$ = $1
	}
	| music_function_musicless_prefix music {
		$$ = ly_append2 ($1, scm_list_1 ($2));
	}
	| MUSIC_FUNCTION_MUSIC_MUSIC music music {
		$$ = scm_list_4 ($1, make_input (@$), $2, $3);
	}
	| MUSIC_FUNCTION_SCM_MUSIC_MUSIC function_scm_argument music music {
		$$ = scm_list_5 ($1, make_input (@$), $2, $3, $4);
	}
	| MUSIC_FUNCTION_SCM_SCM_MUSIC_MUSIC function_scm_argument function_scm_argument music music {
		$$ = scm_list_n ($1, make_input (@$), $2, $3, $4, $5, SCM_UNDEFINED);
	}
	| MUSIC_FUNCTION_MARKUP_MUSIC_MUSIC full_markup music music {
		$$ = scm_list_5 ($1, make_input (@$), $2, $3, $4);
	}
	;


optional_id:
	/**/ { $$ = SCM_EOL; }
	| '=' simple_string {
		$$ = $2;
	}
	;	


prefix_composite_music:
	generic_prefix_music_scm {
		$$ = run_music_function (PARSER, $1);
	}
	| CONTEXT    simple_string optional_id optional_context_mod music {
		$$ = MAKE_SYNTAX ("context-specification", @$, $2, $3, $5, $4, SCM_BOOL_F);
	}
	| NEWCONTEXT simple_string optional_id optional_context_mod music {
		$$ = MAKE_SYNTAX ("context-specification", @$, $2, $3, $5, $4, SCM_BOOL_T);
	}

	| TIMES fraction music {
                $$ = MAKE_SYNTAX ("time-scaled-music", @$, $2, $3);
	}
	| repeated_music		{ $$ = $1; }
	| TRANSPOSE pitch_also_in_chords pitch_also_in_chords music {
		Pitch from = *unsmob_pitch ($2);
		Pitch to = *unsmob_pitch ($3);
		SCM pitch = pitch_interval (from, to).smobbed_copy ();
		$$ = MAKE_SYNTAX ("transpose-music", @$, pitch, $4);
	}
	| mode_changing_head grouped_music_list {
		if ($1 == ly_symbol2scm ("chords"))
		{
		  $$ = MAKE_SYNTAX ("unrelativable-music", @$, $2);
		}
		else
		{
		  $$ = $2;
		}
		PARSER->lexer_->pop_state ();
	}
	| mode_changing_head_with_context optional_context_mod grouped_music_list {
		$$ = MAKE_SYNTAX ("context-specification", @$, $1, SCM_EOL, $3, $2, SCM_BOOL_T);
		if ($1 == ly_symbol2scm ("ChordNames"))
		{
		  $$ = MAKE_SYNTAX ("unrelativable-music", @$, $$);
		}
		PARSER->lexer_->pop_state ();
	}
	| relative_music	{ $$ = $1; }
	| re_rhythmed_music	{ $$ = $1; }
	;

mode_changing_head: 
	NOTEMODE {
		SCM nn = PARSER->lexer_->lookup_identifier ("pitchnames");
		PARSER->lexer_->push_note_state (alist_to_hashq (nn));

		$$ = ly_symbol2scm ("notes");
	}
	| DRUMMODE 
		{
		SCM nn = PARSER->lexer_->lookup_identifier ("drumPitchNames");
		PARSER->lexer_->push_note_state (alist_to_hashq (nn));

		$$ = ly_symbol2scm ("drums");
	}
	| FIGUREMODE {
		PARSER->lexer_->push_figuredbass_state ();

		$$ = ly_symbol2scm ("figures");
	}
	| CHORDMODE {
		SCM nn = PARSER->lexer_->lookup_identifier ("chordmodifiers");
		PARSER->lexer_->chordmodifier_tab_ = alist_to_hashq (nn);
		nn = PARSER->lexer_->lookup_identifier ("pitchnames");
		PARSER->lexer_->push_chord_state (alist_to_hashq (nn));
		$$ = ly_symbol2scm ("chords");

	}
	| LYRICMODE
		{ PARSER->lexer_->push_lyric_state ();
		$$ = ly_symbol2scm ("lyrics");
	}
	;

mode_changing_head_with_context: 
	DRUMS {
		SCM nn = PARSER->lexer_->lookup_identifier ("drumPitchNames");
		PARSER->lexer_->push_note_state (alist_to_hashq (nn));

		$$ = ly_symbol2scm ("DrumStaff");
	}
	| FIGURES {
		PARSER->lexer_->push_figuredbass_state ();

		$$ = ly_symbol2scm ("FiguredBass");
	}
	| CHORDS {
		SCM nn = PARSER->lexer_->lookup_identifier ("chordmodifiers");
		PARSER->lexer_->chordmodifier_tab_ = alist_to_hashq (nn);
		nn = PARSER->lexer_->lookup_identifier ("pitchnames");
		PARSER->lexer_->push_chord_state (alist_to_hashq (nn));
		$$ = ly_symbol2scm ("ChordNames");
	}
	| LYRICS
		{ PARSER->lexer_->push_lyric_state ();
		$$ = ly_symbol2scm ("Lyrics");
	}
	;


relative_music:
	RELATIVE absolute_pitch music {
		Pitch start = *unsmob_pitch ($2);
		$$ = make_music_relative (start, $3);
	}
	| RELATIVE composite_music {
		Pitch middle_c (0, 0, 0);
		$$ = make_music_relative (middle_c, $2);
	}
	;

new_lyrics:
	ADDLYRICS { PARSER->lexer_->push_lyric_state (); }
	/*cont */
	grouped_music_list {
	/* Can also use music at the expensive of two S/Rs similar to
           \repeat \alternative */
		PARSER->lexer_->pop_state ();

		$$ = scm_cons ($3, SCM_EOL);
	}
	| new_lyrics ADDLYRICS {
		PARSER->lexer_->push_lyric_state ();
	} grouped_music_list {
		PARSER->lexer_->pop_state ();
		$$ = scm_cons ($4, $1);
	}
	;

re_rhythmed_music:
	grouped_music_list new_lyrics {
		$$ = MAKE_SYNTAX ("add-lyrics", @$, $1, scm_reverse_x ($2, SCM_EOL));
	}
	| LYRICSTO simple_string {
		PARSER->lexer_->push_lyric_state ();
	} music {
		PARSER->lexer_->pop_state ();
		$$ = MAKE_SYNTAX ("lyric-combine", @$, $2, $4);
	}
	;

context_change:
	CHANGE STRING '=' STRING  {
		$$ = MAKE_SYNTAX ("context-change", @$, scm_string_to_symbol ($2), $4);
	}
	;

property_operation:
	STRING '=' scalar {
		$$ = scm_list_3 (ly_symbol2scm ("assign"),
			scm_string_to_symbol ($1), $3);
	}
	| UNSET simple_string {
		$$ = scm_list_2 (ly_symbol2scm ("unset"),
			scm_string_to_symbol ($2));
	}
	| OVERRIDE simple_string embedded_scm '=' embedded_scm {
		$$ = scm_list_4 (ly_symbol2scm ("push"),
			scm_string_to_symbol ($2), $5, $3);
	}
	| OVERRIDE simple_string embedded_scm embedded_scm '=' embedded_scm {
		$$ = scm_list_5 (ly_symbol2scm ("push"),
				scm_string_to_symbol ($2), $6, $4, $3);
	}
	| REVERT simple_string embedded_scm {
		$$ = scm_list_3 (ly_symbol2scm ("pop"),
			scm_string_to_symbol ($2), $3);
	}
	;

context_def_mod:
	CONSISTS { $$ = ly_symbol2scm ("consists"); }
	| REMOVE { $$ = ly_symbol2scm ("remove"); }

	| ACCEPTS { $$ = ly_symbol2scm ("accepts"); }
	| DEFAULTCHILD { $$ = ly_symbol2scm ("default-child"); }
	| DENIES { $$ = ly_symbol2scm ("denies"); }

	| ALIAS { $$ = ly_symbol2scm ("alias"); }
	| TYPE { $$ = ly_symbol2scm ("translator-type"); }
	| DESCRIPTION { $$ = ly_symbol2scm ("description"); }
	| NAME { $$ = ly_symbol2scm ("context-name"); }
	;

context_mod:
	property_operation { $$ = $1; }
	| context_def_mod STRING {
		$$ = scm_list_2 ($1, $2);
	}
	;

context_prop_spec:
	simple_string {
		if (!is_regular_identifier ($1))
		{
			@$.error (_("Grob name should be alphanumeric"));
		}

		$$ = scm_list_2 (ly_symbol2scm ("Bottom"),
			scm_string_to_symbol ($1));
	}
	| simple_string '.' simple_string {
		$$ = scm_list_2 (scm_string_to_symbol ($1),
			scm_string_to_symbol ($3));
	}
	;

simple_music_property_def:
	OVERRIDE context_prop_spec embedded_scm '=' scalar {
		$$ = scm_list_5 (scm_car ($2),
			ly_symbol2scm ("OverrideProperty"),
			scm_cadr ($2),
			$5, $3);
	}
	| OVERRIDE context_prop_spec embedded_scm  embedded_scm '=' scalar {
		$$ = scm_list_n (scm_car ($2),			
			ly_symbol2scm ("OverrideProperty"),
			scm_cadr ($2),
			$6, $4, $3, SCM_UNDEFINED);
	}
	| REVERT context_prop_spec embedded_scm {
		$$ = scm_list_4 (scm_car ($2),
			ly_symbol2scm ("RevertProperty"),
			scm_cadr ($2),
			$3);
	}
	| SET context_prop_spec '=' scalar {
		$$ = scm_list_4 (scm_car ($2),
			ly_symbol2scm ("PropertySet"),
			scm_cadr ($2),
			$4);
	}
	| UNSET context_prop_spec {
		$$ = scm_list_3 (scm_car ($2),
			ly_symbol2scm ("PropertyUnset"),
			scm_cadr ($2));
	}
	;

music_property_def:
	simple_music_property_def {
		$$ = LOWLEVEL_MAKE_SYNTAX (ly_lily_module_constant ("property-operation"), scm_cons (PARSER->self_scm (), scm_cons2 (make_input (@$), SCM_BOOL_F, $1)));
	}
	| ONCE simple_music_property_def {
		$$ = LOWLEVEL_MAKE_SYNTAX (ly_lily_module_constant ("property-operation"), scm_cons (PARSER->self_scm (), scm_cons2 (make_input (@$), SCM_BOOL_T, $2)));
	}
	;

string:
	STRING {
		$$ = $1;
	}
	| STRING_IDENTIFIER {
		$$ = $1;
	}
	| string '+' string {
		$$ = scm_string_append (scm_list_2 ($1, $3));
	}
	;

simple_string: STRING {
		$$ = $1;
	}
	| LYRICS_STRING {
		$$ = $1;
	}
	| STRING_IDENTIFIER {
		$$ = $1;
	}
	;

scalar: string {
		$$ = $1;
	}
	| LYRICS_STRING {
		$$ = $1;
	}
	| bare_number {
		$$ = $1;
	}
        | embedded_scm {
		$$ = $1;
	}
	| full_markup {
		$$ = $1;
	}
	| DIGIT {
		$$ = scm_from_int ($1);
	}
	;

event_chord:
	/* TODO: Create a special case that avoids the creation of
	   EventChords around simple_elements that have no post_events?
	 */
	simple_chord_elements post_events	{
		SCM elts = ly_append2 ($1, scm_reverse_x ($2, SCM_EOL));

		Input i;
		/* why is this giving wrong start location? -ns
		 * i = @$; */
		i.set_location (@1, @2);
		$$ = MAKE_SYNTAX ("event-chord", i, elts);
	}
	| MULTI_MEASURE_REST optional_notemode_duration post_events {
		Input i;
		i.set_location (@1, @3);
		$$ = MAKE_SYNTAX ("multi-measure-rest", i, $2, $3);
	}
	| command_element
	| note_chord_element
	;


note_chord_element:
	chord_body optional_notemode_duration post_events
	{
		Music *m = unsmob_music ($1);
		SCM dur = unsmob_duration ($2)->smobbed_copy ();
		SCM es = m->get_property ("elements");
		SCM postevs = scm_reverse_x ($3, SCM_EOL);
		
		for (SCM s = es; scm_is_pair (s); s = scm_cdr (s))
		  unsmob_music (scm_car (s))->set_property ("duration", dur);
		es = ly_append2 (es, postevs);

		m-> set_property ("elements", es);
		m->set_spot (@$);
		$$ = m->self_scm ();
	}
	;

chord_body:
	ANGLE_OPEN chord_body_elements ANGLE_CLOSE
	{
		$$ = MAKE_SYNTAX ("event-chord", @$, scm_reverse_x ($2, SCM_EOL));
	}
	;

chord_body_elements:
	/* empty */ 		{ $$ = SCM_EOL; }
	| chord_body_elements chord_body_element {
		$$ = scm_cons ($2, $1);
	}
	;

chord_body_element:
	pitch exclamations questions octave_check post_events
	{
		int q = $3;
		int ex = $2;
		SCM check = $4;
		SCM post = $5;

		Music *n = MY_MAKE_MUSIC ("NoteEvent");
		n->set_property ("pitch", $1);
		n->set_spot (@$);
		if (q % 2)
			n->set_property ("cautionary", SCM_BOOL_T);
		if (ex % 2 || q % 2)
			n->set_property ("force-accidental", SCM_BOOL_T);

		if (scm_is_pair (post)) {
			SCM arts = scm_reverse_x (post, SCM_EOL);
			n->set_property ("articulations", arts);
		}
		if (scm_is_number (check))
		{
			int q = scm_to_int (check);
			n->set_property ("absolute-octave", scm_from_int (q-1));
		}

		$$ = n->unprotect ();
	}
	| DRUM_PITCH post_events {
		Music *n = MY_MAKE_MUSIC ("NoteEvent");
		n->set_property ("duration", $2);
		n->set_property ("drum-type", $1);
		n->set_spot (@$);

		if (scm_is_pair ($2)) {
			SCM arts = scm_reverse_x ($2, SCM_EOL);
			n->set_property ("articulations", arts);
		}
		$$ = n->unprotect ();
	}
	| music_function_chord_body { 
		$$ = run_music_function (PARSER, $1);
	}
	;

music_function_chord_body:
	music_function_musicless_function {
		$$ = $1;
	}
	| music_function_musicless_prefix chord_body_element {
		$$ = ly_append2 ($1, scm_list_1 ($2));
	}
	;

music_function_event:
	music_function_musicless_prefix post_event {
		$$ = ly_append2 ($1, scm_list_1 ($2));
	}
	| music_function_musicless_function {
		$$ = $1;
	}
	;
	

command_element:
	command_event {
		$$ = $1;
	}
	| SKIP duration_length {
		$$ = MAKE_SYNTAX ("skip-music", @$, $2);
	}
	| E_BRACKET_OPEN {
		Music *m = MY_MAKE_MUSIC ("LigatureEvent");
		m->set_property ("span-direction", scm_from_int (START));
		m->set_spot (@$);
		$$ = m->unprotect();
	}
	| E_BRACKET_CLOSE {
		Music *m = MY_MAKE_MUSIC ("LigatureEvent");
		m->set_property ("span-direction", scm_from_int (STOP));
		m->set_spot (@$);
		$$ = m->unprotect ();
	}
	| E_BACKSLASH {
		$$ = MAKE_SYNTAX ("voice-separator", @$, SCM_UNDEFINED);
	}
	| '|'      {
		SCM pipe = PARSER->lexer_->lookup_identifier ("pipeSymbol");

		Music *m = unsmob_music (pipe);
		if (m)
		{
			m = m->clone ();
			m->set_spot (@$);
			$$ = m->unprotect ();
		}
		else
			$$ = MAKE_SYNTAX ("bar-check", @$, SCM_UNDEFINED);

	}
	| TRANSPOSITION pitch {
		Pitch middle_c;
		Pitch sounds_as_c = pitch_interval (*unsmob_pitch ($2), middle_c);
		$$ = MAKE_SYNTAX ("property-operation", @$, SCM_BOOL_F, ly_symbol2scm ("Staff"), ly_symbol2scm ("PropertySet"), ly_symbol2scm ("instrumentTransposition"), sounds_as_c.smobbed_copy ());
	}
	| PARTIAL duration_length	{
		Moment m = - unsmob_duration ($2)->get_length ();
		$$ = MAKE_SYNTAX ("property-operation", @$, SCM_BOOL_F, ly_symbol2scm ("Timing"), ly_symbol2scm ("PropertySet"), ly_symbol2scm ("measurePosition"), m.smobbed_copy ());
		$$ = MAKE_SYNTAX ("context-specification", @$, ly_symbol2scm ("Score"), SCM_BOOL_F, $$, SCM_EOL, SCM_BOOL_F);
	}

	| TIME_T fraction  {
		SCM proc = ly_lily_module_constant ("make-time-signature-set");

		$$ = scm_apply_2   (proc, scm_car ($2), scm_cdr ($2), SCM_EOL);
	}
	| MARK scalar {
		SCM proc = ly_lily_module_constant ("make-mark-set");

		$$ = scm_call_1 (proc, $2);
	}
	;

command_event:
	E_TILDE {
		$$ = MY_MAKE_MUSIC ("PesOrFlexaEvent")->unprotect ();
	}
	| MARK DEFAULT  {
		Music *m = MY_MAKE_MUSIC ("MarkEvent");
		$$ = m->unprotect ();
	}
	| tempo_event {
		$$ = $1;
	}
	| KEY DEFAULT {
		Music *key = MY_MAKE_MUSIC ("KeyChangeEvent");
		$$ = key->unprotect ();
	}
	| KEY NOTENAME_PITCH SCM_IDENTIFIER 	{

		Music *key = MY_MAKE_MUSIC ("KeyChangeEvent");
		if (scm_ilength ($3) > 0)
		{		
			key->set_property ("pitch-alist", $3);
			key->set_property ("tonic", Pitch (0, 0, 0).smobbed_copy ());
			key->transpose (* unsmob_pitch ($2));
		} else {
			PARSER->parser_error (@3, _ ("second argument must be pitch list"));
		}

		$$ = key->unprotect ();
	}
	;


post_events:
	/* empty */ {
		$$ = SCM_EOL;
	}
	| post_events post_event {
		unsmob_music ($2)->set_spot (@2);
		$$ = scm_cons ($2, $$);
	}
	;
	
post_event:
	direction_less_event {
		$$ = $1;
	}
	| '-' music_function_event {
		$$ = run_music_function (PARSER, $2);
	}
	| HYPHEN {
		if (!PARSER->lexer_->is_lyric_state ())
			PARSER->parser_error (@1, _ ("have to be in Lyric mode for lyrics"));
		$$ = MY_MAKE_MUSIC ("HyphenEvent")->unprotect ();
	}
	| EXTENDER {
		if (!PARSER->lexer_->is_lyric_state ())
			PARSER->parser_error (@1, _ ("have to be in Lyric mode for lyrics"));
		$$ = MY_MAKE_MUSIC ("ExtenderEvent")->unprotect ();
	}
	| script_dir direction_reqd_event {
		if ($1)
		{
			Music *m = unsmob_music ($2);
			m->set_property ("direction", scm_from_int ($1));
		}
		$$ = $2;
	}
	| script_dir direction_less_event {
		if ($1)
		{
			Music *m = unsmob_music ($2);
			m->set_property ("direction", scm_from_int ($1));
		}
		$$ = $2;
	}
	| string_number_event
	;

string_number_event:
	E_UNSIGNED {
		Music *s = MY_MAKE_MUSIC ("StringNumberEvent");
		s->set_property ("string-number", scm_from_int ($1));
		s->set_spot (@$);
		$$ = s->unprotect ();
	}
	;

direction_less_char:
	'['  {
		$$ = ly_symbol2scm ("bracketOpenSymbol");
	}
	| ']'  {
		$$ = ly_symbol2scm ("bracketCloseSymbol"); 
	}
	| '~'  {
		$$ = ly_symbol2scm ("tildeSymbol");
	}
	| '('  {
		$$ = ly_symbol2scm ("parenthesisOpenSymbol");
	}
	| ')'  {
		$$ = ly_symbol2scm ("parenthesisCloseSymbol");
	}
	| E_EXCLAMATION  {
		$$ = ly_symbol2scm ("escapedExclamationSymbol");
	}
	| E_OPEN  {
		$$ = ly_symbol2scm ("escapedParenthesisOpenSymbol");
	}
	| E_CLOSE  {
		$$ = ly_symbol2scm ("escapedParenthesisCloseSymbol");
	}
	| E_ANGLE_CLOSE  {
		$$ = ly_symbol2scm ("escapedBiggerSymbol");
	}
	| E_ANGLE_OPEN  {
		$$ = ly_symbol2scm ("escapedSmallerSymbol");
	}
	;

direction_less_event:
	direction_less_char {
		SCM predefd = PARSER->lexer_->lookup_identifier_symbol ($1);
		Music *m = 0;
		if (unsmob_music (predefd))
		{
			m = unsmob_music (predefd)->clone ();
		}
		else
		{
			m = MY_MAKE_MUSIC ("Music");
		}
		m->set_spot (@$);
		$$ = m->unprotect ();
	}
	| EVENT_IDENTIFIER	{
		$$ = $1;
	}
	| tremolo_type  {
               Music *a = MY_MAKE_MUSIC ("TremoloEvent");
               a->set_spot (@$);
               a->set_property ("tremolo-type", scm_from_int ($1));
               $$ = a->unprotect ();
        }
	;	
	
direction_reqd_event:
	gen_text_def {
		$$ = $1;
	}
	| script_abbreviation {
		SCM s = PARSER->lexer_->lookup_identifier ("dash" + ly_scm2string ($1));
		Music *a = MY_MAKE_MUSIC ("ArticulationEvent");
		if (scm_is_string (s))
			a->set_property ("articulation-type", s);
		else PARSER->parser_error (@1, _ ("expecting string as script definition"));
		$$ = a->unprotect ();
	}
	;

octave_check:
	/**/ { $$ = SCM_EOL; }
	| '='  { $$ = scm_from_int (0); }
	| '=' sub_quotes { $$ = scm_from_int ($2); }
	| '=' sup_quotes { $$ = scm_from_int ($2); }
	;

sup_quotes:
	'\'' {
		$$ = 1;
	}
	| sup_quotes '\'' {
		$$ ++;
	}
	;

sub_quotes:
	',' {
		$$ = 1;
	}
	| sub_quotes ',' {
		$$++;
	}
	;

steno_pitch:
	NOTENAME_PITCH	{
		$$ = $1;
	}
	| NOTENAME_PITCH sup_quotes 	{
		Pitch p = *unsmob_pitch ($1);
		p = p.transposed (Pitch ($2,0,0));
		$$ = p.smobbed_copy ();
	}
	| NOTENAME_PITCH sub_quotes	 {
		Pitch p =* unsmob_pitch ($1);
		p = p.transposed (Pitch (-$2,0,0));
		$$ = p.smobbed_copy ();
	}
	;

/*
ugh. duplication
*/

steno_tonic_pitch:
	TONICNAME_PITCH	{
		$$ = $1;
	}
	| TONICNAME_PITCH sup_quotes 	{
		Pitch p = *unsmob_pitch ($1);
		p = p.transposed (Pitch ($2,0,0));
		$$ = p.smobbed_copy ();
	}
	| TONICNAME_PITCH sub_quotes	 {
		Pitch p =* unsmob_pitch ($1);

		p = p.transposed (Pitch (-$2,0,0));
		$$ = p.smobbed_copy ();
	}
	;

pitch:
	steno_pitch {
		$$ = $1;
	}
	;

pitch_also_in_chords:
	pitch
	| steno_tonic_pitch
	;

gen_text_def:
	full_markup {
		Music *t = MY_MAKE_MUSIC ("TextScriptEvent");
		t->set_property ("text", $1);
		t->set_spot (@$);
		$$ = t->unprotect ();
	}
	| string {
		Music *t = MY_MAKE_MUSIC ("TextScriptEvent");
		t->set_property ("text",
			make_simple_markup ($1));
		t->set_spot (@$);
		$$ = t->unprotect ();
	}
	| DIGIT {
		Music *t = MY_MAKE_MUSIC ("FingerEvent");
		t->set_property ("digit", scm_from_int ($1));
		t->set_spot (@$);
		$$ = t->unprotect ();
	}
	;

script_abbreviation:
	'^'		{
		$$ = scm_makfrom0str ("Hat");
	}
	| '+'		{
		$$ = scm_makfrom0str ("Plus");
	}
	| '-' 		{
		$$ = scm_makfrom0str ("Dash");
	}
 	| '|'		{
		$$ = scm_makfrom0str ("Bar");
	}
	| ANGLE_CLOSE	{
		$$ = scm_makfrom0str ("Larger");
	}
	| '.' 		{
		$$ = scm_makfrom0str ("Dot");
	}
	| '_' {
		$$ = scm_makfrom0str ("Underscore");
	}
	;

script_dir:
	'_'	{ $$ = DOWN; }
	| '^'	{ $$ = UP; }
	| '-'	{ $$ = CENTER; }
	;


absolute_pitch:
	steno_pitch	{
		$$ = $1;
	}
	;

duration_length:
	multiplied_duration {
		$$ = $1;
	}
	;

optional_notemode_duration:
	{
		Duration dd = PARSER->default_duration_;
		$$ = dd.smobbed_copy ();
	}
	| multiplied_duration	{
		$$ = $1;
		PARSER->default_duration_ = *unsmob_duration ($$);
	}
	;

steno_duration:
	bare_unsigned dots		{
		int len = 0;
		if (!is_duration ($1))
			PARSER->parser_error (@1, _f ("not a duration: %d", $1));
		else
			len = intlog2 ($1);

		$$ = Duration (len, $2).smobbed_copy ();
	}
	| DURATION_IDENTIFIER dots	{
		Duration *d = unsmob_duration ($1);
		Duration k (d->duration_log (), d->dot_count () + $2);
		*d = k;
		$$ = $1;
	}
	;

multiplied_duration:
	steno_duration {
		$$ = $1;
	}
	| multiplied_duration '*' bare_unsigned {
		$$ = unsmob_duration ($$)->compressed ( $3) .smobbed_copy ();
	}
	| multiplied_duration '*' FRACTION {
		Rational  m (scm_to_int (scm_car ($3)), scm_to_int (scm_cdr ($3)));

		$$ = unsmob_duration ($$)->compressed (m).smobbed_copy ();
	}
	;

fraction:
	FRACTION { $$ = $1; }
	| UNSIGNED '/' UNSIGNED {
		$$ = scm_cons (scm_from_int ($1), scm_from_int ($3));
	}
	;

dots:
	/* empty */ 	{
		$$ = 0;
	}
	| dots '.' {
		$$ ++;
	}
	;

tremolo_type:
	':'	{
		$$ = 0;
	}
	| ':' bare_unsigned {
		if (!is_duration ($2))
			PARSER->parser_error (@2, _f ("not a duration: %d", $2));
		$$ = $2;
	}
	;

bass_number:
	DIGIT   {
		$$ = scm_from_int ($1);
	}
	| UNSIGNED {
		$$ = scm_from_int ($1);
	}
	| STRING { $$ = $1; }
	| full_markup { $$ = $1; }
	;

figured_bass_alteration:
	'-' 	{ $$ = -2; }
	| '+'	{ $$ = 2; }
	| '!'	{ $$ = 0; }
	;

bass_figure:
	FIGURE_SPACE {
		Music *bfr = MY_MAKE_MUSIC ("BassFigureEvent");
		$$ = bfr->self_scm ();
		bfr->unprotect ();
		bfr->set_spot (@1);
	}
	| bass_number  {
		Music *bfr = MY_MAKE_MUSIC ("BassFigureEvent");
		$$ = bfr->self_scm ();

		if (scm_is_number ($1))
			bfr->set_property ("figure", $1);
		else if (Text_interface::is_markup ($1))
			bfr->set_property ("text", $1);

		bfr->unprotect ();
		bfr->set_spot (@1);
	}
	| bass_figure ']' {
		$$ = $1;
		unsmob_music ($1)->set_property ("bracket-stop", SCM_BOOL_T);
	}
	| bass_figure figured_bass_alteration {
		Music *m = unsmob_music ($1);
		if ($2) {
			SCM salter = m->get_property ("alteration");
			int alter = scm_is_number (salter) ? scm_to_int (salter) : 0;
			m->set_property ("alteration",
				scm_from_int (alter + $2));
		} else {
			m->set_property ("alteration", scm_from_int (0));
		}
	}
	| bass_figure figured_bass_modification  {
		Music *m = unsmob_music ($1);
		if ($2 == ly_symbol2scm ("plus"))
			{
			m->set_property ("augmented", SCM_BOOL_T);
			}
		else if ($2 == ly_symbol2scm ("slash"))
			{
			m->set_property ("diminished", SCM_BOOL_T);
			}
		else if ($2 == ly_symbol2scm ("exclamation"))
			{
			m->set_property ("no-continuation", SCM_BOOL_T);
			}
	}
	;


figured_bass_modification:
	E_PLUS		{
		$$ = ly_symbol2scm ("plus");
	}
	| E_EXCLAMATION {
		$$ = ly_symbol2scm ("exclamation");
	}
	| '/'		{
		$$ = ly_symbol2scm ("slash");
	}
	;

br_bass_figure:
	bass_figure {
		$$ = $1;
	}
	| '[' bass_figure {
		$$ = $2;
		unsmob_music ($$)->set_property ("bracket-start", SCM_BOOL_T);
	}
	;

figure_list:
	/**/		{
		$$ = SCM_EOL;
	}
	| figure_list br_bass_figure {
		$$ = scm_cons ($2, $1);
	}
	;

figure_spec:
	FIGURE_OPEN figure_list FIGURE_CLOSE {
		$$ = scm_reverse_x ($2, SCM_EOL);
	}
	;


optional_rest:
	/**/   { $$ = 0; }
	| REST { $$ = 1; }
	;

simple_element:
	pitch exclamations questions octave_check optional_notemode_duration optional_rest {
		if (!PARSER->lexer_->is_note_state ())
			PARSER->parser_error (@1, _ ("have to be in Note mode for notes"));

		Music *n = 0;
		if ($6)
			n = MY_MAKE_MUSIC ("RestEvent");
		else
			n = MY_MAKE_MUSIC ("NoteEvent");
		
		n->set_property ("pitch", $1);
		n->set_property ("duration", $5);

		if (scm_is_number ($4))
		{
			int q = scm_to_int ($4);
			n->set_property ("absolute-octave", scm_from_int (q-1));
		}

		if ($3 % 2)
			n->set_property ("cautionary", SCM_BOOL_T);
		if ($2 % 2 || $3 % 2)
			n->set_property ("force-accidental", SCM_BOOL_T);

		n->set_spot (@$);
		$$ = n->unprotect ();
	}
	| DRUM_PITCH optional_notemode_duration {
		Music *n = MY_MAKE_MUSIC ("NoteEvent");
		n->set_property ("duration", $2);
		n->set_property ("drum-type", $1);

		$$ = n->unprotect ();		
	}
 	| RESTNAME optional_notemode_duration		{
		Music *ev = 0;
 		if (ly_scm2string ($1) == "s") {
			/* Space */
			ev = MY_MAKE_MUSIC ("SkipEvent");
		  }
		else {
			ev = MY_MAKE_MUSIC ("RestEvent");
		
		    }
		ev->set_property ("duration", $2);
		ev->set_spot (@$);
 		$$ = ev->unprotect ();
	}
	| lyric_element optional_notemode_duration 	{
		if (!PARSER->lexer_->is_lyric_state ())
			PARSER->parser_error (@1, _ ("have to be in Lyric mode for lyrics"));

		Music *levent = MY_MAKE_MUSIC ("LyricEvent");
		levent->set_property ("text", $1);
		levent->set_property ("duration",$2);
		levent->set_spot (@$);
		$$= levent->unprotect ();
	}
	;

simple_chord_elements:
	simple_element	{
		$$ = scm_list_1 ($1);
	}	
	| new_chord {
                if (!PARSER->lexer_->is_chord_state ())
                        PARSER->parser_error (@1, _ ("have to be in Chord mode for chords"));
                $$ = $1;
	}
	| figure_spec optional_notemode_duration {
		for (SCM s = $1; scm_is_pair (s); s = scm_cdr (s))
		{
			unsmob_music (scm_car (s))->set_property ("duration", $2);
		}
		$$ = $1;
	}	
	;

lyric_element:
	lyric_markup {
		$$ = $1;
	}
	| LYRICS_STRING {
		$$ = $1;
	}
	;

new_chord:
	steno_tonic_pitch optional_notemode_duration   {
		$$ = make_chord_elements ($1, $2, SCM_EOL);
	}
	| steno_tonic_pitch optional_notemode_duration chord_separator chord_items {
		SCM its = scm_reverse_x ($4, SCM_EOL);
		$$ = make_chord_elements ($1, $2, scm_cons ($3, its));
	}
	;

chord_items:
	/**/ {
		$$ = SCM_EOL;		
	}
	| chord_items chord_item {
		$$ = scm_cons ($2, $$);
	}
	;

chord_separator:
	CHORD_COLON {
		$$ = ly_symbol2scm ("chord-colon");
	}
	| CHORD_CARET {
		$$ = ly_symbol2scm ("chord-caret");
	}
	| CHORD_SLASH steno_tonic_pitch {
 		$$ = scm_list_2 (ly_symbol2scm ("chord-slash"), $2);
	}
	| CHORD_BASS steno_tonic_pitch {
		$$ = scm_list_2 (ly_symbol2scm ("chord-bass"), $2);
	}
	;

chord_item:
	chord_separator {
		$$ = $1;
	}
	| step_numbers {
		$$ = scm_reverse_x ($1, SCM_EOL);
	}
	| CHORD_MODIFIER  {
		$$ = $1;
	}
	;

step_numbers:
	step_number { $$ = scm_cons ($1, SCM_EOL); }
	| step_numbers '.' step_number {
		$$ = scm_cons ($3, $$);
	}
	;

step_number:
	bare_unsigned {
		$$ = make_chord_step ($1, 0);
        }
	| bare_unsigned '+' {
		$$ = make_chord_step ($1, SHARP);
	}
	| bare_unsigned CHORD_MINUS {
		$$ = make_chord_step ($1, FLAT);
	}
	;	

/*
	UTILITIES

TODO: should deprecate in favor of Scheme?

 */
number_expression:
	number_expression '+' number_term {
		$$ = scm_sum ($1, $3);
	}
	| number_expression '-' number_term {
		$$ = scm_difference ($1, $3);
	}
	| number_term
	;

number_term:
	number_factor {
		$$ = $1;
	}
	| number_factor '*' number_factor {
		$$ = scm_product ($1, $3);
	}
	| number_factor '/' number_factor {
		$$ = scm_divide ($1, $3);
	}
	;

number_factor:
	'-'  number_factor { /* %prec UNARY_MINUS */
		$$ = scm_difference ($2, SCM_UNDEFINED);
	}
	| bare_number
	;


bare_number:
	UNSIGNED	{
		$$ = scm_from_int ($1);
	}
	| REAL		{
		$$ = $1;
	}
	| NUMBER_IDENTIFIER		{
		$$ = $1;
	}
	| REAL NUMBER_IDENTIFIER	{
		$$ = scm_from_double (scm_to_double ($1) *scm_to_double ($2));
	}
	| UNSIGNED NUMBER_IDENTIFIER	{
		$$ = scm_from_double ($1 *scm_to_double ($2));
	}
	;


bare_unsigned:
	UNSIGNED {
			$$ = $1;
	}
	| DIGIT {
		$$ = $1;
	}
	;

exclamations:
		{ $$ = 0; }
	| exclamations '!'	{ $$ ++; }
	;

questions:
		{ $$ = 0; }
	| questions '?'	{ $$ ++; }
	;

/*
This should be done more dynamically if possible.
*/

lyric_markup:
	LYRIC_MARKUP_IDENTIFIER {
		$$ = $1;
	}
	| LYRIC_MARKUP
		{ PARSER->lexer_->push_markup_state (); }
	markup_top {
		$$ = $3;
		PARSER->lexer_->pop_state ();
	}
	;

full_markup:
	MARKUP_IDENTIFIER {
		$$ = $1;
	}
	| MARKUP
		{ PARSER->lexer_->push_markup_state (); }
	markup_top {
		$$ = $3;
		PARSER->lexer_->pop_state ();
	}
	;

markup_top:
	markup_list { 
		$$ = scm_list_2 (ly_lily_module_constant ("line-markup"),  $1); 
	}
	| markup_head_1_list simple_markup	{
		$$ = scm_car (scm_call_2 (ly_lily_module_constant ("map-markup-command-list"), $1, scm_list_1 ($2)));
	}
	| simple_markup	{
		$$ = $1;
	}
	;

markup_list:
	markup_composed_list {
		$$ = $1;
	}
	| markup_braced_list {
		$$ = $1;
	}
	;

markup_composed_list:
	markup_head_1_list markup_braced_list {
		$$ = scm_call_2 (ly_lily_module_constant ("map-markup-command-list"), $1, $2);
		
	}
	;

markup_braced_list:
	'{' markup_braced_list_body '}'	{
		$$ = scm_reverse_x ($2, SCM_EOL);
	}
	;

markup_braced_list_body:
	/* empty */	{  $$ = SCM_EOL; }
	| markup_braced_list_body markup {
		$$ = scm_cons ($2, $1);
	}
	| markup_braced_list_body markup_list {
		$$ = scm_append_x (scm_list_2 (scm_reverse_x ($2, SCM_EOL), $1));
	}
	;

markup_head_1_item:
	MARKUP_HEAD_MARKUP0	{
		$$ = scm_list_1 ($1);
	}
	| MARKUP_HEAD_SCM0_MARKUP1 embedded_scm	{
		$$ = scm_list_2 ($1, $2);
	}
	| MARKUP_HEAD_SCM0_SCM1_MARKUP2 embedded_scm embedded_scm	{
		$$ = scm_list_3 ($1, $2, $3);
	}
	;

markup_head_1_list:
	markup_head_1_item	{
		$$ = scm_list_1 ($1);
	}
	| markup_head_1_list markup_head_1_item	{
		$$ = scm_cons ($2, $1);
	}
	;

simple_markup:
	STRING {
		$$ = make_simple_markup ($1);
	}
	| MARKUP_IDENTIFIER {
		$$ = $1;
	}
	| LYRIC_MARKUP_IDENTIFIER {
		$$ = $1;
	}
	| STRING_IDENTIFIER {
		$$ = $1;
	}
	| SCORE {
		SCM nn = PARSER->lexer_->lookup_identifier ("pitchnames");
		PARSER->lexer_->push_note_state (alist_to_hashq (nn));
	} '{' score_body '}' {
		Score * sc = $4;
		$$ = scm_list_2 (ly_lily_module_constant ("score-markup"), sc->self_scm ());
		sc->unprotect ();
		PARSER->lexer_->pop_state ();
	}
	| MARKUP_HEAD_SCM0 embedded_scm {
		$$ = scm_list_2 ($1, $2);
	}
	| MARKUP_HEAD_SCM0_SCM1_SCM2 embedded_scm embedded_scm embedded_scm {
		$$ = scm_list_4 ($1, $2, $3, $4);
	}
	| MARKUP_HEAD_SCM0_SCM1 embedded_scm embedded_scm {
		$$ = scm_list_3 ($1, $2, $3);
	}
	| MARKUP_HEAD_EMPTY {
		$$ = scm_list_1 ($1);
	}
	| MARKUP_HEAD_LIST0 markup_list {
		$$ = scm_list_2 ($1,$2);
	}
	| MARKUP_HEAD_MARKUP0_MARKUP1 markup markup {
		$$ = scm_list_3 ($1, $2, $3);
	}
	;
	
markup:
	markup_head_1_list simple_markup	{
		SCM mapper = ly_lily_module_constant ("map-markup-command-list");
		$$ = scm_car (scm_call_2 (mapper, $1, scm_list_1 ($2)));
	}
	| simple_markup	{
		$$ = $1;
	}
	;

%%

void
Lily_parser::set_yydebug (bool )
{
#if 0
	yydebug = 1;
#endif
}

void
Lily_parser::do_yyparse ()
{
	yyparse ((void*)this);
}





/*

It is a little strange to have this function in this file, but
otherwise, we have to import music classes into the lexer.

*/
int
Lily_lexer::try_special_identifiers (SCM *destination, SCM sid)
{
	if (scm_is_string (sid)) {
		*destination = sid;
		return STRING_IDENTIFIER;
	} else if (unsmob_book (sid)) {
		*destination = unsmob_book (sid)->clone ()->self_scm ();
		return BOOK_IDENTIFIER;
	} else if (scm_is_number (sid)) {
		*destination = sid;
		return NUMBER_IDENTIFIER;
	} else if (unsmob_context_def (sid)) {
		*destination = unsmob_context_def (sid)->clone_scm ();
		return CONTEXT_DEF_IDENTIFIER;
	} else if (unsmob_score (sid)) {
		Score *score = new Score (*unsmob_score (sid));
		*destination = score->self_scm ();
		return SCORE_IDENTIFIER;
	} else if (Music *mus = unsmob_music (sid)) {
		mus = mus->clone ();
		*destination = mus->self_scm ();
		unsmob_music (*destination)->
			set_property ("origin", make_input (last_input_));

		bool is_event = scm_memq (ly_symbol2scm ("event"), mus->get_property ("types"))
			!= SCM_BOOL_F;

		return is_event ? EVENT_IDENTIFIER : MUSIC_IDENTIFIER;
	} else if (unsmob_duration (sid)) {
		*destination = unsmob_duration (sid)->smobbed_copy ();
		return DURATION_IDENTIFIER;
	} else if (unsmob_output_def (sid)) {
		Output_def *p = unsmob_output_def (sid);
		p = p->clone ();

		*destination = p->self_scm ();
		return OUTPUT_DEF_IDENTIFIER;
	} else if (Text_interface::is_markup (sid)) {
		*destination = sid;
		if (is_lyric_state ())
			return LYRIC_MARKUP_IDENTIFIER;
		return MARKUP_IDENTIFIER;
	}

	return -1;	
}

SCM
get_next_unique_context_id ()
{
	return scm_makfrom0str ("$uniqueContextId");
}


SCM
get_next_unique_lyrics_context_id ()
{
	static int new_context_count;
	char s[128];
	snprintf (s, sizeof (s)-1, "uniqueContext%d", new_context_count++);
	return scm_makfrom0str (s);
}


SCM
run_music_function (Lily_parser *parser, SCM expr)
{
	SCM func = scm_car (expr);
	Input *loc = unsmob_input (scm_cadr (expr));
	SCM args = scm_cddr (expr);
	SCM sig = scm_object_property (func, ly_symbol2scm ("music-function-signature"));

	SCM type_check_proc = ly_lily_module_constant ("type-check-list");

	if (!to_boolean (scm_call_3  (type_check_proc, scm_cadr (expr), sig, args)))
	{
		parser->error_level_ = 1;
		return LOWLEVEL_MAKE_SYNTAX (ly_lily_module_constant ("void-music"), scm_list_2 (parser->self_scm (), make_input (*loc)));
	}

	SCM syntax_args = scm_list_4 (parser->self_scm (), make_input (*loc), func, args);
	return LOWLEVEL_MAKE_SYNTAX (ly_lily_module_constant ("music-function"), syntax_args);
}

bool
is_regular_identifier (SCM id)
{
  string str = ly_scm2string (id);
  char const *s = str.c_str ();

  bool v = true;
#if 0
  isalpha (*s);
  s++;
#endif
  while (*s && v)
   {
        v = v && isalnum (*s);
        s++;
   }
  return v;
}


SCM
get_first_context_id (SCM type, Music *m)
{
	SCM id = m->get_property ("context-id");
	if (SCM_BOOL_T == scm_equal_p (m->get_property ("context-type"), type)
	    && scm_is_string (m->get_property ("context-id"))
	    && scm_c_string_length (id) > 0)
	{
		return id;
	}
	return SCM_EOL;
}

SCM
make_simple_markup (SCM a)
{
	return a;
}

bool
is_duration (int t)
{
  return t && t == 1 << intlog2 (t);
}

void
set_music_properties (Music *p, SCM a)
{
  for (SCM k = a; scm_is_pair (k); k = scm_cdr (k))
 	p->internal_set_property (scm_caar (k), scm_cdar (k));
}


SCM
make_chord_step (int step, int alter)
{
	if (step == 7)
		alter += FLAT;

	while (step < 0)
		step += 7;
	Pitch m ((step -1) / 7, (step - 1) % 7, alter);
	return m.smobbed_copy ();
}


SCM
make_chord_elements (SCM pitch, SCM dur, SCM modification_list)
{
	SCM chord_ctor = ly_lily_module_constant ("construct-chord-elements");
	return scm_call_3 (chord_ctor, pitch, dur, modification_list);
}


/* Todo: actually also use apply iso. call too ...  */
bool
ly_input_procedure_p (SCM x)
{
	return ly_is_procedure (x)
		|| (scm_is_pair (x) && ly_is_procedure (scm_car (x)));
}

SCM
make_music_relative (Pitch start, SCM music)
{
	Music *relative = MY_MAKE_MUSIC ("RelativeOctaveMusic");
 	relative->set_property ("element", music);
	
	Music *m = unsmob_music (music);
 	Pitch last = m->to_relative_octave (start);
 	if (lily_1_8_relative)
 		m->set_property ("last-pitch", last.smobbed_copy ());
	return relative->unprotect ();
}

int
yylex (YYSTYPE *s, YYLTYPE *loc, void *v)
{
	Lily_parser *pars = (Lily_parser*) v;
	Lily_lexer *lex = pars->lexer_;

	lex->lexval = (void*) s;
	lex->lexloc = loc;
	lex->prepare_for_next_token ();
	return lex->yylex ();
}
