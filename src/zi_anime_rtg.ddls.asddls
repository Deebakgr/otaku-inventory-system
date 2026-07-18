@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Anime Ratings'
define view entity ZI_ANIME_RTG
  as select from zanime_rtg
  association to parent ZI_ANIME_HDR as _Anime on $projection.AnimeId = _Anime.AnimeId
{
  key rating_id             as RatingId,
  anime_id                  as AnimeId,
  star_rating               as StarRating,
  demand_score              as DemandScore,
  
  case 
    when demand_score >= 70 then 3  
    when demand_score >= 40 then 2  
    when demand_score > 0   then 1  
    else 0                          
  end as DemandCriticality,
  

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
