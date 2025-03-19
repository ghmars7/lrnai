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

# Route pour ajouter un élément au menu (admin)
post '/menu' do
  data = JSON.parse(request.body.read)
  name = data["name"]
  description = data["description"]
  price = data["price"]

  DB.execute("INSERT INTO menu (name, description, price) VALUES (?, ?, ?)", [name, description, price])
  { message: "Menu item added successfully" }.to_json
end

# ============================
# Routes pour les réservations
# ============================

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

# Route pour supprimer une réservation (admin)
delete '/reservations/:id' do
  id = params[:id]
  DB.execute("DELETE FROM reservations WHERE id = ?", [id])
  { message: "Reservation deleted successfully" }.to_json
end