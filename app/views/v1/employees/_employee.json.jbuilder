json.id employee.id if employee.persisted?
json.first_name employee.first_name
json.last_name employee.last_name
json.email employee.email
json.date_of_birth employee.date_of_birth.iso8601
json.phone_number employee.phone_number
json.registration_complete employee.registration_complete
json.created_at employee.created_at
