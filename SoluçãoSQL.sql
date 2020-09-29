select 
  contests.contest_id, 
  contests.hacker_id, 
  contests.name,
  sum(submissoes_somadas.soma_submissoes),
  sum(submissoes_somadas.soma_submissoes_aceitas),
  sum(visualizacoes_somadas.soma_visualizacoes),
  sum(visualizacoes_somadas.soma_visualizacoes_unicas)
from contests
join colleges on contests.contest_id = colleges.contest_id
join challenges on colleges.college_id = challenges.college_id

left join 
(select 
  challenge_id,
  sum(total_submissions) as soma_submissoes,
  sum(total_accepted_submissions) as soma_submissoes_aceitas
  from submission_stats group by challenge_id) 
as submissoes_somadas
on challenges.challenge_id = submissoes_somadas.challenge_id

left join
(select 
  challenge_id,
  sum(total_views) as soma_visualizacoes,
  sum(total_unique_views) as soma_visualizacoes_unicas
  from view_stats group by challenge_id) 
as visualizacoes_somadas
on challenges.challenge_id = visualizacoes_somadas.challenge_id

group by contests.contest_id, contests.hacker_id, contests.name

having (
  sum(submissoes_somadas.soma_submissoes) +
  sum(submissoes_somadas.soma_submissoes_aceitas) +
  sum(visualizacoes_somadas.soma_visualizacoes) +
  sum(visualizacoes_somadas.soma_visualizacoes_unicas)
) > 0
order by contests.contest_id
