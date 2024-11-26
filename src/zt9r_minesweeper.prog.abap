REPORT ZT9R_MINESWEEPER.

DATA ok_code_9000 TYPE syucomm.

PARAMETERS: p_x     TYPE numc2 DEFAULT 30, " = max
            p_y     TYPE numc2 DEFAULT 16, " = max
            p_mines TYPE numc2 DEFAULT 99.

END-OF-SELECTION.
  zcl_t9r_minesweeper=>set_dimension( iv_x = p_x iv_y = p_y iv_mines = p_mines ).
  CALL SCREEN 9000.

MODULE status_9000 OUTPUT.
  SET PF-STATUS '9000'.
  CLEAR ok_code_9000.
ENDMODULE.

MODULE user_command_9000 INPUT.
  CASE ok_code_9000.
    WHEN 'ABBR'
      OR 'EXIT'
      OR 'BACK'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
