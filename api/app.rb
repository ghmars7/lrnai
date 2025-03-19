require 'sinatra'
require 'json'
require 'sqlite3'

# Connexion à la base de données SQLite
DB = SQLite3::Database.new("db/cafe.db")

# Middleware pour gérer JSON
before do
  content_type :json
end

# ============================
# Routes pour les clients
# ============================

# Route pour afficher tous les clients
get '/clients' do
  results = DB.execute("SELECT * FROM clients")
  clients = results.map do |row|
    {
      id: row[0],
      name: row[1],
      email: row[2],
      phone: row[3],
      created_at: row[4]
    }
  end
  clients.to_json
end

get '/clients/:id' do
  id = params[:id]
  client = DB.execute("SELECT * FROM clients WHERE id = ?", [id]).first

  if client
    {
      id: client[0],
      name: client[1],
      email: client[2],
      phone: client[3],
      created_at: client[4]
    }.to_json
  else
    status 404
    { error: "Client not found" }.to_json
  end
end

# Route pour ajouter un nouveau client
post '/clients' do
  data = JSON.parse(request.body.read)
  name = data["name"]
  email = data["email"]
  phone = data["phone"]

  # Vérifier si l'email existe déjà
  existing_client = DB.execute("SELECT id FROM clients WHERE email = ?", [email])
  if existing_client.empty?
    DB.execute("INSERT INTO clients (name, email, phone) VALUES (?, ?, ?)", [name, email, phone])
    { message: "Client added successfully" }.to_json
  else
    status 409 # Conflict
    { error: "A client with this email already exists" }.to_json
  end
end

# Route pour mettre à jour un client
put '/clients/:id' do
  id = params[:id]
  data = JSON.parse(request.body.read)
  name = data["name"]
  email = data["email"]
  phone = data["phone"]

  existing_client = DB.execute("SELECT id FROM clients WHERE email = ? AND id != ?", [email, id])
  if existing_client.empty?
    DB.execute("UPDATE clients SET name = ?, email = ?, phone = ? WHERE id = ?", [name, email, phone, id])
    { message: "Client updated successfully" }.to_json
  else
    status 409 # Conflict
    { error: "A client with this email already exists" }.to_json
  end
rescue SQLite3::Exception => e
  status 400
  { error: e.message }.to_json
end

# Route pour supprimer un client
delete '/clients/:id' do
  id = params[:id]
  DB.execute("DELETE FROM clients WHERE id = ?", [id])
  { message: "Client deleted successfully" }.to_json
end

# ============================
# Routes pour le menu
# ============================

# Route pour afficher le menu
get '/menu' do
  results = DB.execute("SELECT * FROM menu")
  menu_items = results.map do |row|
    {
      id: row[0],
      name: row[1],
      description: row[2],
      price: row[3]
    }
  end
  menu_items.to_json
end

# Route pour obtenir un élément du menu par ID
get '/menu/:id' do
  id = params[:id]
  menu_item = DB.execute("SELECT * FROM menu WHERE id = ?", [id]).first

  if menu_item
    {
      id: menu_item[0],
      name: menu_item[1],
      description: menu_item[2],
      price: menu_item[3]
    }.to_json
  else
    status 404
    { error: "Menu item not found" }.to_json
  end
end


# Route pour ajouter un élément au menu (admin)
post '/menu' do
  data = JSON.parse(request.body.read)
  name = data["name"]
  description = data["description"]
  price = data["price"]

  DB.execute("INSERT INTO menu (name, description, price) VALUES (?, ?, ?)", [name, description, price])
  { message: "Menu item added successfully" }.to_json
end

# Route pour mettre à jour un élément du menu
put '/menu/:id' do
  id = params[:id]
  data = JSON.parse(request.body.read)
  name = data["name"]
  description = data["description"]
  price = data["price"]

  DB.execute("UPDATE menu SET name = ?, description = ?, price = ? WHERE id = ?", [name, description, price, id])
  { message: "Menu item updated successfully" }.to_json
rescue SQLite3::Exception => e
  status 400
  { error: e.message }.to_json
end

# Route pour supprimer un élément du menu
delete '/menu/:id' do
  id = params[:id]
  menu_item = DB.execute("SELECT * FROM menu WHERE id = ?", [id]).first

  if menu_item
    DB.execute("DELETE FROM menu WHERE id = ?", [id])
    { message: "Menu item deleted successfully" }.to_json
  else
    status 404
    { error: "Menu item not found" }.to_json
  end
end

# ============================
# Routes pour les réservations
# ============================

# Route pour afficher toutes les réservations
get '/reservations' do
  results = DB.execute("SELECT * FROM reservations")
  reservations = results.map do |row|
    {
      id: row[0],
      name: row[1],
      email: row[2],
      date: row[3],
      time: row[4],
      guests: row[5]
    }
  end
  reservations.to_json
end

# Route pour obtenir une réservation par ID
get '/reservations/:id' do
  id = params[:id]
  reservation = DB.execute("SELECT * FROM reservations WHERE id = ?", [id]).first

  if reservation
    {
      id: reservation[0],
      name: reservation[1],
      email: reservation[2],
      date: reservation[3],
      time: reservation[4],
      guests: reservation[5]
    }.to_json
  else
    status 404
    { error: "Reservation not found" }.to_json
  end
end

# Route pour réserver une table
post '/reservations' do
  data = JSON.parse(request.body.read)
  name = data["name"]
  email = data["email"]
  date = data["date"]
  time = data["time"]
  guests = data["guests"]

  DB.execute("INSERT INTO reservations (name, email, date, time, guests) VALUES (?, ?, ?, ?, ?)", [name, email, date, time, guests])
  { message: "Reservation made successfully" }.to_json
end

# Route pour mettre à jour une réservation
put '/reservations/:id' do
  id = params[:id]
  data = JSON.parse(request.body.read)
  name = data["name"]
  email = data["email"]
  date = data["date"]
  time = data["time"]
  guests = data["guests"]

  DB.execute("UPDATE reservations SET name = ?, email = ?, date = ?, time = ?, guests = ? WHERE id = ?", [name, email, date, time, guests, id])
  { message: "Reservation updated successfully" }.to_json
rescue SQLite3::Exception => e
  status 400
  { error: e.message }.to_json
end

# Route pour supprimer une réservation (admin)
delete '/reservations/:id' do
  id = params[:id]
  DB.execute("DELETE FROM reservations WHERE id = ?", [id])
  { message: "Reservation deleted successfully" }.to_json
end