# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_12_27_114631) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.uuid "record_id", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "allies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "organization_id", null: false
    t.index ["created_at"], name: "index_allies_on_created_at"
    t.index ["organization_id"], name: "index_allies_on_organization_id"
  end

  create_table "ally_branches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "ally_id", null: false
    t.uuid "branch_id", null: false
    t.index ["ally_id"], name: "index_ally_branches_on_ally_id"
    t.index ["branch_id"], name: "index_ally_branches_on_branch_id"
  end

  create_table "branches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "country", null: false
    t.string "city", null: false
    t.string "address", null: false
    t.string "phone_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "department", null: false
    t.uuid "organization_id", null: false
    t.index ["created_at"], name: "index_branches_on_created_at"
    t.index ["organization_id"], name: "index_branches_on_organization_id"
  end

  create_table "group_attendances", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.date "date", null: false
    t.uuid "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_attendances_on_group_id"
  end

  create_table "groups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "category", null: false
    t.uuid "branch_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "1", null: false
    t.string "display_name"
    t.index ["branch_id"], name: "index_groups_on_branch_id"
    t.index ["name", "category", "branch_id"], name: "index_groups_on_name_and_category_and_branch_id", unique: true
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "organizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "country", null: false
    t.string "report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_organizations_on_created_at"
  end

  create_table "reports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "quicksight_embed_src", null: false
    t.string "quicksight_dashboard_id", null: false
    t.uuid "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_reports_on_organization_id"
  end

  create_table "single_response_inputs", force: :cascade do |t|
    t.string "question"
    t.string "answer"
    t.uuid "survey_response_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_response_id"], name: "index_single_response_inputs_on_survey_response_id"
  end

  create_table "student_attendances", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.date "date"
    t.boolean "present", default: true, null: false
    t.uuid "group_attendance_id", null: false
    t.uuid "student_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_student_attendances_on_deleted_at"
    t.index ["group_attendance_id"], name: "index_student_attendances_on_group_attendance_id"
    t.index ["student_id"], name: "index_student_attendances_on_student_id"
  end

  create_table "students", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "id_number", null: false
    t.string "name", null: false
    t.string "birthplace", null: false
    t.date "birthdate", null: false
    t.integer "gender", null: false
    t.integer "tshirt_size", null: false
    t.integer "shorts_size", null: false
    t.integer "socks_size", null: false
    t.integer "shoe_size", null: false
    t.string "favourite_colour", null: false
    t.string "favourite_food", null: false
    t.string "favourite_sport", null: false
    t.string "favourite_place", null: false
    t.string "feeling_when_playing_soccer", null: false
    t.string "country"
    t.string "city", null: false
    t.string "neighborhood", null: false
    t.string "address", null: false
    t.string "school", null: false
    t.string "extracurricular_activities"
    t.integer "health_coverage", null: false
    t.boolean "displaced", default: false, null: false
    t.string "displacement_origin"
    t.string "displacement_reason"
    t.boolean "lives_with_reinserted_familiar", default: false, null: false
    t.string "program"
    t.boolean "beneficiary_of_another_foundation", default: false, null: false
    t.integer "status", default: 0, null: false
    t.date "withdrawal_date"
    t.string "withdrawal_reason"
    t.uuid "group_id", null: false
    t.uuid "branch_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "id_type", default: "Registro civil", null: false
    t.string "study_day", default: "Mañana", null: false
    t.string "grade", default: " ", null: false
    t.string "eps"
    t.boolean "lives_with_parent", default: false, null: false
    t.string "department", default: " "
    t.string "height", default: " ", null: false
    t.string "weight", default: " ", null: false
    t.index ["branch_id"], name: "index_students_on_branch_id"
    t.index ["deleted_at"], name: "index_students_on_deleted_at"
    t.index ["group_id"], name: "index_students_on_group_id"
  end

  create_table "supervisors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "id_number", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.date "birthdate", null: false
    t.string "phone_number", null: false
    t.string "profession", null: false
    t.integer "relationship", null: false
    t.uuid "student_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_supervisors_on_deleted_at"
    t.index ["student_id"], name: "index_supervisors_on_student_id"
  end

  create_table "survey_responses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "response_id", null: false
    t.jsonb "json_response", null: false
    t.date "date", null: false
    t.uuid "survey_id", null: false
    t.uuid "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "kind_of_measurement"
    t.jsonb "scores"
    t.uuid "branch_id"
    t.index ["branch_id"], name: "index_survey_responses_on_branch_id"
    t.index ["response_id"], name: "index_survey_responses_on_response_id", unique: true
    t.index ["student_id"], name: "index_survey_responses_on_student_id"
    t.index ["survey_id"], name: "index_survey_responses_on_survey_id"
  end

  create_table "surveys", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "key"
    t.string "form_id", null: false
    t.uuid "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default", default: false, null: false
    t.index ["organization_id"], name: "index_surveys_on_organization_id"
  end

  create_table "uploaded_files", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_branches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.uuid "branch_id", null: false
    t.index ["branch_id"], name: "index_user_branches_on_branch_id"
    t.index ["user_id"], name: "index_user_branches_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone_number", null: false
    t.string "country", null: false
    t.integer "role", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.uuid "organization_id"
    t.index ["created_at"], name: "index_users_on_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "allies", "organizations"
  add_foreign_key "ally_branches", "allies"
  add_foreign_key "ally_branches", "branches"
  add_foreign_key "branches", "organizations"
  add_foreign_key "group_attendances", "groups"
  add_foreign_key "groups", "branches"
  add_foreign_key "reports", "organizations"
  add_foreign_key "single_response_inputs", "survey_responses"
  add_foreign_key "student_attendances", "group_attendances", on_delete: :cascade
  add_foreign_key "student_attendances", "students"
  add_foreign_key "students", "branches"
  add_foreign_key "students", "groups"
  add_foreign_key "supervisors", "students"
  add_foreign_key "survey_responses", "branches"
  add_foreign_key "survey_responses", "students"
  add_foreign_key "survey_responses", "surveys"
  add_foreign_key "surveys", "organizations"
  add_foreign_key "user_branches", "branches"
  add_foreign_key "user_branches", "users"
  add_foreign_key "users", "organizations"
end
