/*   
  arpegggio.cc -- implement Arpeggio

  source file of the GNU LilyPond music typesetter
  
  (c) 2000 Jan Nieuwenhuizen <janneke@gnu.org>
 */

#include "molecule.hh"
#include "paper-def.hh"
#include "font-metric.hh"
#include "arpeggio.hh"
#include "score-element.hh"
#include "stem.hh"
#include "staff-symbol-referencer.hh"
#include "staff-symbol.hh"
#include "warn.hh"

bool
Arpeggio::has_interface (Score_element* me)
{
  return me && me->has_interface (ly_symbol2scm ("arpeggio-interface"));
}

MAKE_SCHEME_CALLBACK (Arpeggio, brew_molecule, 1);
SCM 
Arpeggio::brew_molecule (SCM smob) 
{
  Score_element *me = unsmob_element (smob);
  
  Score_element * common = me;
  for (SCM s = me->get_elt_property ("stems"); gh_pair_p (s); s = gh_cdr (s))
    {
      Score_element * stem =  unsmob_element (gh_car (s));
      common =  common->common_refpoint (Staff_symbol_referencer::staff_symbol_l (stem),
				 Y_AXIS);
    }

  /*
    TODO:
    
    Using stems here is not very convenient; should store noteheads
    instead, and also put them into the support. Now we will mess up
    in vicinity of a collision.

  */
  Interval heads;
  Real my_y = me->relative_coordinate (common, Y_AXIS);
      
  for (SCM s = me->get_elt_property ("stems"); gh_pair_p (s); s = gh_cdr (s))
    {
      Score_element * stem = unsmob_element (gh_car (s));
      Score_element * ss = Staff_symbol_referencer::staff_symbol_l (stem);
      Interval iv =Stem::head_positions (stem);
      iv *= Staff_symbol::staff_space (ss)/2.0;
      
      heads.unite (iv + ss->relative_coordinate (common, Y_AXIS)
		   - my_y);
    }

  if (heads.empty_b ())
    {
      programming_error ("Huh? Dumb blonde encountered?");
      /*
	Nee Valerie, jij bent _niet_ dom. 
       */
      return SCM_EOL;
    }
  
  Molecule mol;
  Molecule arpeggio = me->get_default_font ()->find_by_name ("scripts-arpeggio");

  Real y = heads[LEFT];
  while (y < heads[RIGHT])
    {
      mol.add_at_edge (Y_AXIS, UP,arpeggio, 0.0);
      y+= arpeggio. extent (Y_AXIS).length ();
    }
  mol.translate_axis (heads[LEFT], Y_AXIS);

  return mol.create_scheme (); 
}

/*
  We have to do a callback, because brew_molecule () triggers a
  vertical alignment if it is cross-staff.
  This callback also adds padding.
*/
MAKE_SCHEME_CALLBACK(Arpeggio, width_callback,2);
SCM
Arpeggio::width_callback (SCM smob, SCM axis)
{
  Score_element * me = unsmob_element (smob);
  Axis a = (Axis)gh_scm2int (axis);
  assert (a == X_AXIS);
  Molecule arpeggio = me->get_default_font ()->find_by_name ("scripts-arpeggio");

  return ly_interval2scm (arpeggio.extent (X_AXIS) * 1.5);
}
