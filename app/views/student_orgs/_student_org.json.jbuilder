json.extract! student_org, :id, :name, :email, :full_name, :created_at, :updated_at
json.url student_org_url(student_org, format: :json)
