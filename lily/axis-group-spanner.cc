/*
  axis-group-spanner.cc -- implement Axis_group_spanner

  source file of the GNU LilyPond music typesetter

  (c)  1997--1999 Han-Wen Nienhuys <hanwen@cs.uu.nl>
*/

#include "axis-group-spanner.hh"
#include "debug.hh"
#include "item.hh"
#include "paper-column.hh"

/** Do stuff if we're not broken. In this case the last and first
  columns usually are pre- and postbreak respectively,
  so the items from these columns need adjusting.
  */
void
Axis_group_spanner::do_break_processing_if_unbroken()
{
#if 0
  Link_array<Score_element> elems = elem_l_arr ();
  Line_of_score *my_line = line_l();
  for (int i=0; i < elems.size(); i++) 
    {
      if (!elems[i]->line_l()) 
	{
	  Item * item_l = dynamic_cast<Item*> (elems[i]);
	  if  (item_l
	       && item_l->breakable_b ()
	       && item_l->break_status_dir() == 0) 
	    {
	      // last two checks are paranoia
	      Score_element * broken_item_l = 
		item_l->find_broken_piece (my_line);
	      add_element (broken_item_l);
	    }

	  Spanner *spanner_l = dynamic_cast<Spanner*> (elems[i]);
	  if (spanner_l)
	    {
	      Score_element *broken_spanner_l =
		spanner_l->find_broken_piece (my_line);
	      add_element (broken_spanner_l);
	    }
	  remove_element (elems[i]);
	}
      
    }
#endif
}

void
Axis_group_spanner::do_break_processing()
{
  Spanner::do_break_processing ();

  bool breaking_self_b = ! Spanner::line_l();
  if (!breaking_self_b)  
    {
      do_break_processing_if_unbroken();
      Spanner::do_break_processing();
      return;
    }

#if 0
  break_into_pieces ();
  Link_array<Score_element> loose_elems = elem_l_arr ();

  Array<int> axeses;

  for (int i=0; i < loose_elems.size (); i++)
    {
      Score_element* elt = loose_elems[i];
      /*
	    with which axes do we have to meddle?
      */
      int j =0;
      int as [2];
      for (int a = X_AXIS; a < NO_AXES; ++a)
	if (elt->parent_l (Axis (a)) == this)
	  as[j++] = a;
      if (j == 1)
	as[j++] = as[0];

      axeses.push (as[0]);
      axeses.push (as[1]);
    }

  remove_all();
  
  for (int i=0; i < loose_elems.size(); i++) 
    {
      Score_element * elt = loose_elems[i];
      Line_of_score *elt_line = elt->line_l();

      Axis a1= (Axis)axeses[2*i];	// ugh.
      Axis a2= (Axis)axeses[2*i+1];	// ugh.      
      if (! elt_line)
	{
	  /* this piece doesn't know where it belongs.
	     Find out if it was broken, and use the broken remains
	     */


	  Item *it = dynamic_cast <Item *> (elt) ;	  
	  if (Spanner * sp =dynamic_cast <Spanner *> (elt))
	    {
	      for (int j =0; j < sp->broken_into_l_arr_.size(); j++) 
		{
		  Line_of_score *l = sp->broken_into_l_arr_[j]->line_l ();

		  Axis_group_spanner * my_broken_l
		    = dynamic_cast<Axis_group_spanner*>(find_broken_piece (l));
		  
		  Score_element * broken_span_l 
		    = sp->find_broken_piece (l);

		  if (broken_span_l) 
		    my_broken_l->add_element (broken_span_l, a1, a2);
		}
	    }
	  else if (it && it->broken_original_b ())
	    {
	      // broken items
	      Direction  j=LEFT;
	      do 
		{
		  Item * broken_item = it->find_broken_piece (j);
		  Line_of_score * item_line_l = broken_item->line_l() ;
		  if (! item_line_l) 
		    continue;
		    
		  Axis_group_spanner * v
		    = dynamic_cast<Axis_group_spanner*>(find_broken_piece (item_line_l));
		  if (v)
		    v->add_element (broken_item, a1, a2);
		  else
		    {
		      broken_item->set_elt_property ("transparent", SCM_BOOL_T);
		      broken_item->set_empty (X_AXIS); // UGH.
		      broken_item->set_empty (Y_AXIS);		      
		    }

		}
	      while (flip(&j) != LEFT);
	    }
	}
      else 
	{
	  /* this piece *does* know where it belongs.
	     Put it in appropriate piece of this spanner
	     */
	  Axis_group_spanner * my_broken_l
	    = dynamic_cast<Axis_group_spanner*> (find_broken_piece (elt->line_l()));
	  my_broken_l->add_element (elt, a1, a2);
	}
    }
  
  Spanner::do_break_processing();
#endif
}




