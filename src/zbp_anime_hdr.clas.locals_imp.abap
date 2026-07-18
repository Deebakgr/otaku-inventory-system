" ======================================================================
" 1. Handler Class Definition
" ======================================================================
CLASS lhc_Anime DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Anime RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Anime.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE Anime.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Anime.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Anime.

    METHODS read FOR READ
      IMPORTING keys FOR READ Anime RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Anime.

    METHODS rba_Chars FOR READ
      IMPORTING keys_rba FOR READ Anime\_Chars FULL result_requested RESULT result LINK association_links.

    METHODS rba_Ratings FOR READ
      IMPORTING keys_rba FOR READ Anime\_Ratings FULL result_requested RESULT result LINK association_links.

    METHODS cba_Chars FOR MODIFY
      IMPORTING entities_cba FOR CREATE Anime\_Chars.

    METHODS earlynumbering_cba_Chars FOR NUMBERING
      IMPORTING entities FOR CREATE Anime\_Chars.

    METHODS cba_Ratings FOR MODIFY
      IMPORTING entities_cba FOR CREATE Anime\_Ratings.

    METHODS earlynumbering_cba_Ratings FOR NUMBERING
      IMPORTING entities FOR CREATE Anime\_Ratings.

    METHODS MarkAsCompleted FOR MODIFY
      IMPORTING keys FOR ACTION Anime~MarkAsCompleted RESULT result.

    METHODS SetDefaultStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Anime~SetDefaultStatus.

    METHODS ValidateTitle FOR VALIDATE ON SAVE
      IMPORTING keys FOR Anime~ValidateTitle.

    METHODS GenerateText FOR MODIFY
      IMPORTING keys FOR ACTION Anime~GenerateText RESULT result.

ENDCLASS.

" ======================================================================
" 2. Handler Class Implementation
" ======================================================================
CLASS lhc_Anime IMPLEMENTATION.

  METHOD get_instance_authorizations.
    " Boilerplate for authorization
  ENDMETHOD.

  METHOD create.
    LOOP AT entities INTO DATA(ls_entity).
      DATA(ls_db_record) = CORRESPONDING zanime_hdr( ls_entity MAPPING FROM ENTITY ).
      GET TIME STAMP FIELD DATA(lv_ts).
      ls_db_record-created_at = lv_ts.
      ls_db_record-created_by = sy-uname.

      " Writing to Global Buffer
      APPEND ls_db_record TO zbp_anime_hdr=>mt_anime_create.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    LOOP AT entities INTO DATA(ls_entity).
      " 1. FETCH CURRENT DATA FIRST to avoid wiping out fields!
      SELECT SINGLE * FROM zanime_hdr WHERE anime_id = @ls_entity-AnimeId INTO @DATA(ls_db_record).

      " 2. ONLY UPDATE FIELDS THAT HAVE CHANGED (%control check)
      IF ls_entity-%control-Title = if_abap_behv=>mk-on.
        ls_db_record-title = ls_entity-Title.
      ENDIF.
      IF ls_entity-%control-ImageUrl = if_abap_behv=>mk-on.
        ls_db_record-image_url = ls_entity-ImageUrl.
      ENDIF.
      IF ls_entity-%control-ImageDisplay = if_abap_behv=>mk-on.
        ls_db_record-image_url = ls_entity-ImageDisplay.
      ENDIF.
      IF ls_entity-%control-WatchUrl = if_abap_behv=>mk-on.
        ls_db_record-watch_url = ls_entity-WatchUrl.
      ENDIF.
      IF ls_entity-%control-Status = if_abap_behv=>mk-on.
        ls_db_record-status = ls_entity-Status.
      ENDIF.
      IF ls_entity-%control-Criticality = if_abap_behv=>mk-on.
        ls_db_record-criticality = ls_entity-Criticality.
      ENDIF.

      " File Fields
      IF ls_entity-%control-NoteFile = if_abap_behv=>mk-on.
        ls_db_record-note_file = ls_entity-NoteFile.
      ENDIF.
      IF ls_entity-%control-MimeType = if_abap_behv=>mk-on.
        ls_db_record-mimetype = ls_entity-MimeType.
      ENDIF.
      IF ls_entity-%control-FileName = if_abap_behv=>mk-on.
        ls_db_record-filename = ls_entity-FileName.
      ENDIF.

      GET TIME STAMP FIELD DATA(lv_ts).
      ls_db_record-last_changed_at = lv_ts.
      ls_db_record-last_changed_by = sy-uname.

      " 3. Writing safely merged data to Global Buffer
      APPEND ls_db_record TO zbp_anime_hdr=>mt_anime_update.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    LOOP AT keys INTO DATA(ls_key).
      APPEND VALUE #( anime_id = ls_key-AnimeId ) TO zbp_anime_hdr=>mt_anime_delete.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    IF keys IS NOT INITIAL.
      SELECT * FROM zanime_hdr
        FOR ALL ENTRIES IN @keys
        WHERE anime_id = @keys-AnimeId
        INTO TABLE @DATA(lt_active_data).

      result = CORRESPONDING #( lt_active_data MAPPING TO ENTITY ).
    ENDIF.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Chars. ENDMETHOD.
  METHOD rba_Ratings. ENDMETHOD.

  METHOD cba_Chars.
    LOOP AT entities_cba INTO DATA(ls_entity_cba).
      LOOP AT ls_entity_cba-%target INTO DATA(ls_target).
        DATA(ls_db_record) = CORRESPONDING zanime_char( ls_target MAPPING FROM ENTITY ).
        GET TIME STAMP FIELD DATA(lv_ts).
        ls_db_record-created_at = lv_ts.
        ls_db_record-created_by = sy-uname.
        APPEND ls_db_record TO zbp_anime_hdr=>mt_char_create.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD cba_Ratings.
    LOOP AT entities_cba INTO DATA(ls_entity_cba).
      LOOP AT ls_entity_cba-%target INTO DATA(ls_target).
        DATA(ls_db_record) = CORRESPONDING zanime_rtg( ls_target MAPPING FROM ENTITY ).
        GET TIME STAMP FIELD DATA(lv_ts).
        ls_db_record-created_at = lv_ts.
        ls_db_record-created_by = sy-uname.
        APPEND ls_db_record TO zbp_anime_hdr=>mt_rating_create.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD earlynumbering_create.
    LOOP AT entities INTO DATA(ls_entity) WHERE AnimeId IS INITIAL.
      DATA(lv_new_id) = zcl_anime_utility=>generate_anime_id( ).
      APPEND VALUE #( %cid      = ls_entity-%cid
                      AnimeId   = lv_new_id
                      %is_draft = ls_entity-%is_draft ) TO mapped-anime.
    ENDLOOP.
  ENDMETHOD.

  METHOD earlynumbering_cba_Ratings.
    LOOP AT entities INTO DATA(ls_entity).
      LOOP AT ls_entity-%target INTO DATA(ls_target) WHERE RatingId IS INITIAL.
        DATA(lv_new_rating_id) = zcl_anime_utility=>generate_rating_id( ).
        APPEND VALUE #( %cid      = ls_target-%cid
                        RatingId  = lv_new_rating_id
                        %is_draft = ls_target-%is_draft ) TO mapped-rating.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD earlynumbering_cba_Chars.
    LOOP AT entities INTO DATA(ls_entity).
      LOOP AT ls_entity-%target INTO DATA(ls_target) WHERE CharId IS INITIAL.
        DATA(lv_new_char_id) = zcl_anime_utility=>generate_char_id( ).
        APPEND VALUE #( %cid      = ls_target-%cid
                        CharId    = lv_new_char_id
                        %is_draft = ls_target-%is_draft ) TO mapped-character.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD MarkAsCompleted.
    MODIFY ENTITIES OF ZI_ANIME_HDR IN LOCAL MODE
      ENTITY Anime
      UPDATE FIELDS ( Status Criticality )
      WITH VALUE #( FOR ls_key IN keys (
                       %tky        = ls_key-%tky
                       Status      = 'Completed'
                       Criticality = 3 ) ).

    READ ENTITIES OF ZI_ANIME_HDR IN LOCAL MODE
      ENTITY Anime
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_updated_animes).

    result = VALUE #( FOR ls_anime IN lt_updated_animes (
                        %tky   = ls_anime-%tky
                        %param = ls_anime ) ).
  ENDMETHOD.

  METHOD SetDefaultStatus.
    READ ENTITIES OF ZI_ANIME_HDR IN LOCAL MODE
      ENTITY Anime
      FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_anime).

    LOOP AT lt_anime INTO DATA(ls_anime) WHERE Status IS INITIAL.
      MODIFY ENTITIES OF ZI_ANIME_HDR IN LOCAL MODE
        ENTITY Anime
        UPDATE FIELDS ( Status Criticality )
        WITH VALUE #( ( %tky = ls_anime-%tky
                        Status = 'Airing'
                        Criticality = 2 ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD ValidateTitle.
    READ ENTITIES OF ZI_ANIME_HDR IN LOCAL MODE
      ENTITY Anime
      FIELDS ( Title ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_anime).

    LOOP AT lt_anime INTO DATA(ls_anime) WHERE Title IS INITIAL.
      APPEND VALUE #( %tky = ls_anime-%tky ) TO failed-anime.

      APPEND VALUE #( %tky = ls_anime-%tky
                      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                    text = 'Anime Title cannot be blank.' )
                    ) TO reported-anime.
    ENDLOOP.
  ENDMETHOD.

  METHOD GenerateText.
    " 1. Read the Anime Header data
    READ ENTITIES OF ZI_ANIME_HDR IN LOCAL MODE
      ENTITY Anime
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_animes).

    LOOP AT lt_animes ASSIGNING FIELD-SYMBOL(<ls_anime>).

      " =========================================================
      " 2. THE FIX: Fetch Rating & Demand directly from Database!
      " =========================================================
      DATA(lv_star)   = 0.
      DATA(lv_demand) = 0.

      SELECT SINGLE star_rating, demand_score
        FROM zanime_rtg
        WHERE anime_id = @<ls_anime>-AnimeId
        INTO (@lv_star, @lv_demand).

      " 3. Design the file content
      DATA(lv_text) = |==========================================\r\n| &&
                      |           ANIME SUMMARY FILE            \r\n| &&
                      |==========================================\r\n| &&
                      |Anime ID:       { <ls_anime>-AnimeId }\r\n| &&
                      |Title:          { <ls_anime>-Title }\r\n| &&
                      |Current Status: { <ls_anime>-Status }\r\n| &&
                      |User Rating:    { lv_star } / 5 Stars\r\n| &&
                      |Demand Score:   { lv_demand } / 100\r\n| &&
                      |Watch Link:     { <ls_anime>-WatchUrl }\r\n| &&
                      |==========================================|.

      " 4. Convert string to binary (ABAP Cloud syntax)
      DATA(lv_file_content) = cl_abap_conv_codepage=>create_out( )->convert( source = lv_text ).
      DATA(lv_filename)     = |{ <ls_anime>-Title }_Details.txt|.

      " 5. Trigger standard update to save the file
      MODIFY ENTITIES OF ZI_ANIME_HDR IN LOCAL MODE
        ENTITY Anime
        UPDATE FIELDS ( NoteFile MimeType FileName )
        WITH VALUE #( ( %tky     = <ls_anime>-%tky
                        NoteFile = lv_file_content
                        MimeType = 'text/plain'
                        FileName = lv_filename ) ).
    ENDLOOP.

    " 6. Read the final state to return to UI
    READ ENTITIES OF ZI_ANIME_HDR IN LOCAL MODE
      ENTITY Anime
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_final).

    result = VALUE #( FOR ls_final IN lt_final (
                        %tky   = ls_final-%tky
                        %param = ls_final ) ).
  ENDMETHOD.

ENDCLASS.

" ======================================================================
" 3. Saver Class Definition & Implementation
" ======================================================================
CLASS lsc_ZI_ANIME_HDR DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize REDEFINITION.
    METHODS check_before_save REDEFINITION.
    METHODS save REDEFINITION.
    METHODS cleanup REDEFINITION.
    METHODS cleanup_finalize REDEFINITION.
ENDCLASS.

CLASS lsc_ZI_ANIME_HDR IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    " --- HEADER SAVES ---
    IF zbp_anime_hdr=>mt_anime_create IS NOT INITIAL.
      INSERT zanime_hdr FROM TABLE @zbp_anime_hdr=>mt_anime_create.
    ENDIF.
    IF zbp_anime_hdr=>mt_anime_update IS NOT INITIAL.
      UPDATE zanime_hdr FROM TABLE @zbp_anime_hdr=>mt_anime_update.
    ENDIF.
    IF zbp_anime_hdr=>mt_anime_delete IS NOT INITIAL.
      DELETE zanime_hdr FROM TABLE @zbp_anime_hdr=>mt_anime_delete.
    ENDIF.

    " --- RATING SAVES ---
    IF zbp_anime_hdr=>mt_rating_create IS NOT INITIAL.
      INSERT zanime_rtg FROM TABLE @zbp_anime_hdr=>mt_rating_create.
    ENDIF.
    IF zbp_anime_hdr=>mt_rating_update IS NOT INITIAL.
      UPDATE zanime_rtg FROM TABLE @zbp_anime_hdr=>mt_rating_update.
    ENDIF.
    IF zbp_anime_hdr=>mt_rating_delete IS NOT INITIAL.
      DELETE zanime_rtg FROM TABLE @zbp_anime_hdr=>mt_rating_delete.
    ENDIF.

    " --- CHARACTER SAVES ---
    IF zbp_anime_hdr=>mt_char_create IS NOT INITIAL.
      INSERT zanime_char FROM TABLE @zbp_anime_hdr=>mt_char_create.
    ENDIF.
    IF zbp_anime_hdr=>mt_char_update IS NOT INITIAL.
      UPDATE zanime_char FROM TABLE @zbp_anime_hdr=>mt_char_update.
    ENDIF.
    IF zbp_anime_hdr=>mt_char_delete IS NOT INITIAL.
      DELETE zanime_char FROM TABLE @zbp_anime_hdr=>mt_char_delete.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
    CLEAR: zbp_anime_hdr=>mt_anime_create,
           zbp_anime_hdr=>mt_anime_update,
           zbp_anime_hdr=>mt_anime_delete,
           zbp_anime_hdr=>mt_rating_create,
           zbp_anime_hdr=>mt_rating_update,
           zbp_anime_hdr=>mt_rating_delete,
           zbp_anime_hdr=>mt_char_create,
           zbp_anime_hdr=>mt_char_update,
           zbp_anime_hdr=>mt_char_delete.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
