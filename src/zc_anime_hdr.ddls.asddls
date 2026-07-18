@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Anime Header'
@Metadata.allowExtensions: true
define root view entity ZC_ANIME_HDR
  provider contract transactional_query
  as projection on ZI_ANIME_HDR
{
  key AnimeId,
  Title,
  
//  @Semantics.imageUrl: true
  ImageUrl,
  
  @Semantics.imageUrl: true
  ImageDisplay,
  
  WatchUrl,
  Status,
  Criticality,
  NoteFile,
  MimeType,
  FileName,
  
   StarRating,
  DemandScore,
  HeaderDemandScore,
  DemandCriticality,
  
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  LocalLastChangedAt,

  /* Redirected Compositions */
  _Ratings : redirected to composition child ZC_ANIME_RTG,
  _Chars   : redirected to composition child ZC_ANIME_CHAR
}
