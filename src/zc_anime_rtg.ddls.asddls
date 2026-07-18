@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Anime Ratings'
@Metadata.allowExtensions: true
define view entity ZC_ANIME_RTG
  as projection on ZI_ANIME_RTG
{
  key RatingId,
  AnimeId,
  StarRating,
  DemandScore,
  DemandCriticality,

  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  LocalLastChangedAt,

  /* Redirected Parent Association */
  _Anime : redirected to parent ZC_ANIME_HDR
}
