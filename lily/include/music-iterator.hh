/*
  music-iterator.hh -- declare Music_iterator

  source file of the GNU LilyPond music typesetter

  (c)  1997--2000 Han-Wen Nienhuys <hanwen@cs.uu.nl>
*/


#ifndef MUSIC_ITERATOR_HH
#define MUSIC_ITERATOR_HH

#include "lily-proto.hh"
#include "array.hh"
#include "moment.hh"
#include "virtual-methods.hh"
#include "interpretation-context-handle.hh"

/** Walk through music and deliver music to translation units, synced
  in time.  This class provides both the implementation of the shared
  code, and the public interface.

  Derived classes should only have a public constructor.
  The state of an iterator would be the intersection of the particular music 
  construct with one point in musical time.
 */
class Music_iterator
{
  //private:
public:
  Interpretation_context_handle handle_;

protected:
  Music  * music_l_;

  /// ugh. JUNKME
  bool first_b_;

  /**
    Do the actual printing.  This should be overriden in derived classes.  It 
    is called by #print#, in the public interface
   */
  virtual void do_print() const;
    
  /**
    Find a bottom notation context to deliver requests to.
   */
  virtual Translator_group* get_req_translator_l();

  /**
    Get an iterator for MUS, inheriting the translation unit from THIS.
   */
  Music_iterator* get_iterator_p (Music *mus) const;

  /** Do the actual move.  This should be overriden in derived
    classes.  It is called by #process_and_next#, the public interface 
    */
  virtual void do_process_and_next (Moment until);


  virtual Music_iterator* try_music_in_children (Music  *) const;
  
public:
  VIRTUAL_COPY_CONS (Music_iterator);

  Music_iterator();
  Music_iterator (Music_iterator const&);
  virtual ~Music_iterator();


  /**
     Do the reporting.  Will try MUSIC_L_ in its own translator first,
     then its children. Returns the iterator that succeeded
  */
  Music_iterator *  try_music (Music  *) const;

  /**
    The translation unit that we this iterator is reporting  to now.
   */
  Translator_group*report_to_l() const;

  void set_translator (Translator_group*);
  
  /** Get an iterator matching the type of MUS, and use TRANS to find
    an accompanying translation unit
   */
  static Music_iterator* static_get_iterator_p (Music * mus);
  void init_translator (Music  *, Translator_group *); 

  ///  Find the next interesting point in time.
  virtual Moment next_moment() const;


  ///Are we finished with this piece of music?
  virtual bool ok() const;

  virtual Music* get_music ();
  virtual bool next ();

  ///Report all musical information that occurs between now and UNTIL
  void process_and_next (Moment until);

  /**
    Construct sub-iterators, and set the translator to 
    report to.
   */
  virtual void construct_children();
  void print() const;
};

#endif // MUSIC_ITERATOR_HH
