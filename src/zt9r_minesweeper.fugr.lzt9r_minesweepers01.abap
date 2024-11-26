

  DEFINE minesweeper_field.
    SELECTION-SCREEN PUSHBUTTON (4) gv_&1_&2 USER-COMMAND gv_&1_&2 VISIBLE LENGTH 2.
  END-OF-DEFINITION.

  DEFINE minesweeper_line.
    SELECTION-SCREEN BEGIN OF LINE.
      minesweeper_field 01 &1.
      minesweeper_field 02 &1.
      minesweeper_field 03 &1.
      minesweeper_field 04 &1.
      minesweeper_field 05 &1.
      minesweeper_field 06 &1.
      minesweeper_field 07 &1.
      minesweeper_field 08 &1.
      minesweeper_field 09 &1.
      minesweeper_field 10 &1.
      minesweeper_field 11 &1.
      minesweeper_field 12 &1.
      minesweeper_field 13 &1.
      minesweeper_field 14 &1.
      minesweeper_field 15 &1.
      minesweeper_field 16 &1.
      minesweeper_field 17 &1.
      minesweeper_field 18 &1.
      minesweeper_field 19 &1.
      minesweeper_field 20 &1.
      minesweeper_field 21 &1.
      minesweeper_field 22 &1.
      minesweeper_field 23 &1.
      minesweeper_field 24 &1.
      minesweeper_field 25 &1.
      minesweeper_field 26 &1.
      minesweeper_field 27 &1.
      minesweeper_field 28 &1.
      minesweeper_field 29 &1.
      minesweeper_field 30 &1.
    SELECTION-SCREEN END OF LINE.
  END-OF-DEFINITION.

  SELECTION-SCREEN BEGIN OF SCREEN 100 AS SUBSCREEN.

    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN COMMENT 40(30) TEXT-if1  MODIF ID int.
    SELECTION-SCREEN END OF LINE.
    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN COMMENT (20) TEXT-mil FOR FIELD mines.
      PARAMETERS mines TYPE int2 MODIF ID ni VISIBLE LENGTH 3.
      SELECTION-SCREEN COMMENT 40(30) TEXT-if2  MODIF ID int.
      SELECTION-SCREEN PUSHBUTTON (20) restart USER-COMMAND restart.
    SELECTION-SCREEN END OF LINE.

    SELECTION-SCREEN SKIP 1.
    minesweeper_line 01.
    minesweeper_line 02.
    minesweeper_line 03.
    minesweeper_line 04.
    minesweeper_line 05.
    minesweeper_line 06.
    minesweeper_line 07.
    minesweeper_line 08.
    minesweeper_line 09.
    minesweeper_line 10.
    minesweeper_line 11.
    minesweeper_line 12.
    minesweeper_line 13.
    minesweeper_line 14.
    minesweeper_line 15.
    minesweeper_line 16.
  SELECTION-SCREEN END OF SCREEN 100.



  AT SELECTION-SCREEN OUTPUT.
    restart = TEXT-res.
    mines = zcl_t9r_minesweeper=>at_selection_screen_output( ).

  AT SELECTION-SCREEN.
    zcl_t9r_minesweeper=>pai( sy-ucomm ).
