DEFINE minesweeper_form.
  FORM on_ctmenu_gv_&1_&2 USING l_menu TYPE REF TO cl_ctmenu.
     MESSAGE |&1 - &2| TYPE 'S'.
     zcl_t9r_minesweeper=>pai( iv_ucomm = 'GV_&1_&2' iv_set_mineflag = abap_true ).
  ENDFORM.
END-OF-DEFINITION.

DEFINE minesweeper_form_line.

  minesweeper_form 01 &1.
  minesweeper_form 02 &1.
  minesweeper_form 03 &1.
  minesweeper_form 04 &1.
  minesweeper_form 05 &1.
  minesweeper_form 06 &1.
  minesweeper_form 07 &1.
  minesweeper_form 08 &1.
  minesweeper_form 09 &1.
  minesweeper_form 10 &1.
  minesweeper_form 11 &1.
  minesweeper_form 12 &1.
  minesweeper_form 13 &1.
  minesweeper_form 14 &1.
  minesweeper_form 15 &1.
  minesweeper_form 16 &1.
  minesweeper_form 17 &1.
  minesweeper_form 18 &1.
  minesweeper_form 19 &1.
  minesweeper_form 20 &1.
  minesweeper_form 21 &1.
  minesweeper_form 22 &1.
  minesweeper_form 23 &1.
  minesweeper_form 24 &1.
  minesweeper_form 25 &1.
  minesweeper_form 26 &1.
  minesweeper_form 27 &1.
  minesweeper_form 28 &1.
  minesweeper_form 29 &1.
  minesweeper_form 30 &1.

END-OF-DEFINITION.

minesweeper_form_line 01.
minesweeper_form_line 02.
minesweeper_form_line 03.
minesweeper_form_line 04.
minesweeper_form_line 05.
minesweeper_form_line 06.
minesweeper_form_line 07.
minesweeper_form_line 08.
minesweeper_form_line 09.
minesweeper_form_line 10.
minesweeper_form_line 11.
minesweeper_form_line 12.
minesweeper_form_line 13.
minesweeper_form_line 14.
minesweeper_form_line 15.
minesweeper_form_line 16.
