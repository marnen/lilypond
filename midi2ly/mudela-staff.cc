//
// mudela-staff.cc -- implement Mudela_staff
//
// copyright 1997 Jan Nieuwenhuizen <janneke@gnu.org>

#include <assert.h>
#include <ctype.h>
#include "moment.hh"
#include "duration-convert.hh"
#include "string-convert.hh"
#include "midi2ly-proto.hh"
#include "midi2ly-global.hh"
#include "mudela-column.hh"
#include "mudela-item.hh"
#include "mudela-staff.hh"
#include "mudela-stream.hh"
#include "mudela-voice.hh"
#include "mudela-score.hh"

#include "killing-cons.tcc"

extern Mudela_score* mudela_score_l_g;

Mudela_staff::Mudela_staff (int number_i, String copyright_str, String track_name_str, String instrument_str)
{
  number_i_ = number_i;
  copyright_str_ = copyright_str;
  instrument_str_ = instrument_str;
  name_str_ = track_name_str;
  mudela_key_l_ = 0;
  mudela_time_signature_l_ = 0;
  mudela_tempo_l_ = 0;
}

void
Mudela_staff::add_item (Mudela_item* mudela_item_p)
{
  mudela_item_p_list_.append (new Killing_cons <Mudela_item> (mudela_item_p, 0));
  if (mudela_item_p->mudela_column_l_)
    mudela_item_p->mudela_column_l_->add_item (mudela_item_p);
}
/**
   Walk ITEMS and find voices.  Remove categorised items.

   TODO: collect all channels into separate voices. Use chords for sim
   notes on same channel.
   
 */
void
Mudela_staff::eat_voice (Cons_list<Mudela_item>& items)
{
  Mudela_voice* voice_p = new Mudela_voice (this);
  mudela_voice_p_list_.append (new Killing_cons<Mudela_voice> (voice_p, 0));

  //    Moment mom = items.top ()->at_mom ();
  Moment mom = 0;

  for (Cons<Mudela_item>** pp = &items.head_; *pp;)
    {
      Cons<Mudela_item>* i = *pp;
      if (i->car_->at_mom () > mom)
	{
	  Moment dur = i->car_->at_mom () - mom;
	  // ugh, need score
	  Mudela_column* start = mudela_score_l_g->find_column_l (mom);
	  voice_p->add_item (new Mudela_skip (start, dur));
	  mom = i->car_->at_mom ();
	  continue;		// unnecessary
	}
      
      Link_array<Mudela_item> now_items;
      for (Cons<Mudela_item> *cp = i; cp && cp->car_->at_mom () == mom; cp = cp->next_)
	now_items.push (i->car_);

      Mudela_item * which = 0;
      Mudela_note * last_note = dynamic_cast<Mudela_note*> (voice_p->last_item_l_);

      for (int i=0; !which && last_note && i < now_items.size (); i++)
	{
	  Mudela_note * now_note = dynamic_cast<Mudela_note*> (now_items[i]);
	  if (now_note && last_note->channel_i_ != now_note->channel_i_)
	    which = now_note;
	}

#if 0
      // use pitch difference for determining which item to pick.
      if (!which)
	{
	  int mindiff = 100000;	// ugh
	  for (int i=0; !which && last_note && i < now_items.size (); i++)
	    {
	      Mudela_note *nt = dynamic_cast<Mudela_note*> (now_items[i]);
	      if (!nt)
		continue;
	      int diff = abs (last_note->pitch_i_ - nt->pitch_i_ );
	      if(diff < mindiff)
		{
		  mindiff =  diff;
		  which = now_items [i];
		}
	    }

	  if (which && mindiff > 18)		// more than 1.5 octaves apart.  Don't put in same voice.
	    {
	      which =0;
	    }

	}
#endif
      
      if (!which && now_items.size ())
	which = now_items[0];

      

      if (!which)
	{
	  pp = &(*pp)->next_;
	  continue;
	}
      
      while ((*pp)->car_ != which)
	pp = &(*pp)->next_;
      
      mom += (*pp)->car_->duration_mom ();
      Cons<Mudela_item>* c = items.remove_cons (pp);
      voice_p->add_item (c->car_);
      delete c;
    }
}

String
Mudela_staff::id_str ()
{
  String id (name_str ());
  char *cp = id.ch_l ();
  char *end = cp + id.length_i ();
  for (;cp < end; cp++)
    {
      if (!isalpha (*cp))
	{
	  *cp = 'X';
	}
    }
  return id;
}

String
Mudela_staff::name_str ()
{
  if (name_str_.length_i ())
    return name_str_;
  return String ("track") + to_str (char ('A' - 1 + number_i_));
}



void
Mudela_staff::output (Mudela_stream& mudela_stream_r)
{
  int c =0;
  
  String trackbody = "";
  for (Cons<Mudela_voice>* i = mudela_voice_p_list_.head_; i; i = i->next_)
    {
      String voicename = id_str () + "voice" + to_str (char (c + 'A'));
      
      mudela_stream_r << voicename << " = \\notes ";

      trackbody += "\\"  + voicename + "\n";

      mudela_stream_r << "\n";
      i->car_->output (mudela_stream_r);
      c++;      
    }

  mudela_stream_r << _ ("% midi copyright:") << copyright_str_ << '\n';
  mudela_stream_r << _ ("% instrument:") << instrument_str_ << '\n';
  mudela_stream_r << id_str () << " = ";
  mudela_stream_r << "<\n " << trackbody << " >\n";

  mudela_stream_r << " % " << name_str () << '\n';
}

void
Mudela_staff::output_mudela_begin_bar (Mudela_stream& mudela_stream_r, Moment now_mom, int bar_i)
{
  Moment bar_mom = mudela_time_signature_l_->bar_mom ();
  Moment into_bar_mom = now_mom - Moment (bar_i - 1) * bar_mom;
  if (bar_i > 1)
    {
      if (!into_bar_mom)
	mudela_stream_r << "|\n";
    }
  mudela_stream_r << "% " << String_convert::i2dec_str (bar_i, 0, ' ');
  if (into_bar_mom)
    mudela_stream_r << ":" << Duration_convert::dur2_str (Duration_convert::mom2_dur (into_bar_mom));
  mudela_stream_r << '\n';
}


#if 0 // not used for now
void
Mudela_staff::output_mudela_rest (Mudela_stream& mudela_stream_r, Moment begin_mom, Moment end_mom)
{
  Moment bar_mom = mudela_time_signature_l_->bar_mom ();
  Moment now_mom = begin_mom;

  int begin_bar_i = (int) (now_mom / bar_mom) + 1;
  int end_bar_i = (int) (end_mom / bar_mom) + 1;

  if (end_bar_i == begin_bar_i)
    {
      output_mudela_rest_remain (mudela_stream_r, end_mom - begin_mom);
      return;
    }

  // multiple bars involved
  int bar_i = (int) (now_mom / bar_mom) + 1;

  //fill current bar
  Moment begin_bar_mom = Moment (begin_bar_i - 1) * bar_mom;
  if (now_mom > begin_bar_mom)
    {
      int next_bar_i = (int) (now_mom / bar_mom) + 2;
      Moment next_bar_mom = Moment (next_bar_i - 1) * bar_mom;
      assert (next_bar_mom <= end_mom);

      Moment remain_mom = next_bar_mom - now_mom;
      if (remain_mom > Moment (0))
	{
	  output_mudela_rest_remain (mudela_stream_r, remain_mom);
	  now_mom += remain_mom;
	}

      bar_i = check_end_bar_i (now_mom, bar_i);
    }

  // fill whole bars
  int count_i = end_bar_i - bar_i;
  for (int i = 0; i < count_i; i++)
    {
      int begin_bar_i = check_begin_bar_i (now_mom, bar_i);
      if (begin_bar_i)
	output_mudela_begin_bar (mudela_stream_r, now_mom, begin_bar_i);
      mudela_stream_r << "r1 ";
      //	*mudela_stream_r.os_p_ << flush;
      if (begin_bar_i)
	LOGOUT (NORMAL_ver) << begin_bar_i << flush;
      bar_i = check_end_bar_i (now_mom, bar_i);
      now_mom += bar_mom;
    }

  // use "int i" here, and gcc 2.7.2 hits internal compiler error
  int ii = check_begin_bar_i (now_mom, bar_i);
  if (ii)
    output_mudela_begin_bar (mudela_stream_r, now_mom, ii);

  //    bar_i = check_end_bar_i (now_mom, bar_i);

  Moment remain_mom = end_mom - Moment (end_bar_i - 1) * bar_mom;
  if (remain_mom > Moment (0))
    {
      output_mudela_rest_remain (mudela_stream_r, remain_mom);
      now_mom += remain_mom;
    }
  assert (now_mom == end_mom);
}

void
Mudela_staff::output_mudela_rest_remain (Mudela_stream& mudela_stream_r, Moment mom)
{
  if (Duration_convert::no_quantify_b_s)
    {
      Duration dur = Duration_convert::mom2_dur (mom);
      mudela_stream_r << "r" << dur.str () << " ";
      //	assert (mom == dur.mom ());
      assert (mom == dur.length ());
      return;
    }

  Duration dur = Duration_convert::mom2standardised_dur (mom);
  if (dur.type_i_>-10)
    mudela_stream_r << "r" << dur.str () << " ";
}
#endif


void
Mudela_staff::process ()
{
  /*
     group items into voices
     */

  assert (mudela_score_l_g);
  mudela_key_l_ = mudela_score_l_g->mudela_key_l_;
  mudela_time_signature_l_ = mudela_score_l_g->mudela_time_signature_l_;
  mudela_tempo_l_ = mudela_score_l_g->mudela_tempo_l_;

  Cons_list<Mudela_item> items;
  for (Cons<Mudela_item>* i = mudela_item_p_list_.head_; i; i = i->next_)
    items.append (new Cons<Mudela_item> (i->car_, 0));

  while (items.size_i ())
    eat_voice (items);
}
