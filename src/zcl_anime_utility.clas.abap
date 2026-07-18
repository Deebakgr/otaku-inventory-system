CLASS zcl_anime_utility DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    " FIXED: Changed ABAP_CHAR10 to the standard ABAP data element CHAR10
    CLASS-METHODS generate_anime_id RETURNING VALUE(rv_id) TYPE char10.
    CLASS-METHODS generate_rating_id RETURNING VALUE(rv_id) TYPE char10.
    CLASS-METHODS generate_char_id RETURNING VALUE(rv_id) TYPE char10.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_anime_utility IMPLEMENTATION.

  METHOD generate_anime_id.
    GET TIME STAMP FIELD DATA(lv_ts).
    DATA(lv_string) = CONV string( lv_ts ).
    rv_id = substring( val = lv_string off = strlen( lv_string ) - 10 len = 10 ).
  ENDMETHOD.

  METHOD generate_rating_id.
    GET TIME STAMP FIELD DATA(lv_ts).
    DATA(lv_string) = CONV string( lv_ts ).
    rv_id = substring( val = lv_string off = strlen( lv_string ) - 10 len = 10 ).
    WAIT UP TO 1 SECONDS.
  ENDMETHOD.

  METHOD generate_char_id.
    GET TIME STAMP FIELD DATA(lv_ts).
    DATA(lv_string) = CONV string( lv_ts ).
    rv_id = substring( val = lv_string off = strlen( lv_string ) - 10 len = 10 ).
    WAIT UP TO 1 SECONDS.
  ENDMETHOD.

ENDCLASS.
