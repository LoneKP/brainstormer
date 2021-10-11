module DoneVoting
  def users_done_voting_who_are_also_online
    users_online_ids = REDIS.hgetall(brainstorm_key).keys
    all_users_voting_status = REDIS.hgetall(done_voting_brainstorm_status)

    all_users_voting_status_ids = REDIS.hgetall(done_voting_brainstorm_status).keys
    still_online_users_on_voting_list = users_online_ids & all_users_voting_status_ids
    all_users_voting_status.slice(*still_online_users_on_voting_list).values.count("true")
  end

  def total_users_online
    REDIS.hgetall(brainstorm_key).keys.count
  end

  def done_voting_brainstorm_status
    "done_voting_brainstorm_status_#{@brainstorm.token}"
  end

  def brainstorm_key
    "brainstorm_id_#{@brainstorm.token}"
  end
end