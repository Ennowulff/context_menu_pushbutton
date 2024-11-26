CLASS zcl_t9r_minesweeper DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .


  PUBLIC SECTION.

    CLASS-METHODS class_constructor .
    CLASS-METHODS pai
      IMPORTING
        iv_ucomm        TYPE syucomm
        iv_set_mineflag TYPE abap_bool DEFAULT abap_false .
    CLASS-METHODS set_dimension
      IMPORTING
        iv_x     TYPE num2 DEFAULT 16
        iv_y     TYPE num2 DEFAULT 30
        iv_mines TYPE num2 DEFAULT 99 .
    CLASS-METHODS at_selection_screen_output
      RETURNING
        VALUE(rv_mines_left) TYPE int2 .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      BEGIN OF mts_minefield,
        x            TYPE numc2,
        y            TYPE numc2,
        mine         TYPE abap_bool,
        discovered   TYPE abap_bool,
        guessed_mine TYPE abap_bool,
        text         TYPE string,
      END OF mts_minefield .
    TYPES:
      mtt_minefield TYPE HASHED TABLE OF mts_minefield WITH UNIQUE KEY x y .

    CLASS-DATA mv_x TYPE numc2 VALUE 30 ##NO_TEXT.
    CLASS-DATA mv_y TYPE numc2 VALUE 16 ##NO_TEXT.
    CLASS-DATA mv_mines TYPE numc2 VALUE 99 ##NO_TEXT.
    CLASS-DATA mt_minefield TYPE mtt_minefield .
    CLASS-DATA mv_mark_mine TYPE flag VALUE '' ##NO_TEXT.
    CONSTANTS mc_free_field TYPE icon_d VALUE icon_rating_neutral ##NO_TEXT.

    CLASS-METHODS get_minefield_info
      IMPORTING
        !iv_x          TYPE numc2
        !iv_y          TYPE numc2
      RETURNING
        VALUE(rv_info) TYPE char4 .
    CLASS-METHODS build_minefield
      IMPORTING
        !iv_x TYPE numc2
        !iv_y TYPE numc2 .
    CLASS-METHODS discover_field
      IMPORTING
        !iv_x TYPE numc2
        !iv_y TYPE numc2 .

ENDCLASS.



CLASS ZCL_T9R_MINESWEEPER IMPLEMENTATION.


  METHOD at_selection_screen_output.
    DATA: lv_x TYPE numc2,
          lv_y TYPE numc2.


    LOOP AT SCREEN.

      IF screen-group1 = 'INT'.
        screen-intensified = '1'.
      ENDIF.

      IF screen-group1 = 'NI'.
        screen-input = 0.
      ENDIF.

      FIND REGEX 'GV_(\d{2})_(\d{2})\s*' IN screen-name SUBMATCHES lv_x lv_y.
      IF sy-subrc = 0.
* hide excess fields
        IF lv_x > mv_x
          OR lv_y > mv_y.
          screen-input     = '0'.
          screen-invisible = '1'.
        ELSE.
          DATA(lv_pushbutton) = |(SAPLZT9R_MINESWEEPER){ screen-name }|.
          ASSIGN (lv_pushbutton) TO FIELD-SYMBOL(<lv_pushbutton>).
          IF sy-subrc = 0.
            <lv_pushbutton> = get_minefield_info( iv_x = lv_x iv_y = lv_y ).
          ENDIF.
        ENDIF.
      ENDIF.

      MODIFY SCREEN.
    ENDLOOP.

* Calculate mines left
    rv_mines_left = mv_mines.
    LOOP AT mt_minefield ASSIGNING FIELD-SYMBOL(<lv_field>) WHERE  guessed_mine = abap_true.
      rv_mines_left = rv_mines_left - 1.
    ENDLOOP.


  ENDMETHOD.


  METHOD build_minefield.

    DATA: ls_minefield TYPE mts_minefield,
          lv_mines     TYPE i.


    CLEAR mt_minefield.
*--------------------------------------------------------------------*
* Build minefield
*--------------------------------------------------------------------*
    DO mv_x TIMES.
      ls_minefield-x = sy-index.
      DO mv_y TIMES.
        ls_minefield-y = sy-index.
* First click will always be a "discovered" one
        IF    iv_x = ls_minefield-x
          AND iv_y = ls_minefield-y.
          ls_minefield-discovered = abap_true.
          INSERT ls_minefield INTO TABLE mt_minefield ASSIGNING FIELD-SYMBOL(<ls_initial_click>).
        ELSE.
          ls_minefield-discovered = abap_false.
          INSERT ls_minefield INTO TABLE mt_minefield.
        ENDIF.
      ENDDO.
    ENDDO.

*--------------------------------------------------------------------*
* Set mines - make sure no discovered field is set to mine to have first click always be ok
*--------------------------------------------------------------------*
    DATA(lo_random_x) = cl_abap_random_int=>create( seed = CONV i( sy-uzeit )
                                                    min  = 1
                                                    max  = CONV i( mv_x * mv_y ) ).
    WHILE lv_mines < mv_mines.
      DATA(lv_i) = lo_random_x->get_next( ).
      ls_minefield-x = lv_i MOD mv_x + 1.
      ls_minefield-y = ( lv_i - 1 ) DIV mv_x + 1.
      READ TABLE mt_minefield ASSIGNING FIELD-SYMBOL(<ls_minefield>) WITH TABLE KEY x = ls_minefield-x
                                                                                    y = ls_minefield-y.
      IF    sy-subrc = 0
        AND <ls_minefield>-discovered = abap_false
        AND <ls_minefield>-mine       = abap_false.
        lv_mines = lv_mines + 1.
        <ls_minefield>-mine = abap_true.
      ENDIF.

    ENDWHILE.

* Reset disovered field to allow autodiscover in case we have no surroundings
    <ls_initial_click>-discovered = abap_false.
  ENDMETHOD.


  METHOD class_constructor.
    CONSTANTS minesweeper_fugr TYPE string VALUE 'SAPLZT9R_MINESWEEPER' ##NO_TEXT.

    DATA h TYPE d020s.
    DATA f TYPE TABLE OF d021s.
    DATA e TYPE TABLE OF d022s.
    DATA m TYPE TABLE OF d023s.
    DATA: BEGIN OF id,
            p TYPE progname,
            d TYPE sydynnr,
          END OF id.

    id = VALUE #( p = minesweeper_fugr d = '4000' ).
    IMPORT DYNPRO h f e m ID id.
    IF sy-subrc = 0.
      RETURN.
    ENDIF.

    id = VALUE #( p = minesweeper_fugr d = '0100' ). " This is the generated screen
    IMPORT DYNPRO h f e m ID id.

    LOOP AT f ASSIGNING FIELD-SYMBOL(<ls_f>) WHERE fnam(3) = 'GV_'.
      <ls_f>-res1+228(8) = <ls_f>-fnam.

    ENDLOOP.
    h-dnum = '4000'.
    h-fnum = '4000'.
    id = VALUE #( p = minesweeper_fugr d = '4000' ).
    EXPORT DYNPRO h f e m ID id.

  ENDMETHOD.


  METHOD discover_field.

    DATA: ls_minefield               TYPE mts_minefield.


    READ TABLE mt_minefield ASSIGNING FIELD-SYMBOL(<ls_field>) WITH TABLE KEY x = iv_x
                                                                              y = iv_y.
    ASSERT sy-subrc = 0.
    IF <ls_field>-discovered = abap_true. " already discovered --> don't act again
      RETURN.
    ENDIF.

    <ls_field>-discovered = abap_true.

    IF get_minefield_info( iv_x = iv_x iv_y = iv_y ) = mc_free_field. " No mine --> expand
* No surrounding mines --> autodiscover all surrounding fields
      DO 3 TIMES.
        ls_minefield-x = iv_x - 2 + sy-index. " from -1 to +1 .
        DO 3 TIMES.
          ls_minefield-y = iv_y - 2 + sy-index. " from -1 to +1 .
          READ TABLE mt_minefield ASSIGNING FIELD-SYMBOL(<ls_minefield>) WITH TABLE KEY x = ls_minefield-x
                                                                                        y = ls_minefield-y.
          IF sy-subrc = 0.
            discover_field( iv_x = ls_minefield-x iv_y = ls_minefield-y ).
          ENDIF.
        ENDDO.
      ENDDO.

    ENDIF.
  ENDMETHOD.


  METHOD get_minefield_info.
    DATA: ls_minefield               TYPE mts_minefield,
          lv_count_surrounding_mines TYPE i.

    FIELD-SYMBOLS: <ls_minefield> LIKE LINE OF mt_minefield.

    READ TABLE mt_minefield ASSIGNING <ls_minefield> WITH TABLE KEY x = iv_x
                                                                    y = iv_y.
    IF   sy-subrc <> 0.
      rv_info = '.'.
      RETURN.
    ENDIF.

    IF <ls_minefield>-guessed_mine = abap_true.
*        rv_info = icon_defect.
*        rv_info = icon_red_xcircle.
      rv_info = icon_status_critical.
      RETURN.
    ENDIF.

    IF <ls_minefield>-discovered = abap_false.
      rv_info = '.'.
      RETURN.
    ENDIF.



    IF <ls_minefield>-mine = abap_true.
      rv_info = icon_led_red.
      RETURN.
    ENDIF.

* Obviously we have a discovered field .  Count surrounding mines
    DO 3 TIMES.
      ls_minefield-x = iv_x - 2 + sy-index. " from -1 to +1 .
      DO 3 TIMES.
        ls_minefield-y = iv_y - 2 + sy-index. " from -1 to +1 .
        READ TABLE mt_minefield ASSIGNING <ls_minefield> WITH TABLE KEY x = ls_minefield-x
                                                                        y = ls_minefield-y.
        IF sy-subrc = 0
          AND <ls_minefield>-mine = abap_true.
          lv_count_surrounding_mines = lv_count_surrounding_mines + 1.
        ENDIF.
      ENDDO.
    ENDDO.

    IF lv_count_surrounding_mines = 0.
*      rv_info = space.
      rv_info = mc_free_field.
    ELSE.
      rv_info = |{ lv_count_surrounding_mines }|.
    ENDIF.

  ENDMETHOD.


  METHOD pai.
    DATA: lv_x TYPE numc2,
          lv_y TYPE numc2.


    CASE iv_ucomm.
      WHEN 'RESTART'.
        CLEAR mt_minefield.
        cl_gui_cfw=>set_new_ok_code( 'RESTART' ).
        RETURN.
    ENDCASE.


*--------------------------------------------------------------------*
* Find pressed button
*--------------------------------------------------------------------*
    FIND REGEX 'GV_(\d{2})_(\d{2})\s*' IN iv_ucomm SUBMATCHES lv_x lv_y.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    IF mt_minefield IS INITIAL.
      build_minefield( iv_x = lv_x iv_y = lv_y ).
      discover_field( iv_x = lv_x iv_y = lv_y  ).
    ELSE.
      READ TABLE mt_minefield ASSIGNING FIELD-SYMBOL(<ls_minefield>) WITH TABLE KEY x = lv_x y = lv_y.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.
      IF <ls_minefield>-discovered = abap_true. " once is enough ( for marking )
        RETURN.
      ENDIF.
      IF iv_set_mineflag = abap_true.
* just toggle the guessed mine field
        IF <ls_minefield>-guessed_mine = abap_true.
          <ls_minefield>-guessed_mine = abap_false.
        ELSE.
          <ls_minefield>-guessed_mine = abap_true.
        ENDIF.
      ELSE.
* Set field as free ( hopefully no mine )
        discover_field( iv_x = lv_x iv_y = lv_y  ).
        IF <ls_minefield>-mine = abap_true.
          MESSAGE 'You lost' TYPE 'I' DISPLAY LIKE 'E'.
          DO mv_x TIMES.
            lv_x = sy-index.
            DO mv_y TIMES.
              lv_y = sy-index.
              discover_field( iv_x = lv_x iv_y = lv_y  ).
            ENDDO.
          ENDDO.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.


* Check whether won game
    READ TABLE mt_minefield TRANSPORTING NO FIELDS WITH KEY mine       = abap_false  " free field
                                                            discovered = abap_false. " not discovered
    IF sy-subrc <> 0.
      MODIFY mt_minefield FROM VALUE mts_minefield( discovered = abap_true ) TRANSPORTING discovered WHERE discovered = abap_false.
      MODIFY mt_minefield FROM VALUE mts_minefield( guessed_mine = abap_true ) TRANSPORTING guessed_mine WHERE mine = abap_true.
      MESSAGE 'You have won' TYPE 'I' DISPLAY LIKE 'S'.
    ENDIF.


    cl_gui_cfw=>set_new_ok_code( 'MARKED_FIELD' ).


  ENDMETHOD.


  METHOD set_dimension.

    IF    iv_x >= 0
      AND iv_x <= 30.
      mv_x = iv_x.
    ELSEIF iv_x >= 0.
      mv_x = 30.
    ELSE.
      mv_x = 1.
    ENDIF.

    IF    iv_y >= 0
      AND iv_y <= 16.
      mv_y = iv_y.
    ELSEIF iv_y >= 0.
      mv_y = 16.
    ELSE.
      mv_y = 1.
    ENDIF.

    IF iv_mines > 0.
      mv_mines = iv_mines.
    ELSE.
      mv_mines = 1.
    ENDIF.

    CLEAR mt_minefield.


  ENDMETHOD.
ENDCLASS.
