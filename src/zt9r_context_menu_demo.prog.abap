REPORT zt9r_context_menu_demo.


CLASS dontuse DEFINITION.
  PUBLIC SECTION.
    TYPES _fields TYPE TABLE OF string WITH EMPTY KEY.
    CLASS-METHODS set_context_menu_4_pushbutton
      IMPORTING
        i_dynpro_elements TYPE _fields.
ENDCLASS.
CLASS dontuse IMPLEMENTATION.
  METHOD set_context_menu_4_pushbutton.
    CONSTANTS c_programname TYPE string VALUE sy-repid ##NO_TEXT.

    DATA h TYPE d020s.
    DATA f TYPE TABLE OF d021s.
    DATA e TYPE TABLE OF d022s.
    DATA m TYPE TABLE OF d023s.
    DATA i TYPE string.
    DATA l TYPE i.
    DATA w TYPE string.
    DATA: BEGIN OF id,
            p TYPE progname,
            d TYPE sydynnr,
          END OF id.

    id = VALUE #( p = c_programname d = '0100' ).
    IMPORT DYNPRO h f e m ID id.
    IF sy-subrc > 0.
      RETURN.
    ENDIF.

    LOOP AT i_dynpro_elements ASSIGNING FIELD-SYMBOL(<element>).
      TRY.
          f[ fnam = <element> ]-res1+228 = <element>.
        CATCH cx_sy_itab_line_not_found.
          RETURN.
      ENDTRY.
    ENDLOOP.

    h-dnum = '0101'.
    h-fnum = '0101'.
    id = VALUE #( p = c_programname d = '0101' ).
    EXPORT DYNPRO h f e m ID id.

    GENERATE DYNPRO h f e m ID id MESSAGE i LINE l WORD w.

  ENDMETHOD.
ENDCLASS.


DATA checkbox TYPE c LENGTH 1.
DATA input TYPE c LENGTH 20.

START-OF-SELECTION.

  dontuse=>set_context_menu_4_pushbutton( VALUE #(
    ( |CHECKBOX| )
    ( |MAGIC| ) ) ).
  CALL SCREEN 101.

FORM on_ctmenu_magic
  USING
    l_menu TYPE REF TO cl_ctmenu.

  l_menu->add_function(
      fcode             = 'MAGIC1'
      text              = 'Magic option 1'  ).
  l_menu->add_function(
      fcode             = 'CTX2'
      text              = 'Magic option 2'  ).
*  MESSAGE 'Magic' TYPE 'S'.
ENDFORM.
FORM on_ctmenu_general
  USING
    l_menu TYPE REF TO cl_ctmenu.

  l_menu->add_function(
      fcode             = 'GEN1'
      text              = 'General option 1'  ).
  l_menu->add_function(
      fcode             = 'GEN2'
      text              = 'General option 2'  ).
ENDFORM.

FORM on_ctmenu_input
  USING
    l_menu TYPE REF TO cl_ctmenu.

  l_menu->add_function(
      fcode             = 'INPUT'
      text              = 'Clear field'  ).
ENDFORM.

FORM on_ctmenu_checkbox
  USING
    l_menu TYPE REF TO cl_ctmenu.

  l_menu->add_function(
      fcode             = 'CHECKBOX_ON'
      text              = 'Activate option'
      disabled          = SWITCH #( checkbox WHEN abap_true THEN abap_true ELSE abap_false ) ).
  l_menu->add_function(
      fcode             = 'CHECKBOX_OFF'
      text              = 'Deactivate option'
      disabled          = SWITCH #( checkbox WHEN abap_false THEN abap_true ELSE abap_false ) ).

ENDFORM.


MODULE pbo OUTPUT.
  SET PF-STATUS 'DEMO'.
  CLEAR sy-ucomm.
ENDMODULE.
MODULE pai INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'CHECKBOX_ON'.
      checkbox = abap_true.
    WHEN 'CHECKBOX_OFF'.
      checkbox = abap_false.
  ENDCASE.

ENDMODULE.
