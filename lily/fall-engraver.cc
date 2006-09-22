/*
  fall-engraver.cc -- implement Bend_after_engraver

  (c) 2006 Han-Wen Nienhuys

  
*/

#include "engraver.hh"
#include "item.hh"
#include "moment.hh"
#include "spanner.hh"
#include "stream-event.hh"

#include "translator.icc"

class Bend_after_engraver : public Engraver
{
public:
  TRANSLATOR_DECLARATIONS (Bend_after_engraver);
  DECLARE_ACKNOWLEDGER (note_head);

protected:
  DECLARE_TRANSLATOR_LISTENER (bend_after);
  void process_music ();
  void stop_translation_timestep ();
  void start_translation_timestep ();
  void stop_fall ();
  
private:
  Moment stop_moment_;
  Stream_event *fall_event_;
  Spanner *fall_;
  Grob *note_head_;
};

void
Bend_after_engraver::stop_fall ()
{
  bool bar = scm_is_string (get_property ("whichBar"));
  
  
  fall_->set_bound (RIGHT, unsmob_grob (bar
					? get_property ("currentCommandColumn")
					: get_property ("currentMusicalColumn")));
  fall_ = 0;
  note_head_ = 0;
  fall_event_ = 0;
}

void
Bend_after_engraver::stop_translation_timestep ()
{
  if (fall_ && !fall_->get_bound (LEFT)) 
    {
      fall_->set_bound (LEFT, note_head_);
      fall_->set_parent (note_head_,  Y_AXIS);
    }
}

void
Bend_after_engraver::start_translation_timestep ()
{
  if (fall_ && now_mom ().main_part_ >= stop_moment_.main_part_)
    {
      stop_fall ();
    }
}

void
Bend_after_engraver::acknowledge_note_head (Grob_info info)
{
  if (!fall_event_)
    return;
  
  if (note_head_ && fall_)
    {
      stop_fall ();
    }

  note_head_ = info.grob ();
  stop_moment_ = now_mom () + get_event_length (info.event_cause ());
}

Bend_after_engraver::Bend_after_engraver ()
{
  fall_ = 0;
  note_head_ = 0;
  fall_event_ = 0;
}

IMPLEMENT_TRANSLATOR_LISTENER (Bend_after_engraver, bend_after);
void
Bend_after_engraver::listen_bend_after (Stream_event *ev)
{
  ASSIGN_EVENT_ONCE (fall_event_, ev);
}

void
Bend_after_engraver::process_music ()
{
  if (fall_event_ && !fall_)
    {
      fall_ = make_spanner ("BendAfter", fall_event_->self_scm ());
      fall_->set_property ("delta-position",
			   scm_from_double (robust_scm2double (fall_event_->get_property ("delta-step"), 0)));
    }
}

ADD_ACKNOWLEDGER (Bend_after_engraver, note_head);

ADD_TRANSLATOR (Bend_after_engraver,
		/* doc */ "Create fall spanners.",
		/* create */ "BendAfter",
		/* accept */ "bend-after-event",
		/* read */ "",
		/* write */ "");
