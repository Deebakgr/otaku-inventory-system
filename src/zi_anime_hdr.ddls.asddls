@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Anime Header'
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define root view entity ZI_ANIME_HDR
  as select from zanime_hdr
  composition [0..*] of ZI_ANIME_RTG  as _Ratings
  composition [0..*] of ZI_ANIME_CHAR as _Chars
  
  association [1..1] to ZI_ANIME_RTG as _PrimaryRating on $projection.AnimeId = _PrimaryRating.AnimeId
{
  key anime_id              as AnimeId,
  title                     as Title,
  image_url                 as ImageUrl,
  image_url                 as ImageDisplay,
  watch_url                 as WatchUrl,
  status                    as Status,
  criticality               as Criticality,
  
  /* File Download Semantics */
  @Semantics.largeObject: { mimeType: 'MimeType', 
                            fileName: 'FileName', 
                            contentDispositionPreference: #ATTACHMENT }
  note_file                 as NoteFile,
  
  @Semantics.mimeType: true
  mimetype                  as MimeType,
  filename                  as FileName,
  
  _PrimaryRating.StarRating as StarRating,
  _PrimaryRating.DemandScore as DemandScore,
  _PrimaryRating.DemandScore as HeaderDemandScore,
  _PrimaryRating.DemandCriticality as DemandCriticality,

  @Semantics.user.createdBy: true
  created_by                as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at                as CreatedAt,
  @Semantics.user.lastChangedBy: true
  last_changed_by           as LastChangedBy,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at           as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at     as LocalLastChangedAt,

  /* Public Associations */
  _Ratings,
  _Chars
}
