/*
  timing-translator.cc -- implement Timing_translator

  source file of the GNU LilyPond music typesetter

  (c)  1997--1999 Han-Wen Nienhuys <hanwen@cs.uu.nl>
*/

#include "timing-translator.hh"
#include "command-request.hh"
#include "translator-group.hh"
#include "global-translator.hh"
#include "multi-measure-rest.hh"

bool
Timing_translator::do_try_music (Music*r)
{
  if (Timing_req *t =  dynamic_cast <Timing_req *> (r))
    {
      for (int i=0; i < timing_req_l_arr_.size (); i++)
	{
	  if (timing_req_l_arr_[i]->equal_b(t))
	    return true;
	  if (String (classname (timing_req_l_arr_[i])) == classname (r))
	    {
	      r->warning (_ ("conflicting timing request"));
	      return false;
	    }
	}
    
      timing_req_l_arr_.push(t);
      return true;
    }
  return false;
}

/*ugh.
 */
Time_signature_change_req*
Timing_translator::time_signature_req_l() const
{
  Time_signature_change_req *m_l=0;
  for (int i=0; !m_l && i < timing_req_l_arr_.size (); i++)
    {
      m_l=dynamic_cast<Time_signature_change_req*> (timing_req_l_arr_[i]);
    }
  return m_l;
}

void
Timing_translator::do_process_requests()
{
  for (int i=0; i < timing_req_l_arr_.size (); i++)
    {
      Timing_req * tr_l = timing_req_l_arr_[i];

      if (Time_signature_change_req *m_l = dynamic_cast <Time_signature_change_req *> (tr_l))
	{
	  int b_i= m_l->beats_i_;
	  int o_i = m_l->one_beat_i_;
	  if (! time_.allow_time_signature_change_b())
	    tr_l->warning (_ ("time signature change not allowed here"));
	  else
	    {
	      time_.set_time_signature (b_i, o_i);
	    }
	}
      else if (Partial_measure_req *pm = dynamic_cast <Partial_measure_req *> (tr_l))
	{
	  Moment m = pm->length_mom_;
	  String error = time_.try_set_partial_str (m);
	  if (error.length_i ())
	    {
	      tr_l->warning (error);
	    }
	  else
	    time_.setpartial (m);
	}
      else if (dynamic_cast <Barcheck_req *> (tr_l))
	{
	  if (time_.whole_in_measure_)
	    {
	      tr_l ->warning (_f ("barcheck failed by: %s", 
	        time_.whole_in_measure_.str ()));

	      time_.whole_in_measure_ = 0; // resync
	    }
	}
      else if (Cadenza_req *cr = dynamic_cast <Cadenza_req *> (tr_l))
	{
	  time_.set_cadenza (cr->on_b_);
	}
    }

  Translator_group * tr=0;

  Scalar barn = get_property ("currentBarNumber", &tr);
  if (!barn.empty_b () && barn.isnum_b ())
    {
      time_.bars_i_ = int(barn);
      tr->set_property ("currentBarNumber", "");
    }
  

}


void
Timing_translator::do_pre_move_processing()
{
  timing_req_l_arr_.set_size (0);
  Translator *t = this;
  Global_translator *global_l =0;
  do
    {
      t = t->daddy_trans_l_ ;
      global_l = dynamic_cast<Global_translator*> (t);
    }
  while (!global_l);

  /* allbars == ! skipbars */
  bool allbars = ! get_property ("skipBars", 0).to_bool ();

  // urg: multi bar rests: should always process whole of first bar?
  if (!time_.cadenza_b_ && allbars)
    global_l->add_moment_to_process (time_.next_bar_moment ());
}


ADD_THIS_TRANSLATOR(Timing_translator);

void
Timing_translator::do_creation_processing()
{
  time_.when_ = now_mom ();
}

void
Timing_translator::do_post_move_processing()
{
  time_.add (now_mom ()  - time_.when_);


}

void
Timing_translator::do_print () const
{
#ifndef NPRINT
  time_.print ();
#endif
}
