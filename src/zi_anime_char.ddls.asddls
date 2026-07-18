@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Anime Characters'
define view entity ZI_ANIME_CHAR
  as select from zanime_char
  association to parent ZI_ANIME_HDR as _Anime on $projection.AnimeId = _Anime.AnimeId
{
  key char_id               as CharId,
  anime_id                  as AnimeId,
  char_name                 as CharName,
  voice_actor               as VoiceActor,
  char_image_url            as CharImageUrl,
  char_image_url            as CharImageDisplay,

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

  /* Parent Association */
  _Anime
}
