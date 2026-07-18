@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Anime Characters'
@Metadata.allowExtensions: true
define view entity ZC_ANIME_CHAR
  as projection on ZI_ANIME_CHAR
{
  key CharId,
  AnimeId,
  CharName,
  VoiceActor,
  
  CharImageUrl,
  
  @Semantics.imageUrl: true
  CharImageDisplay,

  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  LocalLastChangedAt,

  /* Redirected Parent Association */
  _Anime : redirected to parent ZC_ANIME_HDR
}
