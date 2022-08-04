--invitation non acceptées
select account_receiver.first_name first_name_receiver
from send_invite
inner join account account_sender on account.id_account = send_invite.id_account_sender 
inner join account account_receiver on account.id_account = send_invite.id_account_receiver 
where
send_invite.id_account_sender = 1 and
send_invite.is_accepted = 'f'
;


--liste amies
select account_receiver.first_name, 
account_receiver.last_name,
account_receiver.nickname,
account_receiver.profile_pic,
send_invite.friendship_birthday
from send_invite
inner join account account_sender on account.id_account = send_invite.id_account_sender 
inner join account account_receiver on account.id_account = send_invite.id_account_receiver 
where
send_invite.id_account_sender = 1 and
send_invite.is_accepted = 't'
;

--liste amies récents
select account_receiver.first_name, 
account_receiver.last_name
from send_invite
left join account account_sender on account.id_account = send_invite.id_account_sender 
left join account account_receiver on account.id_account = send_invite.id_account_receiver 
where
send_invite.id_account_sender = 1 and
send_invite.is_accepted = 't'
order by send_invite.friendship_birthday DESC
LIMIT 9
;

--liste message entre deux comptes
select 
account_sender.first_name first_name_sender, 
account_receiver.first_name first_name_receiver, 
message.message_datetime,
message.message_content,
message.seen_datetime
from message
inner join account account_sender on account.id_account = message.id_account_sender 
left join account account_receiver on account.id_account = message.id_account_receiver
where
message.id_account_sender = 1 and
message.id_account_receiver = 2 
order by message.message_datetime DESC
;

--nombre message envoye
select 
account_sender.first_name first_name_sender, 
count(message_content) sended_messege_number
from message
left join account account_sender on account.id_account = message.id_account_sender 
left join account account_receiver on account.id_account = message.id_account_receiver
where
message.id_account_sender = 1 or
message.id_account_receiver = 1 
group by account_sender.first_name
order by sended_messege_number desc
;




--posts envoyées par date
select 
post.id_accoun, 
posting_date,
posting_time,
posting_content
from post
where 
EXTRACT(DAY FROM posting_date) <= EXTRACT(DAY FROM current_date - INTERVAL '3 DAY')
order by posting_time, posting_date
;


--posts envoyées par nombre de comentaire
select DISTINCT
post.id_accoun, 
posting_date,
posting_time,
posting_content
from post, react_post
where 
EXTRACT(DAY FROM posting_date) <= EXTRACT(DAY FROM current_date - INTERVAL '3 DAY') and
post.id_post = react_post.id_post 
group by post.id_accoun, posting_date, posting_time, posting_content
order by count(react_post.reaction_datetime)
;