" ======================================================================
" 1. Transactional Buffer for Rating (Child Entity)
" ======================================================================
CLASS lcl_buffer DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA:
      mt_rating_update TYPE STANDARD TABLE OF zanime_rtg,
      mt_rating_delete TYPE STANDARD TABLE OF zanime_rtg.
ENDCLASS.

" ======================================================================
" Handler Class Definition
" ======================================================================
CLASS lhc_Rating DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY IMPORTING entities FOR UPDATE Rating.
    METHODS delete FOR MODIFY IMPORTING keys FOR DELETE Rating.
    METHODS read FOR READ IMPORTING keys FOR READ Rating RESULT result.
    METHODS rba_Anime FOR READ IMPORTING keys_rba FOR READ Rating\_Anime FULL result_requested RESULT result LINK association_links.
    METHODS ValidateScores FOR VALIDATE ON SAVE IMPORTING keys FOR Rating~ValidateScores.
ENDCLASS.

" ======================================================================
" Handler Class Implementation
" ======================================================================
CLASS lhc_Rating IMPLEMENTATION.

  METHOD update.
    LOOP AT entities INTO DATA(ls_entity).
      DATA(ls_db_record) = CORRESPONDING zanime_rtg( ls_entity MAPPING FROM ENTITY ).
      GET TIME STAMP FIELD DATA(lv_ts).
      ls_db_record-last_changed_at = lv_ts.
      ls_db_record-last_changed_by = sy-uname.

      " Save to the Global Buffer in the Root Class
      APPEND ls_db_record TO zbp_anime_hdr=>mt_rating_update.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    LOOP AT keys INTO DATA(ls_key).
      " Save to the Global Buffer in the Root Class
      APPEND VALUE #( rating_id = ls_key-RatingId ) TO zbp_anime_hdr=>mt_rating_delete.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    IF keys IS NOT INITIAL.
      SELECT * FROM zanime_rtg
        FOR ALL ENTRIES IN @keys
        WHERE rating_id = @keys-RatingId
        INTO TABLE @DATA(lt_active_data).
      result = CORRESPONDING #( lt_active_data MAPPING TO ENTITY ).
    ENDIF.
  ENDMETHOD.

  METHOD rba_Anime.
    " FIXED: Using the tilde (~) operator for ABAP Open SQL Aliases
    IF keys_rba IS NOT INITIAL.
      SELECT h~*
        FROM zanime_hdr AS h
        INNER JOIN zanime_rtg AS r ON h~anime_id = r~anime_id
        FOR ALL ENTRIES IN @keys_rba
        WHERE r~rating_id = @keys_rba-RatingId
        INTO TABLE @DATA(lt_anime).

      result = CORRESPONDING #( lt_anime MAPPING TO ENTITY ).
    ENDIF.
  ENDMETHOD.

  METHOD ValidateScores.
    READ ENTITIES OF ZI_ANIME_HDR IN LOCAL MODE
      ENTITY Rating
      FIELDS ( StarRating DemandScore ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_ratings).

    LOOP AT lt_ratings INTO DATA(ls_rating).
      IF ls_rating-StarRating < 1 OR ls_rating-StarRating > 5.
        APPEND VALUE #( %tky = ls_rating-%tky ) TO failed-rating.
        APPEND VALUE #( %tky = ls_rating-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text = 'Star Rating must be between 1 and 5.' )
                      ) TO reported-rating.
      ENDIF.

      IF ls_rating-DemandScore < 0 OR ls_rating-DemandScore > 100.
        APPEND VALUE #( %tky = ls_rating-%tky ) TO failed-rating.
        APPEND VALUE #( %tky = ls_rating-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text = 'Demand Score must be between 0 and 100.' )
                      ) TO reported-rating.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

