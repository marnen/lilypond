/*
  staff-performer.hh -- declare Staff_performer

  (c) 1996,  1997--1999 Han-Wen Nienhuys <hanwen@cs.uu.nl>
                 Jan Nieuwenhuizen <janneke@gnu.org>
 */

#ifndef STAFF_PERFORMER_HH
#define STAFF_PERFORMER_HH

#include "performer-group-performer.hh"

/** Perform a staff. Individual notes should have their instrument
  (staff-wide) set, so we override play_element()

  */
class Staff_performer : public Performer_group_performer 
{
public:
  VIRTUAL_COPY_CONS(Translator);
  

  Staff_performer ();
  ~Staff_performer ();

  String new_instrument_str ();
  String instrument_str_;

protected:
  virtual void play_element (Audio_element* p);
  virtual void do_removal_processing ();
  virtual void do_creation_processing ();
  virtual void do_process_requests ();
  virtual void do_pre_move_processing ();

private:
  Audio_staff* audio_staff_p_;
  Audio_instrument* instrument_p_;
  Audio_text* instrument_name_p_;
  Audio_text* name_p_;
  Audio_tempo* tempo_p_;
};

#endif // STAFF_PERFORMER_HH
