*CLASS zbp_anime_hdr DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zi_anime_hdr.
*ENDCLASS.
*
*CLASS zbp_anime_hdr IMPLEMENTATION.
*ENDCLASS.
CLASS zbp_anime_hdr DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zi_anime_hdr.
  PUBLIC SECTION.
    " Global Buffer Tables shared across all BP classes
    CLASS-DATA:
      mt_anime_create  TYPE STANDARD TABLE OF zanime_hdr,
      mt_anime_update  TYPE STANDARD TABLE OF zanime_hdr,
      mt_anime_delete  TYPE STANDARD TABLE OF zanime_hdr,

      mt_rating_create TYPE STANDARD TABLE OF zanime_rtg,
      mt_rating_update TYPE STANDARD TABLE OF zanime_rtg,
      mt_rating_delete TYPE STANDARD TABLE OF zanime_rtg,

      " ADD THESE TWO LINES FOR THE CHARACTER TABLE
      mt_char_create   TYPE STANDARD TABLE OF zanime_char,
      mt_char_update   TYPE STANDARD TABLE OF zanime_char,
      mt_char_delete   TYPE STANDARD TABLE OF zanime_char.
ENDCLASS.

CLASS zbp_anime_hdr IMPLEMENTATION.
ENDCLASS.
