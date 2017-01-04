# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170103192842) do

  create_table "asignaciones", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_asignaciones_on_role_id", using: :btree
    t.index ["user_id"], name: "index_asignaciones_on_user_id", using: :btree
  end

  create_table "cantidades", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "color_lote_id"
    t.integer "categoria_id"
    t.integer "cantidad",      default: 0
    t.integer "total_id"
    t.index ["categoria_id"], name: "index_cantidades_on_categoria_id", using: :btree
    t.index ["color_lote_id"], name: "index_cantidades_on_color_lote_id", using: :btree
    t.index ["total_id"], name: "index_cantidades_on_total_id", using: :btree
  end

  create_table "categorias", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "categoria"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clientes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "cliente",                  null: false
    t.string   "telefono"
    t.string   "direccion"
    t.string   "email",                    null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "asunto"
    t.text     "mensaje",    limit: 65535
    t.boolean  "empresa"
  end

  create_table "colores", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "colores_lotes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "color_id"
    t.integer  "lote_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "total_id"
    t.index ["color_id"], name: "index_colores_lotes_on_color_id", using: :btree
    t.index ["lote_id"], name: "index_colores_lotes_on_lote_id", using: :btree
    t.index ["total_id"], name: "index_colores_lotes_on_total_id", using: :btree
  end

  create_table "control_lotes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "fecha_ingreso",                             null: false
    t.datetime "fecha_salida"
    t.integer  "lote_id"
    t.integer  "estado_id",                                 null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "sub_estado_id",                 default: 0
    t.integer  "resp_ingreso_id",               default: 1, null: false
    t.integer  "resp_salida_id"
    t.text     "observaciones",   limit: 65535
    t.index ["estado_id"], name: "index_control_lotes_on_estado_id", using: :btree
    t.index ["lote_id"], name: "index_control_lotes_on_lote_id", using: :btree
    t.index ["resp_ingreso_id"], name: "index_control_lotes_on_resp_ingreso_id", using: :btree
    t.index ["resp_salida_id"], name: "index_control_lotes_on_resp_salida_id", using: :btree
    t.index ["sub_estado_id"], name: "index_control_lotes_on_sub_estado_id", using: :btree
  end

  create_table "estados", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "estado",        null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "nombre_accion"
    t.string   "color"
    t.string   "color_claro"
  end

  create_table "lotes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "empresa"
    t.string   "no_remision"
    t.string   "no_factura"
    t.string   "op",                                              null: false
    t.date     "fecha_revision"
    t.date     "fecha_entrega"
    t.text     "obs_insumos",        limit: 65535
    t.boolean  "fin_insumos",                      default: true
    t.integer  "referencia_id"
    t.integer  "cliente_id",                                      null: false
    t.integer  "tipo_prenda_id"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "meta",                             default: 0
    t.integer  "h_req",                            default: 0
    t.integer  "precio_u",                         default: 0
    t.integer  "precio_t",                         default: 0
    t.integer  "secuencia"
    t.text     "obs_integracion",    limit: 65535
    t.boolean  "fin_integracion",                  default: true
    t.integer  "respon_insumos_id"
    t.integer  "respon_edicion_id",                               null: false
    t.date     "fecha_entrada"
    t.integer  "cantidad",                         default: 0
    t.integer  "programacion_id"
    t.date     "ingresara_a_planta"
    t.index ["cliente_id"], name: "index_lotes_on_cliente_id", using: :btree
    t.index ["programacion_id"], name: "index_lotes_on_programacion_id", using: :btree
    t.index ["referencia_id"], name: "index_lotes_on_referencia_id", using: :btree
    t.index ["respon_edicion_id"], name: "index_lotes_on_respon_edicion_id", using: :btree
    t.index ["respon_insumos_id"], name: "index_lotes_on_respon_insumos_id", using: :btree
    t.index ["tipo_prenda_id"], name: "index_lotes_on_tipo_prenda_id", using: :btree
  end

  create_table "programaciones", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "mes"
    t.integer  "horas",        default: 0
    t.string   "costo"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.boolean  "empresa"
    t.integer  "meta_mensual"
  end

  create_table "referencias", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "referencia", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "rol_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rol_id"], name: "index_roles_users_on_rol_id", using: :btree
    t.index ["user_id"], name: "index_roles_users_on_user_id", using: :btree
  end

  create_table "seguimientos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "cantidad"
    t.integer  "control_lote_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.date     "fecha_salida"
    t.index ["control_lote_id"], name: "index_seguimientos_on_control_lote_id", using: :btree
  end

  create_table "sub_estados", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "sub_estado", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tallas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "talla",        null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "categoria_id"
    t.index ["categoria_id"], name: "index_tallas_on_categoria_id", using: :btree
  end

  create_table "tipos_prendas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "tipo",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "totales", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "total"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "telefono"
    t.string   "username"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  add_foreign_key "asignaciones", "roles", column: "role_id"
  add_foreign_key "asignaciones", "users"
  add_foreign_key "colores_lotes", "totales"
  add_foreign_key "control_lotes", "estados"
  add_foreign_key "control_lotes", "lotes"
  add_foreign_key "lotes", "clientes"
  add_foreign_key "lotes", "programaciones"
  add_foreign_key "lotes", "referencias"
  add_foreign_key "lotes", "tipos_prendas"
  add_foreign_key "roles_users", "roles"
  add_foreign_key "roles_users", "users"
  add_foreign_key "seguimientos", "control_lotes"
end
