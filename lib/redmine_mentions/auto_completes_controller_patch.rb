require_dependency 'auto_completes_controller'

class AutoCompletesController
  def mentions_users
    users = []
    q = params[:q].to_s.strip
    exclude_id = params[:user_id].to_i

    scope = @project.nil? ? User.active.where(type: 'User') : @project.users
    scope = scope.visible
    scope = scope.where.not(id: exclude_id) if exclude_id.positive?

    if q.present?
      users << scope.find_by(id: Regexp.last_match(1)) if q =~ /(\d+)\z/
      users += scope.like(q).order(id: :desc).limit(10).to_a
      users.compact!
    else
      scope = scope.order(last_login_on: :desc).limit(20)
      users = scope.to_a.sort! { |x, y| x.name <=> y.name }
    end

    render json: users.map { |user|
      {
        'id' => user.id,
        'label' => "#{user.name}#{" - #{user.mail}" unless user.pref.hide_mail}",
        'value' => user.id
      }
    }
  end
end
