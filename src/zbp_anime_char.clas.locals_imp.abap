" ======================================================================
" Handler Class Definition
" ======================================================================
CLASS lhc_Character DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Character.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Character.

    METHODS read FOR READ
      IMPORTING keys FOR READ Character RESULT result.

    METHODS rba_Anime FOR READ
      IMPORTING keys_rba FOR READ Character\_Anime FULL result_requested RESULT result LINK association_links.

ENDCLASS.

" ======================================================================
" Handler Class Implementation
" ======================================================================
CLASS lhc_Character IMPLEMENTATION.

  METHOD update.
    LOOP AT entities INTO DATA(ls_entity).
      " Map incoming entity data to the database table structure
      DATA(ls_db_record) = CORRESPONDING zanime_char( ls_entity MAPPING FROM ENTITY ).

      " Set administrative fields
      GET TIME STAMP FIELD DATA(lv_ts).
      ls_db_record-last_changed_at = lv_ts.
      ls_db_record-last_changed_by = sy-uname.

      " Save to the Global Buffer in the Root Class
      APPEND ls_db_record TO zbp_anime_hdr=>mt_char_update.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    LOOP AT keys INTO DATA(ls_key).
      " Save the deleted keys to the Global Buffer in the Root Class
      APPEND VALUE #( char_id = ls_key-CharId ) TO zbp_anime_hdr=>mt_char_delete.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    " Read active data from the database for the Fiori UI
    IF keys IS NOT INITIAL.
      SELECT * FROM zanime_char
        FOR ALL ENTRIES IN @keys
        WHERE char_id = @keys-CharId
        INTO TABLE @DATA(lt_active_data).

      result = CORRESPONDING #( lt_active_data MAPPING TO ENTITY ).
    ENDIF.
  ENDMETHOD.

  METHOD rba_Anime.
    " Using the tilde (~) operator to join the parent and child tables
    IF keys_rba IS NOT INITIAL.
      SELECT h~*
        FROM zanime_hdr AS h
        INNER JOIN zanime_char AS c ON h~anime_id = c~anime_id
        FOR ALL ENTRIES IN @keys_rba
        WHERE c~char_id = @keys_rba-CharId
        INTO TABLE @DATA(lt_anime).

      result = CORRESPONDING #( lt_anime MAPPING TO ENTITY ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
